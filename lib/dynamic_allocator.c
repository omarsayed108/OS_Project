/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
			panic("to_page_va called with invalid pageInfoPtr");
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
}

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
		panic("to_page_info called with invalid pa");
	return &pageBlockInfoArr[idxInPageInfoArr];
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
		is_initialized = 1;
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
		pageBlockInfoArr[i].block_size = 0;
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
	        pageBlockInfoArr[i].block_size = 0;
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
	return pageBlockInfoArr[index].block_size;

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
        if (x <= 1) return 1;
        int power = 2;
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
    if (size < min_block_size)
        size = min_block_size;

    int pow = nearest_pow2_ceil(size);
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
        LIST_REMOVE(&freeBlockLists[index], e);
        to_page_info((uint32) e)->num_of_free_blocks--;
        return (void *)e;
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
        LIST_REMOVE(&freePagesList, page_info_e);

        page_info_e->block_size = pow;
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
        LIST_REMOVE(&freeBlockLists[index], e);
        to_page_info((uint32) e)->num_of_free_blocks--;

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
        if (!LIST_EMPTY(&freeBlockLists[i])) {
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
            LIST_REMOVE(&freeBlockLists[i], e);
            to_page_info((uint32) e)->num_of_free_blocks--;
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
		panic("free_block: address outside dynamic allocator range");
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
		panic("free_block: address is not properly aligned");
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
	int size = get_block_size(va);

	if (size == 0) {
		panic("free_block: attempting to free from unallocated page (double free detected)");
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
    struct BlockElement * block = (struct BlockElement *) va;
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
    page_info_e->num_of_free_blocks++;

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
		 tmp = LIST_NEXT(element);
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;

		 if (page_indexB == page_index){
				 LIST_REMOVE(&freeBlockLists[index], element);
				 blocks_removed++;
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
			panic("free_block: mismatch in number of blocks removed");
		}

    	page_info_e->num_of_free_blocks = 0;
        page_info_e->block_size = 0;
        LIST_INSERT_TAIL(&freePagesList, page_info_e);

        uint32 pp = to_page_va(page_info_e);
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
    return alloc_block(new_size);
  }

  if (new_size == 0) {
    free_block(va);
    return NULL;
  }

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  if (new_size < min_block_size)
    new_size = min_block_size;

  uint32 new_block_size = nearest_pow2_ceil(new_size);

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
    return va;
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  if (new_va == NULL) {
    return NULL;
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);

  return new_va;
}
