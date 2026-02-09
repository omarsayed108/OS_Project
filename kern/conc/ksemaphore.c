// Kernel-level Semaphore

#include "inc/types.h"
#include "inc/x86.h"
#include "inc/memlayout.h"
#include "inc/mmu.h"
#include "inc/environment_definitions.h"
#include "inc/assert.h"
#include "inc/string.h"
#include "ksemaphore.h"
#include "channel.h"
#include "../cpu/cpu.h"
#include "../proc/user_environment.h"

void init_ksemaphore(struct ksemaphore *ksem, int value, char *name)
{
  init_channel(&(ksem->chan), "ksemaphore channel");
  init_kspinlock(&(ksem->lk), "lock of ksemaphore");
  strcpy(ksem->name, name);
  ksem->count = value;
}

void wait_ksemaphore(struct ksemaphore *ksema)
{
#if USE_KHEAP
	acquire_kspinlock(&(ksema->lk));

	ksema->count--;
	if (ksema->count < 0) {
	  sleep(&(ksema->chan), &(ksema->lk));
	}

	release_kspinlock(&(ksema->lk));
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

  //TODO: [PROJECT'25.IM#5] KERNEL PROTECTION: #6 SEMAPHORE - wait_ksemaphore
  //Your code is here
  //Comment the following line
  //panic("wait_ksemaphore() is not implemented yet...!!");

}

void signal_ksemaphore(struct ksemaphore *ksema)
{
#if USE_KHEAP
	acquire_kspinlock(&(ksema->lk));
	ksema->count++;
	if (ksema->count <= 0) {
	  wakeup_one(&(ksema->chan));
	}
	release_kspinlock(&(ksema->lk));
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

  //TODO: [PROJECT'25.IM#5] KERNEL PROTECTION: #7 SEMAPHORE - signal_ksemaphore
  //Your code is here
  //Comment the following line
  //panic("signal_ksemaphore() is not implemented yet...!!");

}
