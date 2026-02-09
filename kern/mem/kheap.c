#include "kheap.h"
#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"
#include <inc/queue.h>

struct FreePageBlock {
	LIST_ENTRY(FreePageBlock) prev_next_info;
	uint32 start_va;
	uint32 size;
};
LIST_HEAD(FreePageBlock_List, FreePageBlock);

static struct FreePageBlock_List free_blocks_list;


static struct kspinlock kheap_lock;

static inline struct FrameInfo* get_frame_info_safe(uint32 va, uint32 **pt)
{

	return get_frame_info(ptr_page_directory, va, pt);
}

static void insert_free_block_sorted(uint32 start_va, uint32 size)
{

	struct FreePageBlock *block = (struct FreePageBlock *)alloc_block(sizeof(struct FreePageBlock));
	if (block == NULL)
	{
		panic("insert_free_block_sorted: failed to allocate metadata");
	}

	block->start_va = start_va;
	block->size = size;

	if (LIST_EMPTY(&free_blocks_list)) {
		LIST_INSERT_HEAD(&free_blocks_list, block);
		return;
	}

	struct FreePageBlock *curr;
	struct FreePageBlock *prev = NULL;

	LIST_FOREACH(curr, &free_blocks_list) {


		if (start_va < curr->start_va) {


			if (prev == NULL) {


				LIST_INSERT_HEAD(&free_blocks_list, block);
			} else {
				  LIST_INSERT_AFTER(&free_blocks_list, prev, block);
			}

			return;
		}
		 prev = curr;
	}

	if (prev != NULL) {



		      LIST_INSERT_AFTER(&free_blocks_list, prev, block);
	}  else {
		LIST_INSERT_HEAD(&free_blocks_list, block);
	}
}

static void remove_free_block(struct FreePageBlock *block)
{
	LIST_REMOVE(&free_blocks_list, block);
	free_block(block);
}

static void merge_adjacent_blocks()
{
	struct FreePageBlock *curr = LIST_FIRST(&free_blocks_list);
	while (curr != NULL) {

		struct FreePageBlock *next = LIST_NEXT(curr);


		if (next != NULL && curr->start_va + curr->size == next->start_va) {

			curr->size += next->size;

			remove_free_block(next);

		} else {
			curr = LIST_NEXT(curr);
		}
	}
}

static void update_break()
{
	uint32 max_end = kheapPageAllocStart;

	uint32 check_va = kheapPageAllocStart;

	uint32 max_scan = kheapPageAllocBreak;


	uint32 consecutive_unmapped = 0;
	uint32 max_consecutive = 100;

	while (check_va < max_scan && check_va < KERNEL_HEAP_MAX) {
		uint32 *pt = NULL;
		struct FrameInfo *fi = get_frame_info_safe(check_va, &pt);

		if (fi != NULL && fi->size > 0) {
			uint32 block_end = check_va + fi->size;
			if (block_end > max_end)
				max_end = block_end;


			check_va = block_end;


			consecutive_unmapped = 0;


			if (block_end > max_scan)
				max_scan = block_end;
		} else {
			int found_free = 0;


			struct FreePageBlock *curr;


			LIST_FOREACH(curr, &free_blocks_list) {

				if (curr->start_va == check_va) {

					check_va = curr->start_va + curr->size;
					found_free = 1;
					consecutive_unmapped = 0;
					break;
				}
			}

			if (!found_free) {

				uint32 next_block = KERNEL_HEAP_MAX;

				LIST_FOREACH(curr, &free_blocks_list) {
					if (curr->start_va > check_va && curr->start_va < next_block)
						next_block = curr->start_va;
				}

				uint32 scan_va = check_va + PAGE_SIZE;

				uint32 scan_limit = (next_block < KERNEL_HEAP_MAX) ? next_block : (check_va + (PAGE_SIZE * 1000));
				if (scan_limit > KERNEL_HEAP_MAX)
					scan_limit = KERNEL_HEAP_MAX;


				int found_alloc = 0;
				while (scan_va < scan_limit) {
					pt = NULL;
					fi = get_frame_info_safe(scan_va, &pt);

					if (fi != NULL && fi->size > 0) {

						next_block = (scan_va < next_block) ? scan_va : next_block;
						found_alloc = 1;
						break;
					}
					scan_va += PAGE_SIZE;
				}

				if (found_alloc || next_block < KERNEL_HEAP_MAX) {

					check_va = next_block;

					consecutive_unmapped = 0;
				} else {
					consecutive_unmapped++;

					if (consecutive_unmapped >= max_consecutive)
						break;

					check_va += PAGE_SIZE;
				}
			}
		}

		if (check_va > max_scan + (PAGE_SIZE * 1000))
			break;
	}

	kheapPageAllocBreak = max_end;
}
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE KERNEL HEAP:
//==============================================
//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #0 kheap_init [GIVEN]
//Remember to initialize locks (if any)

void kheap_init()
{
	initialize_dynamic_allocator(KERNEL_HEAP_START, KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE);

	set_kheap_strategy(KHP_PLACE_CUSTOMFIT);

	kheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
	 kheapPageAllocBreak = kheapPageAllocStart;

	LIST_INIT(&free_blocks_list);


	init_kspinlock(&kheap_lock, "kheap lock");
}

int get_page(void* va)
{
	uint32 page_va = ROUNDDOWN((uint32)va, PAGE_SIZE);
	int ret = alloc_page(ptr_page_directory, page_va, PERM_WRITEABLE, 1);
	if (ret < 0) {
		panic("get_page() in kern: failed to allocate page from the kernel");
	}


	if (ret == 0 || ret == 1) {
		uint32 *pt = NULL;
		struct FrameInfo *fi = get_frame_info_safe(page_va, &pt);
		if (fi != NULL) {
			if (fi->va == 0 || fi->va != page_va) {
				fi->va = page_va;
			}
		}
	}

	return 0;
}

void return_page(void* va)
{
	uint32 page_va = ROUNDDOWN((uint32)va, PAGE_SIZE);


	uint32 *pt = NULL;
	struct FrameInfo *fi = get_frame_info_safe(page_va, &pt);
	if (fi != NULL) {
		fi->va = 0;
	}

	unmap_frame(ptr_page_directory, page_va);
}

void* kmalloc(unsigned int size)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #1 kmalloc
		//Your code is here
		//Comment the following line
		//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
#if USE_KHEAP
	if (size == 0)
		return NULL;

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
		return alloc_block(size);
	}

	int held = holding_kspinlock(&kheap_lock);



	if (!held)
		acquire_kspinlock(&kheap_lock);


	uint32 req_size;


	if (size % PAGE_SIZE == 0) {
		req_size = size;
	} else {
		req_size = ((size / PAGE_SIZE) + 1) * PAGE_SIZE;

	}
	uint32 npages = req_size / PAGE_SIZE;

	if (kheapPageAllocStart == 0) {

		if (!held) {
			release_kspinlock(&kheap_lock);}

		return NULL;

	}

	if (kheapPageAllocBreak == 0 || kheapPageAllocBreak < kheapPageAllocStart) {

		kheapPageAllocBreak = kheapPageAllocStart;
	}

	void* allocated_va = NULL;

	struct FreePageBlock *best_block = NULL;

	   uint32 best_block_start = 0;

	uint32 best_block_size = 0;

	int from_free_list = 0;

	struct FreePageBlock *curr;


	LIST_FOREACH(curr, &free_blocks_list) {

		if (curr->size >= req_size) {

			if (curr->size == req_size) {

				best_block = curr;
			     	best_block_start = curr->start_va;
				best_block_size = curr->size;

				from_free_list = 1;
				break;
			}
			if (curr->size > best_block_size) {
				best_block = curr;


				best_block_start = curr->start_va;


				best_block_size = curr->size;
				from_free_list = 1;

			}
		}
	}

	if (best_block != NULL) {

		  allocated_va = (void*)best_block_start;

		remove_free_block(best_block);

		if (best_block_size > req_size) {
		         	uint32 remainder_start = best_block_start + req_size;


			uint32 remainder_size = best_block_size - req_size;


			insert_free_block_sorted(remainder_start, remainder_size);
		}
	} else {
		if (kheapPageAllocBreak > KERNEL_HEAP_MAX - req_size) {

			if (!held) {
				release_kspinlock(&kheap_lock);
			}
			return NULL;
		}

		allocated_va = (void*)kheapPageAllocBreak;


		kheapPageAllocBreak += req_size;
		from_free_list = 0;
	}

	uint32 va_to_map = (uint32)allocated_va;
	for (uint32 i = 0; i < npages; i++) {

		int ret = alloc_page(ptr_page_directory, va_to_map, PERM_WRITEABLE, 1);

		if (ret < 0) {

			for (uint32 j = 0; j < i; j++) {

				unmap_frame(ptr_page_directory, (uint32)allocated_va + j * PAGE_SIZE);
			}
			if (from_free_list) {
				insert_free_block_sorted(best_block_start, best_block_size);
			} else {
				kheapPageAllocBreak -= req_size;
			}
			if (!held) {
				release_kspinlock(&kheap_lock);
			}
			return NULL;
		}

		if (ret == 0 || ret == 1) {
			uint32 *pt = NULL;
			struct FrameInfo *fi = get_frame_info_safe(va_to_map, &pt);
			if (fi != NULL) {

				if (fi->va == 0 || fi->va != va_to_map) {
					fi->va = va_to_map;
				}
			}
		}

		va_to_map += PAGE_SIZE;
	}

	uint32 *pt = NULL;
	struct FrameInfo *fi = get_frame_info_safe((uint32)allocated_va, &pt);
	if (fi != NULL) {
		fi->size = req_size;
	}

	if (!held) {
		release_kspinlock(&kheap_lock);
	}

	return allocated_va;
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//TODO: [PROJECT'25.BONUS#3] FAST PAGE ALLOCATOR
}

void kfree(void* va)
{
#if USE_KHEAP
	if (!va) return;

	uint32 vAddr = (uint32)va;

	if (vAddr >= KERNEL_HEAP_START && vAddr < dynAllocEnd) {
		free_block(va);
		return;
	}

	if (vAddr >= kheapPageAllocStart && vAddr < KERNEL_HEAP_MAX) {
		     int lock_already_held = holding_kspinlock(&kheap_lock);

		if (!lock_already_held) {
			acquire_kspinlock(&kheap_lock);
		}

		if (vAddr % PAGE_SIZE != 0) {
			if (!lock_already_held) {
				release_kspinlock(&kheap_lock);
			}
			panic("kfree: address not page-aligned");
		}

		uint32* pt = NULL;
		struct FrameInfo* fi = get_frame_info_safe(vAddr, &pt);
		if (!fi || fi->size == 0) {

			if (!lock_already_held) {
				release_kspinlock(&kheap_lock);
			}
			return;
		}

		uint32 size = fi->size;
		uint32 end = vAddr + size;

		for (uint32 addr = vAddr; addr < end; addr += PAGE_SIZE) {
			uint32 *pt_temp = NULL;
			struct FrameInfo *fi_page = get_frame_info_safe(addr, &pt_temp);
			if (fi_page != NULL) {
				fi_page->va = 0;
			}
			unmap_frame(ptr_page_directory, addr);
		}

		fi->size = 0;

		insert_free_block_sorted(vAddr, size);

		merge_adjacent_blocks();

		update_break();

		if (!lock_already_held) {
			release_kspinlock(&kheap_lock);
		}

		return;
	}

	panic("kfree: invalid address");
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

}

//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #3 kheap_virtual_address
	//Your code is here
#if USE_KHEAP
	struct FrameInfo *fi = to_frame_info(physical_address);
	if (fi == NULL) {
		return 0;
	}

	if (fi->va == 0) {
		return 0;
	}

	uint32 va = fi->va;
	if (va < KERNEL_HEAP_START || va >= KERNEL_HEAP_MAX) {
		return 0;
	}

	uint32 offset = PGOFF(physical_address);

	// Return virtual address with offset
	return va + offset;
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("kheap_virtual_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #4 kheap_physical_address
	//Your code is here
#if USE_KHEAP
	unsigned int *ptr_page_table = NULL;
	struct FrameInfo *ptr_frame_info = get_frame_info(ptr_page_directory, virtual_address, &ptr_page_table);
	if (ptr_frame_info == NULL) {
		return 0;
	}

	unsigned int frame = to_physical_address(ptr_frame_info);
	unsigned int offset = PGOFF(virtual_address);
	unsigned int pa = frame + offset;
	return pa;
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("kheap_physical_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//  Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//  possibly moving it in the heap.
//  If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//  On failure, returns a null pointer, and the old virtual_address remains valid.

//  A call with virtual_address = null is equivalent to kmalloc().
//  A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	//Your code is here
	//Comment the following line

	panic("krealloc() is not implemented yet...!!");


}
