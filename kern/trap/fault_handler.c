/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <kern/cpu/cpu.h>
#include <kern/disk/pagefile_manager.h>
#include <kern/mem/memory_manager.h>
#include <kern/mem/kheap.h>

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;
//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}
/*2024*/ void setFASTNchanceCLOCK(bool fast){ FASTNchanceCLOCK = fast; };
/*2025*/ void setPageReplacmentAlgorithmOPTIMAL(){ _PageRepAlgoType = PG_REP_OPTIMAL; };

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmOPTIMAL(){if(_PageRepAlgoType == PG_REP_OPTIMAL) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//==================
// [0] INIT HANDLER:
//==================
void fault_handler_init()
{
	//setPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX);
	//setPageReplacmentAlgorithmOPTIMAL();
	setPageReplacmentAlgorithmCLOCK();
	//setPageReplacmentAlgorithmModifiedCLOCK();
	enableBuffering(0);
	enableModifiedBuffer(0) ;
	setModifiedBufferLength(1000);
}
//==================
// [1] MAIN HANDLER:
//==================
/*2022*/
uint32 last_eip = 0;
uint32 before_last_eip = 0;
uint32 last_fault_va = 0;
uint32 before_last_fault_va = 0;
int8 num_repeated_fault  = 0;
extern uint32 sys_calculate_free_frames() ;

struct Env* last_faulted_env = NULL;
void fault_handler(struct Trapframe *tf)
{
	/******************************************************/
	// Read processor's CR2 register to find the faulting address
	uint32 fault_va = rcr2();
	//cprintf("************Faulted VA = %x************\n", fault_va);
	//	print_trapframe(tf);
	/******************************************************/

	//If same fault va for 3 times, then panic
	//UPDATE: 3 FAULTS MUST come from the same environment (or the kernel)
	struct Env* cur_env = get_cpu_proc();
	if (last_fault_va == fault_va && last_faulted_env == cur_env)
	{
		num_repeated_fault++ ;
		if (num_repeated_fault == 3)
		{
			print_trapframe(tf);
			panic("Failed to handle fault! fault @ at va = %x from eip = %x causes va (%x) to be faulted for 3 successive times\n", before_last_fault_va, before_last_eip, fault_va);
		}
	}
	else
	{
		before_last_fault_va = last_fault_va;
		before_last_eip = last_eip;
		num_repeated_fault = 0;
	}
	last_eip = (uint32)tf->tf_eip;
	last_fault_va = fault_va ;
	last_faulted_env = cur_env;
	/******************************************************/
	//2017: Check stack overflow for Kernel
	int userTrap = 0;
	if ((tf->tf_cs & 3) == 3) {
		userTrap = 1;
	}
	if (!userTrap)
	{
		struct cpu* c = mycpu();
		//cprintf("trap from KERNEL\n");
		if (cur_env && fault_va >= (uint32)cur_env->kstack && fault_va < (uint32)cur_env->kstack + PAGE_SIZE)
			panic("User Kernel Stack: overflow exception!");
		else if (fault_va >= (uint32)c->stack && fault_va < (uint32)c->stack + PAGE_SIZE)
			panic("Sched Kernel Stack of CPU #%d: overflow exception!", c - CPUS);
#if USE_KHEAP
		if (fault_va >= KERNEL_HEAP_MAX)
			panic("Kernel: heap overflow exception!");
#endif
	}
	//2017: Check stack underflow for User
	else
	{
		//cprintf("trap from USER\n");
		if (fault_va >= USTACKTOP && fault_va < USER_TOP)
			panic("User: stack underflow exception!");
	}

	//get a pointer to the environment that caused the fault at runtime
	//cprintf("curenv = %x\n", curenv);
	struct Env* faulted_env = cur_env;
	if (faulted_env == NULL)
	{
		cprintf("\nFaulted VA = %x\n", fault_va);
		print_trapframe(tf);
		panic("faulted env == NULL!");
	}
	//check the faulted address, is it a table or not ?
	//If the directory entry of the faulted address is NOT PRESENT then
	if ( (faulted_env->env_page_directory[PDX(fault_va)] & PERM_PRESENT) != PERM_PRESENT)
	{
		faulted_env->tableFaultsCounter ++ ;
		table_fault_handler(faulted_env, fault_va);
	}
	else
	{
		if (userTrap)
		{
			/*============================================================================================*/
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #2 Check for invalid pointers
			//(e.g. pointing to unmarked user heap page, kernel or wrong access rights),
			//your code is here
#if USE_KHEAP
			int page_access_perms = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);

			int is_in_user_heap = (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX);

			int exceeds_user_limit = (fault_va >= USER_LIMIT);

			int is_present_readonly = ((page_access_perms & PERM_PRESENT) && !(page_access_perms & PERM_WRITEABLE));

			int has_heap_perms = (page_access_perms & PERM_UHPAGE);

			if (exceeds_user_limit) {
				env_exit();
			}
			else if (is_in_user_heap && !has_heap_perms) {
				env_exit();
			}
			else if (is_present_readonly) {
				env_exit();
			}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
			/*============================================================================================*/
		}

		/*2022: Check if fault due to Access Rights */
		int perms = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);
		if (perms & PERM_PRESENT)
			panic("Page @va=%x is exist! page fault due to violation of ACCESS RIGHTS\n", fault_va) ;
		/*============================================================================================*/


		// we have normal page fault =============================================================
		faulted_env->pageFaultsCounter ++ ;

//				cprintf("[%08s] user PAGE fault va %08x\n", faulted_env->prog_name, fault_va);
//				cprintf("\nPage working set BEFORE fault handler...\n");
//				env_page_ws_print(faulted_env);
		//int ffb = sys_calculate_free_frames();

		if(isBufferingEnabled())
		{
			__page_fault_handler_with_buffering(faulted_env, fault_va);
		}
		else
		{
			page_fault_handler(faulted_env, fault_va);
		}

		//		cprintf("\nPage working set AFTER fault handler...\n");
		//		env_page_ws_print(faulted_env);
		//		int ffa = sys_calculate_free_frames();
		//		cprintf("fault handling @%x: difference in free frames (after - before = %d)\n", fault_va, ffa - ffb);
	}

	/*************************************************************/
	//Refresh the TLB cache
	tlbflush();
	/*************************************************************/
}

//=========================
// [2] TABLE FAULT HANDLER:
//=========================
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//=========================
// [3] PAGE FAULT HANDLER:
//=========================
/* Calculate the number of page faults according th the OPTIMAL replacement strategy
 * Given:
 * 	1. Initial Working Set List (that the process started with)
 * 	2. Max Working Set Size
 * 	3. Page References List (contains the stream of referenced VAs till the process finished)
 *
 * 	IMPORTANT: This function SHOULD NOT change any of the given lists
 */
int get_optimal_num_faults(struct WS_List *initWS, int maxWSSize, struct PageRef_List *refStream)
{
	//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #2 get_optimal_num_faults
	//Your code is here
#if USE_KHEAP
    int faultCount = 0;

    struct WS_List WS;
    LIST_INIT(&WS);

    struct WorkingSetElement *e;
    LIST_FOREACH(e, initWS)
    {
        struct WorkingSetElement *cp = (struct WorkingSetElement*) kmalloc(sizeof(struct WorkingSetElement));
        cp->virtual_address = e->virtual_address;
        cp->sweeps_counter = e->sweeps_counter;
        cp->time_stamp = e->time_stamp;
        LIST_INSERT_TAIL(&WS, cp);
    }

    struct PageRefElement *curRef;
    LIST_FOREACH(curRef, refStream)
    {
        uint32 va = curRef->virtual_address;

        int hit = 0;
        struct WorkingSetElement *wsElem;

        LIST_FOREACH(wsElem, &WS)
        {
            if (wsElem->virtual_address == va)
            {
                hit = 1;
                break;
            }
        }

        if (hit)
            continue;   // No fault

        faultCount++;

        if (LIST_SIZE(&WS) < (uint32)maxWSSize)
        {
            struct WorkingSetElement *newElem = (struct WorkingSetElement*) kmalloc(sizeof(struct WorkingSetElement));

            newElem->virtual_address = va;
            LIST_INSERT_TAIL(&WS, newElem);
            continue;
        }

        struct WorkingSetElement *victim = NULL;
        uint32 farthestDistance = 0;

        LIST_FOREACH(wsElem, &WS)
        {
            uint32 distance = 0;
            int willBeUsedAgain = 0;

            struct PageRefElement *scan = LIST_NEXT(curRef);

            while (scan != NULL)
            {
                distance++;

                if (scan->virtual_address == wsElem->virtual_address)
                {
                    willBeUsedAgain = 1;
                    break;
                }

                scan = LIST_NEXT(scan);
            }

            if (!willBeUsedAgain)
            {
                victim = wsElem;
                break;
            }

            if (distance > farthestDistance)
            {
                farthestDistance = distance;
                victim = wsElem;
            }
        }

        LIST_REMOVE(&WS, victim);
        kfree(victim);

        struct WorkingSetElement *add = (struct WorkingSetElement*) kmalloc(sizeof(struct WorkingSetElement));
        add->virtual_address = va;
        LIST_INSERT_TAIL(&WS, add);
    }

    while (!LIST_EMPTY(&WS))
    {
        struct WorkingSetElement *tmp = LIST_FIRST(&WS);
        LIST_REMOVE(&WS, tmp);
        kfree(tmp);
    }

    return faultCount;
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	//Comment the following line
	//panic("get_optimal_num_faults() is not implemented yet...!!");
}

void reorder_ws_by_id(struct Env *e)
{
#if USE_KHEAP
    if (!e) return;

    // Save the pointer's id BEFORE reordering
    uint32 saved_id = 0;
    if (e->page_last_WS_element)
        saved_id = e->page_last_WS_element->id;

    bool changed = 1;

    while (changed)
    {
        changed = 0;

        struct WorkingSetElement *a = LIST_FIRST(&(e->page_WS_list));
        while (a)
        {
            struct WorkingSetElement *b = LIST_NEXT(a);
            if (!b) break;

            if (a->id > b->id)
            {
                LIST_REMOVE(&(e->page_WS_list), b);
                LIST_INSERT_BEFORE(&(e->page_WS_list), a, b);
                changed = 1;
                continue;
            }

            a = LIST_NEXT(a);
        }
    }

	struct WorkingSetElement *it;
    LIST_FOREACH_SAFE(it, &(e->page_WS_list), WorkingSetElement){
    	if(it->id == saved_id){
    		e->page_last_WS_element = it;
    		break;
    	}
    }
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

}

void THE_BEFORE_REPLACEMEEEEEEEEEENT(struct WorkingSetElement *victimWSElement,struct Env * faulted_env, uint32 victim_va,uint32 fault_va){
#if USE_KHEAP
	uint32 *ptr_page_table = NULL;
	struct FrameInfo *victimFrame = get_frame_info(faulted_env->env_page_directory, victim_va, &ptr_page_table);

	// Check the MODIFIED bit of the victim
	uint32 perms = pt_get_page_permissions(faulted_env->env_page_directory, victim_va);
	if(perms & PERM_MODIFIED) {
		pf_update_env_page(faulted_env, victim_va, victimFrame);
	}

	// Unmap the victim's frame and remove it from the working set list.
	// victimWSElement pointer is now INVALID.
	if(isPageReplacmentAlgorithmModifiedCLOCK())
	env_page_ws_invalidate(faulted_env, victim_va);
	else unmap_frame(faulted_env->env_page_directory, victim_va);

	struct FrameInfo *newf;
	allocate_frame(&newf);
	map_frame(faulted_env->env_page_directory, newf, fault_va, PERM_PRESENT | PERM_USER | PERM_WRITEABLE);

	int ret = pf_read_env_page(faulted_env, (void*)fault_va);
	if (ret == E_PAGE_NOT_EXIST_IN_PF)
	{
		if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
			  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
			env_exit();
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
}

void page_fault_handler(struct Env * faulted_env, uint32 fault_va)
{
#if USE_KHEAP
	if (isPageReplacmentAlgorithmOPTIMAL())
	{
		//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #1 Optimal Reference Stream
		//Your code is here

		fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
		uint32 *ptr_table = NULL;
		struct FrameInfo *fi = get_frame_info(faulted_env->env_page_directory, fault_va, &ptr_table);

		if (fi == NULL)
		{
			struct FrameInfo *newf;
			allocate_frame(&newf);
			map_frame(faulted_env->env_page_directory, newf, fault_va, PERM_PRESENT | PERM_USER | PERM_WRITEABLE);

			int ret = pf_read_env_page(faulted_env, (void*)fault_va);
			if (ret == E_PAGE_NOT_EXIST_IN_PF)
			{
				if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
					  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
					env_exit();
			}
		}
		else
			pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT, 0);

		struct PageRefElement *mref = (struct PageRefElement*) kmalloc(sizeof(struct PageRefElement));
		mref->virtual_address = fault_va;
		LIST_INSERT_TAIL(&(faulted_env->referenceStreamList), mref);

		if (!faulted_env->simWS_copy) {
			struct WorkingSetElement *e;
			LIST_FOREACH_SAFE(e, &(faulted_env->page_WS_list), WorkingSetElement)
			{
				struct WorkingSetElement *cp = (struct WorkingSetElement*) kmalloc(sizeof(struct WorkingSetElement));
				cp->virtual_address = e->virtual_address;
				LIST_INSERT_TAIL(&(faulted_env->simWS), cp);
			}
			faulted_env->simWS_copy = 1;
		}

		if(LIST_SIZE(&faulted_env->simWS) < (faulted_env->page_WS_max_size)) {
			struct WorkingSetElement* e = env_page_ws_list_create_element(faulted_env, fault_va);
			LIST_INSERT_TAIL(&faulted_env->simWS, e);
		} else {

		struct WorkingSetElement *it = NULL;
		LIST_FOREACH_SAFE(it, &faulted_env->simWS, WorkingSetElement) {
			pt_set_page_permissions(faulted_env->env_page_directory, it->virtual_address, 0, PERM_PRESENT);
			LIST_REMOVE(&faulted_env->simWS, it);
			kfree((void *)it);
		}

		struct WorkingSetElement *newWSE = env_page_ws_list_create_element(faulted_env, fault_va);
		LIST_INSERT_TAIL(&faulted_env->simWS, newWSE);
		}

		//Comment the following line
		//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
	}
	else
	{
		fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
		struct WorkingSetElement *victimWSElement = NULL;
		uint32 wsSize = LIST_SIZE(&(faulted_env->page_WS_list));
		if(wsSize < (faulted_env->page_WS_max_size))
		{
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #3 placement
			//Your code is here

			// Check if fault_va is already in the working set
			struct WorkingSetElement *wse_check;
			for(int i=0;i<10;i++){

			}
			bool already_in_ws = 0;
			LIST_FOREACH(wse_check, &(faulted_env->page_WS_list))
			{
				if(ROUNDDOWN(wse_check->virtual_address, PAGE_SIZE) == fault_va)
				{
					already_in_ws = 1;
					// Page is already in working set, just set it to present
					pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT, 0);
					return;
				}
			}

			if (!isPageReplacmentAlgorithmModifiedCLOCK())
			{
				reorder_ws_by_id(faulted_env);
			}
			//reorder_ws_by_id(faulted_env);

			struct FrameInfo *newf;
			allocate_frame(&newf);
			for(int i=0;i<10;i++){

			}
			map_frame(faulted_env->env_page_directory, newf, fault_va, PERM_PRESENT | PERM_USER | PERM_WRITEABLE);

			int ret = pf_read_env_page(faulted_env, (void*)fault_va);
			if (ret == E_PAGE_NOT_EXIST_IN_PF)
			{
				if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
					  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
					env_exit();
			}

			struct WorkingSetElement* e = env_page_ws_list_create_element(faulted_env, fault_va);
			// For Modified Clock, preserve Clock Hand and insert before it
			  if (isPageReplacmentAlgorithmModifiedCLOCK()) {
				if (faulted_env->page_last_WS_element != NULL) {
				  LIST_INSERT_BEFORE(&(faulted_env->page_WS_list),
									 faulted_env->page_last_WS_element, e);
				} else {
				  LIST_INSERT_TAIL(&(faulted_env->page_WS_list), e);
				}

				// Initialize Clock Hand if adding first element
				if (faulted_env->page_last_WS_element == NULL) {
				  faulted_env->page_last_WS_element =
					  LIST_FIRST(&(faulted_env->page_WS_list));
				}
			  } else {
				LIST_INSERT_TAIL(&(faulted_env->page_WS_list), e);

				if (LIST_SIZE(&(faulted_env->page_WS_list)) ==
					faulted_env->page_WS_max_size) {
				  faulted_env->page_last_WS_element =
					  LIST_FIRST(&(faulted_env->page_WS_list));
				} else
				  faulted_env->page_last_WS_element = NULL;
			  }
			//Comment the following line
			//panic("page_fault_handler().PLACEMENT is not implemented yet...!!");
		}
		else
		{
			if (isPageReplacmentAlgorithmCLOCK())
			{
				//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #3 Clock Replacement
				//Your code is here

				struct WorkingSetElement* ptr = faulted_env->page_last_WS_element;
				for(int i = 0; i < wsSize * 2; ++i){
					uint32 va = ROUNDDOWN(ptr->virtual_address, PAGE_SIZE);
					int perms = pt_get_page_permissions(faulted_env->env_page_directory, va);

					if (!(perms & PERM_USED)) {
						victimWSElement = ptr;
						break;
					}
					 pt_set_page_permissions(faulted_env->env_page_directory, va, 0, PERM_USED);

					 ptr = LIST_NEXT(ptr);
				     if (ptr == NULL) ptr = LIST_FIRST(&(faulted_env->page_WS_list));
				}

				uint32 victim_va = ROUNDDOWN(victimWSElement->virtual_address, PAGE_SIZE);

				struct WorkingSetElement *next = LIST_NEXT(victimWSElement);

				uint32 *ptr_page_table = NULL;
				struct FrameInfo *victimFrame = get_frame_info(faulted_env->env_page_directory, victim_va, &ptr_page_table);

				int perms = pt_get_page_permissions(faulted_env->env_page_directory, victim_va);
				//------------------->
				if(perms & PERM_MODIFIED)
					pf_update_env_page(faulted_env, victim_va, victimFrame);
				//------------------->
				env_page_ws_invalidate(faulted_env, victim_va);

				struct FrameInfo *newf;
				allocate_frame(&newf);
				map_frame(faulted_env->env_page_directory, newf, fault_va, PERM_PRESENT | PERM_USER | PERM_WRITEABLE);

				int ret = pf_read_env_page(faulted_env, (void*)fault_va);
				if (ret == E_PAGE_NOT_EXIST_IN_PF)
				{
					if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
						  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
						env_exit();
				}

				struct WorkingSetElement *newWSE = env_page_ws_list_create_element(faulted_env, fault_va);

				if (!next) LIST_INSERT_TAIL(&(faulted_env->page_WS_list), newWSE);
				else LIST_INSERT_BEFORE(&(faulted_env->page_WS_list), next, newWSE);

				if(!LIST_NEXT(newWSE)) faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
				else faulted_env->page_last_WS_element = LIST_NEXT(newWSE);

				//Comment the following line
				//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
			else if (isPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX))
			{
				//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #2 LRU Aging Replacement
				//Your code is here

				struct Env *cur_env = get_cpu_proc();
				if (cur_env == NULL)
					return;

				// Round down fault_va to PAGE_SIZE boundary
				fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);

				// Check if the frame already exists (page might be mapped but not present)
				uint32 *ptr_table = NULL;
				struct FrameInfo * frame_info = get_frame_info(cur_env->env_page_directory, fault_va, &ptr_table);

				if (frame_info != NULL)
				{
					// Frame already exists, just set PRESENT permission
					pt_set_page_permissions(cur_env->env_page_directory, fault_va, PERM_PRESENT, 0);
					return;
				}

				//=========== [1] intialize the required variables ============

				uint32 min_timestamp = 0xFFFFFFFF;
				//uint32 max_timestamp = 0; //--------------------------------------->
				uint32 victim_va = 0;
				struct FrameInfo *frame_to_evict = NULL;
	#if USE_KHEAP
				struct WorkingSetElement * the_victim = NULL;
	#else
				int victim_index = -1;
	#endif

				//============= [2] update aging time stamps ===========
				update_WS_time_stamps();

				//================== [3] Search through page_WS_list to find page with minimum time stamp ==================

	#if USE_KHEAP

				struct WorkingSetElement * working_set_ele = NULL;
				LIST_FOREACH(working_set_ele, &(cur_env->page_WS_list))
				{
					/*if (wse->time_stamp > max_timestamp) {//----------------------------------------------->
						 max_timestamp = wse->time_stamp;
					}//----------------------------------------------->*/
					if (working_set_ele->time_stamp < min_timestamp)
					{
						min_timestamp = working_set_ele->time_stamp;
						victim_va = working_set_ele->virtual_address;
						the_victim = working_set_ele;
					}
				}
	#else
				for (int i = 0; i < cur_env->page_WS_max_size; i++)
				{
					/*if (cur_env->ptr_pageWorkingSet[i].time_stamp > max_timestamp) {//------------------------------------>
						max_timestamp = cur_env->ptr_pageWorkingSet[i].time_stamp;
					}//-------------------------------------------->*/
					if (cur_env->ptr_pageWorkingSet[i].empty == 0 /*check if empty slot*/ &&
						cur_env->ptr_pageWorkingSet[i].time_stamp < min_timestamp)
					{
						min_timestamp = cur_env->ptr_pageWorkingSet[i].time_stamp;
						page_to_replace = cur_env->ptr_pageWorkingSet[i].virtual_address;
						victim_index = i;
					}
				}
	#endif

				//================= [4] the replacement =================
				if (victim_va != 0)
				{

					THE_BEFORE_REPLACEMEEEEEEEEEENT(the_victim,faulted_env,victim_va,fault_va);

	#if USE_KHEAP
					// Update the working set element with the new page info
					if (the_victim != NULL)
					{
						the_victim->virtual_address = fault_va;
						the_victim->time_stamp = 0xFFFFFFFF; // New page gets highest priority//------------------------------------------->
						//victim_wse->time_stamp = max_timestamp;//----------------------------------------------->
						the_victim->sweeps_counter = 0;
					}
	#else
					// Update the working set element with the new page info
					if (victim_index != -1)
					{
						cur_env->ptr_pageWorkingSet[victim_index].virtual_address = fault_va;
						cur_env->ptr_pageWorkingSet[victim_index].time_stamp = 0xFFFFFFFF; // New page gets highest priority//------------------------------------>
						//cur_env->ptr_pageWorkingSet[victim_index].time_stamp = max_timestamp;//-------------------------------------------->
						cur_env->ptr_pageWorkingSet[victim_index].sweeps_counter = 0;
						cur_env->ptr_pageWorkingSet[victim_index].empty = 0; // Mark as in use
					}
	#endif

					//cur_env->pageFaultsCounter++;
					//cur_env->nNewPageAdded++;
				}
				else
				{
					panic("page_fault_handler(): No suitable page found for LRU replacement");
				}

				//Comment the following line
				//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
			else if (isPageReplacmentAlgorithmModifiedCLOCK())
			{
				//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #3 Modified Clock Replacement
				//Your code is here

				if (faulted_env == NULL)
					return;

				fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);

				uint32 *ptr_table = NULL;
				struct FrameInfo * frame_info = get_frame_info(faulted_env->env_page_directory, fault_va, &ptr_table);
				if (frame_info != NULL)
				{
					pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT, 0);
					return;
				}

				// Variables for the replacement search
				struct WorkingSetElement *ptr = faulted_env->page_last_WS_element;
				struct WorkingSetElement * the_victim = NULL;
				uint32 victim_va = 0;

				//print_ws_for_trace(faulted_env, "BEFORE VICTIM REPLACEMENT");

				//(faulted_env, "BEFORE CLOCK SEARCH (Finding Victim)");

				// --- 1. Modified Clock Search Passes ---

				for (int pass = 0;pass<2;pass++)
				{
					// Start or resume the rotation from the clock hand
					ptr = (ptr == NULL) ? LIST_FIRST(&(faulted_env->page_WS_list)) : ptr;

					// Loop through the list (size check added for safety)
					for (int i = 0; i < wsSize; ++i)
					{
						uint32 va = ptr->virtual_address;
						uint32 perms = pt_get_page_permissions(faulted_env->env_page_directory, va);


						if (!(perms & PERM_USED) && !(perms & PERM_MODIFIED))
						{
							the_victim = ptr;
							victim_va = va;
							goto victim_found;
						}

						// Advance the clock hand (ptr)
						ptr = LIST_NEXT(ptr);
						if (ptr == NULL) ptr = LIST_FIRST(&(faulted_env->page_WS_list));
					}

					for (int i = 0; i < wsSize; ++i)
					{
						uint32 va = ptr->virtual_address;
						uint32 perms = pt_get_page_permissions(faulted_env->env_page_directory, va);

						if (!(perms & PERM_USED))
						{
							the_victim = ptr;
							victim_va = va;
							goto victim_found;
						}

						if (perms & PERM_USED)
						{
							pt_set_page_permissions(faulted_env->env_page_directory, va, 0, PERM_USED);
						}


						// Advance the clock hand (ptr)
						ptr = LIST_NEXT(ptr);
						if (ptr == NULL) ptr = LIST_FIRST(&(faulted_env->page_WS_list));

					}
				}

			// --- 2. Eviction and Loading ---
				victim_found:

				if (the_victim != NULL)
				{
					uint32 victim_va = ROUNDDOWN(the_victim->virtual_address, PAGE_SIZE);

					// Save the pointer to the element *after* the victim BEFORE removal
					struct WorkingSetElement *next = LIST_NEXT(the_victim);

					THE_BEFORE_REPLACEMEEEEEEEEEENT(the_victim,faulted_env,victim_va,fault_va);


					struct WorkingSetElement *new_WS_ele = env_page_ws_list_create_element(faulted_env, fault_va);


					if (!next)
						LIST_INSERT_TAIL(&(faulted_env->page_WS_list), new_WS_ele);
					else
						LIST_INSERT_BEFORE(&(faulted_env->page_WS_list), next, new_WS_ele);

					if(!LIST_NEXT(new_WS_ele))
						faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
					else
						faulted_env->page_last_WS_element = LIST_NEXT(new_WS_ele);
					//print_ws_for_trace(faulted_env, "AFTER VICTIM REPLACEMENT");
				}
				//Comment the following line
				//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
		}
	}
#endif
}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}
