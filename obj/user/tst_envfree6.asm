
obj/user/tst_envfree6:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 a1 02 00 00       	call   8002d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 60 39 80 00       	push   $0x803960
  800050:	e8 0b 20 00 00       	call   802060 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 61 3b 80 00       	mov    $0x803b61,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 da 27 00 00       	call   802880 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 d3 23 00 00       	call   802481 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 16 24 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 70 39 80 00       	push   $0x803970
  8000c4:	e8 ac 06 00 00       	call   800775 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size, (myEnv->SecondListSize),50);
  8000cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d1:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 a3 39 80 00       	push   $0x8039a3
  8000ed:	e8 ea 24 00 00       	call   8025dc <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fd:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 ac 39 80 00       	push   $0x8039ac
  800119:	e8 be 24 00 00       	call   8025dc <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 cb 24 00 00       	call   8025fa <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 10 27 00 00       	push   $0x2710
  80013a:	e8 ef 34 00 00       	call   80362e <env_sleep>
  80013f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 d4             	pushl  -0x2c(%ebp)
  800148:	e8 ad 24 00 00       	call   8025fa <sys_run_env>
  80014d:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  800150:	90                   	nop
  800151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 f6                	jne    800151 <_main+0x119>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80015b:	e8 21 23 00 00       	call   802481 <sys_calculate_free_frames>
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	50                   	push   %eax
  800164:	68 b8 39 80 00       	push   $0x8039b8
  800169:	e8 07 06 00 00       	call   800775 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800171:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 f9 26 00 00       	call   802880 <sys_utilities>
  800187:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80018a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800190:	bb c5 3b 80 00       	mov    $0x803bc5,%ebx
  800195:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	89 de                	mov    %ebx,%esi
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a2:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a8:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001ad:	b0 00                	mov    $0x0,%al
  8001af:	89 d7                	mov    %edx,%edi
  8001b1:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	6a 00                	push   $0x0
  8001b8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	e8 bc 26 00 00       	call   802880 <sys_utilities>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 44 24 00 00       	call   802616 <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001db:	e8 36 24 00 00       	call   802616 <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	6a 01                	push   $0x1
  8001e8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 8c 26 00 00       	call   802880 <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f7:	e8 85 22 00 00       	call   802481 <sys_calculate_free_frames>
  8001fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 c8 22 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  800204:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800207:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80020e:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800217:	01 d0                	add    %edx,%eax
  800219:	48                   	dec    %eax
  80021a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80021d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800220:	ba 00 00 00 00       	mov    $0x0,%edx
  800225:	f7 75 c8             	divl   -0x38(%ebp)
  800228:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80022b:	29 d0                	sub    %edx,%eax
  80022d:	89 c1                	mov    %eax,%ecx
  80022f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800236:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  80023c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	48                   	dec    %eax
  800242:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800245:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	f7 75 c0             	divl   -0x40(%ebp)
  800250:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800253:	29 d0                	sub    %edx,%eax
  800255:	29 c1                	sub    %eax,%ecx
  800257:	89 c8                	mov    %ecx,%eax
  800259:	c1 e8 0c             	shr    $0xc,%eax
  80025c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 b8             	pushl  -0x48(%ebp)
  800265:	68 ea 39 80 00       	push   $0x8039ea
  80026a:	e8 06 05 00 00       	call   800775 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800278:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80027b:	74 2e                	je     8002ab <_main+0x273>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  80027d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	ff 75 b8             	pushl  -0x48(%ebp)
  800286:	50                   	push   %eax
  800287:	ff 75 d0             	pushl  -0x30(%ebp)
  80028a:	68 fc 39 80 00       	push   $0x8039fc
  80028f:	e8 e1 04 00 00       	call   800775 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 6c 3a 80 00       	push   $0x803a6c
  80029f:	6a 36                	push   $0x36
  8002a1:	68 a2 3a 80 00       	push   $0x803aa2
  8002a6:	e8 dc 01 00 00       	call   800487 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b1:	68 b8 3a 80 00       	push   $0x803ab8
  8002b6:	e8 ba 04 00 00       	call   800775 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 18 3b 80 00       	push   $0x803b18
  8002c6:	e8 aa 04 00 00       	call   800775 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ce:	90                   	nop
}
  8002cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e0:	e8 65 23 00 00       	call   80264a <sys_getenvindex>
  8002e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	01 c0                	add    %eax,%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 d0                	add    %edx,%eax
  8002f6:	c1 e0 02             	shl    $0x2,%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	c1 e0 03             	shl    $0x3,%eax
  8002fe:	01 d0                	add    %edx,%eax
  800300:	c1 e0 02             	shl    $0x2,%eax
  800303:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800308:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8a 40 20             	mov    0x20(%eax),%al
  800315:	84 c0                	test   %al,%al
  800317:	74 0d                	je     800326 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800319:	a1 20 50 80 00       	mov    0x805020,%eax
  80031e:	83 c0 20             	add    $0x20,%eax
  800321:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032a:	7e 0a                	jle    800336 <libmain+0x5f>
		binaryname = argv[0];
  80032c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 f4 fc ff ff       	call   800038 <_main>
  800344:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800347:	a1 00 50 80 00       	mov    0x805000,%eax
  80034c:	85 c0                	test   %eax,%eax
  80034e:	0f 84 01 01 00 00    	je     800455 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800354:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035a:	bb 24 3d 80 00       	mov    $0x803d24,%ebx
  80035f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800364:	89 c7                	mov    %eax,%edi
  800366:	89 de                	mov    %ebx,%esi
  800368:	89 d1                	mov    %edx,%ecx
  80036a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80036c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800374:	b0 00                	mov    $0x0,%al
  800376:	89 d7                	mov    %edx,%edi
  800378:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80037a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800381:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	50                   	push   %eax
  800388:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038e:	50                   	push   %eax
  80038f:	e8 ec 24 00 00       	call   802880 <sys_utilities>
  800394:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800397:	e8 35 20 00 00       	call   8023d1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	68 44 3c 80 00       	push   $0x803c44
  8003a4:	e8 cc 03 00 00       	call   800775 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	74 18                	je     8003cb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003b3:	e8 e6 24 00 00       	call   80289e <sys_get_optimal_num_faults>
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	50                   	push   %eax
  8003bc:	68 6c 3c 80 00       	push   $0x803c6c
  8003c1:	e8 af 03 00 00       	call   800775 <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	eb 59                	jmp    800424 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d0:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003db:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	68 90 3c 80 00       	push   $0x803c90
  8003eb:	e8 85 03 00 00       	call   800775 <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f8:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800403:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800409:	a1 20 50 80 00       	mov    0x805020,%eax
  80040e:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800414:	51                   	push   %ecx
  800415:	52                   	push   %edx
  800416:	50                   	push   %eax
  800417:	68 b8 3c 80 00       	push   $0x803cb8
  80041c:	e8 54 03 00 00       	call   800775 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800424:	a1 20 50 80 00       	mov    0x805020,%eax
  800429:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 10 3d 80 00       	push   $0x803d10
  800438:	e8 38 03 00 00       	call   800775 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	68 44 3c 80 00       	push   $0x803c44
  800448:	e8 28 03 00 00       	call   800775 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800450:	e8 96 1f 00 00       	call   8023eb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800455:	e8 1f 00 00 00       	call   800479 <exit>
}
  80045a:	90                   	nop
  80045b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045e:	5b                   	pop    %ebx
  80045f:	5e                   	pop    %esi
  800460:	5f                   	pop    %edi
  800461:	5d                   	pop    %ebp
  800462:	c3                   	ret    

00800463 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	6a 00                	push   $0x0
  80046e:	e8 a3 21 00 00       	call   802616 <sys_destroy_env>
  800473:	83 c4 10             	add    $0x10,%esp
}
  800476:	90                   	nop
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <exit>:

void
exit(void)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047f:	e8 f8 21 00 00       	call   80267c <sys_exit_env>
}
  800484:	90                   	nop
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80048d:	8d 45 10             	lea    0x10(%ebp),%eax
  800490:	83 c0 04             	add    $0x4,%eax
  800493:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800496:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80049b:	85 c0                	test   %eax,%eax
  80049d:	74 16                	je     8004b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049f:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 88 3d 80 00       	push   $0x803d88
  8004ad:	e8 c3 02 00 00       	call   800775 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b5:	a1 04 50 80 00       	mov    0x805004,%eax
  8004ba:	83 ec 0c             	sub    $0xc,%esp
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	ff 75 08             	pushl  0x8(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	68 90 3d 80 00       	push   $0x803d90
  8004c9:	6a 74                	push   $0x74
  8004cb:	e8 d2 02 00 00       	call   8007a2 <cprintf_colored>
  8004d0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	50                   	push   %eax
  8004dd:	e8 24 02 00 00       	call   800706 <vcprintf>
  8004e2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	6a 00                	push   $0x0
  8004ea:	68 b8 3d 80 00       	push   $0x803db8
  8004ef:	e8 12 02 00 00       	call   800706 <vcprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f7:	e8 7d ff ff ff       	call   800479 <exit>

	// should not return here
	while (1) ;
  8004fc:	eb fe                	jmp    8004fc <_panic+0x75>

008004fe <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	53                   	push   %ebx
  800502:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800505:	a1 20 50 80 00       	mov    0x805020,%eax
  80050a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800510:	8b 45 0c             	mov    0xc(%ebp),%eax
  800513:	39 c2                	cmp    %eax,%edx
  800515:	74 14                	je     80052b <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	68 bc 3d 80 00       	push   $0x803dbc
  80051f:	6a 26                	push   $0x26
  800521:	68 08 3e 80 00       	push   $0x803e08
  800526:	e8 5c ff ff ff       	call   800487 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800532:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800539:	e9 d9 00 00 00       	jmp    800617 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800541:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	01 d0                	add    %edx,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	85 c0                	test   %eax,%eax
  800551:	75 08                	jne    80055b <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800553:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800556:	e9 b9 00 00 00       	jmp    800614 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80055b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800562:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800569:	eb 79                	jmp    8005e4 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80056b:	a1 20 50 80 00       	mov    0x805020,%eax
  800570:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800576:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800579:	89 d0                	mov    %edx,%eax
  80057b:	01 c0                	add    %eax,%eax
  80057d:	01 d0                	add    %edx,%eax
  80057f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800586:	01 d8                	add    %ebx,%eax
  800588:	01 d0                	add    %edx,%eax
  80058a:	01 c8                	add    %ecx,%eax
  80058c:	8a 40 04             	mov    0x4(%eax),%al
  80058f:	84 c0                	test   %al,%al
  800591:	75 4e                	jne    8005e1 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800593:	a1 20 50 80 00       	mov    0x805020,%eax
  800598:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80059e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005ae:	01 d8                	add    %ebx,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	01 c8                	add    %ecx,%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	01 c8                	add    %ecx,%eax
  8005d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d4:	39 c2                	cmp    %eax,%edx
  8005d6:	75 09                	jne    8005e1 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005df:	eb 19                	jmp    8005fa <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e1:	ff 45 e8             	incl   -0x18(%ebp)
  8005e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f2:	39 c2                	cmp    %eax,%edx
  8005f4:	0f 87 71 ff ff ff    	ja     80056b <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 14 3e 80 00       	push   $0x803e14
  800608:	6a 3a                	push   $0x3a
  80060a:	68 08 3e 80 00       	push   $0x803e08
  80060f:	e8 73 fe ff ff       	call   800487 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 1b ff ff ff    	jl     80053e <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 2e                	jmp    800661 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 50 80 00       	mov    0x805020,%eax
  800638:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80064e:	01 d8                	add    %ebx,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c8                	add    %ecx,%eax
  800654:	8a 40 04             	mov    0x4(%eax),%al
  800657:	3c 01                	cmp    $0x1,%al
  800659:	75 03                	jne    80065e <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80065b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065e:	ff 45 e0             	incl   -0x20(%ebp)
  800661:	a1 20 50 80 00       	mov    0x805020,%eax
  800666:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80066c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066f:	39 c2                	cmp    %eax,%edx
  800671:	77 c0                	ja     800633 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800676:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800679:	74 14                	je     80068f <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80067b:	83 ec 04             	sub    $0x4,%esp
  80067e:	68 68 3e 80 00       	push   $0x803e68
  800683:	6a 44                	push   $0x44
  800685:	68 08 3e 80 00       	push   $0x803e08
  80068a:	e8 f8 fd ff ff       	call   800487 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80068f:	90                   	nop
  800690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800693:	c9                   	leave  
  800694:	c3                   	ret    

00800695 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
  800698:	53                   	push   %ebx
  800699:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a7:	89 0a                	mov    %ecx,(%edx)
  8006a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ac:	88 d1                	mov    %dl,%cl
  8006ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006bf:	75 30                	jne    8006f1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006c1:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006c7:	a0 44 50 80 00       	mov    0x805044,%al
  8006cc:	0f b6 c0             	movzbl %al,%eax
  8006cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d2:	8b 09                	mov    (%ecx),%ecx
  8006d4:	89 cb                	mov    %ecx,%ebx
  8006d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d9:	83 c1 08             	add    $0x8,%ecx
  8006dc:	52                   	push   %edx
  8006dd:	50                   	push   %eax
  8006de:	53                   	push   %ebx
  8006df:	51                   	push   %ecx
  8006e0:	e8 a8 1c 00 00       	call   80238d <sys_cputs>
  8006e5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 40 04             	mov    0x4(%eax),%eax
  8006f7:	8d 50 01             	lea    0x1(%eax),%edx
  8006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800700:	90                   	nop
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800716:	00 00 00 
	b.cnt = 0;
  800719:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800720:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	ff 75 08             	pushl  0x8(%ebp)
  800729:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072f:	50                   	push   %eax
  800730:	68 95 06 80 00       	push   $0x800695
  800735:	e8 5a 02 00 00       	call   800994 <vprintfmt>
  80073a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80073d:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800743:	a0 44 50 80 00       	mov    0x805044,%al
  800748:	0f b6 c0             	movzbl %al,%eax
  80074b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800751:	52                   	push   %edx
  800752:	50                   	push   %eax
  800753:	51                   	push   %ecx
  800754:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075a:	83 c0 08             	add    $0x8,%eax
  80075d:	50                   	push   %eax
  80075e:	e8 2a 1c 00 00       	call   80238d <sys_cputs>
  800763:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800766:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80076d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800782:	8d 45 0c             	lea    0xc(%ebp),%eax
  800785:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 f4             	pushl  -0xc(%ebp)
  800791:	50                   	push   %eax
  800792:	e8 6f ff ff ff       	call   800706 <vcprintf>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a8:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	c1 e0 08             	shl    $0x8,%eax
  8007b5:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8007ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	e8 34 ff ff ff       	call   800706 <vcprintf>
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007d8:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007df:	07 00 00 

	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007ed:	e8 df 1b 00 00       	call   8023d1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800801:	50                   	push   %eax
  800802:	e8 ff fe ff ff       	call   800706 <vcprintf>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80080d:	e8 d9 1b 00 00       	call   8023eb <sys_unlock_cons>
	return cnt;
  800812:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 14             	sub    $0x14,%esp
  80081e:	8b 45 10             	mov    0x10(%ebp),%eax
  800821:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80082a:	8b 45 18             	mov    0x18(%ebp),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800835:	77 55                	ja     80088c <printnum+0x75>
  800837:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083a:	72 05                	jb     800841 <printnum+0x2a>
  80083c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083f:	77 4b                	ja     80088c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800841:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800844:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800847:	8b 45 18             	mov    0x18(%ebp),%eax
  80084a:	ba 00 00 00 00       	mov    $0x0,%edx
  80084f:	52                   	push   %edx
  800850:	50                   	push   %eax
  800851:	ff 75 f4             	pushl  -0xc(%ebp)
  800854:	ff 75 f0             	pushl  -0x10(%ebp)
  800857:	e8 90 2e 00 00       	call   8036ec <__udivdi3>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	ff 75 20             	pushl  0x20(%ebp)
  800865:	53                   	push   %ebx
  800866:	ff 75 18             	pushl  0x18(%ebp)
  800869:	52                   	push   %edx
  80086a:	50                   	push   %eax
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	e8 a1 ff ff ff       	call   800817 <printnum>
  800876:	83 c4 20             	add    $0x20,%esp
  800879:	eb 1a                	jmp    800895 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 20             	pushl  0x20(%ebp)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088c:	ff 4d 1c             	decl   0x1c(%ebp)
  80088f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800893:	7f e6                	jg     80087b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800895:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800898:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a3:	53                   	push   %ebx
  8008a4:	51                   	push   %ecx
  8008a5:	52                   	push   %edx
  8008a6:	50                   	push   %eax
  8008a7:	e8 50 2f 00 00       	call   8037fc <__umoddi3>
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	05 d4 40 80 00       	add    $0x8040d4,%eax
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
}
  8008c8:	90                   	nop
  8008c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d5:	7e 1c                	jle    8008f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	8d 50 08             	lea    0x8(%eax),%edx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	89 10                	mov    %edx,(%eax)
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	83 e8 08             	sub    $0x8,%eax
  8008ec:	8b 50 04             	mov    0x4(%eax),%edx
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	eb 40                	jmp    800933 <getuint+0x65>
	else if (lflag)
  8008f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f7:	74 1e                	je     800917 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
  800915:	eb 1c                	jmp    800933 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8d 50 04             	lea    0x4(%eax),%edx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	89 10                	mov    %edx,(%eax)
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800938:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093c:	7e 1c                	jle    80095a <getint+0x25>
		return va_arg(*ap, long long);
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	8d 50 08             	lea    0x8(%eax),%edx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	89 10                	mov    %edx,(%eax)
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	83 e8 08             	sub    $0x8,%eax
  800953:	8b 50 04             	mov    0x4(%eax),%edx
  800956:	8b 00                	mov    (%eax),%eax
  800958:	eb 38                	jmp    800992 <getint+0x5d>
	else if (lflag)
  80095a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095e:	74 1a                	je     80097a <getint+0x45>
		return va_arg(*ap, long);
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	8d 50 04             	lea    0x4(%eax),%edx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	89 10                	mov    %edx,(%eax)
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	83 e8 04             	sub    $0x4,%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	99                   	cltd   
  800978:	eb 18                	jmp    800992 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	8d 50 04             	lea    0x4(%eax),%edx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 10                	mov    %edx,(%eax)
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	83 e8 04             	sub    $0x4,%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	99                   	cltd   
}
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099c:	eb 17                	jmp    8009b5 <vprintfmt+0x21>
			if (ch == '\0')
  80099e:	85 db                	test   %ebx,%ebx
  8009a0:	0f 84 c1 03 00 00    	je     800d67 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	53                   	push   %ebx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8d 50 01             	lea    0x1(%eax),%edx
  8009bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8009be:	8a 00                	mov    (%eax),%al
  8009c0:	0f b6 d8             	movzbl %al,%ebx
  8009c3:	83 fb 25             	cmp    $0x25,%ebx
  8009c6:	75 d6                	jne    80099e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009eb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f1:	8a 00                	mov    (%eax),%al
  8009f3:	0f b6 d8             	movzbl %al,%ebx
  8009f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f9:	83 f8 5b             	cmp    $0x5b,%eax
  8009fc:	0f 87 3d 03 00 00    	ja     800d3f <vprintfmt+0x3ab>
  800a02:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  800a09:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0f:	eb d7                	jmp    8009e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a11:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a15:	eb d1                	jmp    8009e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	c1 e0 02             	shl    $0x2,%eax
  800a26:	01 d0                	add    %edx,%eax
  800a28:	01 c0                	add    %eax,%eax
  800a2a:	01 d8                	add    %ebx,%eax
  800a2c:	83 e8 30             	sub    $0x30,%eax
  800a2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3d:	7e 3e                	jle    800a7d <vprintfmt+0xe9>
  800a3f:	83 fb 39             	cmp    $0x39,%ebx
  800a42:	7f 39                	jg     800a7d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a44:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a47:	eb d5                	jmp    800a1e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	83 c0 04             	add    $0x4,%eax
  800a4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	83 e8 04             	sub    $0x4,%eax
  800a58:	8b 00                	mov    (%eax),%eax
  800a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a5d:	eb 1f                	jmp    800a7e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	79 83                	jns    8009e8 <vprintfmt+0x54>
				width = 0;
  800a65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6c:	e9 77 ff ff ff       	jmp    8009e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a71:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a78:	e9 6b ff ff ff       	jmp    8009e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a7d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a82:	0f 89 60 ff ff ff    	jns    8009e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a95:	e9 4e ff ff ff       	jmp    8009e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a9a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a9d:	e9 46 ff ff ff       	jmp    8009e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 c0 04             	add    $0x4,%eax
  800aa8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	50                   	push   %eax
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	ff d0                	call   *%eax
  800abf:	83 c4 10             	add    $0x10,%esp
			break;
  800ac2:	e9 9b 02 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 e8 04             	sub    $0x4,%eax
  800ad6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad8:	85 db                	test   %ebx,%ebx
  800ada:	79 02                	jns    800ade <vprintfmt+0x14a>
				err = -err;
  800adc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ade:	83 fb 64             	cmp    $0x64,%ebx
  800ae1:	7f 0b                	jg     800aee <vprintfmt+0x15a>
  800ae3:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  800aea:	85 f6                	test   %esi,%esi
  800aec:	75 19                	jne    800b07 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aee:	53                   	push   %ebx
  800aef:	68 e5 40 80 00       	push   $0x8040e5
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	ff 75 08             	pushl  0x8(%ebp)
  800afa:	e8 70 02 00 00       	call   800d6f <printfmt>
  800aff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b02:	e9 5b 02 00 00       	jmp    800d62 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b07:	56                   	push   %esi
  800b08:	68 ee 40 80 00       	push   $0x8040ee
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	ff 75 08             	pushl  0x8(%ebp)
  800b13:	e8 57 02 00 00       	call   800d6f <printfmt>
  800b18:	83 c4 10             	add    $0x10,%esp
			break;
  800b1b:	e9 42 02 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b20:	8b 45 14             	mov    0x14(%ebp),%eax
  800b23:	83 c0 04             	add    $0x4,%eax
  800b26:	89 45 14             	mov    %eax,0x14(%ebp)
  800b29:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 30                	mov    (%eax),%esi
  800b31:	85 f6                	test   %esi,%esi
  800b33:	75 05                	jne    800b3a <vprintfmt+0x1a6>
				p = "(null)";
  800b35:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  800b3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3e:	7e 6d                	jle    800bad <vprintfmt+0x219>
  800b40:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b44:	74 67                	je     800bad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	50                   	push   %eax
  800b4d:	56                   	push   %esi
  800b4e:	e8 1e 03 00 00       	call   800e71 <strnlen>
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b59:	eb 16                	jmp    800b71 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	50                   	push   %eax
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	ff d0                	call   *%eax
  800b6b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b75:	7f e4                	jg     800b5b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b77:	eb 34                	jmp    800bad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b7d:	74 1c                	je     800b9b <vprintfmt+0x207>
  800b7f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b82:	7e 05                	jle    800b89 <vprintfmt+0x1f5>
  800b84:	83 fb 7e             	cmp    $0x7e,%ebx
  800b87:	7e 12                	jle    800b9b <vprintfmt+0x207>
					putch('?', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	6a 3f                	push   $0x3f
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	eb 0f                	jmp    800baa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	53                   	push   %ebx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800baa:	ff 4d e4             	decl   -0x1c(%ebp)
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	8d 70 01             	lea    0x1(%eax),%esi
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	0f be d8             	movsbl %al,%ebx
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	74 24                	je     800bdf <vprintfmt+0x24b>
  800bbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbf:	78 b8                	js     800b79 <vprintfmt+0x1e5>
  800bc1:	ff 4d e0             	decl   -0x20(%ebp)
  800bc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc8:	79 af                	jns    800b79 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bca:	eb 13                	jmp    800bdf <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	6a 20                	push   $0x20
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff d0                	call   *%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be3:	7f e7                	jg     800bcc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be5:	e9 78 01 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bea:	83 ec 08             	sub    $0x8,%esp
  800bed:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf3:	50                   	push   %eax
  800bf4:	e8 3c fd ff ff       	call   800935 <getint>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c08:	85 d2                	test   %edx,%edx
  800c0a:	79 23                	jns    800c2f <vprintfmt+0x29b>
				putch('-', putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	6a 2d                	push   $0x2d
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	ff d0                	call   *%eax
  800c19:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c22:	f7 d8                	neg    %eax
  800c24:	83 d2 00             	adc    $0x0,%edx
  800c27:	f7 da                	neg    %edx
  800c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c36:	e9 bc 00 00 00       	jmp    800cf7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c41:	8d 45 14             	lea    0x14(%ebp),%eax
  800c44:	50                   	push   %eax
  800c45:	e8 84 fc ff ff       	call   8008ce <getuint>
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c53:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c5a:	e9 98 00 00 00       	jmp    800cf7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 58                	push   $0x58
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	6a 58                	push   $0x58
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	ff d0                	call   *%eax
  800c7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 58                	push   $0x58
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			break;
  800c8f:	e9 ce 00 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	6a 30                	push   $0x30
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	6a 78                	push   $0x78
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	ff d0                	call   *%eax
  800cb1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 c0 04             	add    $0x4,%eax
  800cba:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ccf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd6:	eb 1f                	jmp    800cf7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cde:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce1:	50                   	push   %eax
  800ce2:	e8 e7 fb ff ff       	call   8008ce <getuint>
  800ce7:	83 c4 10             	add    $0x10,%esp
  800cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ced:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	83 ec 04             	sub    $0x4,%esp
  800d01:	52                   	push   %edx
  800d02:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 f4             	pushl  -0xc(%ebp)
  800d09:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 00 fb ff ff       	call   800817 <printnum>
  800d17:	83 c4 20             	add    $0x20,%esp
			break;
  800d1a:	eb 46                	jmp    800d62 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	53                   	push   %ebx
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	ff d0                	call   *%eax
  800d28:	83 c4 10             	add    $0x10,%esp
			break;
  800d2b:	eb 35                	jmp    800d62 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d2d:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d34:	eb 2c                	jmp    800d62 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d36:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d3d:	eb 23                	jmp    800d62 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	6a 25                	push   $0x25
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4f:	ff 4d 10             	decl   0x10(%ebp)
  800d52:	eb 03                	jmp    800d57 <vprintfmt+0x3c3>
  800d54:	ff 4d 10             	decl   0x10(%ebp)
  800d57:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5a:	48                   	dec    %eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3c 25                	cmp    $0x25,%al
  800d5f:	75 f3                	jne    800d54 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d61:	90                   	nop
		}
	}
  800d62:	e9 35 fc ff ff       	jmp    80099c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d67:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d75:	8d 45 10             	lea    0x10(%ebp),%eax
  800d78:	83 c0 04             	add    $0x4,%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	ff 75 f4             	pushl  -0xc(%ebp)
  800d84:	50                   	push   %eax
  800d85:	ff 75 0c             	pushl  0xc(%ebp)
  800d88:	ff 75 08             	pushl  0x8(%ebp)
  800d8b:	e8 04 fc ff ff       	call   800994 <vprintfmt>
  800d90:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d93:	90                   	nop
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 40 08             	mov    0x8(%eax),%eax
  800d9f:	8d 50 01             	lea    0x1(%eax),%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 10                	mov    (%eax),%edx
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	8b 40 04             	mov    0x4(%eax),%eax
  800db3:	39 c2                	cmp    %eax,%edx
  800db5:	73 12                	jae    800dc9 <sprintputch+0x33>
		*b->buf++ = ch;
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	8d 48 01             	lea    0x1(%eax),%ecx
  800dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc2:	89 0a                	mov    %ecx,(%edx)
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	88 10                	mov    %dl,(%eax)
}
  800dc9:	90                   	nop
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	01 d0                	add    %edx,%eax
  800de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ded:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df1:	74 06                	je     800df9 <vsnprintf+0x2d>
  800df3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df7:	7f 07                	jg     800e00 <vsnprintf+0x34>
		return -E_INVAL;
  800df9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfe:	eb 20                	jmp    800e20 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e00:	ff 75 14             	pushl  0x14(%ebp)
  800e03:	ff 75 10             	pushl  0x10(%ebp)
  800e06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e09:	50                   	push   %eax
  800e0a:	68 96 0d 80 00       	push   $0x800d96
  800e0f:	e8 80 fb ff ff       	call   800994 <vprintfmt>
  800e14:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e28:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2b:	83 c0 04             	add    $0x4,%eax
  800e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	ff 75 f4             	pushl  -0xc(%ebp)
  800e37:	50                   	push   %eax
  800e38:	ff 75 0c             	pushl  0xc(%ebp)
  800e3b:	ff 75 08             	pushl  0x8(%ebp)
  800e3e:	e8 89 ff ff ff       	call   800dcc <vsnprintf>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5b:	eb 06                	jmp    800e63 <strlen+0x15>
		n++;
  800e5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e60:	ff 45 08             	incl   0x8(%ebp)
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	75 f1                	jne    800e5d <strlen+0xf>
		n++;
	return n;
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7e:	eb 09                	jmp    800e89 <strnlen+0x18>
		n++;
  800e80:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e83:	ff 45 08             	incl   0x8(%ebp)
  800e86:	ff 4d 0c             	decl   0xc(%ebp)
  800e89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8d:	74 09                	je     800e98 <strnlen+0x27>
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	84 c0                	test   %al,%al
  800e96:	75 e8                	jne    800e80 <strnlen+0xf>
		n++;
	return n;
  800e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea9:	90                   	nop
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8d 50 01             	lea    0x1(%eax),%edx
  800eb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebc:	8a 12                	mov    (%edx),%dl
  800ebe:	88 10                	mov    %dl,(%eax)
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	84 c0                	test   %al,%al
  800ec4:	75 e4                	jne    800eaa <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ede:	eb 1f                	jmp    800eff <strncpy+0x34>
		*dst++ = *src;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8d 50 01             	lea    0x1(%eax),%edx
  800ee6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	84 c0                	test   %al,%al
  800ef7:	74 03                	je     800efc <strncpy+0x31>
			src++;
  800ef9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efc:	ff 45 fc             	incl   -0x4(%ebp)
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f05:	72 d9                	jb     800ee0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1c:	74 30                	je     800f4e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f1e:	eb 16                	jmp    800f36 <strlcpy+0x2a>
			*dst++ = *src++;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8d 50 01             	lea    0x1(%eax),%edx
  800f26:	89 55 08             	mov    %edx,0x8(%ebp)
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f32:	8a 12                	mov    (%edx),%dl
  800f34:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f36:	ff 4d 10             	decl   0x10(%ebp)
  800f39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3d:	74 09                	je     800f48 <strlcpy+0x3c>
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	75 d8                	jne    800f20 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	29 c2                	sub    %eax,%edx
  800f56:	89 d0                	mov    %edx,%eax
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5d:	eb 06                	jmp    800f65 <strcmp+0xb>
		p++, q++;
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	84 c0                	test   %al,%al
  800f6c:	74 0e                	je     800f7c <strcmp+0x22>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 10                	mov    (%eax),%dl
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	38 c2                	cmp    %al,%dl
  800f7a:	74 e3                	je     800f5f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	0f b6 d0             	movzbl %al,%edx
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 c0             	movzbl %al,%eax
  800f8c:	29 c2                	sub    %eax,%edx
  800f8e:	89 d0                	mov    %edx,%eax
}
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f95:	eb 09                	jmp    800fa0 <strncmp+0xe>
		n--, p++, q++;
  800f97:	ff 4d 10             	decl   0x10(%ebp)
  800f9a:	ff 45 08             	incl   0x8(%ebp)
  800f9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	74 17                	je     800fbd <strncmp+0x2b>
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	84 c0                	test   %al,%al
  800fad:	74 0e                	je     800fbd <strncmp+0x2b>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 10                	mov    (%eax),%dl
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	38 c2                	cmp    %al,%dl
  800fbb:	74 da                	je     800f97 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc1:	75 07                	jne    800fca <strncmp+0x38>
		return 0;
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc8:	eb 14                	jmp    800fde <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f b6 d0             	movzbl %al,%edx
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f b6 c0             	movzbl %al,%eax
  800fda:	29 c2                	sub    %eax,%edx
  800fdc:	89 d0                	mov    %edx,%eax
}
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 04             	sub    $0x4,%esp
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fec:	eb 12                	jmp    801000 <strchr+0x20>
		if (*s == c)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff6:	75 05                	jne    800ffd <strchr+0x1d>
			return (char *) s;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	eb 11                	jmp    80100e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	75 e5                	jne    800fee <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101c:	eb 0d                	jmp    80102b <strfind+0x1b>
		if (*s == c)
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801026:	74 0e                	je     801036 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801028:	ff 45 08             	incl   0x8(%ebp)
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	84 c0                	test   %al,%al
  801032:	75 ea                	jne    80101e <strfind+0xe>
  801034:	eb 01                	jmp    801037 <strfind+0x27>
		if (*s == c)
			break;
  801036:	90                   	nop
	return (char *) s;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801048:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80104c:	76 63                	jbe    8010b1 <memset+0x75>
		uint64 data_block = c;
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	99                   	cltd   
  801052:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801055:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801062:	c1 e0 08             	shl    $0x8,%eax
  801065:	09 45 f0             	or     %eax,-0x10(%ebp)
  801068:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80106b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801071:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801075:	c1 e0 10             	shl    $0x10,%eax
  801078:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	89 c2                	mov    %eax,%edx
  801086:	b8 00 00 00 00       	mov    $0x0,%eax
  80108b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80108e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801091:	eb 18                	jmp    8010ab <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801093:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801096:	8d 41 08             	lea    0x8(%ecx),%eax
  801099:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80109c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a2:	89 01                	mov    %eax,(%ecx)
  8010a4:	89 51 04             	mov    %edx,0x4(%ecx)
  8010a7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010af:	77 e2                	ja     801093 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 23                	je     8010da <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010bd:	eb 0e                	jmp    8010cd <memset+0x91>
			*p8++ = (uint8)c;
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8d 50 01             	lea    0x1(%eax),%edx
  8010c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	75 e5                	jne    8010bf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010f1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f5:	76 24                	jbe    80111b <memcpy+0x3c>
		while(n >= 8){
  8010f7:	eb 1c                	jmp    801115 <memcpy+0x36>
			*d64 = *s64;
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	8b 50 04             	mov    0x4(%eax),%edx
  8010ff:	8b 00                	mov    (%eax),%eax
  801101:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801104:	89 01                	mov    %eax,(%ecx)
  801106:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801109:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80110d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801111:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801115:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801119:	77 de                	ja     8010f9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80111b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111f:	74 31                	je     801152 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80112d:	eb 16                	jmp    801145 <memcpy+0x66>
			*d8++ = *s8++;
  80112f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801132:	8d 50 01             	lea    0x1(%eax),%edx
  801135:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801141:	8a 12                	mov    (%edx),%dl
  801143:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114b:	89 55 10             	mov    %edx,0x10(%ebp)
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 dd                	jne    80112f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80116f:	73 50                	jae    8011c1 <memmove+0x6a>
  801171:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 d0                	add    %edx,%eax
  801179:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80117c:	76 43                	jbe    8011c1 <memmove+0x6a>
		s += n;
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80118a:	eb 10                	jmp    80119c <memmove+0x45>
			*--d = *--s;
  80118c:	ff 4d f8             	decl   -0x8(%ebp)
  80118f:	ff 4d fc             	decl   -0x4(%ebp)
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	8a 10                	mov    (%eax),%dl
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	75 e3                	jne    80118c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a9:	eb 23                	jmp    8011ce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ae:	8d 50 01             	lea    0x1(%eax),%edx
  8011b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011bd:	8a 12                	mov    (%edx),%dl
  8011bf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	75 dd                	jne    8011ab <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011e5:	eb 2a                	jmp    801211 <memcmp+0x3e>
		if (*s1 != *s2)
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8a 10                	mov    (%eax),%dl
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	38 c2                	cmp    %al,%dl
  8011f3:	74 16                	je     80120b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f b6 d0             	movzbl %al,%edx
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f b6 c0             	movzbl %al,%eax
  801205:	29 c2                	sub    %eax,%edx
  801207:	89 d0                	mov    %edx,%eax
  801209:	eb 18                	jmp    801223 <memcmp+0x50>
		s1++, s2++;
  80120b:	ff 45 fc             	incl   -0x4(%ebp)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	8d 50 ff             	lea    -0x1(%eax),%edx
  801217:	89 55 10             	mov    %edx,0x10(%ebp)
  80121a:	85 c0                	test   %eax,%eax
  80121c:	75 c9                	jne    8011e7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	8b 45 10             	mov    0x10(%ebp),%eax
  801231:	01 d0                	add    %edx,%eax
  801233:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801236:	eb 15                	jmp    80124d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f b6 d0             	movzbl %al,%edx
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	0f b6 c0             	movzbl %al,%eax
  801246:	39 c2                	cmp    %eax,%edx
  801248:	74 0d                	je     801257 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80124a:	ff 45 08             	incl   0x8(%ebp)
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801253:	72 e3                	jb     801238 <memfind+0x13>
  801255:	eb 01                	jmp    801258 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801257:	90                   	nop
	return (void *) s;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80126a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801271:	eb 03                	jmp    801276 <strtol+0x19>
		s++;
  801273:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 20                	cmp    $0x20,%al
  80127d:	74 f4                	je     801273 <strtol+0x16>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 09                	cmp    $0x9,%al
  801286:	74 eb                	je     801273 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 2b                	cmp    $0x2b,%al
  80128f:	75 05                	jne    801296 <strtol+0x39>
		s++;
  801291:	ff 45 08             	incl   0x8(%ebp)
  801294:	eb 13                	jmp    8012a9 <strtol+0x4c>
	else if (*s == '-')
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 2d                	cmp    $0x2d,%al
  80129d:	75 0a                	jne    8012a9 <strtol+0x4c>
		s++, neg = 1;
  80129f:	ff 45 08             	incl   0x8(%ebp)
  8012a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ad:	74 06                	je     8012b5 <strtol+0x58>
  8012af:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012b3:	75 20                	jne    8012d5 <strtol+0x78>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	3c 30                	cmp    $0x30,%al
  8012bc:	75 17                	jne    8012d5 <strtol+0x78>
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	40                   	inc    %eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 78                	cmp    $0x78,%al
  8012c6:	75 0d                	jne    8012d5 <strtol+0x78>
		s += 2, base = 16;
  8012c8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012cc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012d3:	eb 28                	jmp    8012fd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d9:	75 15                	jne    8012f0 <strtol+0x93>
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	3c 30                	cmp    $0x30,%al
  8012e2:	75 0c                	jne    8012f0 <strtol+0x93>
		s++, base = 8;
  8012e4:	ff 45 08             	incl   0x8(%ebp)
  8012e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ee:	eb 0d                	jmp    8012fd <strtol+0xa0>
	else if (base == 0)
  8012f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f4:	75 07                	jne    8012fd <strtol+0xa0>
		base = 10;
  8012f6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	3c 2f                	cmp    $0x2f,%al
  801304:	7e 19                	jle    80131f <strtol+0xc2>
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	3c 39                	cmp    $0x39,%al
  80130d:	7f 10                	jg     80131f <strtol+0xc2>
			dig = *s - '0';
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f be c0             	movsbl %al,%eax
  801317:	83 e8 30             	sub    $0x30,%eax
  80131a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131d:	eb 42                	jmp    801361 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	3c 60                	cmp    $0x60,%al
  801326:	7e 19                	jle    801341 <strtol+0xe4>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	3c 7a                	cmp    $0x7a,%al
  80132f:	7f 10                	jg     801341 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f be c0             	movsbl %al,%eax
  801339:	83 e8 57             	sub    $0x57,%eax
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133f:	eb 20                	jmp    801361 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	3c 40                	cmp    $0x40,%al
  801348:	7e 39                	jle    801383 <strtol+0x126>
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	3c 5a                	cmp    $0x5a,%al
  801351:	7f 30                	jg     801383 <strtol+0x126>
			dig = *s - 'A' + 10;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be c0             	movsbl %al,%eax
  80135b:	83 e8 37             	sub    $0x37,%eax
  80135e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	3b 45 10             	cmp    0x10(%ebp),%eax
  801367:	7d 19                	jge    801382 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801369:	ff 45 08             	incl   0x8(%ebp)
  80136c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801373:	89 c2                	mov    %eax,%edx
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80137d:	e9 7b ff ff ff       	jmp    8012fd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801382:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801383:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801387:	74 08                	je     801391 <strtol+0x134>
		*endptr = (char *) s;
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801391:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801395:	74 07                	je     80139e <strtol+0x141>
  801397:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139a:	f7 d8                	neg    %eax
  80139c:	eb 03                	jmp    8013a1 <strtol+0x144>
  80139e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <ltostr>:

void
ltostr(long value, char *str)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bb:	79 13                	jns    8013d0 <ltostr+0x2d>
	{
		neg = 1;
  8013bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013cd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013d8:	99                   	cltd   
  8013d9:	f7 f9                	idiv   %ecx
  8013db:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e1:	8d 50 01             	lea    0x1(%eax),%edx
  8013e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e7:	89 c2                	mov    %eax,%edx
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f1:	83 c2 30             	add    $0x30,%edx
  8013f4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013fe:	f7 e9                	imul   %ecx
  801400:	c1 fa 02             	sar    $0x2,%edx
  801403:	89 c8                	mov    %ecx,%eax
  801405:	c1 f8 1f             	sar    $0x1f,%eax
  801408:	29 c2                	sub    %eax,%edx
  80140a:	89 d0                	mov    %edx,%eax
  80140c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80140f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801413:	75 bb                	jne    8013d0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801415:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80141c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141f:	48                   	dec    %eax
  801420:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801423:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801427:	74 3d                	je     801466 <ltostr+0xc3>
		start = 1 ;
  801429:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801430:	eb 34                	jmp    801466 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80143f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	01 c2                	add    %eax,%edx
  80145b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80145e:	88 02                	mov    %al,(%edx)
		start++ ;
  801460:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801463:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801469:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80146c:	7c c4                	jl     801432 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80146e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
  801476:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 c4 f9 ff ff       	call   800e4e <strlen>
  80148a:	83 c4 04             	add    $0x4,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	e8 b6 f9 ff ff       	call   800e4e <strlen>
  801498:	83 c4 04             	add    $0x4,%esp
  80149b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80149e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ac:	eb 17                	jmp    8014c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b4:	01 c2                	add    %eax,%edx
  8014b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	01 c8                	add    %ecx,%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c2:	ff 45 fc             	incl   -0x4(%ebp)
  8014c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014cb:	7c e1                	jl     8014ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014db:	eb 1f                	jmp    8014fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e0:	8d 50 01             	lea    0x1(%eax),%edx
  8014e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014e6:	89 c2                	mov    %eax,%edx
  8014e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014eb:	01 c2                	add    %eax,%edx
  8014ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	01 c8                	add    %ecx,%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f9:	ff 45 f8             	incl   -0x8(%ebp)
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801502:	7c d9                	jl     8014dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801504:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801507:	8b 45 10             	mov    0x10(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	c6 00 00             	movb   $0x0,(%eax)
}
  80150f:	90                   	nop
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80151e:	8b 45 14             	mov    0x14(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
  80152d:	01 d0                	add    %edx,%eax
  80152f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801535:	eb 0c                	jmp    801543 <strsplit+0x31>
			*string++ = 0;
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	8d 50 01             	lea    0x1(%eax),%edx
  80153d:	89 55 08             	mov    %edx,0x8(%ebp)
  801540:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 18                	je     801564 <strsplit+0x52>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 83 fa ff ff       	call   800fe0 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	75 d3                	jne    801537 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	84 c0                	test   %al,%al
  80156b:	74 5a                	je     8015c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80156d:	8b 45 14             	mov    0x14(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	83 f8 0f             	cmp    $0xf,%eax
  801575:	75 07                	jne    80157e <strsplit+0x6c>
		{
			return 0;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
  80157c:	eb 66                	jmp    8015e4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80157e:	8b 45 14             	mov    0x14(%ebp),%eax
  801581:	8b 00                	mov    (%eax),%eax
  801583:	8d 48 01             	lea    0x1(%eax),%ecx
  801586:	8b 55 14             	mov    0x14(%ebp),%edx
  801589:	89 0a                	mov    %ecx,(%edx)
  80158b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801592:	8b 45 10             	mov    0x10(%ebp),%eax
  801595:	01 c2                	add    %eax,%edx
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80159c:	eb 03                	jmp    8015a1 <strsplit+0x8f>
			string++;
  80159e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	84 c0                	test   %al,%al
  8015a8:	74 8b                	je     801535 <strsplit+0x23>
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	0f be c0             	movsbl %al,%eax
  8015b2:	50                   	push   %eax
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	e8 25 fa ff ff       	call   800fe0 <strchr>
  8015bb:	83 c4 08             	add    $0x8,%esp
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	74 dc                	je     80159e <strsplit+0x8c>
			string++;
	}
  8015c2:	e9 6e ff ff ff       	jmp    801535 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	8b 00                	mov    (%eax),%eax
  8015cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f9:	eb 4a                	jmp    801645 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	01 c2                	add    %eax,%edx
  801603:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	01 c8                	add    %ecx,%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 0c             	mov    0xc(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	3c 40                	cmp    $0x40,%al
  80161b:	7e 25                	jle    801642 <str2lower+0x5c>
  80161d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	8a 00                	mov    (%eax),%al
  801627:	3c 5a                	cmp    $0x5a,%al
  801629:	7f 17                	jg     801642 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801636:	8b 55 08             	mov    0x8(%ebp),%edx
  801639:	01 ca                	add    %ecx,%edx
  80163b:	8a 12                	mov    (%edx),%dl
  80163d:	83 c2 20             	add    $0x20,%edx
  801640:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801642:	ff 45 fc             	incl   -0x4(%ebp)
  801645:	ff 75 0c             	pushl  0xc(%ebp)
  801648:	e8 01 f8 ff ff       	call   800e4e <strlen>
  80164d:	83 c4 04             	add    $0x4,%esp
  801650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801653:	7f a6                	jg     8015fb <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801655:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801660:	83 ec 0c             	sub    $0xc,%esp
  801663:	6a 10                	push   $0x10
  801665:	e8 b2 15 00 00       	call   802c1c <alloc_block>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801670:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801674:	75 14                	jne    80168a <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	68 68 42 80 00       	push   $0x804268
  80167e:	6a 14                	push   $0x14
  801680:	68 91 42 80 00       	push   $0x804291
  801685:	e8 fd ed ff ff       	call   800487 <_panic>

	node->start = start;
  80168a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168d:	8b 55 08             	mov    0x8(%ebp),%edx
  801690:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801695:	8b 55 0c             	mov    0xc(%ebp),%edx
  801698:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80169b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8016a2:	a1 24 50 80 00       	mov    0x805024,%eax
  8016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016aa:	eb 18                	jmp    8016c4 <insert_page_alloc+0x6a>
		if (start < it->start)
  8016ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016af:	8b 00                	mov    (%eax),%eax
  8016b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016b4:	77 37                	ja     8016ed <insert_page_alloc+0x93>
			break;
		prev = it;
  8016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8016bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c8:	74 08                	je     8016d2 <insert_page_alloc+0x78>
  8016ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cd:	8b 40 08             	mov    0x8(%eax),%eax
  8016d0:	eb 05                	jmp    8016d7 <insert_page_alloc+0x7d>
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	75 c7                	jne    8016ac <insert_page_alloc+0x52>
  8016e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e9:	75 c1                	jne    8016ac <insert_page_alloc+0x52>
  8016eb:	eb 01                	jmp    8016ee <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8016ed:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8016ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f2:	75 64                	jne    801758 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8016f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f8:	75 14                	jne    80170e <insert_page_alloc+0xb4>
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 a0 42 80 00       	push   $0x8042a0
  801702:	6a 21                	push   $0x21
  801704:	68 91 42 80 00       	push   $0x804291
  801709:	e8 79 ed ff ff       	call   800487 <_panic>
  80170e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801714:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801717:	89 50 08             	mov    %edx,0x8(%eax)
  80171a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171d:	8b 40 08             	mov    0x8(%eax),%eax
  801720:	85 c0                	test   %eax,%eax
  801722:	74 0d                	je     801731 <insert_page_alloc+0xd7>
  801724:	a1 24 50 80 00       	mov    0x805024,%eax
  801729:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80172c:	89 50 0c             	mov    %edx,0xc(%eax)
  80172f:	eb 08                	jmp    801739 <insert_page_alloc+0xdf>
  801731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801734:	a3 28 50 80 00       	mov    %eax,0x805028
  801739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173c:	a3 24 50 80 00       	mov    %eax,0x805024
  801741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801744:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80174b:	a1 30 50 80 00       	mov    0x805030,%eax
  801750:	40                   	inc    %eax
  801751:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801756:	eb 71                	jmp    8017c9 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801758:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80175c:	74 06                	je     801764 <insert_page_alloc+0x10a>
  80175e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801762:	75 14                	jne    801778 <insert_page_alloc+0x11e>
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 c4 42 80 00       	push   $0x8042c4
  80176c:	6a 23                	push   $0x23
  80176e:	68 91 42 80 00       	push   $0x804291
  801773:	e8 0f ed ff ff       	call   800487 <_panic>
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	8b 50 08             	mov    0x8(%eax),%edx
  80177e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801781:	89 50 08             	mov    %edx,0x8(%eax)
  801784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801787:	8b 40 08             	mov    0x8(%eax),%eax
  80178a:	85 c0                	test   %eax,%eax
  80178c:	74 0c                	je     80179a <insert_page_alloc+0x140>
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	8b 40 08             	mov    0x8(%eax),%eax
  801794:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801797:	89 50 0c             	mov    %edx,0xc(%eax)
  80179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a0:	89 50 08             	mov    %edx,0x8(%eax)
  8017a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	8b 40 08             	mov    0x8(%eax),%eax
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	75 08                	jne    8017be <insert_page_alloc+0x164>
  8017b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b9:	a3 28 50 80 00       	mov    %eax,0x805028
  8017be:	a1 30 50 80 00       	mov    0x805030,%eax
  8017c3:	40                   	inc    %eax
  8017c4:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8017c9:	90                   	nop
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8017d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	75 0c                	jne    8017e7 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8017db:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017e0:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8017e5:	eb 67                	jmp    80184e <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8017e7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017ef:	a1 24 50 80 00       	mov    0x805024,%eax
  8017f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017f7:	eb 26                	jmp    80181f <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8017f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fc:	8b 10                	mov    (%eax),%edx
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801801:	8b 40 04             	mov    0x4(%eax),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80180f:	76 06                	jbe    801817 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801817:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80181c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80181f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801823:	74 08                	je     80182d <recompute_page_alloc_break+0x61>
  801825:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801828:	8b 40 08             	mov    0x8(%eax),%eax
  80182b:	eb 05                	jmp    801832 <recompute_page_alloc_break+0x66>
  80182d:	b8 00 00 00 00       	mov    $0x0,%eax
  801832:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801837:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80183c:	85 c0                	test   %eax,%eax
  80183e:	75 b9                	jne    8017f9 <recompute_page_alloc_break+0x2d>
  801840:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801844:	75 b3                	jne    8017f9 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801849:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801856:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80185d:	8b 55 08             	mov    0x8(%ebp),%edx
  801860:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	48                   	dec    %eax
  801866:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801869:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	f7 75 d8             	divl   -0x28(%ebp)
  801874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801877:	29 d0                	sub    %edx,%eax
  801879:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80187c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801880:	75 0a                	jne    80188c <alloc_pages_custom_fit+0x3c>
		return NULL;
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
  801887:	e9 7e 01 00 00       	jmp    801a0a <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80188c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801893:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801897:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80189e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8018a5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8018aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8018ad:	a1 24 50 80 00       	mov    0x805024,%eax
  8018b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018b5:	eb 69                	jmp    801920 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8018b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ba:	8b 00                	mov    (%eax),%eax
  8018bc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018bf:	76 47                	jbe    801908 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8018c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8018c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ca:	8b 00                	mov    (%eax),%eax
  8018cc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018cf:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8018d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018d5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018d8:	72 2e                	jb     801908 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8018da:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018de:	75 14                	jne    8018f4 <alloc_pages_custom_fit+0xa4>
  8018e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018e3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018e6:	75 0c                	jne    8018f4 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8018e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8018ee:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018f2:	eb 14                	jmp    801908 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8018f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018f7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018fa:	76 0c                	jbe    801908 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8018fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801902:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801905:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190b:	8b 10                	mov    (%eax),%edx
  80190d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801910:	8b 40 04             	mov    0x4(%eax),%eax
  801913:	01 d0                	add    %edx,%eax
  801915:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801918:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80191d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801920:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801924:	74 08                	je     80192e <alloc_pages_custom_fit+0xde>
  801926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801929:	8b 40 08             	mov    0x8(%eax),%eax
  80192c:	eb 05                	jmp    801933 <alloc_pages_custom_fit+0xe3>
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801938:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80193d:	85 c0                	test   %eax,%eax
  80193f:	0f 85 72 ff ff ff    	jne    8018b7 <alloc_pages_custom_fit+0x67>
  801945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801949:	0f 85 68 ff ff ff    	jne    8018b7 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80194f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801954:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801957:	76 47                	jbe    8019a0 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80195c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80195f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801964:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801967:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  80196a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80196d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801970:	72 2e                	jb     8019a0 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801972:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801976:	75 14                	jne    80198c <alloc_pages_custom_fit+0x13c>
  801978:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80197b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80197e:	75 0c                	jne    80198c <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801980:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801983:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801986:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80198a:	eb 14                	jmp    8019a0 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80198c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80198f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801992:	76 0c                	jbe    8019a0 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801994:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801997:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  80199a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80199d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  8019a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8019a7:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8019ab:	74 08                	je     8019b5 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019b3:	eb 40                	jmp    8019f5 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  8019b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019b9:	74 08                	je     8019c3 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8019bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019be:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019c1:	eb 32                	jmp    8019f5 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8019c3:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8019c8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8019cb:	89 c2                	mov    %eax,%edx
  8019cd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019d2:	39 c2                	cmp    %eax,%edx
  8019d4:	73 07                	jae    8019dd <alloc_pages_custom_fit+0x18d>
			return NULL;
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	eb 2d                	jmp    801a0a <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8019dd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8019e5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8019eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019ee:	01 d0                	add    %edx,%eax
  8019f0:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8019f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8019fe:	50                   	push   %eax
  8019ff:	e8 56 fc ff ff       	call   80165a <insert_page_alloc>
  801a04:	83 c4 10             	add    $0x10,%esp

	return result;
  801a07:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a18:	a1 24 50 80 00       	mov    0x805024,%eax
  801a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a20:	eb 1a                	jmp    801a3c <find_allocated_size+0x30>
		if (it->start == va)
  801a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a2a:	75 08                	jne    801a34 <find_allocated_size+0x28>
			return it->size;
  801a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2f:	8b 40 04             	mov    0x4(%eax),%eax
  801a32:	eb 34                	jmp    801a68 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a34:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a39:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a40:	74 08                	je     801a4a <find_allocated_size+0x3e>
  801a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a45:	8b 40 08             	mov    0x8(%eax),%eax
  801a48:	eb 05                	jmp    801a4f <find_allocated_size+0x43>
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a54:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	75 c5                	jne    801a22 <find_allocated_size+0x16>
  801a5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a61:	75 bf                	jne    801a22 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a76:	a1 24 50 80 00       	mov    0x805024,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	e9 e1 01 00 00       	jmp    801c64 <free_pages+0x1fa>
		if (it->start == va) {
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a8b:	0f 85 cb 01 00 00    	jne    801c5c <free_pages+0x1f2>

			uint32 start = it->start;
  801a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a94:	8b 00                	mov    (%eax),%eax
  801a96:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	8b 40 04             	mov    0x4(%eax),%eax
  801a9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa5:	f7 d0                	not    %eax
  801aa7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801aaa:	73 1d                	jae    801ac9 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801aac:	83 ec 0c             	sub    $0xc,%esp
  801aaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ab2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab5:	68 f8 42 80 00       	push   $0x8042f8
  801aba:	68 a5 00 00 00       	push   $0xa5
  801abf:	68 91 42 80 00       	push   $0x804291
  801ac4:	e8 be e9 ff ff       	call   800487 <_panic>
			}

			uint32 start_end = start + size;
  801ac9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	79 19                	jns    801af4 <free_pages+0x8a>
  801adb:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801ae2:	77 10                	ja     801af4 <free_pages+0x8a>
  801ae4:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801aeb:	77 07                	ja     801af4 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 2c                	js     801b20 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801af4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af7:	83 ec 0c             	sub    $0xc,%esp
  801afa:	68 00 00 00 a0       	push   $0xa0000000
  801aff:	ff 75 e0             	pushl  -0x20(%ebp)
  801b02:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b05:	ff 75 e8             	pushl  -0x18(%ebp)
  801b08:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b0b:	50                   	push   %eax
  801b0c:	68 3c 43 80 00       	push   $0x80433c
  801b11:	68 ad 00 00 00       	push   $0xad
  801b16:	68 91 42 80 00       	push   $0x804291
  801b1b:	e8 67 e9 ff ff       	call   800487 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b26:	e9 88 00 00 00       	jmp    801bb3 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801b2b:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801b32:	76 17                	jbe    801b4b <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801b34:	ff 75 f0             	pushl  -0x10(%ebp)
  801b37:	68 a0 43 80 00       	push   $0x8043a0
  801b3c:	68 b4 00 00 00       	push   $0xb4
  801b41:	68 91 42 80 00       	push   $0x804291
  801b46:	e8 3c e9 ff ff       	call   800487 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4e:	05 00 10 00 00       	add    $0x1000,%eax
  801b53:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	79 2e                	jns    801b8b <free_pages+0x121>
  801b5d:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b64:	77 25                	ja     801b8b <free_pages+0x121>
  801b66:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b6d:	77 1c                	ja     801b8b <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	68 00 10 00 00       	push   $0x1000
  801b77:	ff 75 f0             	pushl  -0x10(%ebp)
  801b7a:	e8 38 0d 00 00       	call   8028b7 <sys_free_user_mem>
  801b7f:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b82:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b89:	eb 28                	jmp    801bb3 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8e:	68 00 00 00 a0       	push   $0xa0000000
  801b93:	ff 75 dc             	pushl  -0x24(%ebp)
  801b96:	68 00 10 00 00       	push   $0x1000
  801b9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801b9e:	50                   	push   %eax
  801b9f:	68 e0 43 80 00       	push   $0x8043e0
  801ba4:	68 bd 00 00 00       	push   $0xbd
  801ba9:	68 91 42 80 00       	push   $0x804291
  801bae:	e8 d4 e8 ff ff       	call   800487 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801bb9:	0f 82 6c ff ff ff    	jb     801b2b <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc3:	75 17                	jne    801bdc <free_pages+0x172>
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 42 44 80 00       	push   $0x804442
  801bcd:	68 c1 00 00 00       	push   $0xc1
  801bd2:	68 91 42 80 00       	push   $0x804291
  801bd7:	e8 ab e8 ff ff       	call   800487 <_panic>
  801bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdf:	8b 40 08             	mov    0x8(%eax),%eax
  801be2:	85 c0                	test   %eax,%eax
  801be4:	74 11                	je     801bf7 <free_pages+0x18d>
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	8b 40 08             	mov    0x8(%eax),%eax
  801bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bef:	8b 52 0c             	mov    0xc(%edx),%edx
  801bf2:	89 50 0c             	mov    %edx,0xc(%eax)
  801bf5:	eb 0b                	jmp    801c02 <free_pages+0x198>
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfd:	a3 28 50 80 00       	mov    %eax,0x805028
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	8b 40 0c             	mov    0xc(%eax),%eax
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	74 11                	je     801c1d <free_pages+0x1b3>
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c15:	8b 52 08             	mov    0x8(%edx),%edx
  801c18:	89 50 08             	mov    %edx,0x8(%eax)
  801c1b:	eb 0b                	jmp    801c28 <free_pages+0x1be>
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	8b 40 08             	mov    0x8(%eax),%eax
  801c23:	a3 24 50 80 00       	mov    %eax,0x805024
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c3c:	a1 30 50 80 00       	mov    0x805030,%eax
  801c41:	48                   	dec    %eax
  801c42:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4d:	e8 24 15 00 00       	call   803176 <free_block>
  801c52:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801c55:	e8 72 fb ff ff       	call   8017cc <recompute_page_alloc_break>

			return;
  801c5a:	eb 37                	jmp    801c93 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c5c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c68:	74 08                	je     801c72 <free_pages+0x208>
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	8b 40 08             	mov    0x8(%eax),%eax
  801c70:	eb 05                	jmp    801c77 <free_pages+0x20d>
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
  801c77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c7c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c81:	85 c0                	test   %eax,%eax
  801c83:	0f 85 fa fd ff ff    	jne    801a83 <free_pages+0x19>
  801c89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c8d:	0f 85 f0 fd ff ff    	jne    801a83 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    

00801c9f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ca5:	a1 08 50 80 00       	mov    0x805008,%eax
  801caa:	85 c0                	test   %eax,%eax
  801cac:	74 60                	je     801d0e <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cae:	83 ec 08             	sub    $0x8,%esp
  801cb1:	68 00 00 00 82       	push   $0x82000000
  801cb6:	68 00 00 00 80       	push   $0x80000000
  801cbb:	e8 0d 0d 00 00       	call   8029cd <initialize_dynamic_allocator>
  801cc0:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cc3:	e8 f3 0a 00 00       	call   8027bb <sys_get_uheap_strategy>
  801cc8:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ccd:	a1 40 50 80 00       	mov    0x805040,%eax
  801cd2:	05 00 10 00 00       	add    $0x1000,%eax
  801cd7:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cdc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ce1:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801ce6:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801ced:	00 00 00 
  801cf0:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801cf7:	00 00 00 
  801cfa:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801d01:	00 00 00 

		__firstTimeFlag = 0;
  801d04:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801d0b:	00 00 00 
	}
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d25:	83 ec 08             	sub    $0x8,%esp
  801d28:	68 06 04 00 00       	push   $0x406
  801d2d:	50                   	push   %eax
  801d2e:	e8 d2 06 00 00       	call   802405 <__sys_allocate_page>
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d3d:	79 17                	jns    801d56 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	68 60 44 80 00       	push   $0x804460
  801d47:	68 ea 00 00 00       	push   $0xea
  801d4c:	68 91 42 80 00       	push   $0x804291
  801d51:	e8 31 e7 ff ff       	call   800487 <_panic>
	return 0;
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	50                   	push   %eax
  801d75:	e8 d2 06 00 00       	call   80244c <__sys_unmap_frame>
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d84:	79 17                	jns    801d9d <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	68 9c 44 80 00       	push   $0x80449c
  801d8e:	68 f5 00 00 00       	push   $0xf5
  801d93:	68 91 42 80 00       	push   $0x804291
  801d98:	e8 ea e6 ff ff       	call   800487 <_panic>
}
  801d9d:	90                   	nop
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801da6:	e8 f4 fe ff ff       	call   801c9f <uheap_init>
	if (size == 0) return NULL ;
  801dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801daf:	75 0a                	jne    801dbb <malloc+0x1b>
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	e9 67 01 00 00       	jmp    801f22 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801dbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801dc2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dc9:	77 16                	ja     801de1 <malloc+0x41>
		result = alloc_block(size);
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	e8 46 0e 00 00       	call   802c1c <alloc_block>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddc:	e9 3e 01 00 00       	jmp    801f1f <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801de1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801de8:	8b 55 08             	mov    0x8(%ebp),%edx
  801deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dee:	01 d0                	add    %edx,%eax
  801df0:	48                   	dec    %eax
  801df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfc:	f7 75 f0             	divl   -0x10(%ebp)
  801dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e02:	29 d0                	sub    %edx,%eax
  801e04:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801e07:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	75 0a                	jne    801e1a <malloc+0x7a>
			return NULL;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
  801e15:	e9 08 01 00 00       	jmp    801f22 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801e1a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	74 0f                	je     801e32 <malloc+0x92>
  801e23:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e29:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e2e:	39 c2                	cmp    %eax,%edx
  801e30:	73 0a                	jae    801e3c <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801e32:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e37:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801e3c:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801e41:	83 f8 05             	cmp    $0x5,%eax
  801e44:	75 11                	jne    801e57 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	ff 75 e8             	pushl  -0x18(%ebp)
  801e4c:	e8 ff f9 ff ff       	call   801850 <alloc_pages_custom_fit>
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5b:	0f 84 be 00 00 00    	je     801f1f <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6d:	e8 9a fb ff ff       	call   801a0c <find_allocated_size>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801e78:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e7c:	75 17                	jne    801e95 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e81:	68 dc 44 80 00       	push   $0x8044dc
  801e86:	68 24 01 00 00       	push   $0x124
  801e8b:	68 91 42 80 00       	push   $0x804291
  801e90:	e8 f2 e5 ff ff       	call   800487 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e98:	f7 d0                	not    %eax
  801e9a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e9d:	73 1d                	jae    801ebc <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 e0             	pushl  -0x20(%ebp)
  801ea5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ea8:	68 24 45 80 00       	push   $0x804524
  801ead:	68 29 01 00 00       	push   $0x129
  801eb2:	68 91 42 80 00       	push   $0x804291
  801eb7:	e8 cb e5 ff ff       	call   800487 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801ebc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec2:	01 d0                	add    %edx,%eax
  801ec4:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801ec7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	79 2c                	jns    801efa <malloc+0x15a>
  801ece:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801ed5:	77 23                	ja     801efa <malloc+0x15a>
  801ed7:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ede:	77 1a                	ja     801efa <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801ee0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	79 13                	jns    801efa <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801ee7:	83 ec 08             	sub    $0x8,%esp
  801eea:	ff 75 e0             	pushl  -0x20(%ebp)
  801eed:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ef0:	e8 de 09 00 00       	call   8028d3 <sys_allocate_user_mem>
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	eb 25                	jmp    801f1f <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801efa:	68 00 00 00 a0       	push   $0xa0000000
  801eff:	ff 75 dc             	pushl  -0x24(%ebp)
  801f02:	ff 75 e0             	pushl  -0x20(%ebp)
  801f05:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f08:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0b:	68 60 45 80 00       	push   $0x804560
  801f10:	68 33 01 00 00       	push   $0x133
  801f15:	68 91 42 80 00       	push   $0x804291
  801f1a:	e8 68 e5 ff ff       	call   800487 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f2e:	0f 84 26 01 00 00    	je     80205a <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	79 1c                	jns    801f5d <free+0x39>
  801f41:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801f48:	77 13                	ja     801f5d <free+0x39>
		free_block(virtual_address);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	e8 21 12 00 00       	call   803176 <free_block>
  801f55:	83 c4 10             	add    $0x10,%esp
		return;
  801f58:	e9 01 01 00 00       	jmp    80205e <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801f5d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f65:	0f 82 d8 00 00 00    	jb     802043 <free+0x11f>
  801f6b:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801f72:	0f 87 cb 00 00 00    	ja     802043 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f80:	85 c0                	test   %eax,%eax
  801f82:	74 17                	je     801f9b <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801f84:	ff 75 08             	pushl  0x8(%ebp)
  801f87:	68 d0 45 80 00       	push   $0x8045d0
  801f8c:	68 57 01 00 00       	push   $0x157
  801f91:	68 91 42 80 00       	push   $0x804291
  801f96:	e8 ec e4 ff ff       	call   800487 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	e8 66 fa ff ff       	call   801a0c <find_allocated_size>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801fac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb0:	0f 84 a7 00 00 00    	je     80205d <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb9:	f7 d0                	not    %eax
  801fbb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fbe:	73 1d                	jae    801fdd <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc9:	68 f8 45 80 00       	push   $0x8045f8
  801fce:	68 61 01 00 00       	push   $0x161
  801fd3:	68 91 42 80 00       	push   $0x804291
  801fd8:	e8 aa e4 ff ff       	call   800487 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801fdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe3:	01 d0                	add    %edx,%eax
  801fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	85 c0                	test   %eax,%eax
  801fed:	79 19                	jns    802008 <free+0xe4>
  801fef:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801ff6:	77 10                	ja     802008 <free+0xe4>
  801ff8:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801fff:	77 07                	ja     802008 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802004:	85 c0                	test   %eax,%eax
  802006:	78 2b                	js     802033 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	68 00 00 00 a0       	push   $0xa0000000
  802010:	ff 75 ec             	pushl  -0x14(%ebp)
  802013:	ff 75 f0             	pushl  -0x10(%ebp)
  802016:	ff 75 f4             	pushl  -0xc(%ebp)
  802019:	ff 75 f0             	pushl  -0x10(%ebp)
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	68 34 46 80 00       	push   $0x804634
  802024:	68 69 01 00 00       	push   $0x169
  802029:	68 91 42 80 00       	push   $0x804291
  80202e:	e8 54 e4 ff ff       	call   800487 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	ff 75 08             	pushl  0x8(%ebp)
  802039:	e8 2c fa ff ff       	call   801a6a <free_pages>
  80203e:	83 c4 10             	add    $0x10,%esp
		return;
  802041:	eb 1b                	jmp    80205e <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802043:	ff 75 08             	pushl  0x8(%ebp)
  802046:	68 90 46 80 00       	push   $0x804690
  80204b:	68 70 01 00 00       	push   $0x170
  802050:	68 91 42 80 00       	push   $0x804291
  802055:	e8 2d e4 ff ff       	call   800487 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80205a:	90                   	nop
  80205b:	eb 01                	jmp    80205e <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80205d:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 38             	sub    $0x38,%esp
  802066:	8b 45 10             	mov    0x10(%ebp),%eax
  802069:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80206c:	e8 2e fc ff ff       	call   801c9f <uheap_init>
	if (size == 0) return NULL ;
  802071:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802075:	75 0a                	jne    802081 <smalloc+0x21>
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
  80207c:	e9 3d 01 00 00       	jmp    8021be <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802081:	8b 45 0c             	mov    0xc(%ebp),%eax
  802084:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80208f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802092:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802096:	74 0e                	je     8020a6 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80209e:	05 00 10 00 00       	add    $0x1000,%eax
  8020a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	c1 e8 0c             	shr    $0xc,%eax
  8020ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8020af:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	75 0a                	jne    8020c2 <smalloc+0x62>
		return NULL;
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	e9 fc 00 00 00       	jmp    8021be <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020c2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	74 0f                	je     8020da <smalloc+0x7a>
  8020cb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020d1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020d6:	39 c2                	cmp    %eax,%edx
  8020d8:	73 0a                	jae    8020e4 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8020da:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020df:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020e4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020e9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020ee:	29 c2                	sub    %eax,%edx
  8020f0:	89 d0                	mov    %edx,%eax
  8020f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020f5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020fb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802100:	29 c2                	sub    %eax,%edx
  802102:	89 d0                	mov    %edx,%eax
  802104:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80210d:	77 13                	ja     802122 <smalloc+0xc2>
  80210f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802112:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802115:	77 0b                	ja     802122 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802117:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80211a:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80211d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802120:	73 0a                	jae    80212c <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	e9 92 00 00 00       	jmp    8021be <smalloc+0x15e>
	}

	void *va = NULL;
  80212c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802133:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802138:	83 f8 05             	cmp    $0x5,%eax
  80213b:	75 11                	jne    80214e <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	e8 08 f7 ff ff       	call   801850 <alloc_pages_custom_fit>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80214e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802152:	75 27                	jne    80217b <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802154:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80215b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80215e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802161:	89 c2                	mov    %eax,%edx
  802163:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802168:	39 c2                	cmp    %eax,%edx
  80216a:	73 07                	jae    802173 <smalloc+0x113>
			return NULL;}
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	eb 4b                	jmp    8021be <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802173:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802178:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80217b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80217f:	ff 75 f0             	pushl  -0x10(%ebp)
  802182:	50                   	push   %eax
  802183:	ff 75 0c             	pushl  0xc(%ebp)
  802186:	ff 75 08             	pushl  0x8(%ebp)
  802189:	e8 cb 03 00 00       	call   802559 <sys_create_shared_object>
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802194:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802198:	79 07                	jns    8021a1 <smalloc+0x141>
		return NULL;
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
  80219f:	eb 1d                	jmp    8021be <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8021a1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021a6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8021a9:	75 10                	jne    8021bb <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8021ab:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021c6:	e8 d4 fa ff ff       	call   801c9f <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021cb:	83 ec 08             	sub    $0x8,%esp
  8021ce:	ff 75 0c             	pushl  0xc(%ebp)
  8021d1:	ff 75 08             	pushl  0x8(%ebp)
  8021d4:	e8 aa 03 00 00       	call   802583 <sys_size_of_shared_object>
  8021d9:	83 c4 10             	add    $0x10,%esp
  8021dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8021df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e3:	7f 0a                	jg     8021ef <sget+0x2f>
		return NULL;
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	e9 32 01 00 00       	jmp    802321 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8021ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802200:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802204:	74 0e                	je     802214 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80220c:	05 00 10 00 00       	add    $0x1000,%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802214:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802219:	85 c0                	test   %eax,%eax
  80221b:	75 0a                	jne    802227 <sget+0x67>
		return NULL;
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
  802222:	e9 fa 00 00 00       	jmp    802321 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802227:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 0f                	je     80223f <sget+0x7f>
  802230:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802236:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80223b:	39 c2                	cmp    %eax,%edx
  80223d:	73 0a                	jae    802249 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80223f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802244:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802249:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80224e:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802253:	29 c2                	sub    %eax,%edx
  802255:	89 d0                	mov    %edx,%eax
  802257:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80225a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802260:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802265:	29 c2                	sub    %eax,%edx
  802267:	89 d0                	mov    %edx,%eax
  802269:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802272:	77 13                	ja     802287 <sget+0xc7>
  802274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802277:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80227a:	77 0b                	ja     802287 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80227c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227f:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802285:	73 0a                	jae    802291 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	e9 90 00 00 00       	jmp    802321 <sget+0x161>

	void *va = NULL;
  802291:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802298:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80229d:	83 f8 05             	cmp    $0x5,%eax
  8022a0:	75 11                	jne    8022b3 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8022a2:	83 ec 0c             	sub    $0xc,%esp
  8022a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a8:	e8 a3 f5 ff ff       	call   801850 <alloc_pages_custom_fit>
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8022b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b7:	75 27                	jne    8022e0 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8022b9:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8022c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022c3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8022c6:	89 c2                	mov    %eax,%edx
  8022c8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022cd:	39 c2                	cmp    %eax,%edx
  8022cf:	73 07                	jae    8022d8 <sget+0x118>
			return NULL;
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	eb 49                	jmp    802321 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8022d8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e6:	ff 75 0c             	pushl  0xc(%ebp)
  8022e9:	ff 75 08             	pushl  0x8(%ebp)
  8022ec:	e8 af 02 00 00       	call   8025a0 <sys_get_shared_object>
  8022f1:	83 c4 10             	add    $0x10,%esp
  8022f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8022f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022fb:	79 07                	jns    802304 <sget+0x144>
		return NULL;
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802302:	eb 1d                	jmp    802321 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802304:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802309:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80230c:	75 10                	jne    80231e <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80230e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802329:	e8 71 f9 ff ff       	call   801c9f <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 b4 46 80 00       	push   $0x8046b4
  802336:	68 19 02 00 00       	push   $0x219
  80233b:	68 91 42 80 00       	push   $0x804291
  802340:	e8 42 e1 ff ff       	call   800487 <_panic>

00802345 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	68 dc 46 80 00       	push   $0x8046dc
  802353:	68 2b 02 00 00       	push   $0x22b
  802358:	68 91 42 80 00       	push   $0x804291
  80235d:	e8 25 e1 ff ff       	call   800487 <_panic>

00802362 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	57                   	push   %edi
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802371:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802374:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802377:	8b 7d 18             	mov    0x18(%ebp),%edi
  80237a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80237d:	cd 30                	int    $0x30
  80237f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	5b                   	pop    %ebx
  802389:	5e                   	pop    %esi
  80238a:	5f                   	pop    %edi
  80238b:	5d                   	pop    %ebp
  80238c:	c3                   	ret    

0080238d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	8b 45 10             	mov    0x10(%ebp),%eax
  802396:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802399:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80239c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	6a 00                	push   $0x0
  8023a5:	51                   	push   %ecx
  8023a6:	52                   	push   %edx
  8023a7:	ff 75 0c             	pushl  0xc(%ebp)
  8023aa:	50                   	push   %eax
  8023ab:	6a 00                	push   $0x0
  8023ad:	e8 b0 ff ff ff       	call   802362 <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	90                   	nop
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 02                	push   $0x2
  8023c7:	e8 96 ff ff ff       	call   802362 <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
}
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 03                	push   $0x3
  8023e0:	e8 7d ff ff ff       	call   802362 <syscall>
  8023e5:	83 c4 18             	add    $0x18,%esp
}
  8023e8:	90                   	nop
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 04                	push   $0x4
  8023fa:	e8 63 ff ff ff       	call   802362 <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
}
  802402:	90                   	nop
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	52                   	push   %edx
  802415:	50                   	push   %eax
  802416:	6a 08                	push   $0x8
  802418:	e8 45 ff ff ff       	call   802362 <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	56                   	push   %esi
  802426:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802427:	8b 75 18             	mov    0x18(%ebp),%esi
  80242a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80242d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	51                   	push   %ecx
  802439:	52                   	push   %edx
  80243a:	50                   	push   %eax
  80243b:	6a 09                	push   $0x9
  80243d:	e8 20 ff ff ff       	call   802362 <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802448:	5b                   	pop    %ebx
  802449:	5e                   	pop    %esi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    

0080244c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	ff 75 08             	pushl  0x8(%ebp)
  80245a:	6a 0a                	push   $0xa
  80245c:	e8 01 ff ff ff       	call   802362 <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	ff 75 0c             	pushl  0xc(%ebp)
  802472:	ff 75 08             	pushl  0x8(%ebp)
  802475:	6a 0b                	push   $0xb
  802477:	e8 e6 fe ff ff       	call   802362 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 0c                	push   $0xc
  802490:	e8 cd fe ff ff       	call   802362 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 0d                	push   $0xd
  8024a9:	e8 b4 fe ff ff       	call   802362 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 0e                	push   $0xe
  8024c2:	e8 9b fe ff ff       	call   802362 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 0f                	push   $0xf
  8024db:	e8 82 fe ff ff       	call   802362 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	ff 75 08             	pushl  0x8(%ebp)
  8024f3:	6a 10                	push   $0x10
  8024f5:	e8 68 fe ff ff       	call   802362 <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 11                	push   $0x11
  80250e:	e8 4f fe ff ff       	call   802362 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	90                   	nop
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_cputc>:

void
sys_cputc(const char c)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802525:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	50                   	push   %eax
  802532:	6a 01                	push   $0x1
  802534:	e8 29 fe ff ff       	call   802362 <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	90                   	nop
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 14                	push   $0x14
  80254e:	e8 0f fe ff ff       	call   802362 <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
}
  802556:	90                   	nop
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	8b 45 10             	mov    0x10(%ebp),%eax
  802562:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802565:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802568:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	6a 00                	push   $0x0
  802571:	51                   	push   %ecx
  802572:	52                   	push   %edx
  802573:	ff 75 0c             	pushl  0xc(%ebp)
  802576:	50                   	push   %eax
  802577:	6a 15                	push   $0x15
  802579:	e8 e4 fd ff ff       	call   802362 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802586:	8b 55 0c             	mov    0xc(%ebp),%edx
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	52                   	push   %edx
  802593:	50                   	push   %eax
  802594:	6a 16                	push   $0x16
  802596:	e8 c7 fd ff ff       	call   802362 <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	51                   	push   %ecx
  8025b1:	52                   	push   %edx
  8025b2:	50                   	push   %eax
  8025b3:	6a 17                	push   $0x17
  8025b5:	e8 a8 fd ff ff       	call   802362 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	52                   	push   %edx
  8025cf:	50                   	push   %eax
  8025d0:	6a 18                	push   $0x18
  8025d2:	e8 8b fd ff ff       	call   802362 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	6a 00                	push   $0x0
  8025e4:	ff 75 14             	pushl  0x14(%ebp)
  8025e7:	ff 75 10             	pushl  0x10(%ebp)
  8025ea:	ff 75 0c             	pushl  0xc(%ebp)
  8025ed:	50                   	push   %eax
  8025ee:	6a 19                	push   $0x19
  8025f0:	e8 6d fd ff ff       	call   802362 <syscall>
  8025f5:	83 c4 18             	add    $0x18,%esp
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	50                   	push   %eax
  802609:	6a 1a                	push   $0x1a
  80260b:	e8 52 fd ff ff       	call   802362 <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
}
  802613:	90                   	nop
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	50                   	push   %eax
  802625:	6a 1b                	push   $0x1b
  802627:	e8 36 fd ff ff       	call   802362 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 05                	push   $0x5
  802640:	e8 1d fd ff ff       	call   802362 <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 06                	push   $0x6
  802659:	e8 04 fd ff ff       	call   802362 <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 07                	push   $0x7
  802672:	e8 eb fc ff ff       	call   802362 <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_exit_env>:


void sys_exit_env(void)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 1c                	push   $0x1c
  80268b:	e8 d2 fc ff ff       	call   802362 <syscall>
  802690:	83 c4 18             	add    $0x18,%esp
}
  802693:	90                   	nop
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80269c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80269f:	8d 50 04             	lea    0x4(%eax),%edx
  8026a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	52                   	push   %edx
  8026ac:	50                   	push   %eax
  8026ad:	6a 1d                	push   $0x1d
  8026af:	e8 ae fc ff ff       	call   802362 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
	return result;
  8026b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026c0:	89 01                	mov    %eax,(%ecx)
  8026c2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	c9                   	leave  
  8026c9:	c2 04 00             	ret    $0x4

008026cc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	ff 75 10             	pushl  0x10(%ebp)
  8026d6:	ff 75 0c             	pushl  0xc(%ebp)
  8026d9:	ff 75 08             	pushl  0x8(%ebp)
  8026dc:	6a 13                	push   $0x13
  8026de:	e8 7f fc ff ff       	call   802362 <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e6:	90                   	nop
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 1e                	push   $0x1e
  8026f8:	e8 65 fc ff ff       	call   802362 <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 04             	sub    $0x4,%esp
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80270e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	50                   	push   %eax
  80271b:	6a 1f                	push   $0x1f
  80271d:	e8 40 fc ff ff       	call   802362 <syscall>
  802722:	83 c4 18             	add    $0x18,%esp
	return ;
  802725:	90                   	nop
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <rsttst>:
void rsttst()
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 21                	push   $0x21
  802737:	e8 26 fc ff ff       	call   802362 <syscall>
  80273c:	83 c4 18             	add    $0x18,%esp
	return ;
  80273f:	90                   	nop
}
  802740:	c9                   	leave  
  802741:	c3                   	ret    

00802742 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	8b 45 14             	mov    0x14(%ebp),%eax
  80274b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80274e:	8b 55 18             	mov    0x18(%ebp),%edx
  802751:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802755:	52                   	push   %edx
  802756:	50                   	push   %eax
  802757:	ff 75 10             	pushl  0x10(%ebp)
  80275a:	ff 75 0c             	pushl  0xc(%ebp)
  80275d:	ff 75 08             	pushl  0x8(%ebp)
  802760:	6a 20                	push   $0x20
  802762:	e8 fb fb ff ff       	call   802362 <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
	return ;
  80276a:	90                   	nop
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <chktst>:
void chktst(uint32 n)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	ff 75 08             	pushl  0x8(%ebp)
  80277b:	6a 22                	push   $0x22
  80277d:	e8 e0 fb ff ff       	call   802362 <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
	return ;
  802785:	90                   	nop
}
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <inctst>:

void inctst()
{
  802788:	55                   	push   %ebp
  802789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 23                	push   $0x23
  802797:	e8 c6 fb ff ff       	call   802362 <syscall>
  80279c:	83 c4 18             	add    $0x18,%esp
	return ;
  80279f:	90                   	nop
}
  8027a0:	c9                   	leave  
  8027a1:	c3                   	ret    

008027a2 <gettst>:
uint32 gettst()
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 24                	push   $0x24
  8027b1:	e8 ac fb ff ff       	call   802362 <syscall>
  8027b6:	83 c4 18             	add    $0x18,%esp
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 25                	push   $0x25
  8027ca:	e8 93 fb ff ff       	call   802362 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
  8027d2:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8027d7:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	ff 75 08             	pushl  0x8(%ebp)
  8027f4:	6a 26                	push   $0x26
  8027f6:	e8 67 fb ff ff       	call   802362 <syscall>
  8027fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027fe:	90                   	nop
}
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802805:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802808:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80280b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	6a 00                	push   $0x0
  802813:	53                   	push   %ebx
  802814:	51                   	push   %ecx
  802815:	52                   	push   %edx
  802816:	50                   	push   %eax
  802817:	6a 27                	push   $0x27
  802819:	e8 44 fb ff ff       	call   802362 <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
}
  802821:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	52                   	push   %edx
  802836:	50                   	push   %eax
  802837:	6a 28                	push   $0x28
  802839:	e8 24 fb ff ff       	call   802362 <syscall>
  80283e:	83 c4 18             	add    $0x18,%esp
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802846:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	6a 00                	push   $0x0
  802851:	51                   	push   %ecx
  802852:	ff 75 10             	pushl  0x10(%ebp)
  802855:	52                   	push   %edx
  802856:	50                   	push   %eax
  802857:	6a 29                	push   $0x29
  802859:	e8 04 fb ff ff       	call   802362 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	ff 75 10             	pushl  0x10(%ebp)
  80286d:	ff 75 0c             	pushl  0xc(%ebp)
  802870:	ff 75 08             	pushl  0x8(%ebp)
  802873:	6a 12                	push   $0x12
  802875:	e8 e8 fa ff ff       	call   802362 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
	return ;
  80287d:	90                   	nop
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802883:	8b 55 0c             	mov    0xc(%ebp),%edx
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	52                   	push   %edx
  802890:	50                   	push   %eax
  802891:	6a 2a                	push   $0x2a
  802893:	e8 ca fa ff ff       	call   802362 <syscall>
  802898:	83 c4 18             	add    $0x18,%esp
	return;
  80289b:	90                   	nop
}
  80289c:	c9                   	leave  
  80289d:	c3                   	ret    

0080289e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80289e:	55                   	push   %ebp
  80289f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 2b                	push   $0x2b
  8028ad:	e8 b0 fa ff ff       	call   802362 <syscall>
  8028b2:	83 c4 18             	add    $0x18,%esp
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	ff 75 0c             	pushl  0xc(%ebp)
  8028c3:	ff 75 08             	pushl  0x8(%ebp)
  8028c6:	6a 2d                	push   $0x2d
  8028c8:	e8 95 fa ff ff       	call   802362 <syscall>
  8028cd:	83 c4 18             	add    $0x18,%esp
	return;
  8028d0:	90                   	nop
}
  8028d1:	c9                   	leave  
  8028d2:	c3                   	ret    

008028d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028d3:	55                   	push   %ebp
  8028d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	ff 75 0c             	pushl  0xc(%ebp)
  8028df:	ff 75 08             	pushl  0x8(%ebp)
  8028e2:	6a 2c                	push   $0x2c
  8028e4:	e8 79 fa ff ff       	call   802362 <syscall>
  8028e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ec:	90                   	nop
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8028f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	52                   	push   %edx
  8028ff:	50                   	push   %eax
  802900:	6a 2e                	push   $0x2e
  802902:	e8 5b fa ff ff       	call   802362 <syscall>
  802907:	83 c4 18             	add    $0x18,%esp
	return ;
  80290a:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802913:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  80291a:	72 09                	jb     802925 <to_page_va+0x18>
  80291c:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802923:	72 14                	jb     802939 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802925:	83 ec 04             	sub    $0x4,%esp
  802928:	68 00 47 80 00       	push   $0x804700
  80292d:	6a 15                	push   $0x15
  80292f:	68 2b 47 80 00       	push   $0x80472b
  802934:	e8 4e db ff ff       	call   800487 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	ba 60 50 80 00       	mov    $0x805060,%edx
  802941:	29 d0                	sub    %edx,%eax
  802943:	c1 f8 02             	sar    $0x2,%eax
  802946:	89 c2                	mov    %eax,%edx
  802948:	89 d0                	mov    %edx,%eax
  80294a:	c1 e0 02             	shl    $0x2,%eax
  80294d:	01 d0                	add    %edx,%eax
  80294f:	c1 e0 02             	shl    $0x2,%eax
  802952:	01 d0                	add    %edx,%eax
  802954:	c1 e0 02             	shl    $0x2,%eax
  802957:	01 d0                	add    %edx,%eax
  802959:	89 c1                	mov    %eax,%ecx
  80295b:	c1 e1 08             	shl    $0x8,%ecx
  80295e:	01 c8                	add    %ecx,%eax
  802960:	89 c1                	mov    %eax,%ecx
  802962:	c1 e1 10             	shl    $0x10,%ecx
  802965:	01 c8                	add    %ecx,%eax
  802967:	01 c0                	add    %eax,%eax
  802969:	01 d0                	add    %edx,%eax
  80296b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	c1 e0 0c             	shl    $0xc,%eax
  802974:	89 c2                	mov    %eax,%edx
  802976:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80297b:	01 d0                	add    %edx,%eax
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
  802982:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802985:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80298a:	8b 55 08             	mov    0x8(%ebp),%edx
  80298d:	29 c2                	sub    %eax,%edx
  80298f:	89 d0                	mov    %edx,%eax
  802991:	c1 e8 0c             	shr    $0xc,%eax
  802994:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299b:	78 09                	js     8029a6 <to_page_info+0x27>
  80299d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8029a4:	7e 14                	jle    8029ba <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8029a6:	83 ec 04             	sub    $0x4,%esp
  8029a9:	68 44 47 80 00       	push   $0x804744
  8029ae:	6a 22                	push   $0x22
  8029b0:	68 2b 47 80 00       	push   $0x80472b
  8029b5:	e8 cd da ff ff       	call   800487 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8029ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bd:	89 d0                	mov    %edx,%eax
  8029bf:	01 c0                	add    %eax,%eax
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	c1 e0 02             	shl    $0x2,%eax
  8029c6:	05 60 50 80 00       	add    $0x805060,%eax
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
  8029d0:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	05 00 00 00 02       	add    $0x2000000,%eax
  8029db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029de:	73 16                	jae    8029f6 <initialize_dynamic_allocator+0x29>
  8029e0:	68 68 47 80 00       	push   $0x804768
  8029e5:	68 8e 47 80 00       	push   $0x80478e
  8029ea:	6a 34                	push   $0x34
  8029ec:	68 2b 47 80 00       	push   $0x80472b
  8029f1:	e8 91 da ff ff       	call   800487 <_panic>
		is_initialized = 1;
  8029f6:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8029fd:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0b:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802a10:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802a17:	00 00 00 
  802a1a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802a21:	00 00 00 
  802a24:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802a2b:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802a2e:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802a35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a3c:	eb 36                	jmp    802a74 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	c1 e0 04             	shl    $0x4,%eax
  802a44:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	c1 e0 04             	shl    $0x4,%eax
  802a55:	05 84 d0 81 00       	add    $0x81d084,%eax
  802a5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	c1 e0 04             	shl    $0x4,%eax
  802a66:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802a6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802a71:	ff 45 f4             	incl   -0xc(%ebp)
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a7a:	72 c2                	jb     802a3e <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802a7c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a82:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a87:	29 c2                	sub    %eax,%edx
  802a89:	89 d0                	mov    %edx,%eax
  802a8b:	c1 e8 0c             	shr    $0xc,%eax
  802a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a98:	e9 c8 00 00 00       	jmp    802b65 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 d0                	mov    %edx,%eax
  802aa2:	01 c0                	add    %eax,%eax
  802aa4:	01 d0                	add    %edx,%eax
  802aa6:	c1 e0 02             	shl    $0x2,%eax
  802aa9:	05 68 50 80 00       	add    $0x805068,%eax
  802aae:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab6:	89 d0                	mov    %edx,%eax
  802ab8:	01 c0                	add    %eax,%eax
  802aba:	01 d0                	add    %edx,%eax
  802abc:	c1 e0 02             	shl    $0x2,%eax
  802abf:	05 6a 50 80 00       	add    $0x80506a,%eax
  802ac4:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802ac9:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802acf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ad2:	89 c8                	mov    %ecx,%eax
  802ad4:	01 c0                	add    %eax,%eax
  802ad6:	01 c8                	add    %ecx,%eax
  802ad8:	c1 e0 02             	shl    $0x2,%eax
  802adb:	05 64 50 80 00       	add    $0x805064,%eax
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae5:	89 d0                	mov    %edx,%eax
  802ae7:	01 c0                	add    %eax,%eax
  802ae9:	01 d0                	add    %edx,%eax
  802aeb:	c1 e0 02             	shl    $0x2,%eax
  802aee:	05 64 50 80 00       	add    $0x805064,%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 1b                	je     802b14 <initialize_dynamic_allocator+0x147>
  802af9:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802aff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b02:	89 c8                	mov    %ecx,%eax
  802b04:	01 c0                	add    %eax,%eax
  802b06:	01 c8                	add    %ecx,%eax
  802b08:	c1 e0 02             	shl    $0x2,%eax
  802b0b:	05 60 50 80 00       	add    $0x805060,%eax
  802b10:	89 02                	mov    %eax,(%edx)
  802b12:	eb 16                	jmp    802b2a <initialize_dynamic_allocator+0x15d>
  802b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b17:	89 d0                	mov    %edx,%eax
  802b19:	01 c0                	add    %eax,%eax
  802b1b:	01 d0                	add    %edx,%eax
  802b1d:	c1 e0 02             	shl    $0x2,%eax
  802b20:	05 60 50 80 00       	add    $0x805060,%eax
  802b25:	a3 48 50 80 00       	mov    %eax,0x805048
  802b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2d:	89 d0                	mov    %edx,%eax
  802b2f:	01 c0                	add    %eax,%eax
  802b31:	01 d0                	add    %edx,%eax
  802b33:	c1 e0 02             	shl    $0x2,%eax
  802b36:	05 60 50 80 00       	add    $0x805060,%eax
  802b3b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	01 c0                	add    %eax,%eax
  802b47:	01 d0                	add    %edx,%eax
  802b49:	c1 e0 02             	shl    $0x2,%eax
  802b4c:	05 60 50 80 00       	add    $0x805060,%eax
  802b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b57:	a1 54 50 80 00       	mov    0x805054,%eax
  802b5c:	40                   	inc    %eax
  802b5d:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802b62:	ff 45 f0             	incl   -0x10(%ebp)
  802b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b68:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b6b:	0f 82 2c ff ff ff    	jb     802a9d <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b77:	eb 2f                	jmp    802ba8 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7c:	89 d0                	mov    %edx,%eax
  802b7e:	01 c0                	add    %eax,%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	c1 e0 02             	shl    $0x2,%eax
  802b85:	05 68 50 80 00       	add    $0x805068,%eax
  802b8a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	01 c0                	add    %eax,%eax
  802b96:	01 d0                	add    %edx,%eax
  802b98:	c1 e0 02             	shl    $0x2,%eax
  802b9b:	05 6a 50 80 00       	add    $0x80506a,%eax
  802ba0:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802ba5:	ff 45 ec             	incl   -0x14(%ebp)
  802ba8:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802baf:	76 c8                	jbe    802b79 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802bb1:	90                   	nop
  802bb2:	c9                   	leave  
  802bb3:	c3                   	ret    

00802bb4 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
  802bb7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802bba:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbd:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802bc2:	29 c2                	sub    %eax,%edx
  802bc4:	89 d0                	mov    %edx,%eax
  802bc6:	c1 e8 0c             	shr    $0xc,%eax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802bcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bcf:	89 d0                	mov    %edx,%eax
  802bd1:	01 c0                	add    %eax,%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	c1 e0 02             	shl    $0x2,%eax
  802bd8:	05 68 50 80 00       	add    $0x805068,%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802be2:	c9                   	leave  
  802be3:	c3                   	ret    

00802be4 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802be4:	55                   	push   %ebp
  802be5:	89 e5                	mov    %esp,%ebp
  802be7:	83 ec 14             	sub    $0x14,%esp
  802bea:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802bed:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802bf1:	77 07                	ja     802bfa <nearest_pow2_ceil.1513+0x16>
  802bf3:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf8:	eb 20                	jmp    802c1a <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802bfa:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802c01:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802c04:	eb 08                	jmp    802c0e <nearest_pow2_ceil.1513+0x2a>
  802c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c09:	01 c0                	add    %eax,%eax
  802c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c0e:	d1 6d 08             	shrl   0x8(%ebp)
  802c11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c15:	75 ef                	jne    802c06 <nearest_pow2_ceil.1513+0x22>
        return power;
  802c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802c22:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802c29:	76 16                	jbe    802c41 <alloc_block+0x25>
  802c2b:	68 a4 47 80 00       	push   $0x8047a4
  802c30:	68 8e 47 80 00       	push   $0x80478e
  802c35:	6a 72                	push   $0x72
  802c37:	68 2b 47 80 00       	push   $0x80472b
  802c3c:	e8 46 d8 ff ff       	call   800487 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802c41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c45:	75 0a                	jne    802c51 <alloc_block+0x35>
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4c:	e9 bd 04 00 00       	jmp    80310e <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802c51:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c5e:	73 06                	jae    802c66 <alloc_block+0x4a>
        size = min_block_size;
  802c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c63:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802c66:	83 ec 0c             	sub    $0xc,%esp
  802c69:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c6c:	ff 75 08             	pushl  0x8(%ebp)
  802c6f:	89 c1                	mov    %eax,%ecx
  802c71:	e8 6e ff ff ff       	call   802be4 <nearest_pow2_ceil.1513>
  802c76:	83 c4 10             	add    $0x10,%esp
  802c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802c7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7f:	83 ec 0c             	sub    $0xc,%esp
  802c82:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c85:	52                   	push   %edx
  802c86:	89 c1                	mov    %eax,%ecx
  802c88:	e8 83 04 00 00       	call   803110 <log2_ceil.1520>
  802c8d:	83 c4 10             	add    $0x10,%esp
  802c90:	83 e8 03             	sub    $0x3,%eax
  802c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c99:	c1 e0 04             	shl    $0x4,%eax
  802c9c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	0f 84 d8 00 00 00    	je     802d83 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cae:	c1 e0 04             	shl    $0x4,%eax
  802cb1:	05 80 d0 81 00       	add    $0x81d080,%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802cbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cbf:	75 17                	jne    802cd8 <alloc_block+0xbc>
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	68 c5 47 80 00       	push   $0x8047c5
  802cc9:	68 98 00 00 00       	push   $0x98
  802cce:	68 2b 47 80 00       	push   $0x80472b
  802cd3:	e8 af d7 ff ff       	call   800487 <_panic>
  802cd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 10                	je     802cf1 <alloc_block+0xd5>
  802ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce9:	8b 52 04             	mov    0x4(%edx),%edx
  802cec:	89 50 04             	mov    %edx,0x4(%eax)
  802cef:	eb 14                	jmp    802d05 <alloc_block+0xe9>
  802cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cfa:	c1 e2 04             	shl    $0x4,%edx
  802cfd:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802d03:	89 02                	mov    %eax,(%edx)
  802d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 0f                	je     802d1e <alloc_block+0x102>
  802d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d18:	8b 12                	mov    (%edx),%edx
  802d1a:	89 10                	mov    %edx,(%eax)
  802d1c:	eb 13                	jmp    802d31 <alloc_block+0x115>
  802d1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d26:	c1 e2 04             	shl    $0x4,%edx
  802d29:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d2f:	89 02                	mov    %eax,(%edx)
  802d31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d47:	c1 e0 04             	shl    $0x4,%eax
  802d4a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d57:	c1 e0 04             	shl    $0x4,%eax
  802d5a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d5f:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d64:	83 ec 0c             	sub    $0xc,%esp
  802d67:	50                   	push   %eax
  802d68:	e8 12 fc ff ff       	call   80297f <to_page_info>
  802d6d:	83 c4 10             	add    $0x10,%esp
  802d70:	89 c2                	mov    %eax,%edx
  802d72:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d76:	48                   	dec    %eax
  802d77:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802d7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7e:	e9 8b 03 00 00       	jmp    80310e <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802d83:	a1 48 50 80 00       	mov    0x805048,%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	0f 84 64 02 00 00    	je     802ff4 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d90:	a1 48 50 80 00       	mov    0x805048,%eax
  802d95:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d98:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d9c:	75 17                	jne    802db5 <alloc_block+0x199>
  802d9e:	83 ec 04             	sub    $0x4,%esp
  802da1:	68 c5 47 80 00       	push   $0x8047c5
  802da6:	68 a0 00 00 00       	push   $0xa0
  802dab:	68 2b 47 80 00       	push   $0x80472b
  802db0:	e8 d2 d6 ff ff       	call   800487 <_panic>
  802db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	74 10                	je     802dce <alloc_block+0x1b2>
  802dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dc6:	8b 52 04             	mov    0x4(%edx),%edx
  802dc9:	89 50 04             	mov    %edx,0x4(%eax)
  802dcc:	eb 0b                	jmp    802dd9 <alloc_block+0x1bd>
  802dce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd1:	8b 40 04             	mov    0x4(%eax),%eax
  802dd4:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802dd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	85 c0                	test   %eax,%eax
  802de1:	74 0f                	je     802df2 <alloc_block+0x1d6>
  802de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de6:	8b 40 04             	mov    0x4(%eax),%eax
  802de9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dec:	8b 12                	mov    (%edx),%edx
  802dee:	89 10                	mov    %edx,(%eax)
  802df0:	eb 0a                	jmp    802dfc <alloc_block+0x1e0>
  802df2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	a3 48 50 80 00       	mov    %eax,0x805048
  802dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0f:	a1 54 50 80 00       	mov    0x805054,%eax
  802e14:	48                   	dec    %eax
  802e15:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e20:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802e24:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e29:	99                   	cltd   
  802e2a:	f7 7d e8             	idivl  -0x18(%ebp)
  802e2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e30:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802e34:	83 ec 0c             	sub    $0xc,%esp
  802e37:	ff 75 dc             	pushl  -0x24(%ebp)
  802e3a:	e8 ce fa ff ff       	call   80290d <to_page_va>
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e48:	83 ec 0c             	sub    $0xc,%esp
  802e4b:	50                   	push   %eax
  802e4c:	e8 c0 ee ff ff       	call   801d11 <get_page>
  802e51:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e5b:	e9 aa 00 00 00       	jmp    802f0a <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802e67:	89 c2                	mov    %eax,%edx
  802e69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e6c:	01 d0                	add    %edx,%eax
  802e6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802e71:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e75:	75 17                	jne    802e8e <alloc_block+0x272>
  802e77:	83 ec 04             	sub    $0x4,%esp
  802e7a:	68 e4 47 80 00       	push   $0x8047e4
  802e7f:	68 aa 00 00 00       	push   $0xaa
  802e84:	68 2b 47 80 00       	push   $0x80472b
  802e89:	e8 f9 d5 ff ff       	call   800487 <_panic>
  802e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e91:	c1 e0 04             	shl    $0x4,%eax
  802e94:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e99:	8b 10                	mov    (%eax),%edx
  802e9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ea1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea4:	8b 40 04             	mov    0x4(%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 14                	je     802ebf <alloc_block+0x2a3>
  802eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eae:	c1 e0 04             	shl    $0x4,%eax
  802eb1:	05 84 d0 81 00       	add    $0x81d084,%eax
  802eb6:	8b 00                	mov    (%eax),%eax
  802eb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ebb:	89 10                	mov    %edx,(%eax)
  802ebd:	eb 11                	jmp    802ed0 <alloc_block+0x2b4>
  802ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec2:	c1 e0 04             	shl    $0x4,%eax
  802ec5:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802ecb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ece:	89 02                	mov    %eax,(%edx)
  802ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed3:	c1 e0 04             	shl    $0x4,%eax
  802ed6:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802edf:	89 02                	mov    %eax,(%edx)
  802ee1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eed:	c1 e0 04             	shl    $0x4,%eax
  802ef0:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	8d 50 01             	lea    0x1(%eax),%edx
  802efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802efd:	c1 e0 04             	shl    $0x4,%eax
  802f00:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f05:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802f07:	ff 45 f4             	incl   -0xc(%ebp)
  802f0a:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f0f:	99                   	cltd   
  802f10:	f7 7d e8             	idivl  -0x18(%ebp)
  802f13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f16:	0f 8f 44 ff ff ff    	jg     802e60 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1f:	c1 e0 04             	shl    $0x4,%eax
  802f22:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802f2c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f30:	75 17                	jne    802f49 <alloc_block+0x32d>
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	68 c5 47 80 00       	push   $0x8047c5
  802f3a:	68 ae 00 00 00       	push   $0xae
  802f3f:	68 2b 47 80 00       	push   $0x80472b
  802f44:	e8 3e d5 ff ff       	call   800487 <_panic>
  802f49:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 10                	je     802f62 <alloc_block+0x346>
  802f52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f5a:	8b 52 04             	mov    0x4(%edx),%edx
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	eb 14                	jmp    802f76 <alloc_block+0x35a>
  802f62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f6b:	c1 e2 04             	shl    $0x4,%edx
  802f6e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f74:	89 02                	mov    %eax,(%edx)
  802f76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f79:	8b 40 04             	mov    0x4(%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	74 0f                	je     802f8f <alloc_block+0x373>
  802f80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f89:	8b 12                	mov    (%edx),%edx
  802f8b:	89 10                	mov    %edx,(%eax)
  802f8d:	eb 13                	jmp    802fa2 <alloc_block+0x386>
  802f8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f97:	c1 e2 04             	shl    $0x4,%edx
  802f9a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802fa0:	89 02                	mov    %eax,(%edx)
  802fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb8:	c1 e0 04             	shl    $0x4,%eax
  802fbb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  802fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc8:	c1 e0 04             	shl    $0x4,%eax
  802fcb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fd0:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802fd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd5:	83 ec 0c             	sub    $0xc,%esp
  802fd8:	50                   	push   %eax
  802fd9:	e8 a1 f9 ff ff       	call   80297f <to_page_info>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	89 c2                	mov    %eax,%edx
  802fe3:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fe7:	48                   	dec    %eax
  802fe8:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fef:	e9 1a 01 00 00       	jmp    80310e <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff7:	40                   	inc    %eax
  802ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ffb:	e9 ed 00 00 00       	jmp    8030ed <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	c1 e0 04             	shl    $0x4,%eax
  803006:	05 80 d0 81 00       	add    $0x81d080,%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	85 c0                	test   %eax,%eax
  80300f:	0f 84 d5 00 00 00    	je     8030ea <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803018:	c1 e0 04             	shl    $0x4,%eax
  80301b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803025:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803029:	75 17                	jne    803042 <alloc_block+0x426>
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	68 c5 47 80 00       	push   $0x8047c5
  803033:	68 b8 00 00 00       	push   $0xb8
  803038:	68 2b 47 80 00       	push   $0x80472b
  80303d:	e8 45 d4 ff ff       	call   800487 <_panic>
  803042:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 10                	je     80305b <alloc_block+0x43f>
  80304b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803053:	8b 52 04             	mov    0x4(%edx),%edx
  803056:	89 50 04             	mov    %edx,0x4(%eax)
  803059:	eb 14                	jmp    80306f <alloc_block+0x453>
  80305b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803064:	c1 e2 04             	shl    $0x4,%edx
  803067:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80306d:	89 02                	mov    %eax,(%edx)
  80306f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	74 0f                	je     803088 <alloc_block+0x46c>
  803079:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80307c:	8b 40 04             	mov    0x4(%eax),%eax
  80307f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803082:	8b 12                	mov    (%edx),%edx
  803084:	89 10                	mov    %edx,(%eax)
  803086:	eb 13                	jmp    80309b <alloc_block+0x47f>
  803088:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803090:	c1 e2 04             	shl    $0x4,%edx
  803093:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803099:	89 02                	mov    %eax,(%edx)
  80309b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b1:	c1 e0 04             	shl    $0x4,%eax
  8030b4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	c1 e0 04             	shl    $0x4,%eax
  8030c4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030c9:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8030cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ce:	83 ec 0c             	sub    $0xc,%esp
  8030d1:	50                   	push   %eax
  8030d2:	e8 a8 f8 ff ff       	call   80297f <to_page_info>
  8030d7:	83 c4 10             	add    $0x10,%esp
  8030da:	89 c2                	mov    %eax,%edx
  8030dc:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8030e0:	48                   	dec    %eax
  8030e1:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8030e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e8:	eb 24                	jmp    80310e <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030ea:	ff 45 f0             	incl   -0x10(%ebp)
  8030ed:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030f1:	0f 8e 09 ff ff ff    	jle    803000 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	68 07 48 80 00       	push   $0x804807
  8030ff:	68 bf 00 00 00       	push   $0xbf
  803104:	68 2b 47 80 00       	push   $0x80472b
  803109:	e8 79 d3 ff ff       	call   800487 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80310e:	c9                   	leave  
  80310f:	c3                   	ret    

00803110 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803110:	55                   	push   %ebp
  803111:	89 e5                	mov    %esp,%ebp
  803113:	83 ec 14             	sub    $0x14,%esp
  803116:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311d:	75 07                	jne    803126 <log2_ceil.1520+0x16>
  80311f:	b8 00 00 00 00       	mov    $0x0,%eax
  803124:	eb 1b                	jmp    803141 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803126:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80312d:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803130:	eb 06                	jmp    803138 <log2_ceil.1520+0x28>
            x >>= 1;
  803132:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803135:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313c:	75 f4                	jne    803132 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80313e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803141:	c9                   	leave  
  803142:	c3                   	ret    

00803143 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803143:	55                   	push   %ebp
  803144:	89 e5                	mov    %esp,%ebp
  803146:	83 ec 14             	sub    $0x14,%esp
  803149:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80314c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803150:	75 07                	jne    803159 <log2_ceil.1547+0x16>
  803152:	b8 00 00 00 00       	mov    $0x0,%eax
  803157:	eb 1b                	jmp    803174 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803160:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803163:	eb 06                	jmp    80316b <log2_ceil.1547+0x28>
			x >>= 1;
  803165:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803168:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80316b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316f:	75 f4                	jne    803165 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803171:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803174:	c9                   	leave  
  803175:	c3                   	ret    

00803176 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803176:	55                   	push   %ebp
  803177:	89 e5                	mov    %esp,%ebp
  803179:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80317c:	8b 55 08             	mov    0x8(%ebp),%edx
  80317f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803184:	39 c2                	cmp    %eax,%edx
  803186:	72 0c                	jb     803194 <free_block+0x1e>
  803188:	8b 55 08             	mov    0x8(%ebp),%edx
  80318b:	a1 40 50 80 00       	mov    0x805040,%eax
  803190:	39 c2                	cmp    %eax,%edx
  803192:	72 19                	jb     8031ad <free_block+0x37>
  803194:	68 0c 48 80 00       	push   $0x80480c
  803199:	68 8e 47 80 00       	push   $0x80478e
  80319e:	68 d0 00 00 00       	push   $0xd0
  8031a3:	68 2b 47 80 00       	push   $0x80472b
  8031a8:	e8 da d2 ff ff       	call   800487 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8031ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b1:	0f 84 42 03 00 00    	je     8034f9 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8031b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ba:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031bf:	39 c2                	cmp    %eax,%edx
  8031c1:	72 0c                	jb     8031cf <free_block+0x59>
  8031c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c6:	a1 40 50 80 00       	mov    0x805040,%eax
  8031cb:	39 c2                	cmp    %eax,%edx
  8031cd:	72 17                	jb     8031e6 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8031cf:	83 ec 04             	sub    $0x4,%esp
  8031d2:	68 44 48 80 00       	push   $0x804844
  8031d7:	68 e6 00 00 00       	push   $0xe6
  8031dc:	68 2b 47 80 00       	push   $0x80472b
  8031e1:	e8 a1 d2 ff ff       	call   800487 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8031e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031ee:	29 c2                	sub    %eax,%edx
  8031f0:	89 d0                	mov    %edx,%eax
  8031f2:	83 e0 07             	and    $0x7,%eax
  8031f5:	85 c0                	test   %eax,%eax
  8031f7:	74 17                	je     803210 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 78 48 80 00       	push   $0x804878
  803201:	68 ea 00 00 00       	push   $0xea
  803206:	68 2b 47 80 00       	push   $0x80472b
  80320b:	e8 77 d2 ff ff       	call   800487 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	83 ec 0c             	sub    $0xc,%esp
  803216:	50                   	push   %eax
  803217:	e8 63 f7 ff ff       	call   80297f <to_page_info>
  80321c:	83 c4 10             	add    $0x10,%esp
  80321f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803222:	83 ec 0c             	sub    $0xc,%esp
  803225:	ff 75 08             	pushl  0x8(%ebp)
  803228:	e8 87 f9 ff ff       	call   802bb4 <get_block_size>
  80322d:	83 c4 10             	add    $0x10,%esp
  803230:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803233:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803237:	75 17                	jne    803250 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803239:	83 ec 04             	sub    $0x4,%esp
  80323c:	68 a4 48 80 00       	push   $0x8048a4
  803241:	68 f1 00 00 00       	push   $0xf1
  803246:	68 2b 47 80 00       	push   $0x80472b
  80324b:	e8 37 d2 ff ff       	call   800487 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803250:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803253:	83 ec 0c             	sub    $0xc,%esp
  803256:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803259:	52                   	push   %edx
  80325a:	89 c1                	mov    %eax,%ecx
  80325c:	e8 e2 fe ff ff       	call   803143 <log2_ceil.1547>
  803261:	83 c4 10             	add    $0x10,%esp
  803264:	83 e8 03             	sub    $0x3,%eax
  803267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803270:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803274:	75 17                	jne    80328d <free_block+0x117>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 f0 48 80 00       	push   $0x8048f0
  80327e:	68 f6 00 00 00       	push   $0xf6
  803283:	68 2b 47 80 00       	push   $0x80472b
  803288:	e8 fa d1 ff ff       	call   800487 <_panic>
  80328d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803290:	c1 e0 04             	shl    $0x4,%eax
  803293:	05 80 d0 81 00       	add    $0x81d080,%eax
  803298:	8b 10                	mov    (%eax),%edx
  80329a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329d:	89 10                	mov    %edx,(%eax)
  80329f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a2:	8b 00                	mov    (%eax),%eax
  8032a4:	85 c0                	test   %eax,%eax
  8032a6:	74 15                	je     8032bd <free_block+0x147>
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	c1 e0 04             	shl    $0x4,%eax
  8032ae:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b8:	89 50 04             	mov    %edx,0x4(%eax)
  8032bb:	eb 11                	jmp    8032ce <free_block+0x158>
  8032bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c0:	c1 e0 04             	shl    $0x4,%eax
  8032c3:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8032c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cc:	89 02                	mov    %eax,(%edx)
  8032ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d1:	c1 e0 04             	shl    $0x4,%eax
  8032d4:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8032da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032dd:	89 02                	mov    %eax,(%edx)
  8032df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ec:	c1 e0 04             	shl    $0x4,%eax
  8032ef:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	8d 50 01             	lea    0x1(%eax),%edx
  8032f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fc:	c1 e0 04             	shl    $0x4,%eax
  8032ff:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803304:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803309:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80330d:	40                   	inc    %eax
  80330e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803311:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803315:	8b 55 08             	mov    0x8(%ebp),%edx
  803318:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80331d:	29 c2                	sub    %eax,%edx
  80331f:	89 d0                	mov    %edx,%eax
  803321:	c1 e8 0c             	shr    $0xc,%eax
  803324:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80332e:	0f b7 c8             	movzwl %ax,%ecx
  803331:	b8 00 10 00 00       	mov    $0x1000,%eax
  803336:	99                   	cltd   
  803337:	f7 7d e8             	idivl  -0x18(%ebp)
  80333a:	39 c1                	cmp    %eax,%ecx
  80333c:	0f 85 b8 01 00 00    	jne    8034fa <free_block+0x384>
    	uint32 blocks_removed = 0;
  803342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334c:	c1 e0 04             	shl    $0x4,%eax
  80334f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803359:	e9 d5 00 00 00       	jmp    803433 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	8b 00                	mov    (%eax),%eax
  803363:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803369:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80336e:	29 c2                	sub    %eax,%edx
  803370:	89 d0                	mov    %edx,%eax
  803372:	c1 e8 0c             	shr    $0xc,%eax
  803375:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803378:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80337e:	0f 85 a9 00 00 00    	jne    80342d <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803388:	75 17                	jne    8033a1 <free_block+0x22b>
  80338a:	83 ec 04             	sub    $0x4,%esp
  80338d:	68 c5 47 80 00       	push   $0x8047c5
  803392:	68 04 01 00 00       	push   $0x104
  803397:	68 2b 47 80 00       	push   $0x80472b
  80339c:	e8 e6 d0 ff ff       	call   800487 <_panic>
  8033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	74 10                	je     8033ba <free_block+0x244>
  8033aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b2:	8b 52 04             	mov    0x4(%edx),%edx
  8033b5:	89 50 04             	mov    %edx,0x4(%eax)
  8033b8:	eb 14                	jmp    8033ce <free_block+0x258>
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	8b 40 04             	mov    0x4(%eax),%eax
  8033c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c3:	c1 e2 04             	shl    $0x4,%edx
  8033c6:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8033cc:	89 02                	mov    %eax,(%edx)
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	8b 40 04             	mov    0x4(%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 0f                	je     8033e7 <free_block+0x271>
  8033d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033db:	8b 40 04             	mov    0x4(%eax),%eax
  8033de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e1:	8b 12                	mov    (%edx),%edx
  8033e3:	89 10                	mov    %edx,(%eax)
  8033e5:	eb 13                	jmp    8033fa <free_block+0x284>
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ef:	c1 e2 04             	shl    $0x4,%edx
  8033f2:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033f8:	89 02                	mov    %eax,(%edx)
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803410:	c1 e0 04             	shl    $0x4,%eax
  803413:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80341d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803420:	c1 e0 04             	shl    $0x4,%eax
  803423:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803428:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80342a:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80342d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803430:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803433:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803437:	0f 85 21 ff ff ff    	jne    80335e <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80343d:	b8 00 10 00 00       	mov    $0x1000,%eax
  803442:	99                   	cltd   
  803443:	f7 7d e8             	idivl  -0x18(%ebp)
  803446:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803449:	74 17                	je     803462 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 14 49 80 00       	push   $0x804914
  803453:	68 0c 01 00 00       	push   $0x10c
  803458:	68 2b 47 80 00       	push   $0x80472b
  80345d:	e8 25 d0 ff ff       	call   800487 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803465:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80346b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803478:	75 17                	jne    803491 <free_block+0x31b>
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	68 e4 47 80 00       	push   $0x8047e4
  803482:	68 11 01 00 00       	push   $0x111
  803487:	68 2b 47 80 00       	push   $0x80472b
  80348c:	e8 f6 cf ff ff       	call   800487 <_panic>
  803491:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349a:	89 50 04             	mov    %edx,0x4(%eax)
  80349d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	85 c0                	test   %eax,%eax
  8034a5:	74 0c                	je     8034b3 <free_block+0x33d>
  8034a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8034ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034af:	89 10                	mov    %edx,(%eax)
  8034b1:	eb 08                	jmp    8034bb <free_block+0x345>
  8034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b6:	a3 48 50 80 00       	mov    %eax,0x805048
  8034bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034be:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cc:	a1 54 50 80 00       	mov    0x805054,%eax
  8034d1:	40                   	inc    %eax
  8034d2:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8034d7:	83 ec 0c             	sub    $0xc,%esp
  8034da:	ff 75 ec             	pushl  -0x14(%ebp)
  8034dd:	e8 2b f4 ff ff       	call   80290d <to_page_va>
  8034e2:	83 c4 10             	add    $0x10,%esp
  8034e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8034e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034eb:	83 ec 0c             	sub    $0xc,%esp
  8034ee:	50                   	push   %eax
  8034ef:	e8 69 e8 ff ff       	call   801d5d <return_page>
  8034f4:	83 c4 10             	add    $0x10,%esp
  8034f7:	eb 01                	jmp    8034fa <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034f9:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8034fa:	c9                   	leave  
  8034fb:	c3                   	ret    

008034fc <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8034fc:	55                   	push   %ebp
  8034fd:	89 e5                	mov    %esp,%ebp
  8034ff:	83 ec 14             	sub    $0x14,%esp
  803502:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803505:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803509:	77 07                	ja     803512 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80350b:	b8 01 00 00 00       	mov    $0x1,%eax
  803510:	eb 20                	jmp    803532 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803512:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803519:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  80351c:	eb 08                	jmp    803526 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  80351e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803521:	01 c0                	add    %eax,%eax
  803523:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803526:	d1 6d 08             	shrl   0x8(%ebp)
  803529:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352d:	75 ef                	jne    80351e <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80352f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803532:	c9                   	leave  
  803533:	c3                   	ret    

00803534 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803534:	55                   	push   %ebp
  803535:	89 e5                	mov    %esp,%ebp
  803537:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80353a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353e:	75 13                	jne    803553 <realloc_block+0x1f>
    return alloc_block(new_size);
  803540:	83 ec 0c             	sub    $0xc,%esp
  803543:	ff 75 0c             	pushl  0xc(%ebp)
  803546:	e8 d1 f6 ff ff       	call   802c1c <alloc_block>
  80354b:	83 c4 10             	add    $0x10,%esp
  80354e:	e9 d9 00 00 00       	jmp    80362c <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803553:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803557:	75 18                	jne    803571 <realloc_block+0x3d>
    free_block(va);
  803559:	83 ec 0c             	sub    $0xc,%esp
  80355c:	ff 75 08             	pushl  0x8(%ebp)
  80355f:	e8 12 fc ff ff       	call   803176 <free_block>
  803564:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803567:	b8 00 00 00 00       	mov    $0x0,%eax
  80356c:	e9 bb 00 00 00       	jmp    80362c <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803571:	83 ec 0c             	sub    $0xc,%esp
  803574:	ff 75 08             	pushl  0x8(%ebp)
  803577:	e8 38 f6 ff ff       	call   802bb4 <get_block_size>
  80357c:	83 c4 10             	add    $0x10,%esp
  80357f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803582:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80358f:	73 06                	jae    803597 <realloc_block+0x63>
    new_size = min_block_size;
  803591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803594:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803597:	83 ec 0c             	sub    $0xc,%esp
  80359a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80359d:	ff 75 0c             	pushl  0xc(%ebp)
  8035a0:	89 c1                	mov    %eax,%ecx
  8035a2:	e8 55 ff ff ff       	call   8034fc <nearest_pow2_ceil.1572>
  8035a7:	83 c4 10             	add    $0x10,%esp
  8035aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8035ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035b3:	75 05                	jne    8035ba <realloc_block+0x86>
    return va;
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	eb 72                	jmp    80362c <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8035ba:	83 ec 0c             	sub    $0xc,%esp
  8035bd:	ff 75 0c             	pushl  0xc(%ebp)
  8035c0:	e8 57 f6 ff ff       	call   802c1c <alloc_block>
  8035c5:	83 c4 10             	add    $0x10,%esp
  8035c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8035cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035cf:	75 07                	jne    8035d8 <realloc_block+0xa4>
    return NULL;
  8035d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d6:	eb 54                	jmp    80362c <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8035d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035de:	39 d0                	cmp    %edx,%eax
  8035e0:	76 02                	jbe    8035e4 <realloc_block+0xb0>
  8035e2:	89 d0                	mov    %edx,%eax
  8035e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8035f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035fa:	eb 17                	jmp    803613 <realloc_block+0xdf>
    dst[i] = src[i];
  8035fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803602:	01 c2                	add    %eax,%edx
  803604:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	01 c8                	add    %ecx,%eax
  80360c:	8a 00                	mov    (%eax),%al
  80360e:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803610:	ff 45 f4             	incl   -0xc(%ebp)
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803619:	72 e1                	jb     8035fc <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80361b:	83 ec 0c             	sub    $0xc,%esp
  80361e:	ff 75 08             	pushl  0x8(%ebp)
  803621:	e8 50 fb ff ff       	call   803176 <free_block>
  803626:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80362c:	c9                   	leave  
  80362d:	c3                   	ret    

0080362e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80362e:	55                   	push   %ebp
  80362f:	89 e5                	mov    %esp,%ebp
  803631:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803634:	8b 55 08             	mov    0x8(%ebp),%edx
  803637:	89 d0                	mov    %edx,%eax
  803639:	c1 e0 02             	shl    $0x2,%eax
  80363c:	01 d0                	add    %edx,%eax
  80363e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803645:	01 d0                	add    %edx,%eax
  803647:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80364e:	01 d0                	add    %edx,%eax
  803650:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803657:	01 d0                	add    %edx,%eax
  803659:	c1 e0 04             	shl    $0x4,%eax
  80365c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  80365f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803666:	0f 31                	rdtsc  
  803668:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80366b:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803674:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803677:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80367a:	eb 46                	jmp    8036c2 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80367c:	0f 31                	rdtsc  
  80367e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803681:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803684:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803687:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80368a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80368d:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803690:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803696:	29 c2                	sub    %eax,%edx
  803698:	89 d0                	mov    %edx,%eax
  80369a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80369d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	89 d1                	mov    %edx,%ecx
  8036a5:	29 c1                	sub    %eax,%ecx
  8036a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ad:	39 c2                	cmp    %eax,%edx
  8036af:	0f 97 c0             	seta   %al
  8036b2:	0f b6 c0             	movzbl %al,%eax
  8036b5:	29 c1                	sub    %eax,%ecx
  8036b7:	89 c8                	mov    %ecx,%eax
  8036b9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8036bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8036c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036c8:	72 b2                	jb     80367c <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8036ca:	90                   	nop
  8036cb:	c9                   	leave  
  8036cc:	c3                   	ret    

008036cd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036cd:	55                   	push   %ebp
  8036ce:	89 e5                	mov    %esp,%ebp
  8036d0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036da:	eb 03                	jmp    8036df <busy_wait+0x12>
  8036dc:	ff 45 fc             	incl   -0x4(%ebp)
  8036df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036e5:	72 f5                	jb     8036dc <busy_wait+0xf>
	return i;
  8036e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036ea:	c9                   	leave  
  8036eb:	c3                   	ret    

008036ec <__udivdi3>:
  8036ec:	55                   	push   %ebp
  8036ed:	57                   	push   %edi
  8036ee:	56                   	push   %esi
  8036ef:	53                   	push   %ebx
  8036f0:	83 ec 1c             	sub    $0x1c,%esp
  8036f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803703:	89 ca                	mov    %ecx,%edx
  803705:	89 f8                	mov    %edi,%eax
  803707:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80370b:	85 f6                	test   %esi,%esi
  80370d:	75 2d                	jne    80373c <__udivdi3+0x50>
  80370f:	39 cf                	cmp    %ecx,%edi
  803711:	77 65                	ja     803778 <__udivdi3+0x8c>
  803713:	89 fd                	mov    %edi,%ebp
  803715:	85 ff                	test   %edi,%edi
  803717:	75 0b                	jne    803724 <__udivdi3+0x38>
  803719:	b8 01 00 00 00       	mov    $0x1,%eax
  80371e:	31 d2                	xor    %edx,%edx
  803720:	f7 f7                	div    %edi
  803722:	89 c5                	mov    %eax,%ebp
  803724:	31 d2                	xor    %edx,%edx
  803726:	89 c8                	mov    %ecx,%eax
  803728:	f7 f5                	div    %ebp
  80372a:	89 c1                	mov    %eax,%ecx
  80372c:	89 d8                	mov    %ebx,%eax
  80372e:	f7 f5                	div    %ebp
  803730:	89 cf                	mov    %ecx,%edi
  803732:	89 fa                	mov    %edi,%edx
  803734:	83 c4 1c             	add    $0x1c,%esp
  803737:	5b                   	pop    %ebx
  803738:	5e                   	pop    %esi
  803739:	5f                   	pop    %edi
  80373a:	5d                   	pop    %ebp
  80373b:	c3                   	ret    
  80373c:	39 ce                	cmp    %ecx,%esi
  80373e:	77 28                	ja     803768 <__udivdi3+0x7c>
  803740:	0f bd fe             	bsr    %esi,%edi
  803743:	83 f7 1f             	xor    $0x1f,%edi
  803746:	75 40                	jne    803788 <__udivdi3+0x9c>
  803748:	39 ce                	cmp    %ecx,%esi
  80374a:	72 0a                	jb     803756 <__udivdi3+0x6a>
  80374c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803750:	0f 87 9e 00 00 00    	ja     8037f4 <__udivdi3+0x108>
  803756:	b8 01 00 00 00       	mov    $0x1,%eax
  80375b:	89 fa                	mov    %edi,%edx
  80375d:	83 c4 1c             	add    $0x1c,%esp
  803760:	5b                   	pop    %ebx
  803761:	5e                   	pop    %esi
  803762:	5f                   	pop    %edi
  803763:	5d                   	pop    %ebp
  803764:	c3                   	ret    
  803765:	8d 76 00             	lea    0x0(%esi),%esi
  803768:	31 ff                	xor    %edi,%edi
  80376a:	31 c0                	xor    %eax,%eax
  80376c:	89 fa                	mov    %edi,%edx
  80376e:	83 c4 1c             	add    $0x1c,%esp
  803771:	5b                   	pop    %ebx
  803772:	5e                   	pop    %esi
  803773:	5f                   	pop    %edi
  803774:	5d                   	pop    %ebp
  803775:	c3                   	ret    
  803776:	66 90                	xchg   %ax,%ax
  803778:	89 d8                	mov    %ebx,%eax
  80377a:	f7 f7                	div    %edi
  80377c:	31 ff                	xor    %edi,%edi
  80377e:	89 fa                	mov    %edi,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	bd 20 00 00 00       	mov    $0x20,%ebp
  80378d:	89 eb                	mov    %ebp,%ebx
  80378f:	29 fb                	sub    %edi,%ebx
  803791:	89 f9                	mov    %edi,%ecx
  803793:	d3 e6                	shl    %cl,%esi
  803795:	89 c5                	mov    %eax,%ebp
  803797:	88 d9                	mov    %bl,%cl
  803799:	d3 ed                	shr    %cl,%ebp
  80379b:	89 e9                	mov    %ebp,%ecx
  80379d:	09 f1                	or     %esi,%ecx
  80379f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037a3:	89 f9                	mov    %edi,%ecx
  8037a5:	d3 e0                	shl    %cl,%eax
  8037a7:	89 c5                	mov    %eax,%ebp
  8037a9:	89 d6                	mov    %edx,%esi
  8037ab:	88 d9                	mov    %bl,%cl
  8037ad:	d3 ee                	shr    %cl,%esi
  8037af:	89 f9                	mov    %edi,%ecx
  8037b1:	d3 e2                	shl    %cl,%edx
  8037b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b7:	88 d9                	mov    %bl,%cl
  8037b9:	d3 e8                	shr    %cl,%eax
  8037bb:	09 c2                	or     %eax,%edx
  8037bd:	89 d0                	mov    %edx,%eax
  8037bf:	89 f2                	mov    %esi,%edx
  8037c1:	f7 74 24 0c          	divl   0xc(%esp)
  8037c5:	89 d6                	mov    %edx,%esi
  8037c7:	89 c3                	mov    %eax,%ebx
  8037c9:	f7 e5                	mul    %ebp
  8037cb:	39 d6                	cmp    %edx,%esi
  8037cd:	72 19                	jb     8037e8 <__udivdi3+0xfc>
  8037cf:	74 0b                	je     8037dc <__udivdi3+0xf0>
  8037d1:	89 d8                	mov    %ebx,%eax
  8037d3:	31 ff                	xor    %edi,%edi
  8037d5:	e9 58 ff ff ff       	jmp    803732 <__udivdi3+0x46>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037e0:	89 f9                	mov    %edi,%ecx
  8037e2:	d3 e2                	shl    %cl,%edx
  8037e4:	39 c2                	cmp    %eax,%edx
  8037e6:	73 e9                	jae    8037d1 <__udivdi3+0xe5>
  8037e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037eb:	31 ff                	xor    %edi,%edi
  8037ed:	e9 40 ff ff ff       	jmp    803732 <__udivdi3+0x46>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	31 c0                	xor    %eax,%eax
  8037f6:	e9 37 ff ff ff       	jmp    803732 <__udivdi3+0x46>
  8037fb:	90                   	nop

008037fc <__umoddi3>:
  8037fc:	55                   	push   %ebp
  8037fd:	57                   	push   %edi
  8037fe:	56                   	push   %esi
  8037ff:	53                   	push   %ebx
  803800:	83 ec 1c             	sub    $0x1c,%esp
  803803:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803807:	8b 74 24 34          	mov    0x34(%esp),%esi
  80380b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80380f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80381b:	89 f3                	mov    %esi,%ebx
  80381d:	89 fa                	mov    %edi,%edx
  80381f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803823:	89 34 24             	mov    %esi,(%esp)
  803826:	85 c0                	test   %eax,%eax
  803828:	75 1a                	jne    803844 <__umoddi3+0x48>
  80382a:	39 f7                	cmp    %esi,%edi
  80382c:	0f 86 a2 00 00 00    	jbe    8038d4 <__umoddi3+0xd8>
  803832:	89 c8                	mov    %ecx,%eax
  803834:	89 f2                	mov    %esi,%edx
  803836:	f7 f7                	div    %edi
  803838:	89 d0                	mov    %edx,%eax
  80383a:	31 d2                	xor    %edx,%edx
  80383c:	83 c4 1c             	add    $0x1c,%esp
  80383f:	5b                   	pop    %ebx
  803840:	5e                   	pop    %esi
  803841:	5f                   	pop    %edi
  803842:	5d                   	pop    %ebp
  803843:	c3                   	ret    
  803844:	39 f0                	cmp    %esi,%eax
  803846:	0f 87 ac 00 00 00    	ja     8038f8 <__umoddi3+0xfc>
  80384c:	0f bd e8             	bsr    %eax,%ebp
  80384f:	83 f5 1f             	xor    $0x1f,%ebp
  803852:	0f 84 ac 00 00 00    	je     803904 <__umoddi3+0x108>
  803858:	bf 20 00 00 00       	mov    $0x20,%edi
  80385d:	29 ef                	sub    %ebp,%edi
  80385f:	89 fe                	mov    %edi,%esi
  803861:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803865:	89 e9                	mov    %ebp,%ecx
  803867:	d3 e0                	shl    %cl,%eax
  803869:	89 d7                	mov    %edx,%edi
  80386b:	89 f1                	mov    %esi,%ecx
  80386d:	d3 ef                	shr    %cl,%edi
  80386f:	09 c7                	or     %eax,%edi
  803871:	89 e9                	mov    %ebp,%ecx
  803873:	d3 e2                	shl    %cl,%edx
  803875:	89 14 24             	mov    %edx,(%esp)
  803878:	89 d8                	mov    %ebx,%eax
  80387a:	d3 e0                	shl    %cl,%eax
  80387c:	89 c2                	mov    %eax,%edx
  80387e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803882:	d3 e0                	shl    %cl,%eax
  803884:	89 44 24 04          	mov    %eax,0x4(%esp)
  803888:	8b 44 24 08          	mov    0x8(%esp),%eax
  80388c:	89 f1                	mov    %esi,%ecx
  80388e:	d3 e8                	shr    %cl,%eax
  803890:	09 d0                	or     %edx,%eax
  803892:	d3 eb                	shr    %cl,%ebx
  803894:	89 da                	mov    %ebx,%edx
  803896:	f7 f7                	div    %edi
  803898:	89 d3                	mov    %edx,%ebx
  80389a:	f7 24 24             	mull   (%esp)
  80389d:	89 c6                	mov    %eax,%esi
  80389f:	89 d1                	mov    %edx,%ecx
  8038a1:	39 d3                	cmp    %edx,%ebx
  8038a3:	0f 82 87 00 00 00    	jb     803930 <__umoddi3+0x134>
  8038a9:	0f 84 91 00 00 00    	je     803940 <__umoddi3+0x144>
  8038af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038b3:	29 f2                	sub    %esi,%edx
  8038b5:	19 cb                	sbb    %ecx,%ebx
  8038b7:	89 d8                	mov    %ebx,%eax
  8038b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038bd:	d3 e0                	shl    %cl,%eax
  8038bf:	89 e9                	mov    %ebp,%ecx
  8038c1:	d3 ea                	shr    %cl,%edx
  8038c3:	09 d0                	or     %edx,%eax
  8038c5:	89 e9                	mov    %ebp,%ecx
  8038c7:	d3 eb                	shr    %cl,%ebx
  8038c9:	89 da                	mov    %ebx,%edx
  8038cb:	83 c4 1c             	add    $0x1c,%esp
  8038ce:	5b                   	pop    %ebx
  8038cf:	5e                   	pop    %esi
  8038d0:	5f                   	pop    %edi
  8038d1:	5d                   	pop    %ebp
  8038d2:	c3                   	ret    
  8038d3:	90                   	nop
  8038d4:	89 fd                	mov    %edi,%ebp
  8038d6:	85 ff                	test   %edi,%edi
  8038d8:	75 0b                	jne    8038e5 <__umoddi3+0xe9>
  8038da:	b8 01 00 00 00       	mov    $0x1,%eax
  8038df:	31 d2                	xor    %edx,%edx
  8038e1:	f7 f7                	div    %edi
  8038e3:	89 c5                	mov    %eax,%ebp
  8038e5:	89 f0                	mov    %esi,%eax
  8038e7:	31 d2                	xor    %edx,%edx
  8038e9:	f7 f5                	div    %ebp
  8038eb:	89 c8                	mov    %ecx,%eax
  8038ed:	f7 f5                	div    %ebp
  8038ef:	89 d0                	mov    %edx,%eax
  8038f1:	e9 44 ff ff ff       	jmp    80383a <__umoddi3+0x3e>
  8038f6:	66 90                	xchg   %ax,%ax
  8038f8:	89 c8                	mov    %ecx,%eax
  8038fa:	89 f2                	mov    %esi,%edx
  8038fc:	83 c4 1c             	add    $0x1c,%esp
  8038ff:	5b                   	pop    %ebx
  803900:	5e                   	pop    %esi
  803901:	5f                   	pop    %edi
  803902:	5d                   	pop    %ebp
  803903:	c3                   	ret    
  803904:	3b 04 24             	cmp    (%esp),%eax
  803907:	72 06                	jb     80390f <__umoddi3+0x113>
  803909:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80390d:	77 0f                	ja     80391e <__umoddi3+0x122>
  80390f:	89 f2                	mov    %esi,%edx
  803911:	29 f9                	sub    %edi,%ecx
  803913:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803917:	89 14 24             	mov    %edx,(%esp)
  80391a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80391e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803922:	8b 14 24             	mov    (%esp),%edx
  803925:	83 c4 1c             	add    $0x1c,%esp
  803928:	5b                   	pop    %ebx
  803929:	5e                   	pop    %esi
  80392a:	5f                   	pop    %edi
  80392b:	5d                   	pop    %ebp
  80392c:	c3                   	ret    
  80392d:	8d 76 00             	lea    0x0(%esi),%esi
  803930:	2b 04 24             	sub    (%esp),%eax
  803933:	19 fa                	sbb    %edi,%edx
  803935:	89 d1                	mov    %edx,%ecx
  803937:	89 c6                	mov    %eax,%esi
  803939:	e9 71 ff ff ff       	jmp    8038af <__umoddi3+0xb3>
  80393e:	66 90                	xchg   %ax,%ax
  803940:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803944:	72 ea                	jb     803930 <__umoddi3+0x134>
  803946:	89 d9                	mov    %ebx,%ecx
  803948:	e9 62 ff ff ff       	jmp    8038af <__umoddi3+0xb3>
