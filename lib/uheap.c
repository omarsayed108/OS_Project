#include <inc/lib.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct PageAlloc {
	uint32 start;
	uint32 size;
	LIST_ENTRY(PageAlloc) prev_next_info;
};

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
	struct PageAlloc *node =
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
		panic("insert_page_alloc: no space for metadata");

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
		if (start < it->start)
			break;
		prev = it;
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}

static void recompute_page_alloc_break()
{
	if (LIST_EMPTY(&page_alloc_list)) {
		uheapPageAllocBreak = uheapPageAllocStart;
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
}

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
	if (required_size == 0)
		return NULL;

	void *exact_fit = NULL;
	uint8 has_exact = 0;
	void *worst_fit = NULL;
	uint32 worst_fit_size = 0;



	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
		if (it->start > cur) {

			uint32 hole_start = cur;
			uint32 hole_size  = it->start - cur;

			if (hole_size >= required_size) {
				if (!has_exact && hole_size == required_size) {
					exact_fit = (void*)hole_start;
					has_exact = 1;
				} else if (hole_size > worst_fit_size) {
					worst_fit      = (void*)hole_start;
					worst_fit_size = hole_size;
				}
			}
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
		uint32 hole_start = cur;
		uint32 hole_size  = uheapPageAllocBreak - cur;

		if (hole_size >= required_size) {
			if (!has_exact && hole_size == required_size) {
				exact_fit = (void*)hole_start;
				has_exact = 1;
			} else if (hole_size > worst_fit_size) {
				worst_fit      = (void*)hole_start;
				worst_fit_size = hole_size;
			}
		}
	}

	void *result = NULL;

	if (has_exact) {

		result = exact_fit;
	} else if (worst_fit != NULL) {

		result = worst_fit;
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
			return NULL;

		result = (void*)uheapPageAllocBreak;
		uheapPageAllocBreak += required_size;
	}


	insert_page_alloc((uint32)result, required_size);

	return result;
}

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
		if (it->start == va)
			return it->size;
	}
	return 0;
}

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
		if (it->start == va) {

			uint32 start = it->start;
			uint32 size  = it->size;


			if (start > 0xFFFFFFFFU - size) {
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
			}

			uint32 start_end = start + size;

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
				}

				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
			free_block(it);
			recompute_page_alloc_break();

			return;
		}
	}
}

uint32 get_free_region_size(uint32 va)
{
	(void)va;
	return 0;
}

//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
	if(__firstTimeFlag)
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
		uheapPlaceStrategy = sys_get_uheap_strategy();
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		uheapPageAllocBreak = uheapPageAllocStart;

		LIST_INIT(&page_alloc_list);

		__firstTimeFlag = 0;
	}
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
	if (ret < 0)
		panic("get_page() in user: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
	if (ret < 0)
		panic("return_page() in user: failed to return a page to the kernel");
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
		result = alloc_block(size);

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);


		if (uheapPageAllocStart == 0) {
			return NULL;
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
			uheapPageAllocBreak = uheapPageAllocStart;
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
		result = alloc_pages_custom_fit(alloc_size);
		}
		if (result != NULL) {
			uint32 result_va = (uint32)result;
			uint32 actual_size = find_allocated_size(result);

			if (actual_size == 0) {
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
			}

			uint32 result_end = result_va + actual_size;

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
				sys_allocate_user_mem(result_va, actual_size);
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;

#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;

	uint32 addr = (uint32)virtual_address;

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
		free_block(virtual_address);
		return;
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
		if (addr % PAGE_SIZE != 0) {
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
		}

		uint32 addr_end = addr + alloc_size;

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
		return;
	}

	panic("free(): invalid virtual address %p\n", virtual_address);

#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
	uint32 remainder = size & (PAGE_SIZE - 1);
	if (remainder != 0)
	    alignedSize += (PAGE_SIZE - remainder);

	uint32 requiredPages = alignedSize / PAGE_SIZE;

	if (uheapPageAllocStart == 0)
		return NULL;

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
	        	uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
	}

	void *va = NULL;
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
		va = alloc_pages_custom_fit(alignedSize);
	}

	if (va == NULL) {
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
		if (uheapPageAllocBreak > max_allowed - alignedSize){
			return NULL;}

		va = (void *)uheapPageAllocBreak;
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);

	if (sharedID < 0)
		return NULL;

	if (va == (void *)uheapPageAllocBreak) {
		uheapPageAllocBreak +=alignedSize;
	}

	return va;

#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
	if (objsizeeeee <= 0)
		return NULL;

	uint32 alignedsize = objsizeeeee;
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
		if (remainder != 0)
		    alignedsize += (PAGE_SIZE - remainder);

	if (uheapPageAllocStart == 0)
		return NULL;

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
		usedSize > sharedLimitSize - alignedsize)
		return NULL;

	void *va = NULL;
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
		va = alloc_pages_custom_fit(alignedsize);

	if (va == NULL) {
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;

		if (uheapPageAllocBreak > max_allowed - alignedsize)
			return NULL;

		va = (void *)uheapPageAllocBreak;
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
	if (sharedID < 0)
		return NULL;

	if (va == (void *)uheapPageAllocBreak)
		uheapPageAllocBreak += alignedsize;

	return va;
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================
	panic("realloc() is not implemented yet...!!");
}

//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
