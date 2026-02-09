
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 9c 02 00 00       	call   8002d2 <libmain>
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
	// Testing scenario 4: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 a0 38 80 00       	push   $0x8038a0
  800050:	e8 06 20 00 00       	call   80205b <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb a1 3a 80 00       	mov    $0x803aa1,%ebx
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
  8000a1:	e8 d5 27 00 00       	call   80287b <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 ce 23 00 00       	call   80247c <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 11 24 00 00       	call   8024c7 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 b0 38 80 00       	push   $0x8038b0
  8000c4:	e8 a7 06 00 00       	call   800770 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d1:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 e3 38 80 00       	push   $0x8038e3
  8000ed:	e8 e5 24 00 00       	call   8025d7 <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fd:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 ec 38 80 00       	push   $0x8038ec
  800119:	e8 b9 24 00 00       	call   8025d7 <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 c6 24 00 00       	call   8025f5 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  800132:	90                   	nop
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 01             	cmp    $0x1,%eax
  80013b:	75 f6                	jne    800133 <_main+0xfb>

	sys_run_env(envIdProcessB);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 d4             	pushl  -0x2c(%ebp)
  800143:	e8 ad 24 00 00       	call   8025f5 <sys_run_env>
  800148:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80014b:	90                   	nop
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	8b 00                	mov    (%eax),%eax
  800151:	83 f8 02             	cmp    $0x2,%eax
  800154:	75 f6                	jne    80014c <_main+0x114>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800156:	e8 21 23 00 00       	call   80247c <sys_calculate_free_frames>
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	50                   	push   %eax
  80015f:	68 f8 38 80 00       	push   $0x8038f8
  800164:	e8 07 06 00 00       	call   800770 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80016c:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 f9 26 00 00       	call   80287b <sys_utilities>
  800182:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800185:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80018b:	bb 05 3b 80 00       	mov    $0x803b05,%ebx
  800190:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80019d:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a3:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001a8:	b0 00                	mov    $0x0,%al
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 bc 26 00 00       	call   80287b <sys_utilities>
  8001bf:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c8:	e8 44 24 00 00       	call   802611 <sys_destroy_env>
  8001cd:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d6:	e8 36 24 00 00       	call   802611 <sys_destroy_env>
  8001db:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	6a 01                	push   $0x1
  8001e3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	e8 8c 26 00 00       	call   80287b <sys_utilities>
  8001ef:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f2:	e8 85 22 00 00       	call   80247c <sys_calculate_free_frames>
  8001f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 c8 22 00 00       	call   8024c7 <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800202:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800209:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 d0                	add    %edx,%eax
  800214:	48                   	dec    %eax
  800215:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800218:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	f7 75 c8             	divl   -0x38(%ebp)
  800223:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800226:	29 d0                	sub    %edx,%eax
  800228:	89 c1                	mov    %eax,%ecx
  80022a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800231:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800237:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	48                   	dec    %eax
  80023d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800240:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 75 c0             	divl   -0x40(%ebp)
  80024b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024e:	29 d0                	sub    %edx,%eax
  800250:	29 c1                	sub    %eax,%ecx
  800252:	89 c8                	mov    %ecx,%eax
  800254:	c1 e8 0c             	shr    $0xc,%eax
  800257:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	68 2a 39 80 00       	push   $0x80392a
  800265:	e8 06 05 00 00       	call   800770 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800273:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800276:	74 2e                	je     8002a6 <_main+0x26e>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800278:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80027b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	50                   	push   %eax
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	68 3c 39 80 00       	push   $0x80393c
  80028a:	e8 e1 04 00 00       	call   800770 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 ac 39 80 00       	push   $0x8039ac
  80029a:	6a 38                	push   $0x38
  80029c:	68 e2 39 80 00       	push   $0x8039e2
  8002a1:	e8 dc 01 00 00       	call   800482 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ac:	68 f8 39 80 00       	push   $0x8039f8
  8002b1:	e8 ba 04 00 00       	call   800770 <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	68 58 3a 80 00       	push   $0x803a58
  8002c1:	e8 aa 04 00 00       	call   800770 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	return;
  8002c9:	90                   	nop
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002db:	e8 65 23 00 00       	call   802645 <sys_getenvindex>
  8002e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e6:	89 d0                	mov    %edx,%eax
  8002e8:	01 c0                	add    %eax,%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	c1 e0 02             	shl    $0x2,%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 d0                	add    %edx,%eax
  8002f6:	c1 e0 03             	shl    $0x3,%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	c1 e0 02             	shl    $0x2,%eax
  8002fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800303:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800308:	a1 20 50 80 00       	mov    0x805020,%eax
  80030d:	8a 40 20             	mov    0x20(%eax),%al
  800310:	84 c0                	test   %al,%al
  800312:	74 0d                	je     800321 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800314:	a1 20 50 80 00       	mov    0x805020,%eax
  800319:	83 c0 20             	add    $0x20,%eax
  80031c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800325:	7e 0a                	jle    800331 <libmain+0x5f>
		binaryname = argv[0];
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	ff 75 0c             	pushl  0xc(%ebp)
  800337:	ff 75 08             	pushl  0x8(%ebp)
  80033a:	e8 f9 fc ff ff       	call   800038 <_main>
  80033f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800342:	a1 00 50 80 00       	mov    0x805000,%eax
  800347:	85 c0                	test   %eax,%eax
  800349:	0f 84 01 01 00 00    	je     800450 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800355:	bb 64 3c 80 00       	mov    $0x803c64,%ebx
  80035a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800367:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036f:	b0 00                	mov    $0x0,%al
  800371:	89 d7                	mov    %edx,%edi
  800373:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800375:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80037c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	50                   	push   %eax
  800383:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800389:	50                   	push   %eax
  80038a:	e8 ec 24 00 00       	call   80287b <sys_utilities>
  80038f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800392:	e8 35 20 00 00       	call   8023cc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800397:	83 ec 0c             	sub    $0xc,%esp
  80039a:	68 84 3b 80 00       	push   $0x803b84
  80039f:	e8 cc 03 00 00       	call   800770 <cprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	74 18                	je     8003c6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ae:	e8 e6 24 00 00       	call   802899 <sys_get_optimal_num_faults>
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	50                   	push   %eax
  8003b7:	68 ac 3b 80 00       	push   $0x803bac
  8003bc:	e8 af 03 00 00       	call   800770 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	eb 59                	jmp    80041f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003cb:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d6:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	52                   	push   %edx
  8003e0:	50                   	push   %eax
  8003e1:	68 d0 3b 80 00       	push   $0x803bd0
  8003e6:	e8 85 03 00 00       	call   800770 <cprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f3:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fe:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800404:	a1 20 50 80 00       	mov    0x805020,%eax
  800409:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80040f:	51                   	push   %ecx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	68 f8 3b 80 00       	push   $0x803bf8
  800417:	e8 54 03 00 00       	call   800770 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041f:	a1 20 50 80 00       	mov    0x805020,%eax
  800424:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	50                   	push   %eax
  80042e:	68 50 3c 80 00       	push   $0x803c50
  800433:	e8 38 03 00 00       	call   800770 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	68 84 3b 80 00       	push   $0x803b84
  800443:	e8 28 03 00 00       	call   800770 <cprintf>
  800448:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80044b:	e8 96 1f 00 00       	call   8023e6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800450:	e8 1f 00 00 00       	call   800474 <exit>
}
  800455:	90                   	nop
  800456:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800459:	5b                   	pop    %ebx
  80045a:	5e                   	pop    %esi
  80045b:	5f                   	pop    %edi
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    

0080045e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	6a 00                	push   $0x0
  800469:	e8 a3 21 00 00       	call   802611 <sys_destroy_env>
  80046e:	83 c4 10             	add    $0x10,%esp
}
  800471:	90                   	nop
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <exit>:

void
exit(void)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047a:	e8 f8 21 00 00       	call   802677 <sys_exit_env>
}
  80047f:	90                   	nop
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800488:	8d 45 10             	lea    0x10(%ebp),%eax
  80048b:	83 c0 04             	add    $0x4,%eax
  80048e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800491:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	74 16                	je     8004b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049a:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	50                   	push   %eax
  8004a3:	68 c8 3c 80 00       	push   $0x803cc8
  8004a8:	e8 c3 02 00 00       	call   800770 <cprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b0:	a1 04 50 80 00       	mov    0x805004,%eax
  8004b5:	83 ec 0c             	sub    $0xc,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	ff 75 08             	pushl  0x8(%ebp)
  8004be:	50                   	push   %eax
  8004bf:	68 d0 3c 80 00       	push   $0x803cd0
  8004c4:	6a 74                	push   $0x74
  8004c6:	e8 d2 02 00 00       	call   80079d <cprintf_colored>
  8004cb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	e8 24 02 00 00       	call   800701 <vcprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	6a 00                	push   $0x0
  8004e5:	68 f8 3c 80 00       	push   $0x803cf8
  8004ea:	e8 12 02 00 00       	call   800701 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f2:	e8 7d ff ff ff       	call   800474 <exit>

	// should not return here
	while (1) ;
  8004f7:	eb fe                	jmp    8004f7 <_panic+0x75>

008004f9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	53                   	push   %ebx
  8004fd:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800500:	a1 20 50 80 00       	mov    0x805020,%eax
  800505:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050e:	39 c2                	cmp    %eax,%edx
  800510:	74 14                	je     800526 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 fc 3c 80 00       	push   $0x803cfc
  80051a:	6a 26                	push   $0x26
  80051c:	68 48 3d 80 00       	push   $0x803d48
  800521:	e8 5c ff ff ff       	call   800482 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80052d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800534:	e9 d9 00 00 00       	jmp    800612 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	01 d0                	add    %edx,%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	85 c0                	test   %eax,%eax
  80054c:	75 08                	jne    800556 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80054e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800551:	e9 b9 00 00 00       	jmp    80060f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800556:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800564:	eb 79                	jmp    8005df <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800566:	a1 20 50 80 00       	mov    0x805020,%eax
  80056b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800571:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800574:	89 d0                	mov    %edx,%eax
  800576:	01 c0                	add    %eax,%eax
  800578:	01 d0                	add    %edx,%eax
  80057a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800581:	01 d8                	add    %ebx,%eax
  800583:	01 d0                	add    %edx,%eax
  800585:	01 c8                	add    %ecx,%eax
  800587:	8a 40 04             	mov    0x4(%eax),%al
  80058a:	84 c0                	test   %al,%al
  80058c:	75 4e                	jne    8005dc <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058e:	a1 20 50 80 00       	mov    0x805020,%eax
  800593:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800599:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80059c:	89 d0                	mov    %edx,%eax
  80059e:	01 c0                	add    %eax,%eax
  8005a0:	01 d0                	add    %edx,%eax
  8005a2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005a9:	01 d8                	add    %ebx,%eax
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cf:	39 c2                	cmp    %eax,%edx
  8005d1:	75 09                	jne    8005dc <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005da:	eb 19                	jmp    8005f5 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005dc:	ff 45 e8             	incl   -0x18(%ebp)
  8005df:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ed:	39 c2                	cmp    %eax,%edx
  8005ef:	0f 87 71 ff ff ff    	ja     800566 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f9:	75 14                	jne    80060f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 54 3d 80 00       	push   $0x803d54
  800603:	6a 3a                	push   $0x3a
  800605:	68 48 3d 80 00       	push   $0x803d48
  80060a:	e8 73 fe ff ff       	call   800482 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060f:	ff 45 f0             	incl   -0x10(%ebp)
  800612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800615:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800618:	0f 8c 1b ff ff ff    	jl     800539 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800625:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80062c:	eb 2e                	jmp    80065c <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062e:	a1 20 50 80 00       	mov    0x805020,%eax
  800633:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063c:	89 d0                	mov    %edx,%eax
  80063e:	01 c0                	add    %eax,%eax
  800640:	01 d0                	add    %edx,%eax
  800642:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800649:	01 d8                	add    %ebx,%eax
  80064b:	01 d0                	add    %edx,%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8a 40 04             	mov    0x4(%eax),%al
  800652:	3c 01                	cmp    $0x1,%al
  800654:	75 03                	jne    800659 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800656:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	ff 45 e0             	incl   -0x20(%ebp)
  80065c:	a1 20 50 80 00       	mov    0x805020,%eax
  800661:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066a:	39 c2                	cmp    %eax,%edx
  80066c:	77 c0                	ja     80062e <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800671:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800674:	74 14                	je     80068a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800676:	83 ec 04             	sub    $0x4,%esp
  800679:	68 a8 3d 80 00       	push   $0x803da8
  80067e:	6a 44                	push   $0x44
  800680:	68 48 3d 80 00       	push   $0x803d48
  800685:	e8 f8 fd ff ff       	call   800482 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80068a:	90                   	nop
  80068b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80068e:	c9                   	leave  
  80068f:	c3                   	ret    

00800690 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800690:	55                   	push   %ebp
  800691:	89 e5                	mov    %esp,%ebp
  800693:	53                   	push   %ebx
  800694:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	8d 48 01             	lea    0x1(%eax),%ecx
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	89 0a                	mov    %ecx,(%edx)
  8006a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a7:	88 d1                	mov    %dl,%cl
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ba:	75 30                	jne    8006ec <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006bc:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006c2:	a0 44 50 80 00       	mov    0x805044,%al
  8006c7:	0f b6 c0             	movzbl %al,%eax
  8006ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006cd:	8b 09                	mov    (%ecx),%ecx
  8006cf:	89 cb                	mov    %ecx,%ebx
  8006d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d4:	83 c1 08             	add    $0x8,%ecx
  8006d7:	52                   	push   %edx
  8006d8:	50                   	push   %eax
  8006d9:	53                   	push   %ebx
  8006da:	51                   	push   %ecx
  8006db:	e8 a8 1c 00 00       	call   802388 <sys_cputs>
  8006e0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ef:	8b 40 04             	mov    0x4(%eax),%eax
  8006f2:	8d 50 01             	lea    0x1(%eax),%edx
  8006f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006fb:	90                   	nop
  8006fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    

00800701 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800711:	00 00 00 
	b.cnt = 0;
  800714:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072a:	50                   	push   %eax
  80072b:	68 90 06 80 00       	push   $0x800690
  800730:	e8 5a 02 00 00       	call   80098f <vprintfmt>
  800735:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800738:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80073e:	a0 44 50 80 00       	mov    0x805044,%al
  800743:	0f b6 c0             	movzbl %al,%eax
  800746:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80074c:	52                   	push   %edx
  80074d:	50                   	push   %eax
  80074e:	51                   	push   %ecx
  80074f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800755:	83 c0 08             	add    $0x8,%eax
  800758:	50                   	push   %eax
  800759:	e8 2a 1c 00 00       	call   802388 <sys_cputs>
  80075e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800761:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800768:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    

00800770 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800776:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  80077d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800780:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	ff 75 f4             	pushl  -0xc(%ebp)
  80078c:	50                   	push   %eax
  80078d:	e8 6f ff ff ff       	call   800701 <vcprintf>
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800798:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a3:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	c1 e0 08             	shl    $0x8,%eax
  8007b0:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8007b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b8:	83 c0 04             	add    $0x4,%eax
  8007bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	e8 34 ff ff ff       	call   800701 <vcprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007d3:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007da:	07 00 00 

	return cnt;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    

008007e2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e8:	e8 df 1b 00 00       	call   8023cc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fc:	50                   	push   %eax
  8007fd:	e8 ff fe ff ff       	call   800701 <vcprintf>
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800808:	e8 d9 1b 00 00       	call   8023e6 <sys_unlock_cons>
	return cnt;
  80080d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	83 ec 14             	sub    $0x14,%esp
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800825:	8b 45 18             	mov    0x18(%ebp),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
  80082d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800830:	77 55                	ja     800887 <printnum+0x75>
  800832:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800835:	72 05                	jb     80083c <printnum+0x2a>
  800837:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083a:	77 4b                	ja     800887 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80083c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800842:	8b 45 18             	mov    0x18(%ebp),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
  80084a:	52                   	push   %edx
  80084b:	50                   	push   %eax
  80084c:	ff 75 f4             	pushl  -0xc(%ebp)
  80084f:	ff 75 f0             	pushl  -0x10(%ebp)
  800852:	e8 d5 2d 00 00       	call   80362c <__udivdi3>
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	83 ec 04             	sub    $0x4,%esp
  80085d:	ff 75 20             	pushl  0x20(%ebp)
  800860:	53                   	push   %ebx
  800861:	ff 75 18             	pushl  0x18(%ebp)
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	ff 75 08             	pushl  0x8(%ebp)
  80086c:	e8 a1 ff ff ff       	call   800812 <printnum>
  800871:	83 c4 20             	add    $0x20,%esp
  800874:	eb 1a                	jmp    800890 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	ff 75 20             	pushl  0x20(%ebp)
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800887:	ff 4d 1c             	decl   0x1c(%ebp)
  80088a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80088e:	7f e6                	jg     800876 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800890:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800893:	bb 00 00 00 00       	mov    $0x0,%ebx
  800898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089e:	53                   	push   %ebx
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	e8 95 2e 00 00       	call   80373c <__umoddi3>
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	05 14 40 80 00       	add    $0x804014,%eax
  8008af:	8a 00                	mov    (%eax),%al
  8008b1:	0f be c0             	movsbl %al,%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
}
  8008c3:	90                   	nop
  8008c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d0:	7e 1c                	jle    8008ee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 08             	lea    0x8(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 08             	sub    $0x8,%eax
  8008e7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	eb 40                	jmp    80092e <getuint+0x65>
	else if (lflag)
  8008ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f2:	74 1e                	je     800912 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 50 04             	lea    0x4(%eax),%edx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 10                	mov    %edx,(%eax)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	83 e8 04             	sub    $0x4,%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	ba 00 00 00 00       	mov    $0x0,%edx
  800910:	eb 1c                	jmp    80092e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	8d 50 04             	lea    0x4(%eax),%edx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	89 10                	mov    %edx,(%eax)
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	83 e8 04             	sub    $0x4,%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800933:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800937:	7e 1c                	jle    800955 <getint+0x25>
		return va_arg(*ap, long long);
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	8d 50 08             	lea    0x8(%eax),%edx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 10                	mov    %edx,(%eax)
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	83 e8 08             	sub    $0x8,%eax
  80094e:	8b 50 04             	mov    0x4(%eax),%edx
  800951:	8b 00                	mov    (%eax),%eax
  800953:	eb 38                	jmp    80098d <getint+0x5d>
	else if (lflag)
  800955:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800959:	74 1a                	je     800975 <getint+0x45>
		return va_arg(*ap, long);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	99                   	cltd   
  800973:	eb 18                	jmp    80098d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	8d 50 04             	lea    0x4(%eax),%edx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	89 10                	mov    %edx,(%eax)
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	83 e8 04             	sub    $0x4,%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	99                   	cltd   
}
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	56                   	push   %esi
  800993:	53                   	push   %ebx
  800994:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800997:	eb 17                	jmp    8009b0 <vprintfmt+0x21>
			if (ch == '\0')
  800999:	85 db                	test   %ebx,%ebx
  80099b:	0f 84 c1 03 00 00    	je     800d62 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	0f b6 d8             	movzbl %al,%ebx
  8009be:	83 fb 25             	cmp    $0x25,%ebx
  8009c1:	75 d6                	jne    800999 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e6:	8d 50 01             	lea    0x1(%eax),%edx
  8009e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ec:	8a 00                	mov    (%eax),%al
  8009ee:	0f b6 d8             	movzbl %al,%ebx
  8009f1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f4:	83 f8 5b             	cmp    $0x5b,%eax
  8009f7:	0f 87 3d 03 00 00    	ja     800d3a <vprintfmt+0x3ab>
  8009fd:	8b 04 85 38 40 80 00 	mov    0x804038(,%eax,4),%eax
  800a04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0a:	eb d7                	jmp    8009e3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a10:	eb d1                	jmp    8009e3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a1c:	89 d0                	mov    %edx,%eax
  800a1e:	c1 e0 02             	shl    $0x2,%eax
  800a21:	01 d0                	add    %edx,%eax
  800a23:	01 c0                	add    %eax,%eax
  800a25:	01 d8                	add    %ebx,%eax
  800a27:	83 e8 30             	sub    $0x30,%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a30:	8a 00                	mov    (%eax),%al
  800a32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a35:	83 fb 2f             	cmp    $0x2f,%ebx
  800a38:	7e 3e                	jle    800a78 <vprintfmt+0xe9>
  800a3a:	83 fb 39             	cmp    $0x39,%ebx
  800a3d:	7f 39                	jg     800a78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a42:	eb d5                	jmp    800a19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	83 c0 04             	add    $0x4,%eax
  800a4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	83 e8 04             	sub    $0x4,%eax
  800a53:	8b 00                	mov    (%eax),%eax
  800a55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a58:	eb 1f                	jmp    800a79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5e:	79 83                	jns    8009e3 <vprintfmt+0x54>
				width = 0;
  800a60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a67:	e9 77 ff ff ff       	jmp    8009e3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a73:	e9 6b ff ff ff       	jmp    8009e3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7d:	0f 89 60 ff ff ff    	jns    8009e3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a90:	e9 4e ff ff ff       	jmp    8009e3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a98:	e9 46 ff ff ff       	jmp    8009e3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	83 c0 04             	add    $0x4,%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	83 e8 04             	sub    $0x4,%eax
  800aac:	8b 00                	mov    (%eax),%eax
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
			break;
  800abd:	e9 9b 02 00 00       	jmp    800d5d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac5:	83 c0 04             	add    $0x4,%eax
  800ac8:	89 45 14             	mov    %eax,0x14(%ebp)
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 e8 04             	sub    $0x4,%eax
  800ad1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad3:	85 db                	test   %ebx,%ebx
  800ad5:	79 02                	jns    800ad9 <vprintfmt+0x14a>
				err = -err;
  800ad7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad9:	83 fb 64             	cmp    $0x64,%ebx
  800adc:	7f 0b                	jg     800ae9 <vprintfmt+0x15a>
  800ade:	8b 34 9d 80 3e 80 00 	mov    0x803e80(,%ebx,4),%esi
  800ae5:	85 f6                	test   %esi,%esi
  800ae7:	75 19                	jne    800b02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae9:	53                   	push   %ebx
  800aea:	68 25 40 80 00       	push   $0x804025
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 70 02 00 00       	call   800d6a <printfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800afd:	e9 5b 02 00 00       	jmp    800d5d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b02:	56                   	push   %esi
  800b03:	68 2e 40 80 00       	push   $0x80402e
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 57 02 00 00       	call   800d6a <printfmt>
  800b13:	83 c4 10             	add    $0x10,%esp
			break;
  800b16:	e9 42 02 00 00       	jmp    800d5d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1e:	83 c0 04             	add    $0x4,%eax
  800b21:	89 45 14             	mov    %eax,0x14(%ebp)
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	83 e8 04             	sub    $0x4,%eax
  800b2a:	8b 30                	mov    (%eax),%esi
  800b2c:	85 f6                	test   %esi,%esi
  800b2e:	75 05                	jne    800b35 <vprintfmt+0x1a6>
				p = "(null)";
  800b30:	be 31 40 80 00       	mov    $0x804031,%esi
			if (width > 0 && padc != '-')
  800b35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b39:	7e 6d                	jle    800ba8 <vprintfmt+0x219>
  800b3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3f:	74 67                	je     800ba8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	50                   	push   %eax
  800b48:	56                   	push   %esi
  800b49:	e8 1e 03 00 00       	call   800e6c <strnlen>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b54:	eb 16                	jmp    800b6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	50                   	push   %eax
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b69:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b70:	7f e4                	jg     800b56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b72:	eb 34                	jmp    800ba8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b78:	74 1c                	je     800b96 <vprintfmt+0x207>
  800b7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b7d:	7e 05                	jle    800b84 <vprintfmt+0x1f5>
  800b7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b82:	7e 12                	jle    800b96 <vprintfmt+0x207>
					putch('?', putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	6a 3f                	push   $0x3f
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	eb 0f                	jmp    800ba5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	53                   	push   %ebx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba8:	89 f0                	mov    %esi,%eax
  800baa:	8d 70 01             	lea    0x1(%eax),%esi
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	0f be d8             	movsbl %al,%ebx
  800bb2:	85 db                	test   %ebx,%ebx
  800bb4:	74 24                	je     800bda <vprintfmt+0x24b>
  800bb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bba:	78 b8                	js     800b74 <vprintfmt+0x1e5>
  800bbc:	ff 4d e0             	decl   -0x20(%ebp)
  800bbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc3:	79 af                	jns    800b74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc5:	eb 13                	jmp    800bda <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 20                	push   $0x20
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bde:	7f e7                	jg     800bc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be0:	e9 78 01 00 00       	jmp    800d5d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 e8             	pushl  -0x18(%ebp)
  800beb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bee:	50                   	push   %eax
  800bef:	e8 3c fd ff ff       	call   800930 <getint>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c03:	85 d2                	test   %edx,%edx
  800c05:	79 23                	jns    800c2a <vprintfmt+0x29b>
				putch('-', putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	6a 2d                	push   $0x2d
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1d:	f7 d8                	neg    %eax
  800c1f:	83 d2 00             	adc    $0x0,%edx
  800c22:	f7 da                	neg    %edx
  800c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c27:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c31:	e9 bc 00 00 00       	jmp    800cf2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3f:	50                   	push   %eax
  800c40:	e8 84 fc ff ff       	call   8008c9 <getuint>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c55:	e9 98 00 00 00       	jmp    800cf2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 58                	push   $0x58
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 0c             	pushl  0xc(%ebp)
  800c70:	6a 58                	push   $0x58
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	6a 58                	push   $0x58
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	ff d0                	call   *%eax
  800c87:	83 c4 10             	add    $0x10,%esp
			break;
  800c8a:	e9 ce 00 00 00       	jmp    800d5d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	6a 30                	push   $0x30
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	ff d0                	call   *%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	6a 78                	push   $0x78
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800caf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb2:	83 c0 04             	add    $0x4,%eax
  800cb5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbb:	83 e8 04             	sub    $0x4,%eax
  800cbe:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd1:	eb 1f                	jmp    800cf2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd9:	8d 45 14             	lea    0x14(%ebp),%eax
  800cdc:	50                   	push   %eax
  800cdd:	e8 e7 fb ff ff       	call   8008c9 <getuint>
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ceb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf9:	83 ec 04             	sub    $0x4,%esp
  800cfc:	52                   	push   %edx
  800cfd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d00:	50                   	push   %eax
  800d01:	ff 75 f4             	pushl  -0xc(%ebp)
  800d04:	ff 75 f0             	pushl  -0x10(%ebp)
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 00 fb ff ff       	call   800812 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
			break;
  800d15:	eb 46                	jmp    800d5d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	53                   	push   %ebx
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	ff d0                	call   *%eax
  800d23:	83 c4 10             	add    $0x10,%esp
			break;
  800d26:	eb 35                	jmp    800d5d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d28:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d2f:	eb 2c                	jmp    800d5d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d31:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d38:	eb 23                	jmp    800d5d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	6a 25                	push   $0x25
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	ff d0                	call   *%eax
  800d47:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4a:	ff 4d 10             	decl   0x10(%ebp)
  800d4d:	eb 03                	jmp    800d52 <vprintfmt+0x3c3>
  800d4f:	ff 4d 10             	decl   0x10(%ebp)
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	48                   	dec    %eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	3c 25                	cmp    $0x25,%al
  800d5a:	75 f3                	jne    800d4f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d5c:	90                   	nop
		}
	}
  800d5d:	e9 35 fc ff ff       	jmp    800997 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d62:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d70:	8d 45 10             	lea    0x10(%ebp),%eax
  800d73:	83 c0 04             	add    $0x4,%eax
  800d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7f:	50                   	push   %eax
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 08             	pushl  0x8(%ebp)
  800d86:	e8 04 fc ff ff       	call   80098f <vprintfmt>
  800d8b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d8e:	90                   	nop
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8b 40 08             	mov    0x8(%eax),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8b 10                	mov    (%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 40 04             	mov    0x4(%eax),%eax
  800dae:	39 c2                	cmp    %eax,%edx
  800db0:	73 12                	jae    800dc4 <sprintputch+0x33>
		*b->buf++ = ch;
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	8d 48 01             	lea    0x1(%eax),%ecx
  800dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbd:	89 0a                	mov    %ecx,(%edx)
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	88 10                	mov    %dl,(%eax)
}
  800dc4:	90                   	nop
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	01 d0                	add    %edx,%eax
  800dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dec:	74 06                	je     800df4 <vsnprintf+0x2d>
  800dee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df2:	7f 07                	jg     800dfb <vsnprintf+0x34>
		return -E_INVAL;
  800df4:	b8 03 00 00 00       	mov    $0x3,%eax
  800df9:	eb 20                	jmp    800e1b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dfb:	ff 75 14             	pushl  0x14(%ebp)
  800dfe:	ff 75 10             	pushl  0x10(%ebp)
  800e01:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e04:	50                   	push   %eax
  800e05:	68 91 0d 80 00       	push   $0x800d91
  800e0a:	e8 80 fb ff ff       	call   80098f <vprintfmt>
  800e0f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e15:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e23:	8d 45 10             	lea    0x10(%ebp),%eax
  800e26:	83 c0 04             	add    $0x4,%eax
  800e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e32:	50                   	push   %eax
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	ff 75 08             	pushl  0x8(%ebp)
  800e39:	e8 89 ff ff ff       	call   800dc7 <vsnprintf>
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e56:	eb 06                	jmp    800e5e <strlen+0x15>
		n++;
  800e58:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5b:	ff 45 08             	incl   0x8(%ebp)
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	84 c0                	test   %al,%al
  800e65:	75 f1                	jne    800e58 <strlen+0xf>
		n++;
	return n;
  800e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e79:	eb 09                	jmp    800e84 <strnlen+0x18>
		n++;
  800e7b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 4d 0c             	decl   0xc(%ebp)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 09                	je     800e93 <strnlen+0x27>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	75 e8                	jne    800e7b <strnlen+0xf>
		n++;
	return n;
  800e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    

00800e98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea4:	90                   	nop
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8d 50 01             	lea    0x1(%eax),%edx
  800eab:	89 55 08             	mov    %edx,0x8(%ebp)
  800eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb7:	8a 12                	mov    (%edx),%dl
  800eb9:	88 10                	mov    %dl,(%eax)
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	84 c0                	test   %al,%al
  800ebf:	75 e4                	jne    800ea5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed9:	eb 1f                	jmp    800efa <strncpy+0x34>
		*dst++ = *src;
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8d 50 01             	lea    0x1(%eax),%edx
  800ee1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee7:	8a 12                	mov    (%edx),%dl
  800ee9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	74 03                	je     800ef7 <strncpy+0x31>
			src++;
  800ef4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef7:	ff 45 fc             	incl   -0x4(%ebp)
  800efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f00:	72 d9                	jb     800edb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 30                	je     800f49 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f19:	eb 16                	jmp    800f31 <strlcpy+0x2a>
			*dst++ = *src++;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8d 50 01             	lea    0x1(%eax),%edx
  800f21:	89 55 08             	mov    %edx,0x8(%ebp)
  800f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2d:	8a 12                	mov    (%edx),%dl
  800f2f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f31:	ff 4d 10             	decl   0x10(%ebp)
  800f34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f38:	74 09                	je     800f43 <strlcpy+0x3c>
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	84 c0                	test   %al,%al
  800f41:	75 d8                	jne    800f1b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4f:	29 c2                	sub    %eax,%edx
  800f51:	89 d0                	mov    %edx,%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f58:	eb 06                	jmp    800f60 <strcmp+0xb>
		p++, q++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	84 c0                	test   %al,%al
  800f67:	74 0e                	je     800f77 <strcmp+0x22>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 10                	mov    (%eax),%dl
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	38 c2                	cmp    %al,%dl
  800f75:	74 e3                	je     800f5a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	0f b6 d0             	movzbl %al,%edx
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	0f b6 c0             	movzbl %al,%eax
  800f87:	29 c2                	sub    %eax,%edx
  800f89:	89 d0                	mov    %edx,%eax
}
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f90:	eb 09                	jmp    800f9b <strncmp+0xe>
		n--, p++, q++;
  800f92:	ff 4d 10             	decl   0x10(%ebp)
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9f:	74 17                	je     800fb8 <strncmp+0x2b>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	84 c0                	test   %al,%al
  800fa8:	74 0e                	je     800fb8 <strncmp+0x2b>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 10                	mov    (%eax),%dl
  800faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	38 c2                	cmp    %al,%dl
  800fb6:	74 da                	je     800f92 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbc:	75 07                	jne    800fc5 <strncmp+0x38>
		return 0;
  800fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc3:	eb 14                	jmp    800fd9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f b6 d0             	movzbl %al,%edx
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	0f b6 c0             	movzbl %al,%eax
  800fd5:	29 c2                	sub    %eax,%edx
  800fd7:	89 d0                	mov    %edx,%eax
}
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 04             	sub    $0x4,%esp
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe7:	eb 12                	jmp    800ffb <strchr+0x20>
		if (*s == c)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff1:	75 05                	jne    800ff8 <strchr+0x1d>
			return (char *) s;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	eb 11                	jmp    801009 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	84 c0                	test   %al,%al
  801002:	75 e5                	jne    800fe9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 04             	sub    $0x4,%esp
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801017:	eb 0d                	jmp    801026 <strfind+0x1b>
		if (*s == c)
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801021:	74 0e                	je     801031 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801023:	ff 45 08             	incl   0x8(%ebp)
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	84 c0                	test   %al,%al
  80102d:	75 ea                	jne    801019 <strfind+0xe>
  80102f:	eb 01                	jmp    801032 <strfind+0x27>
		if (*s == c)
			break;
  801031:	90                   	nop
	return (char *) s;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801043:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801047:	76 63                	jbe    8010ac <memset+0x75>
		uint64 data_block = c;
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	99                   	cltd   
  80104d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801050:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801059:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80105d:	c1 e0 08             	shl    $0x8,%eax
  801060:	09 45 f0             	or     %eax,-0x10(%ebp)
  801063:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801070:	c1 e0 10             	shl    $0x10,%eax
  801073:	09 45 f0             	or     %eax,-0x10(%ebp)
  801076:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107f:	89 c2                	mov    %eax,%edx
  801081:	b8 00 00 00 00       	mov    $0x0,%eax
  801086:	09 45 f0             	or     %eax,-0x10(%ebp)
  801089:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80108c:	eb 18                	jmp    8010a6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80108e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801091:	8d 41 08             	lea    0x8(%ecx),%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109d:	89 01                	mov    %eax,(%ecx)
  80109f:	89 51 04             	mov    %edx,0x4(%ecx)
  8010a2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010aa:	77 e2                	ja     80108e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b0:	74 23                	je     8010d5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b8:	eb 0e                	jmp    8010c8 <memset+0x91>
			*p8++ = (uint8)c;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 e5                	jne    8010ba <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010ec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f0:	76 24                	jbe    801116 <memcpy+0x3c>
		while(n >= 8){
  8010f2:	eb 1c                	jmp    801110 <memcpy+0x36>
			*d64 = *s64;
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ff:	89 01                	mov    %eax,(%ecx)
  801101:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801104:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801108:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80110c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801110:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801114:	77 de                	ja     8010f4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111a:	74 31                	je     80114d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801122:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801125:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801128:	eb 16                	jmp    801140 <memcpy+0x66>
			*d8++ = *s8++;
  80112a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112d:	8d 50 01             	lea    0x1(%eax),%edx
  801130:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801136:	8d 4a 01             	lea    0x1(%edx),%ecx
  801139:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80113c:	8a 12                	mov    (%edx),%dl
  80113e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	8d 50 ff             	lea    -0x1(%eax),%edx
  801146:	89 55 10             	mov    %edx,0x10(%ebp)
  801149:	85 c0                	test   %eax,%eax
  80114b:	75 dd                	jne    80112a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801167:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80116a:	73 50                	jae    8011bc <memmove+0x6a>
  80116c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 d0                	add    %edx,%eax
  801174:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801177:	76 43                	jbe    8011bc <memmove+0x6a>
		s += n;
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801185:	eb 10                	jmp    801197 <memmove+0x45>
			*--d = *--s;
  801187:	ff 4d f8             	decl   -0x8(%ebp)
  80118a:	ff 4d fc             	decl   -0x4(%ebp)
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	8a 10                	mov    (%eax),%dl
  801192:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801195:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	75 e3                	jne    801187 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a4:	eb 23                	jmp    8011c9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b8:	8a 12                	mov    (%edx),%dl
  8011ba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	75 dd                	jne    8011a6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011e0:	eb 2a                	jmp    80120c <memcmp+0x3e>
		if (*s1 != *s2)
  8011e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e5:	8a 10                	mov    (%eax),%dl
  8011e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	38 c2                	cmp    %al,%dl
  8011ee:	74 16                	je     801206 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f b6 d0             	movzbl %al,%edx
  8011f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
  801204:	eb 18                	jmp    80121e <memcmp+0x50>
		s1++, s2++;
  801206:	ff 45 fc             	incl   -0x4(%ebp)
  801209:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801212:	89 55 10             	mov    %edx,0x10(%ebp)
  801215:	85 c0                	test   %eax,%eax
  801217:	75 c9                	jne    8011e2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 d0                	add    %edx,%eax
  80122e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801231:	eb 15                	jmp    801248 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f b6 d0             	movzbl %al,%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	0f b6 c0             	movzbl %al,%eax
  801241:	39 c2                	cmp    %eax,%edx
  801243:	74 0d                	je     801252 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801245:	ff 45 08             	incl   0x8(%ebp)
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80124e:	72 e3                	jb     801233 <memfind+0x13>
  801250:	eb 01                	jmp    801253 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801252:	90                   	nop
	return (void *) s;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80125e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801265:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126c:	eb 03                	jmp    801271 <strtol+0x19>
		s++;
  80126e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 20                	cmp    $0x20,%al
  801278:	74 f4                	je     80126e <strtol+0x16>
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 09                	cmp    $0x9,%al
  801281:	74 eb                	je     80126e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	3c 2b                	cmp    $0x2b,%al
  80128a:	75 05                	jne    801291 <strtol+0x39>
		s++;
  80128c:	ff 45 08             	incl   0x8(%ebp)
  80128f:	eb 13                	jmp    8012a4 <strtol+0x4c>
	else if (*s == '-')
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	3c 2d                	cmp    $0x2d,%al
  801298:	75 0a                	jne    8012a4 <strtol+0x4c>
		s++, neg = 1;
  80129a:	ff 45 08             	incl   0x8(%ebp)
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a8:	74 06                	je     8012b0 <strtol+0x58>
  8012aa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012ae:	75 20                	jne    8012d0 <strtol+0x78>
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 30                	cmp    $0x30,%al
  8012b7:	75 17                	jne    8012d0 <strtol+0x78>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	40                   	inc    %eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 78                	cmp    $0x78,%al
  8012c1:	75 0d                	jne    8012d0 <strtol+0x78>
		s += 2, base = 16;
  8012c3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ce:	eb 28                	jmp    8012f8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d4:	75 15                	jne    8012eb <strtol+0x93>
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 30                	cmp    $0x30,%al
  8012dd:	75 0c                	jne    8012eb <strtol+0x93>
		s++, base = 8;
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e9:	eb 0d                	jmp    8012f8 <strtol+0xa0>
	else if (base == 0)
  8012eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ef:	75 07                	jne    8012f8 <strtol+0xa0>
		base = 10;
  8012f1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 2f                	cmp    $0x2f,%al
  8012ff:	7e 19                	jle    80131a <strtol+0xc2>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 39                	cmp    $0x39,%al
  801308:	7f 10                	jg     80131a <strtol+0xc2>
			dig = *s - '0';
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	83 e8 30             	sub    $0x30,%eax
  801315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801318:	eb 42                	jmp    80135c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3c 60                	cmp    $0x60,%al
  801321:	7e 19                	jle    80133c <strtol+0xe4>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 7a                	cmp    $0x7a,%al
  80132a:	7f 10                	jg     80133c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	0f be c0             	movsbl %al,%eax
  801334:	83 e8 57             	sub    $0x57,%eax
  801337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133a:	eb 20                	jmp    80135c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	3c 40                	cmp    $0x40,%al
  801343:	7e 39                	jle    80137e <strtol+0x126>
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	3c 5a                	cmp    $0x5a,%al
  80134c:	7f 30                	jg     80137e <strtol+0x126>
			dig = *s - 'A' + 10;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	0f be c0             	movsbl %al,%eax
  801356:	83 e8 37             	sub    $0x37,%eax
  801359:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80135c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801362:	7d 19                	jge    80137d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80136e:	89 c2                	mov    %eax,%edx
  801370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801378:	e9 7b ff ff ff       	jmp    8012f8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80137d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80137e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801382:	74 08                	je     80138c <strtol+0x134>
		*endptr = (char *) s;
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	8b 55 08             	mov    0x8(%ebp),%edx
  80138a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80138c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801390:	74 07                	je     801399 <strtol+0x141>
  801392:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801395:	f7 d8                	neg    %eax
  801397:	eb 03                	jmp    80139c <strtol+0x144>
  801399:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <ltostr>:

void
ltostr(long value, char *str)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b6:	79 13                	jns    8013cb <ltostr+0x2d>
	{
		neg = 1;
  8013b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013d3:	99                   	cltd   
  8013d4:	f7 f9                	idiv   %ecx
  8013d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013dc:	8d 50 01             	lea    0x1(%eax),%edx
  8013df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e2:	89 c2                	mov    %eax,%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ec:	83 c2 30             	add    $0x30,%edx
  8013ef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f9:	f7 e9                	imul   %ecx
  8013fb:	c1 fa 02             	sar    $0x2,%edx
  8013fe:	89 c8                	mov    %ecx,%eax
  801400:	c1 f8 1f             	sar    $0x1f,%eax
  801403:	29 c2                	sub    %eax,%edx
  801405:	89 d0                	mov    %edx,%eax
  801407:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80140a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140e:	75 bb                	jne    8013cb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801410:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801417:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141a:	48                   	dec    %eax
  80141b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80141e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801422:	74 3d                	je     801461 <ltostr+0xc3>
		start = 1 ;
  801424:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80142b:	eb 34                	jmp    801461 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80142d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80143a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	01 c2                	add    %eax,%edx
  801442:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	01 c8                	add    %ecx,%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80144e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c2                	add    %eax,%edx
  801456:	8a 45 eb             	mov    -0x15(%ebp),%al
  801459:	88 02                	mov    %al,(%edx)
		start++ ;
  80145b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80145e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801467:	7c c4                	jl     80142d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801469:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80146c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146f:	01 d0                	add    %edx,%eax
  801471:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801474:	90                   	nop
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80147d:	ff 75 08             	pushl  0x8(%ebp)
  801480:	e8 c4 f9 ff ff       	call   800e49 <strlen>
  801485:	83 c4 04             	add    $0x4,%esp
  801488:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	e8 b6 f9 ff ff       	call   800e49 <strlen>
  801493:	83 c4 04             	add    $0x4,%esp
  801496:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801499:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a7:	eb 17                	jmp    8014c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	01 c2                	add    %eax,%edx
  8014b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	01 c8                	add    %ecx,%eax
  8014b9:	8a 00                	mov    (%eax),%al
  8014bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014bd:	ff 45 fc             	incl   -0x4(%ebp)
  8014c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c6:	7c e1                	jl     8014a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d6:	eb 1f                	jmp    8014f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014db:	8d 50 01             	lea    0x1(%eax),%edx
  8014de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014e1:	89 c2                	mov    %eax,%edx
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 c2                	add    %eax,%edx
  8014e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ee:	01 c8                	add    %ecx,%eax
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f4:	ff 45 f8             	incl   -0x8(%ebp)
  8014f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014fd:	7c d9                	jl     8014d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c6 00 00             	movb   $0x0,(%eax)
}
  80150a:	90                   	nop
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801510:	8b 45 14             	mov    0x14(%ebp),%eax
  801513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	01 d0                	add    %edx,%eax
  80152a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801530:	eb 0c                	jmp    80153e <strsplit+0x31>
			*string++ = 0;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8d 50 01             	lea    0x1(%eax),%edx
  801538:	89 55 08             	mov    %edx,0x8(%ebp)
  80153b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	84 c0                	test   %al,%al
  801545:	74 18                	je     80155f <strsplit+0x52>
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	0f be c0             	movsbl %al,%eax
  80154f:	50                   	push   %eax
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	e8 83 fa ff ff       	call   800fdb <strchr>
  801558:	83 c4 08             	add    $0x8,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	75 d3                	jne    801532 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8a 00                	mov    (%eax),%al
  801564:	84 c0                	test   %al,%al
  801566:	74 5a                	je     8015c2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801568:	8b 45 14             	mov    0x14(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	83 f8 0f             	cmp    $0xf,%eax
  801570:	75 07                	jne    801579 <strsplit+0x6c>
		{
			return 0;
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
  801577:	eb 66                	jmp    8015df <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801579:	8b 45 14             	mov    0x14(%ebp),%eax
  80157c:	8b 00                	mov    (%eax),%eax
  80157e:	8d 48 01             	lea    0x1(%eax),%ecx
  801581:	8b 55 14             	mov    0x14(%ebp),%edx
  801584:	89 0a                	mov    %ecx,(%edx)
  801586:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158d:	8b 45 10             	mov    0x10(%ebp),%eax
  801590:	01 c2                	add    %eax,%edx
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801597:	eb 03                	jmp    80159c <strsplit+0x8f>
			string++;
  801599:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	84 c0                	test   %al,%al
  8015a3:	74 8b                	je     801530 <strsplit+0x23>
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	0f be c0             	movsbl %al,%eax
  8015ad:	50                   	push   %eax
  8015ae:	ff 75 0c             	pushl  0xc(%ebp)
  8015b1:	e8 25 fa ff ff       	call   800fdb <strchr>
  8015b6:	83 c4 08             	add    $0x8,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	74 dc                	je     801599 <strsplit+0x8c>
			string++;
	}
  8015bd:	e9 6e ff ff ff       	jmp    801530 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015c2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d2:	01 d0                	add    %edx,%eax
  8015d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015da:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f4:	eb 4a                	jmp    801640 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	01 c2                	add    %eax,%edx
  8015fe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	01 c8                	add    %ecx,%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80160a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	3c 40                	cmp    $0x40,%al
  801616:	7e 25                	jle    80163d <str2lower+0x5c>
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	8a 00                	mov    (%eax),%al
  801622:	3c 5a                	cmp    $0x5a,%al
  801624:	7f 17                	jg     80163d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	01 d0                	add    %edx,%eax
  80162e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801631:	8b 55 08             	mov    0x8(%ebp),%edx
  801634:	01 ca                	add    %ecx,%edx
  801636:	8a 12                	mov    (%edx),%dl
  801638:	83 c2 20             	add    $0x20,%edx
  80163b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80163d:	ff 45 fc             	incl   -0x4(%ebp)
  801640:	ff 75 0c             	pushl  0xc(%ebp)
  801643:	e8 01 f8 ff ff       	call   800e49 <strlen>
  801648:	83 c4 04             	add    $0x4,%esp
  80164b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80164e:	7f a6                	jg     8015f6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801650:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	6a 10                	push   $0x10
  801660:	e8 b2 15 00 00       	call   802c17 <alloc_block>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80166b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80166f:	75 14                	jne    801685 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 a8 41 80 00       	push   $0x8041a8
  801679:	6a 14                	push   $0x14
  80167b:	68 d1 41 80 00       	push   $0x8041d1
  801680:	e8 fd ed ff ff       	call   800482 <_panic>

	node->start = start;
  801685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801688:	8b 55 08             	mov    0x8(%ebp),%edx
  80168b:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80168d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801696:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80169d:	a1 24 50 80 00       	mov    0x805024,%eax
  8016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a5:	eb 18                	jmp    8016bf <insert_page_alloc+0x6a>
		if (start < it->start)
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016af:	77 37                	ja     8016e8 <insert_page_alloc+0x93>
			break;
		prev = it;
  8016b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8016b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c3:	74 08                	je     8016cd <insert_page_alloc+0x78>
  8016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c8:	8b 40 08             	mov    0x8(%eax),%eax
  8016cb:	eb 05                	jmp    8016d2 <insert_page_alloc+0x7d>
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	75 c7                	jne    8016a7 <insert_page_alloc+0x52>
  8016e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e4:	75 c1                	jne    8016a7 <insert_page_alloc+0x52>
  8016e6:	eb 01                	jmp    8016e9 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8016e8:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8016e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ed:	75 64                	jne    801753 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8016ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f3:	75 14                	jne    801709 <insert_page_alloc+0xb4>
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	68 e0 41 80 00       	push   $0x8041e0
  8016fd:	6a 21                	push   $0x21
  8016ff:	68 d1 41 80 00       	push   $0x8041d1
  801704:	e8 79 ed ff ff       	call   800482 <_panic>
  801709:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80170f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801712:	89 50 08             	mov    %edx,0x8(%eax)
  801715:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801718:	8b 40 08             	mov    0x8(%eax),%eax
  80171b:	85 c0                	test   %eax,%eax
  80171d:	74 0d                	je     80172c <insert_page_alloc+0xd7>
  80171f:	a1 24 50 80 00       	mov    0x805024,%eax
  801724:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801727:	89 50 0c             	mov    %edx,0xc(%eax)
  80172a:	eb 08                	jmp    801734 <insert_page_alloc+0xdf>
  80172c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172f:	a3 28 50 80 00       	mov    %eax,0x805028
  801734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801737:	a3 24 50 80 00       	mov    %eax,0x805024
  80173c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801746:	a1 30 50 80 00       	mov    0x805030,%eax
  80174b:	40                   	inc    %eax
  80174c:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801751:	eb 71                	jmp    8017c4 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801753:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801757:	74 06                	je     80175f <insert_page_alloc+0x10a>
  801759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80175d:	75 14                	jne    801773 <insert_page_alloc+0x11e>
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	68 04 42 80 00       	push   $0x804204
  801767:	6a 23                	push   $0x23
  801769:	68 d1 41 80 00       	push   $0x8041d1
  80176e:	e8 0f ed ff ff       	call   800482 <_panic>
  801773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801776:	8b 50 08             	mov    0x8(%eax),%edx
  801779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177c:	89 50 08             	mov    %edx,0x8(%eax)
  80177f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801782:	8b 40 08             	mov    0x8(%eax),%eax
  801785:	85 c0                	test   %eax,%eax
  801787:	74 0c                	je     801795 <insert_page_alloc+0x140>
  801789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178c:	8b 40 08             	mov    0x8(%eax),%eax
  80178f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801792:	89 50 0c             	mov    %edx,0xc(%eax)
  801795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801798:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80179b:	89 50 08             	mov    %edx,0x8(%eax)
  80179e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a4:	89 50 0c             	mov    %edx,0xc(%eax)
  8017a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017aa:	8b 40 08             	mov    0x8(%eax),%eax
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	75 08                	jne    8017b9 <insert_page_alloc+0x164>
  8017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b4:	a3 28 50 80 00       	mov    %eax,0x805028
  8017b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8017be:	40                   	inc    %eax
  8017bf:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8017cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	75 0c                	jne    8017e2 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8017d6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017db:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8017e0:	eb 67                	jmp    801849 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8017e2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017ea:	a1 24 50 80 00       	mov    0x805024,%eax
  8017ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017f2:	eb 26                	jmp    80181a <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8017f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f7:	8b 10                	mov    (%eax),%edx
  8017f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fc:	8b 40 04             	mov    0x4(%eax),%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801807:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80180a:	76 06                	jbe    801812 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80180c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801812:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801817:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80181a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80181e:	74 08                	je     801828 <recompute_page_alloc_break+0x61>
  801820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801823:	8b 40 08             	mov    0x8(%eax),%eax
  801826:	eb 05                	jmp    80182d <recompute_page_alloc_break+0x66>
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
  80182d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801832:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801837:	85 c0                	test   %eax,%eax
  801839:	75 b9                	jne    8017f4 <recompute_page_alloc_break+0x2d>
  80183b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80183f:	75 b3                	jne    8017f4 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801851:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801858:	8b 55 08             	mov    0x8(%ebp),%edx
  80185b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	48                   	dec    %eax
  801861:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801864:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801867:	ba 00 00 00 00       	mov    $0x0,%edx
  80186c:	f7 75 d8             	divl   -0x28(%ebp)
  80186f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801872:	29 d0                	sub    %edx,%eax
  801874:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801877:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80187b:	75 0a                	jne    801887 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
  801882:	e9 7e 01 00 00       	jmp    801a05 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80188e:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801892:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801899:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8018a0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8018a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8018a8:	a1 24 50 80 00       	mov    0x805024,%eax
  8018ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018b0:	eb 69                	jmp    80191b <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8018b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b5:	8b 00                	mov    (%eax),%eax
  8018b7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018ba:	76 47                	jbe    801903 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8018bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8018c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c5:	8b 00                	mov    (%eax),%eax
  8018c7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018ca:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8018cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018d3:	72 2e                	jb     801903 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8018d5:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018d9:	75 14                	jne    8018ef <alloc_pages_custom_fit+0xa4>
  8018db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018de:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018e1:	75 0c                	jne    8018ef <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8018e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8018e9:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018ed:	eb 14                	jmp    801903 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8018ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018f2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018f5:	76 0c                	jbe    801903 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8018f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8018fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801900:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801906:	8b 10                	mov    (%eax),%edx
  801908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190b:	8b 40 04             	mov    0x4(%eax),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801913:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801918:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80191b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80191f:	74 08                	je     801929 <alloc_pages_custom_fit+0xde>
  801921:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801924:	8b 40 08             	mov    0x8(%eax),%eax
  801927:	eb 05                	jmp    80192e <alloc_pages_custom_fit+0xe3>
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
  80192e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801933:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801938:	85 c0                	test   %eax,%eax
  80193a:	0f 85 72 ff ff ff    	jne    8018b2 <alloc_pages_custom_fit+0x67>
  801940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801944:	0f 85 68 ff ff ff    	jne    8018b2 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80194a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80194f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801952:	76 47                	jbe    80199b <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801957:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80195a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80195f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801962:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801965:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801968:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80196b:	72 2e                	jb     80199b <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80196d:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801971:	75 14                	jne    801987 <alloc_pages_custom_fit+0x13c>
  801973:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801976:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801979:	75 0c                	jne    801987 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80197b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80197e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801981:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801985:	eb 14                	jmp    80199b <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801987:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80198a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80198d:	76 0c                	jbe    80199b <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80198f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801992:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801995:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801998:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80199b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8019a2:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8019a6:	74 08                	je     8019b0 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019ae:	eb 40                	jmp    8019f0 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  8019b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019b4:	74 08                	je     8019be <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8019b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019bc:	eb 32                	jmp    8019f0 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8019be:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8019c3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8019c6:	89 c2                	mov    %eax,%edx
  8019c8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019cd:	39 c2                	cmp    %eax,%edx
  8019cf:	73 07                	jae    8019d8 <alloc_pages_custom_fit+0x18d>
			return NULL;
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d6:	eb 2d                	jmp    801a05 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8019d8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8019e0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8019e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019e9:	01 d0                	add    %edx,%eax
  8019eb:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8019f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019f3:	83 ec 08             	sub    $0x8,%esp
  8019f6:	ff 75 d0             	pushl  -0x30(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	e8 56 fc ff ff       	call   801655 <insert_page_alloc>
  8019ff:	83 c4 10             	add    $0x10,%esp

	return result;
  801a02:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a13:	a1 24 50 80 00       	mov    0x805024,%eax
  801a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a1b:	eb 1a                	jmp    801a37 <find_allocated_size+0x30>
		if (it->start == va)
  801a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a20:	8b 00                	mov    (%eax),%eax
  801a22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a25:	75 08                	jne    801a2f <find_allocated_size+0x28>
			return it->size;
  801a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2a:	8b 40 04             	mov    0x4(%eax),%eax
  801a2d:	eb 34                	jmp    801a63 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a2f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a3b:	74 08                	je     801a45 <find_allocated_size+0x3e>
  801a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a40:	8b 40 08             	mov    0x8(%eax),%eax
  801a43:	eb 05                	jmp    801a4a <find_allocated_size+0x43>
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a4f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a54:	85 c0                	test   %eax,%eax
  801a56:	75 c5                	jne    801a1d <find_allocated_size+0x16>
  801a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a5c:	75 bf                	jne    801a1d <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a71:	a1 24 50 80 00       	mov    0x805024,%eax
  801a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a79:	e9 e1 01 00 00       	jmp    801c5f <free_pages+0x1fa>
		if (it->start == va) {
  801a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a81:	8b 00                	mov    (%eax),%eax
  801a83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a86:	0f 85 cb 01 00 00    	jne    801c57 <free_pages+0x1f2>

			uint32 start = it->start;
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	8b 40 04             	mov    0x4(%eax),%eax
  801a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa0:	f7 d0                	not    %eax
  801aa2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801aa5:	73 1d                	jae    801ac4 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801aa7:	83 ec 0c             	sub    $0xc,%esp
  801aaa:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aad:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab0:	68 38 42 80 00       	push   $0x804238
  801ab5:	68 a5 00 00 00       	push   $0xa5
  801aba:	68 d1 41 80 00       	push   $0x8041d1
  801abf:	e8 be e9 ff ff       	call   800482 <_panic>
			}

			uint32 start_end = start + size;
  801ac4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aca:	01 d0                	add    %edx,%eax
  801acc:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	79 19                	jns    801aef <free_pages+0x8a>
  801ad6:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801add:	77 10                	ja     801aef <free_pages+0x8a>
  801adf:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801ae6:	77 07                	ja     801aef <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 2c                	js     801b1b <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	68 00 00 00 a0       	push   $0xa0000000
  801afa:	ff 75 e0             	pushl  -0x20(%ebp)
  801afd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b00:	ff 75 e8             	pushl  -0x18(%ebp)
  801b03:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b06:	50                   	push   %eax
  801b07:	68 7c 42 80 00       	push   $0x80427c
  801b0c:	68 ad 00 00 00       	push   $0xad
  801b11:	68 d1 41 80 00       	push   $0x8041d1
  801b16:	e8 67 e9 ff ff       	call   800482 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b21:	e9 88 00 00 00       	jmp    801bae <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801b26:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801b2d:	76 17                	jbe    801b46 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801b2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801b32:	68 e0 42 80 00       	push   $0x8042e0
  801b37:	68 b4 00 00 00       	push   $0xb4
  801b3c:	68 d1 41 80 00       	push   $0x8041d1
  801b41:	e8 3c e9 ff ff       	call   800482 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b49:	05 00 10 00 00       	add    $0x1000,%eax
  801b4e:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b54:	85 c0                	test   %eax,%eax
  801b56:	79 2e                	jns    801b86 <free_pages+0x121>
  801b58:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b5f:	77 25                	ja     801b86 <free_pages+0x121>
  801b61:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b68:	77 1c                	ja     801b86 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	68 00 10 00 00       	push   $0x1000
  801b72:	ff 75 f0             	pushl  -0x10(%ebp)
  801b75:	e8 38 0d 00 00       	call   8028b2 <sys_free_user_mem>
  801b7a:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b7d:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b84:	eb 28                	jmp    801bae <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b89:	68 00 00 00 a0       	push   $0xa0000000
  801b8e:	ff 75 dc             	pushl  -0x24(%ebp)
  801b91:	68 00 10 00 00       	push   $0x1000
  801b96:	ff 75 f0             	pushl  -0x10(%ebp)
  801b99:	50                   	push   %eax
  801b9a:	68 20 43 80 00       	push   $0x804320
  801b9f:	68 bd 00 00 00       	push   $0xbd
  801ba4:	68 d1 41 80 00       	push   $0x8041d1
  801ba9:	e8 d4 e8 ff ff       	call   800482 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801bb4:	0f 82 6c ff ff ff    	jb     801b26 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bbe:	75 17                	jne    801bd7 <free_pages+0x172>
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	68 82 43 80 00       	push   $0x804382
  801bc8:	68 c1 00 00 00       	push   $0xc1
  801bcd:	68 d1 41 80 00       	push   $0x8041d1
  801bd2:	e8 ab e8 ff ff       	call   800482 <_panic>
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	8b 40 08             	mov    0x8(%eax),%eax
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	74 11                	je     801bf2 <free_pages+0x18d>
  801be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be4:	8b 40 08             	mov    0x8(%eax),%eax
  801be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bea:	8b 52 0c             	mov    0xc(%edx),%edx
  801bed:	89 50 0c             	mov    %edx,0xc(%eax)
  801bf0:	eb 0b                	jmp    801bfd <free_pages+0x198>
  801bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf8:	a3 28 50 80 00       	mov    %eax,0x805028
  801bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c00:	8b 40 0c             	mov    0xc(%eax),%eax
  801c03:	85 c0                	test   %eax,%eax
  801c05:	74 11                	je     801c18 <free_pages+0x1b3>
  801c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c10:	8b 52 08             	mov    0x8(%edx),%edx
  801c13:	89 50 08             	mov    %edx,0x8(%eax)
  801c16:	eb 0b                	jmp    801c23 <free_pages+0x1be>
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	8b 40 08             	mov    0x8(%eax),%eax
  801c1e:	a3 24 50 80 00       	mov    %eax,0x805024
  801c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c37:	a1 30 50 80 00       	mov    0x805030,%eax
  801c3c:	48                   	dec    %eax
  801c3d:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801c42:	83 ec 0c             	sub    $0xc,%esp
  801c45:	ff 75 f4             	pushl  -0xc(%ebp)
  801c48:	e8 24 15 00 00       	call   803171 <free_block>
  801c4d:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801c50:	e8 72 fb ff ff       	call   8017c7 <recompute_page_alloc_break>

			return;
  801c55:	eb 37                	jmp    801c8e <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c57:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c63:	74 08                	je     801c6d <free_pages+0x208>
  801c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c68:	8b 40 08             	mov    0x8(%eax),%eax
  801c6b:	eb 05                	jmp    801c72 <free_pages+0x20d>
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c77:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	0f 85 fa fd ff ff    	jne    801a7e <free_pages+0x19>
  801c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c88:	0f 85 f0 fd ff ff    	jne    801a7e <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    

00801c9a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ca0:	a1 08 50 80 00       	mov    0x805008,%eax
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	74 60                	je     801d09 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ca9:	83 ec 08             	sub    $0x8,%esp
  801cac:	68 00 00 00 82       	push   $0x82000000
  801cb1:	68 00 00 00 80       	push   $0x80000000
  801cb6:	e8 0d 0d 00 00       	call   8029c8 <initialize_dynamic_allocator>
  801cbb:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cbe:	e8 f3 0a 00 00       	call   8027b6 <sys_get_uheap_strategy>
  801cc3:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cc8:	a1 40 50 80 00       	mov    0x805040,%eax
  801ccd:	05 00 10 00 00       	add    $0x1000,%eax
  801cd2:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cd7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cdc:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801ce1:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801ce8:	00 00 00 
  801ceb:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801cf2:	00 00 00 
  801cf5:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801cfc:	00 00 00 

		__firstTimeFlag = 0;
  801cff:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801d06:	00 00 00 
	}
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d20:	83 ec 08             	sub    $0x8,%esp
  801d23:	68 06 04 00 00       	push   $0x406
  801d28:	50                   	push   %eax
  801d29:	e8 d2 06 00 00       	call   802400 <__sys_allocate_page>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d38:	79 17                	jns    801d51 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	68 a0 43 80 00       	push   $0x8043a0
  801d42:	68 ea 00 00 00       	push   $0xea
  801d47:	68 d1 41 80 00       	push   $0x8041d1
  801d4c:	e8 31 e7 ff ff       	call   800482 <_panic>
	return 0;
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	50                   	push   %eax
  801d70:	e8 d2 06 00 00       	call   802447 <__sys_unmap_frame>
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7f:	79 17                	jns    801d98 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	68 dc 43 80 00       	push   $0x8043dc
  801d89:	68 f5 00 00 00       	push   $0xf5
  801d8e:	68 d1 41 80 00       	push   $0x8041d1
  801d93:	e8 ea e6 ff ff       	call   800482 <_panic>
}
  801d98:	90                   	nop
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801da1:	e8 f4 fe ff ff       	call   801c9a <uheap_init>
	if (size == 0) return NULL ;
  801da6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801daa:	75 0a                	jne    801db6 <malloc+0x1b>
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
  801db1:	e9 67 01 00 00       	jmp    801f1d <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801dbd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dc4:	77 16                	ja     801ddc <malloc+0x41>
		result = alloc_block(size);
  801dc6:	83 ec 0c             	sub    $0xc,%esp
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	e8 46 0e 00 00       	call   802c17 <alloc_block>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd7:	e9 3e 01 00 00       	jmp    801f1a <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801ddc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801de3:	8b 55 08             	mov    0x8(%ebp),%edx
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	01 d0                	add    %edx,%eax
  801deb:	48                   	dec    %eax
  801dec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df2:	ba 00 00 00 00       	mov    $0x0,%edx
  801df7:	f7 75 f0             	divl   -0x10(%ebp)
  801dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dfd:	29 d0                	sub    %edx,%eax
  801dff:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801e02:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	75 0a                	jne    801e15 <malloc+0x7a>
			return NULL;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e10:	e9 08 01 00 00       	jmp    801f1d <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801e15:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	74 0f                	je     801e2d <malloc+0x92>
  801e1e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e24:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e29:	39 c2                	cmp    %eax,%edx
  801e2b:	73 0a                	jae    801e37 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801e2d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e32:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801e37:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801e3c:	83 f8 05             	cmp    $0x5,%eax
  801e3f:	75 11                	jne    801e52 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	ff 75 e8             	pushl  -0x18(%ebp)
  801e47:	e8 ff f9 ff ff       	call   80184b <alloc_pages_custom_fit>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e56:	0f 84 be 00 00 00    	je     801f1a <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	ff 75 f4             	pushl  -0xc(%ebp)
  801e68:	e8 9a fb ff ff       	call   801a07 <find_allocated_size>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801e73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e77:	75 17                	jne    801e90 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801e79:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7c:	68 1c 44 80 00       	push   $0x80441c
  801e81:	68 24 01 00 00       	push   $0x124
  801e86:	68 d1 41 80 00       	push   $0x8041d1
  801e8b:	e8 f2 e5 ff ff       	call   800482 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e93:	f7 d0                	not    %eax
  801e95:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e98:	73 1d                	jae    801eb7 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	ff 75 e0             	pushl  -0x20(%ebp)
  801ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ea3:	68 64 44 80 00       	push   $0x804464
  801ea8:	68 29 01 00 00       	push   $0x129
  801ead:	68 d1 41 80 00       	push   $0x8041d1
  801eb2:	e8 cb e5 ff ff       	call   800482 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801eb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801eba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	79 2c                	jns    801ef5 <malloc+0x15a>
  801ec9:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801ed0:	77 23                	ja     801ef5 <malloc+0x15a>
  801ed2:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ed9:	77 1a                	ja     801ef5 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801edb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	79 13                	jns    801ef5 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801ee2:	83 ec 08             	sub    $0x8,%esp
  801ee5:	ff 75 e0             	pushl  -0x20(%ebp)
  801ee8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eeb:	e8 de 09 00 00       	call   8028ce <sys_allocate_user_mem>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	eb 25                	jmp    801f1a <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801ef5:	68 00 00 00 a0       	push   $0xa0000000
  801efa:	ff 75 dc             	pushl  -0x24(%ebp)
  801efd:	ff 75 e0             	pushl  -0x20(%ebp)
  801f00:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f03:	ff 75 f4             	pushl  -0xc(%ebp)
  801f06:	68 a0 44 80 00       	push   $0x8044a0
  801f0b:	68 33 01 00 00       	push   $0x133
  801f10:	68 d1 41 80 00       	push   $0x8041d1
  801f15:	e8 68 e5 ff ff       	call   800482 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f29:	0f 84 26 01 00 00    	je     802055 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	79 1c                	jns    801f58 <free+0x39>
  801f3c:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801f43:	77 13                	ja     801f58 <free+0x39>
		free_block(virtual_address);
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	e8 21 12 00 00       	call   803171 <free_block>
  801f50:	83 c4 10             	add    $0x10,%esp
		return;
  801f53:	e9 01 01 00 00       	jmp    802059 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801f58:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f5d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f60:	0f 82 d8 00 00 00    	jb     80203e <free+0x11f>
  801f66:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801f6d:	0f 87 cb 00 00 00    	ja     80203e <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	74 17                	je     801f96 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	68 10 45 80 00       	push   $0x804510
  801f87:	68 57 01 00 00       	push   $0x157
  801f8c:	68 d1 41 80 00       	push   $0x8041d1
  801f91:	e8 ec e4 ff ff       	call   800482 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	ff 75 08             	pushl  0x8(%ebp)
  801f9c:	e8 66 fa ff ff       	call   801a07 <find_allocated_size>
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801fa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fab:	0f 84 a7 00 00 00    	je     802058 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb4:	f7 d0                	not    %eax
  801fb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fb9:	73 1d                	jae    801fd8 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc4:	68 38 45 80 00       	push   $0x804538
  801fc9:	68 61 01 00 00       	push   $0x161
  801fce:	68 d1 41 80 00       	push   $0x8041d1
  801fd3:	e8 aa e4 ff ff       	call   800482 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	79 19                	jns    802003 <free+0xe4>
  801fea:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801ff1:	77 10                	ja     802003 <free+0xe4>
  801ff3:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801ffa:	77 07                	ja     802003 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 2b                	js     80202e <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 00 00 00 a0       	push   $0xa0000000
  80200b:	ff 75 ec             	pushl  -0x14(%ebp)
  80200e:	ff 75 f0             	pushl  -0x10(%ebp)
  802011:	ff 75 f4             	pushl  -0xc(%ebp)
  802014:	ff 75 f0             	pushl  -0x10(%ebp)
  802017:	ff 75 08             	pushl  0x8(%ebp)
  80201a:	68 74 45 80 00       	push   $0x804574
  80201f:	68 69 01 00 00       	push   $0x169
  802024:	68 d1 41 80 00       	push   $0x8041d1
  802029:	e8 54 e4 ff ff       	call   800482 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	ff 75 08             	pushl  0x8(%ebp)
  802034:	e8 2c fa ff ff       	call   801a65 <free_pages>
  802039:	83 c4 10             	add    $0x10,%esp
		return;
  80203c:	eb 1b                	jmp    802059 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80203e:	ff 75 08             	pushl  0x8(%ebp)
  802041:	68 d0 45 80 00       	push   $0x8045d0
  802046:	68 70 01 00 00       	push   $0x170
  80204b:	68 d1 41 80 00       	push   $0x8041d1
  802050:	e8 2d e4 ff ff       	call   800482 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802055:	90                   	nop
  802056:	eb 01                	jmp    802059 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802058:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 38             	sub    $0x38,%esp
  802061:	8b 45 10             	mov    0x10(%ebp),%eax
  802064:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802067:	e8 2e fc ff ff       	call   801c9a <uheap_init>
	if (size == 0) return NULL ;
  80206c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802070:	75 0a                	jne    80207c <smalloc+0x21>
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	e9 3d 01 00 00       	jmp    8021b9 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802082:	8b 45 0c             	mov    0xc(%ebp),%eax
  802085:	25 ff 0f 00 00       	and    $0xfff,%eax
  80208a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80208d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802091:	74 0e                	je     8020a1 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802099:	05 00 10 00 00       	add    $0x1000,%eax
  80209e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	c1 e8 0c             	shr    $0xc,%eax
  8020a7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8020aa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	75 0a                	jne    8020bd <smalloc+0x62>
		return NULL;
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	e9 fc 00 00 00       	jmp    8021b9 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020bd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	74 0f                	je     8020d5 <smalloc+0x7a>
  8020c6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020cc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020d1:	39 c2                	cmp    %eax,%edx
  8020d3:	73 0a                	jae    8020df <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8020d5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020da:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020df:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020e4:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020e9:	29 c2                	sub    %eax,%edx
  8020eb:	89 d0                	mov    %edx,%eax
  8020ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020f0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020f6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020fb:	29 c2                	sub    %eax,%edx
  8020fd:	89 d0                	mov    %edx,%eax
  8020ff:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802108:	77 13                	ja     80211d <smalloc+0xc2>
  80210a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802110:	77 0b                	ja     80211d <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802115:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802118:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80211b:	73 0a                	jae    802127 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
  802122:	e9 92 00 00 00       	jmp    8021b9 <smalloc+0x15e>
	}

	void *va = NULL;
  802127:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80212e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802133:	83 f8 05             	cmp    $0x5,%eax
  802136:	75 11                	jne    802149 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	ff 75 f4             	pushl  -0xc(%ebp)
  80213e:	e8 08 f7 ff ff       	call   80184b <alloc_pages_custom_fit>
  802143:	83 c4 10             	add    $0x10,%esp
  802146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214d:	75 27                	jne    802176 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80214f:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802156:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802159:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80215c:	89 c2                	mov    %eax,%edx
  80215e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	73 07                	jae    80216e <smalloc+0x113>
			return NULL;}
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
  80216c:	eb 4b                	jmp    8021b9 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80216e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802173:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802176:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80217a:	ff 75 f0             	pushl  -0x10(%ebp)
  80217d:	50                   	push   %eax
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	ff 75 08             	pushl  0x8(%ebp)
  802184:	e8 cb 03 00 00       	call   802554 <sys_create_shared_object>
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80218f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802193:	79 07                	jns    80219c <smalloc+0x141>
		return NULL;
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
  80219a:	eb 1d                	jmp    8021b9 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80219c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021a1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8021a4:	75 10                	jne    8021b6 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8021a6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8021b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021c1:	e8 d4 fa ff ff       	call   801c9a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021c6:	83 ec 08             	sub    $0x8,%esp
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	e8 aa 03 00 00       	call   80257e <sys_size_of_shared_object>
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8021da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021de:	7f 0a                	jg     8021ea <sget+0x2f>
		return NULL;
  8021e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e5:	e9 32 01 00 00       	jmp    80231c <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8021ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8021f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f3:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8021fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021ff:	74 0e                	je     80220f <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802207:	05 00 10 00 00       	add    $0x1000,%eax
  80220c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80220f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	75 0a                	jne    802222 <sget+0x67>
		return NULL;
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
  80221d:	e9 fa 00 00 00       	jmp    80231c <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802222:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	74 0f                	je     80223a <sget+0x7f>
  80222b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802231:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802236:	39 c2                	cmp    %eax,%edx
  802238:	73 0a                	jae    802244 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80223a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80223f:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802244:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802249:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80224e:	29 c2                	sub    %eax,%edx
  802250:	89 d0                	mov    %edx,%eax
  802252:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802255:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80225b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802260:	29 c2                	sub    %eax,%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80226d:	77 13                	ja     802282 <sget+0xc7>
  80226f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802272:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802275:	77 0b                	ja     802282 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227a:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80227d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802280:	73 0a                	jae    80228c <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	e9 90 00 00 00       	jmp    80231c <sget+0x161>

	void *va = NULL;
  80228c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802293:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802298:	83 f8 05             	cmp    $0x5,%eax
  80229b:	75 11                	jne    8022ae <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a3:	e8 a3 f5 ff ff       	call   80184b <alloc_pages_custom_fit>
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8022ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b2:	75 27                	jne    8022db <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8022b4:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8022bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022be:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8022c1:	89 c2                	mov    %eax,%edx
  8022c3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022c8:	39 c2                	cmp    %eax,%edx
  8022ca:	73 07                	jae    8022d3 <sget+0x118>
			return NULL;
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	eb 49                	jmp    80231c <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8022d3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e1:	ff 75 0c             	pushl  0xc(%ebp)
  8022e4:	ff 75 08             	pushl  0x8(%ebp)
  8022e7:	e8 af 02 00 00       	call   80259b <sys_get_shared_object>
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8022f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022f6:	79 07                	jns    8022ff <sget+0x144>
		return NULL;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fd:	eb 1d                	jmp    80231c <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8022ff:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802304:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802307:	75 10                	jne    802319 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802309:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802319:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802324:	e8 71 f9 ff ff       	call   801c9a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	68 f4 45 80 00       	push   $0x8045f4
  802331:	68 19 02 00 00       	push   $0x219
  802336:	68 d1 41 80 00       	push   $0x8041d1
  80233b:	e8 42 e1 ff ff       	call   800482 <_panic>

00802340 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	68 1c 46 80 00       	push   $0x80461c
  80234e:	68 2b 02 00 00       	push   $0x22b
  802353:	68 d1 41 80 00       	push   $0x8041d1
  802358:	e8 25 e1 ff ff       	call   800482 <_panic>

0080235d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	57                   	push   %edi
  802361:	56                   	push   %esi
  802362:	53                   	push   %ebx
  802363:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802372:	8b 7d 18             	mov    0x18(%ebp),%edi
  802375:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802378:	cd 30                	int    $0x30
  80237a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5f                   	pop    %edi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    

00802388 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	8b 45 10             	mov    0x10(%ebp),%eax
  802391:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802394:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802397:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	6a 00                	push   $0x0
  8023a0:	51                   	push   %ecx
  8023a1:	52                   	push   %edx
  8023a2:	ff 75 0c             	pushl  0xc(%ebp)
  8023a5:	50                   	push   %eax
  8023a6:	6a 00                	push   $0x0
  8023a8:	e8 b0 ff ff ff       	call   80235d <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	90                   	nop
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 02                	push   $0x2
  8023c2:	e8 96 ff ff ff       	call   80235d <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 03                	push   $0x3
  8023db:	e8 7d ff ff ff       	call   80235d <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	90                   	nop
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 04                	push   $0x4
  8023f5:	e8 63 ff ff ff       	call   80235d <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	90                   	nop
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802403:	8b 55 0c             	mov    0xc(%ebp),%edx
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	52                   	push   %edx
  802410:	50                   	push   %eax
  802411:	6a 08                	push   $0x8
  802413:	e8 45 ff ff ff       	call   80235d <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	56                   	push   %esi
  802421:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802422:	8b 75 18             	mov    0x18(%ebp),%esi
  802425:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802428:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80242b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	56                   	push   %esi
  802432:	53                   	push   %ebx
  802433:	51                   	push   %ecx
  802434:	52                   	push   %edx
  802435:	50                   	push   %eax
  802436:	6a 09                	push   $0x9
  802438:	e8 20 ff ff ff       	call   80235d <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802443:	5b                   	pop    %ebx
  802444:	5e                   	pop    %esi
  802445:	5d                   	pop    %ebp
  802446:	c3                   	ret    

00802447 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	ff 75 08             	pushl  0x8(%ebp)
  802455:	6a 0a                	push   $0xa
  802457:	e8 01 ff ff ff       	call   80235d <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	ff 75 0c             	pushl  0xc(%ebp)
  80246d:	ff 75 08             	pushl  0x8(%ebp)
  802470:	6a 0b                	push   $0xb
  802472:	e8 e6 fe ff ff       	call   80235d <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 0c                	push   $0xc
  80248b:	e8 cd fe ff ff       	call   80235d <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 0d                	push   $0xd
  8024a4:	e8 b4 fe ff ff       	call   80235d <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 0e                	push   $0xe
  8024bd:	e8 9b fe ff ff       	call   80235d <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 0f                	push   $0xf
  8024d6:	e8 82 fe ff ff       	call   80235d <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	ff 75 08             	pushl  0x8(%ebp)
  8024ee:	6a 10                	push   $0x10
  8024f0:	e8 68 fe ff ff       	call   80235d <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 11                	push   $0x11
  802509:	e8 4f fe ff ff       	call   80235d <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	90                   	nop
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_cputc>:

void
sys_cputc(const char c)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 04             	sub    $0x4,%esp
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802520:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	50                   	push   %eax
  80252d:	6a 01                	push   $0x1
  80252f:	e8 29 fe ff ff       	call   80235d <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	90                   	nop
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 14                	push   $0x14
  802549:	e8 0f fe ff ff       	call   80235d <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	90                   	nop
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	8b 45 10             	mov    0x10(%ebp),%eax
  80255d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802560:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802563:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	6a 00                	push   $0x0
  80256c:	51                   	push   %ecx
  80256d:	52                   	push   %edx
  80256e:	ff 75 0c             	pushl  0xc(%ebp)
  802571:	50                   	push   %eax
  802572:	6a 15                	push   $0x15
  802574:	e8 e4 fd ff ff       	call   80235d <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802581:	8b 55 0c             	mov    0xc(%ebp),%edx
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	52                   	push   %edx
  80258e:	50                   	push   %eax
  80258f:	6a 16                	push   $0x16
  802591:	e8 c7 fd ff ff       	call   80235d <syscall>
  802596:	83 c4 18             	add    $0x18,%esp
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80259e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	51                   	push   %ecx
  8025ac:	52                   	push   %edx
  8025ad:	50                   	push   %eax
  8025ae:	6a 17                	push   $0x17
  8025b0:	e8 a8 fd ff ff       	call   80235d <syscall>
  8025b5:	83 c4 18             	add    $0x18,%esp
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	52                   	push   %edx
  8025ca:	50                   	push   %eax
  8025cb:	6a 18                	push   $0x18
  8025cd:	e8 8b fd ff ff       	call   80235d <syscall>
  8025d2:	83 c4 18             	add    $0x18,%esp
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	6a 00                	push   $0x0
  8025df:	ff 75 14             	pushl  0x14(%ebp)
  8025e2:	ff 75 10             	pushl  0x10(%ebp)
  8025e5:	ff 75 0c             	pushl  0xc(%ebp)
  8025e8:	50                   	push   %eax
  8025e9:	6a 19                	push   $0x19
  8025eb:	e8 6d fd ff ff       	call   80235d <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	50                   	push   %eax
  802604:	6a 1a                	push   $0x1a
  802606:	e8 52 fd ff ff       	call   80235d <syscall>
  80260b:	83 c4 18             	add    $0x18,%esp
}
  80260e:	90                   	nop
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	50                   	push   %eax
  802620:	6a 1b                	push   $0x1b
  802622:	e8 36 fd ff ff       	call   80235d <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 05                	push   $0x5
  80263b:	e8 1d fd ff ff       	call   80235d <syscall>
  802640:	83 c4 18             	add    $0x18,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 06                	push   $0x6
  802654:	e8 04 fd ff ff       	call   80235d <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
}
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 07                	push   $0x7
  80266d:	e8 eb fc ff ff       	call   80235d <syscall>
  802672:	83 c4 18             	add    $0x18,%esp
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_exit_env>:


void sys_exit_env(void)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 1c                	push   $0x1c
  802686:	e8 d2 fc ff ff       	call   80235d <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	90                   	nop
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802697:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80269a:	8d 50 04             	lea    0x4(%eax),%edx
  80269d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	52                   	push   %edx
  8026a7:	50                   	push   %eax
  8026a8:	6a 1d                	push   $0x1d
  8026aa:	e8 ae fc ff ff       	call   80235d <syscall>
  8026af:	83 c4 18             	add    $0x18,%esp
	return result;
  8026b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026bb:	89 01                	mov    %eax,(%ecx)
  8026bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	c9                   	leave  
  8026c4:	c2 04 00             	ret    $0x4

008026c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	ff 75 10             	pushl  0x10(%ebp)
  8026d1:	ff 75 0c             	pushl  0xc(%ebp)
  8026d4:	ff 75 08             	pushl  0x8(%ebp)
  8026d7:	6a 13                	push   $0x13
  8026d9:	e8 7f fc ff ff       	call   80235d <syscall>
  8026de:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e1:	90                   	nop
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 1e                	push   $0x1e
  8026f3:	e8 65 fc ff ff       	call   80235d <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 04             	sub    $0x4,%esp
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802709:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	50                   	push   %eax
  802716:	6a 1f                	push   $0x1f
  802718:	e8 40 fc ff ff       	call   80235d <syscall>
  80271d:	83 c4 18             	add    $0x18,%esp
	return ;
  802720:	90                   	nop
}
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <rsttst>:
void rsttst()
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 21                	push   $0x21
  802732:	e8 26 fc ff ff       	call   80235d <syscall>
  802737:	83 c4 18             	add    $0x18,%esp
	return ;
  80273a:	90                   	nop
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80273d:	55                   	push   %ebp
  80273e:	89 e5                	mov    %esp,%ebp
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	8b 45 14             	mov    0x14(%ebp),%eax
  802746:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802749:	8b 55 18             	mov    0x18(%ebp),%edx
  80274c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802750:	52                   	push   %edx
  802751:	50                   	push   %eax
  802752:	ff 75 10             	pushl  0x10(%ebp)
  802755:	ff 75 0c             	pushl  0xc(%ebp)
  802758:	ff 75 08             	pushl  0x8(%ebp)
  80275b:	6a 20                	push   $0x20
  80275d:	e8 fb fb ff ff       	call   80235d <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
	return ;
  802765:	90                   	nop
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <chktst>:
void chktst(uint32 n)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	ff 75 08             	pushl  0x8(%ebp)
  802776:	6a 22                	push   $0x22
  802778:	e8 e0 fb ff ff       	call   80235d <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
	return ;
  802780:	90                   	nop
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <inctst>:

void inctst()
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 23                	push   $0x23
  802792:	e8 c6 fb ff ff       	call   80235d <syscall>
  802797:	83 c4 18             	add    $0x18,%esp
	return ;
  80279a:	90                   	nop
}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <gettst>:
uint32 gettst()
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 24                	push   $0x24
  8027ac:	e8 ac fb ff ff       	call   80235d <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 25                	push   $0x25
  8027c5:	e8 93 fb ff ff       	call   80235d <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
  8027cd:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8027d2:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    

008027d9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027d9:	55                   	push   %ebp
  8027da:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	ff 75 08             	pushl  0x8(%ebp)
  8027ef:	6a 26                	push   $0x26
  8027f1:	e8 67 fb ff ff       	call   80235d <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f9:	90                   	nop
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802800:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802803:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802806:	8b 55 0c             	mov    0xc(%ebp),%edx
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	6a 00                	push   $0x0
  80280e:	53                   	push   %ebx
  80280f:	51                   	push   %ecx
  802810:	52                   	push   %edx
  802811:	50                   	push   %eax
  802812:	6a 27                	push   $0x27
  802814:	e8 44 fb ff ff       	call   80235d <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
}
  80281c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802824:	8b 55 0c             	mov    0xc(%ebp),%edx
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	52                   	push   %edx
  802831:	50                   	push   %eax
  802832:	6a 28                	push   $0x28
  802834:	e8 24 fb ff ff       	call   80235d <syscall>
  802839:	83 c4 18             	add    $0x18,%esp
}
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802841:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802844:	8b 55 0c             	mov    0xc(%ebp),%edx
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	6a 00                	push   $0x0
  80284c:	51                   	push   %ecx
  80284d:	ff 75 10             	pushl  0x10(%ebp)
  802850:	52                   	push   %edx
  802851:	50                   	push   %eax
  802852:	6a 29                	push   $0x29
  802854:	e8 04 fb ff ff       	call   80235d <syscall>
  802859:	83 c4 18             	add    $0x18,%esp
}
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	ff 75 10             	pushl  0x10(%ebp)
  802868:	ff 75 0c             	pushl  0xc(%ebp)
  80286b:	ff 75 08             	pushl  0x8(%ebp)
  80286e:	6a 12                	push   $0x12
  802870:	e8 e8 fa ff ff       	call   80235d <syscall>
  802875:	83 c4 18             	add    $0x18,%esp
	return ;
  802878:	90                   	nop
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80287e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	52                   	push   %edx
  80288b:	50                   	push   %eax
  80288c:	6a 2a                	push   $0x2a
  80288e:	e8 ca fa ff ff       	call   80235d <syscall>
  802893:	83 c4 18             	add    $0x18,%esp
	return;
  802896:	90                   	nop
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 2b                	push   $0x2b
  8028a8:	e8 b0 fa ff ff       	call   80235d <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
}
  8028b0:	c9                   	leave  
  8028b1:	c3                   	ret    

008028b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	ff 75 0c             	pushl  0xc(%ebp)
  8028be:	ff 75 08             	pushl  0x8(%ebp)
  8028c1:	6a 2d                	push   $0x2d
  8028c3:	e8 95 fa ff ff       	call   80235d <syscall>
  8028c8:	83 c4 18             	add    $0x18,%esp
	return;
  8028cb:	90                   	nop
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	ff 75 0c             	pushl  0xc(%ebp)
  8028da:	ff 75 08             	pushl  0x8(%ebp)
  8028dd:	6a 2c                	push   $0x2c
  8028df:	e8 79 fa ff ff       	call   80235d <syscall>
  8028e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e7:	90                   	nop
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8028ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	52                   	push   %edx
  8028fa:	50                   	push   %eax
  8028fb:	6a 2e                	push   $0x2e
  8028fd:	e8 5b fa ff ff       	call   80235d <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
	return ;
  802905:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
  80290b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80290e:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802915:	72 09                	jb     802920 <to_page_va+0x18>
  802917:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  80291e:	72 14                	jb     802934 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 40 46 80 00       	push   $0x804640
  802928:	6a 15                	push   $0x15
  80292a:	68 6b 46 80 00       	push   $0x80466b
  80292f:	e8 4e db ff ff       	call   800482 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	ba 60 50 80 00       	mov    $0x805060,%edx
  80293c:	29 d0                	sub    %edx,%eax
  80293e:	c1 f8 02             	sar    $0x2,%eax
  802941:	89 c2                	mov    %eax,%edx
  802943:	89 d0                	mov    %edx,%eax
  802945:	c1 e0 02             	shl    $0x2,%eax
  802948:	01 d0                	add    %edx,%eax
  80294a:	c1 e0 02             	shl    $0x2,%eax
  80294d:	01 d0                	add    %edx,%eax
  80294f:	c1 e0 02             	shl    $0x2,%eax
  802952:	01 d0                	add    %edx,%eax
  802954:	89 c1                	mov    %eax,%ecx
  802956:	c1 e1 08             	shl    $0x8,%ecx
  802959:	01 c8                	add    %ecx,%eax
  80295b:	89 c1                	mov    %eax,%ecx
  80295d:	c1 e1 10             	shl    $0x10,%ecx
  802960:	01 c8                	add    %ecx,%eax
  802962:	01 c0                	add    %eax,%eax
  802964:	01 d0                	add    %edx,%eax
  802966:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	c1 e0 0c             	shl    $0xc,%eax
  80296f:	89 c2                	mov    %eax,%edx
  802971:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802976:	01 d0                	add    %edx,%eax
}
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802980:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802985:	8b 55 08             	mov    0x8(%ebp),%edx
  802988:	29 c2                	sub    %eax,%edx
  80298a:	89 d0                	mov    %edx,%eax
  80298c:	c1 e8 0c             	shr    $0xc,%eax
  80298f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802996:	78 09                	js     8029a1 <to_page_info+0x27>
  802998:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80299f:	7e 14                	jle    8029b5 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8029a1:	83 ec 04             	sub    $0x4,%esp
  8029a4:	68 84 46 80 00       	push   $0x804684
  8029a9:	6a 22                	push   $0x22
  8029ab:	68 6b 46 80 00       	push   $0x80466b
  8029b0:	e8 cd da ff ff       	call   800482 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8029b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b8:	89 d0                	mov    %edx,%eax
  8029ba:	01 c0                	add    %eax,%eax
  8029bc:	01 d0                	add    %edx,%eax
  8029be:	c1 e0 02             	shl    $0x2,%eax
  8029c1:	05 60 50 80 00       	add    $0x805060,%eax
}
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	05 00 00 00 02       	add    $0x2000000,%eax
  8029d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029d9:	73 16                	jae    8029f1 <initialize_dynamic_allocator+0x29>
  8029db:	68 a8 46 80 00       	push   $0x8046a8
  8029e0:	68 ce 46 80 00       	push   $0x8046ce
  8029e5:	6a 34                	push   $0x34
  8029e7:	68 6b 46 80 00       	push   $0x80466b
  8029ec:	e8 91 da ff ff       	call   800482 <_panic>
		is_initialized = 1;
  8029f1:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8029f8:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a06:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802a0b:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802a12:	00 00 00 
  802a15:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802a1c:	00 00 00 
  802a1f:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802a26:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802a29:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802a30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a37:	eb 36                	jmp    802a6f <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	c1 e0 04             	shl    $0x4,%eax
  802a3f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	c1 e0 04             	shl    $0x4,%eax
  802a50:	05 84 d0 81 00       	add    $0x81d084,%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	c1 e0 04             	shl    $0x4,%eax
  802a61:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802a6c:	ff 45 f4             	incl   -0xc(%ebp)
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a75:	72 c2                	jb     802a39 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802a77:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a7d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a82:	29 c2                	sub    %eax,%edx
  802a84:	89 d0                	mov    %edx,%eax
  802a86:	c1 e8 0c             	shr    $0xc,%eax
  802a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a93:	e9 c8 00 00 00       	jmp    802b60 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9b:	89 d0                	mov    %edx,%eax
  802a9d:	01 c0                	add    %eax,%eax
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	c1 e0 02             	shl    $0x2,%eax
  802aa4:	05 68 50 80 00       	add    $0x805068,%eax
  802aa9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802aae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab1:	89 d0                	mov    %edx,%eax
  802ab3:	01 c0                	add    %eax,%eax
  802ab5:	01 d0                	add    %edx,%eax
  802ab7:	c1 e0 02             	shl    $0x2,%eax
  802aba:	05 6a 50 80 00       	add    $0x80506a,%eax
  802abf:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802ac4:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802aca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802acd:	89 c8                	mov    %ecx,%eax
  802acf:	01 c0                	add    %eax,%eax
  802ad1:	01 c8                	add    %ecx,%eax
  802ad3:	c1 e0 02             	shl    $0x2,%eax
  802ad6:	05 64 50 80 00       	add    $0x805064,%eax
  802adb:	89 10                	mov    %edx,(%eax)
  802add:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae0:	89 d0                	mov    %edx,%eax
  802ae2:	01 c0                	add    %eax,%eax
  802ae4:	01 d0                	add    %edx,%eax
  802ae6:	c1 e0 02             	shl    $0x2,%eax
  802ae9:	05 64 50 80 00       	add    $0x805064,%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 1b                	je     802b0f <initialize_dynamic_allocator+0x147>
  802af4:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802afa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802afd:	89 c8                	mov    %ecx,%eax
  802aff:	01 c0                	add    %eax,%eax
  802b01:	01 c8                	add    %ecx,%eax
  802b03:	c1 e0 02             	shl    $0x2,%eax
  802b06:	05 60 50 80 00       	add    $0x805060,%eax
  802b0b:	89 02                	mov    %eax,(%edx)
  802b0d:	eb 16                	jmp    802b25 <initialize_dynamic_allocator+0x15d>
  802b0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	01 c0                	add    %eax,%eax
  802b16:	01 d0                	add    %edx,%eax
  802b18:	c1 e0 02             	shl    $0x2,%eax
  802b1b:	05 60 50 80 00       	add    $0x805060,%eax
  802b20:	a3 48 50 80 00       	mov    %eax,0x805048
  802b25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b28:	89 d0                	mov    %edx,%eax
  802b2a:	01 c0                	add    %eax,%eax
  802b2c:	01 d0                	add    %edx,%eax
  802b2e:	c1 e0 02             	shl    $0x2,%eax
  802b31:	05 60 50 80 00       	add    $0x805060,%eax
  802b36:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3e:	89 d0                	mov    %edx,%eax
  802b40:	01 c0                	add    %eax,%eax
  802b42:	01 d0                	add    %edx,%eax
  802b44:	c1 e0 02             	shl    $0x2,%eax
  802b47:	05 60 50 80 00       	add    $0x805060,%eax
  802b4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b52:	a1 54 50 80 00       	mov    0x805054,%eax
  802b57:	40                   	inc    %eax
  802b58:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802b5d:	ff 45 f0             	incl   -0x10(%ebp)
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b66:	0f 82 2c ff ff ff    	jb     802a98 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b72:	eb 2f                	jmp    802ba3 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802b74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b77:	89 d0                	mov    %edx,%eax
  802b79:	01 c0                	add    %eax,%eax
  802b7b:	01 d0                	add    %edx,%eax
  802b7d:	c1 e0 02             	shl    $0x2,%eax
  802b80:	05 68 50 80 00       	add    $0x805068,%eax
  802b85:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b8d:	89 d0                	mov    %edx,%eax
  802b8f:	01 c0                	add    %eax,%eax
  802b91:	01 d0                	add    %edx,%eax
  802b93:	c1 e0 02             	shl    $0x2,%eax
  802b96:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b9b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802ba0:	ff 45 ec             	incl   -0x14(%ebp)
  802ba3:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802baa:	76 c8                	jbe    802b74 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802bac:	90                   	nop
  802bad:	c9                   	leave  
  802bae:	c3                   	ret    

00802baf <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802baf:	55                   	push   %ebp
  802bb0:	89 e5                	mov    %esp,%ebp
  802bb2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802bbd:	29 c2                	sub    %eax,%edx
  802bbf:	89 d0                	mov    %edx,%eax
  802bc1:	c1 e8 0c             	shr    $0xc,%eax
  802bc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802bc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bca:	89 d0                	mov    %edx,%eax
  802bcc:	01 c0                	add    %eax,%eax
  802bce:	01 d0                	add    %edx,%eax
  802bd0:	c1 e0 02             	shl    $0x2,%eax
  802bd3:	05 68 50 80 00       	add    $0x805068,%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802bdd:	c9                   	leave  
  802bde:	c3                   	ret    

00802bdf <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802bdf:	55                   	push   %ebp
  802be0:	89 e5                	mov    %esp,%ebp
  802be2:	83 ec 14             	sub    $0x14,%esp
  802be5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802be8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802bec:	77 07                	ja     802bf5 <nearest_pow2_ceil.1513+0x16>
  802bee:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf3:	eb 20                	jmp    802c15 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802bf5:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802bfc:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802bff:	eb 08                	jmp    802c09 <nearest_pow2_ceil.1513+0x2a>
  802c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c04:	01 c0                	add    %eax,%eax
  802c06:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c09:	d1 6d 08             	shrl   0x8(%ebp)
  802c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c10:	75 ef                	jne    802c01 <nearest_pow2_ceil.1513+0x22>
        return power;
  802c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
  802c1a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802c1d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802c24:	76 16                	jbe    802c3c <alloc_block+0x25>
  802c26:	68 e4 46 80 00       	push   $0x8046e4
  802c2b:	68 ce 46 80 00       	push   $0x8046ce
  802c30:	6a 72                	push   $0x72
  802c32:	68 6b 46 80 00       	push   $0x80466b
  802c37:	e8 46 d8 ff ff       	call   800482 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c40:	75 0a                	jne    802c4c <alloc_block+0x35>
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax
  802c47:	e9 bd 04 00 00       	jmp    803109 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802c4c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c59:	73 06                	jae    802c61 <alloc_block+0x4a>
        size = min_block_size;
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c67:	ff 75 08             	pushl  0x8(%ebp)
  802c6a:	89 c1                	mov    %eax,%ecx
  802c6c:	e8 6e ff ff ff       	call   802bdf <nearest_pow2_ceil.1513>
  802c71:	83 c4 10             	add    $0x10,%esp
  802c74:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802c77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7a:	83 ec 0c             	sub    $0xc,%esp
  802c7d:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c80:	52                   	push   %edx
  802c81:	89 c1                	mov    %eax,%ecx
  802c83:	e8 83 04 00 00       	call   80310b <log2_ceil.1520>
  802c88:	83 c4 10             	add    $0x10,%esp
  802c8b:	83 e8 03             	sub    $0x3,%eax
  802c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	c1 e0 04             	shl    $0x4,%eax
  802c97:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	0f 84 d8 00 00 00    	je     802d7e <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca9:	c1 e0 04             	shl    $0x4,%eax
  802cac:	05 80 d0 81 00       	add    $0x81d080,%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802cb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cba:	75 17                	jne    802cd3 <alloc_block+0xbc>
  802cbc:	83 ec 04             	sub    $0x4,%esp
  802cbf:	68 05 47 80 00       	push   $0x804705
  802cc4:	68 98 00 00 00       	push   $0x98
  802cc9:	68 6b 46 80 00       	push   $0x80466b
  802cce:	e8 af d7 ff ff       	call   800482 <_panic>
  802cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 10                	je     802cec <alloc_block+0xd5>
  802cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdf:	8b 00                	mov    (%eax),%eax
  802ce1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce4:	8b 52 04             	mov    0x4(%edx),%edx
  802ce7:	89 50 04             	mov    %edx,0x4(%eax)
  802cea:	eb 14                	jmp    802d00 <alloc_block+0xe9>
  802cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf5:	c1 e2 04             	shl    $0x4,%edx
  802cf8:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802cfe:	89 02                	mov    %eax,(%edx)
  802d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d03:	8b 40 04             	mov    0x4(%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	74 0f                	je     802d19 <alloc_block+0x102>
  802d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0d:	8b 40 04             	mov    0x4(%eax),%eax
  802d10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d13:	8b 12                	mov    (%edx),%edx
  802d15:	89 10                	mov    %edx,(%eax)
  802d17:	eb 13                	jmp    802d2c <alloc_block+0x115>
  802d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d21:	c1 e2 04             	shl    $0x4,%edx
  802d24:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d2a:	89 02                	mov    %eax,(%edx)
  802d2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d42:	c1 e0 04             	shl    $0x4,%eax
  802d45:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d52:	c1 e0 04             	shl    $0x4,%eax
  802d55:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d5a:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5f:	83 ec 0c             	sub    $0xc,%esp
  802d62:	50                   	push   %eax
  802d63:	e8 12 fc ff ff       	call   80297a <to_page_info>
  802d68:	83 c4 10             	add    $0x10,%esp
  802d6b:	89 c2                	mov    %eax,%edx
  802d6d:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d71:	48                   	dec    %eax
  802d72:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d79:	e9 8b 03 00 00       	jmp    803109 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802d7e:	a1 48 50 80 00       	mov    0x805048,%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	0f 84 64 02 00 00    	je     802fef <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d8b:	a1 48 50 80 00       	mov    0x805048,%eax
  802d90:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d97:	75 17                	jne    802db0 <alloc_block+0x199>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 05 47 80 00       	push   $0x804705
  802da1:	68 a0 00 00 00       	push   $0xa0
  802da6:	68 6b 46 80 00       	push   $0x80466b
  802dab:	e8 d2 d6 ff ff       	call   800482 <_panic>
  802db0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 10                	je     802dc9 <alloc_block+0x1b2>
  802db9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dc1:	8b 52 04             	mov    0x4(%edx),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	eb 0b                	jmp    802dd4 <alloc_block+0x1bd>
  802dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802dd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 0f                	je     802ded <alloc_block+0x1d6>
  802dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de7:	8b 12                	mov    (%edx),%edx
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	eb 0a                	jmp    802df7 <alloc_block+0x1e0>
  802ded:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	a3 48 50 80 00       	mov    %eax,0x805048
  802df7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0a:	a1 54 50 80 00       	mov    0x805054,%eax
  802e0f:	48                   	dec    %eax
  802e10:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e1b:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802e1f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e24:	99                   	cltd   
  802e25:	f7 7d e8             	idivl  -0x18(%ebp)
  802e28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e2b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802e2f:	83 ec 0c             	sub    $0xc,%esp
  802e32:	ff 75 dc             	pushl  -0x24(%ebp)
  802e35:	e8 ce fa ff ff       	call   802908 <to_page_va>
  802e3a:	83 c4 10             	add    $0x10,%esp
  802e3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802e40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e43:	83 ec 0c             	sub    $0xc,%esp
  802e46:	50                   	push   %eax
  802e47:	e8 c0 ee ff ff       	call   801d0c <get_page>
  802e4c:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e56:	e9 aa 00 00 00       	jmp    802f05 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802e62:	89 c2                	mov    %eax,%edx
  802e64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e67:	01 d0                	add    %edx,%eax
  802e69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802e6c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e70:	75 17                	jne    802e89 <alloc_block+0x272>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 24 47 80 00       	push   $0x804724
  802e7a:	68 aa 00 00 00       	push   $0xaa
  802e7f:	68 6b 46 80 00       	push   $0x80466b
  802e84:	e8 f9 d5 ff ff       	call   800482 <_panic>
  802e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8c:	c1 e0 04             	shl    $0x4,%eax
  802e8f:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e94:	8b 10                	mov    (%eax),%edx
  802e96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e99:	89 50 04             	mov    %edx,0x4(%eax)
  802e9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 14                	je     802eba <alloc_block+0x2a3>
  802ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea9:	c1 e0 04             	shl    $0x4,%eax
  802eac:	05 84 d0 81 00       	add    $0x81d084,%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802eb6:	89 10                	mov    %edx,(%eax)
  802eb8:	eb 11                	jmp    802ecb <alloc_block+0x2b4>
  802eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebd:	c1 e0 04             	shl    $0x4,%eax
  802ec0:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802ec6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec9:	89 02                	mov    %eax,(%edx)
  802ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ece:	c1 e0 04             	shl    $0x4,%eax
  802ed1:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802ed7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eda:	89 02                	mov    %eax,(%edx)
  802edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802edf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee8:	c1 e0 04             	shl    $0x4,%eax
  802eeb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	8d 50 01             	lea    0x1(%eax),%edx
  802ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef8:	c1 e0 04             	shl    $0x4,%eax
  802efb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f00:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802f02:	ff 45 f4             	incl   -0xc(%ebp)
  802f05:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f0a:	99                   	cltd   
  802f0b:	f7 7d e8             	idivl  -0x18(%ebp)
  802f0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f11:	0f 8f 44 ff ff ff    	jg     802e5b <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1a:	c1 e0 04             	shl    $0x4,%eax
  802f1d:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802f27:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f2b:	75 17                	jne    802f44 <alloc_block+0x32d>
  802f2d:	83 ec 04             	sub    $0x4,%esp
  802f30:	68 05 47 80 00       	push   $0x804705
  802f35:	68 ae 00 00 00       	push   $0xae
  802f3a:	68 6b 46 80 00       	push   $0x80466b
  802f3f:	e8 3e d5 ff ff       	call   800482 <_panic>
  802f44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	74 10                	je     802f5d <alloc_block+0x346>
  802f4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f55:	8b 52 04             	mov    0x4(%edx),%edx
  802f58:	89 50 04             	mov    %edx,0x4(%eax)
  802f5b:	eb 14                	jmp    802f71 <alloc_block+0x35a>
  802f5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f66:	c1 e2 04             	shl    $0x4,%edx
  802f69:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f6f:	89 02                	mov    %eax,(%edx)
  802f71:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0f                	je     802f8a <alloc_block+0x373>
  802f7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f84:	8b 12                	mov    (%edx),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 13                	jmp    802f9d <alloc_block+0x386>
  802f8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f92:	c1 e2 04             	shl    $0x4,%edx
  802f95:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f9b:	89 02                	mov    %eax,(%edx)
  802f9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb3:	c1 e0 04             	shl    $0x4,%eax
  802fb6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  802fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc3:	c1 e0 04             	shl    $0x4,%eax
  802fc6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fcb:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802fcd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd0:	83 ec 0c             	sub    $0xc,%esp
  802fd3:	50                   	push   %eax
  802fd4:	e8 a1 f9 ff ff       	call   80297a <to_page_info>
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	89 c2                	mov    %eax,%edx
  802fde:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fe2:	48                   	dec    %eax
  802fe3:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fea:	e9 1a 01 00 00       	jmp    803109 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff2:	40                   	inc    %eax
  802ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ff6:	e9 ed 00 00 00       	jmp    8030e8 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	c1 e0 04             	shl    $0x4,%eax
  803001:	05 80 d0 81 00       	add    $0x81d080,%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	0f 84 d5 00 00 00    	je     8030e5 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803013:	c1 e0 04             	shl    $0x4,%eax
  803016:	05 80 d0 81 00       	add    $0x81d080,%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803020:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803024:	75 17                	jne    80303d <alloc_block+0x426>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 05 47 80 00       	push   $0x804705
  80302e:	68 b8 00 00 00       	push   $0xb8
  803033:	68 6b 46 80 00       	push   $0x80466b
  803038:	e8 45 d4 ff ff       	call   800482 <_panic>
  80303d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 10                	je     803056 <alloc_block+0x43f>
  803046:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80304e:	8b 52 04             	mov    0x4(%edx),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 14                	jmp    80306a <alloc_block+0x453>
  803056:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803059:	8b 40 04             	mov    0x4(%eax),%eax
  80305c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305f:	c1 e2 04             	shl    $0x4,%edx
  803062:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803068:	89 02                	mov    %eax,(%edx)
  80306a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0f                	je     803083 <alloc_block+0x46c>
  803074:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80307d:	8b 12                	mov    (%edx),%edx
  80307f:	89 10                	mov    %edx,(%eax)
  803081:	eb 13                	jmp    803096 <alloc_block+0x47f>
  803083:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80308b:	c1 e2 04             	shl    $0x4,%edx
  80308e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803094:	89 02                	mov    %eax,(%edx)
  803096:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	c1 e0 04             	shl    $0x4,%eax
  8030af:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bc:	c1 e0 04             	shl    $0x4,%eax
  8030bf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030c4:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8030c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c9:	83 ec 0c             	sub    $0xc,%esp
  8030cc:	50                   	push   %eax
  8030cd:	e8 a8 f8 ff ff       	call   80297a <to_page_info>
  8030d2:	83 c4 10             	add    $0x10,%esp
  8030d5:	89 c2                	mov    %eax,%edx
  8030d7:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8030db:	48                   	dec    %eax
  8030dc:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8030e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e3:	eb 24                	jmp    803109 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030e5:	ff 45 f0             	incl   -0x10(%ebp)
  8030e8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030ec:	0f 8e 09 ff ff ff    	jle    802ffb <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8030f2:	83 ec 04             	sub    $0x4,%esp
  8030f5:	68 47 47 80 00       	push   $0x804747
  8030fa:	68 bf 00 00 00       	push   $0xbf
  8030ff:	68 6b 46 80 00       	push   $0x80466b
  803104:	e8 79 d3 ff ff       	call   800482 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803109:	c9                   	leave  
  80310a:	c3                   	ret    

0080310b <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80310b:	55                   	push   %ebp
  80310c:	89 e5                	mov    %esp,%ebp
  80310e:	83 ec 14             	sub    $0x14,%esp
  803111:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803118:	75 07                	jne    803121 <log2_ceil.1520+0x16>
  80311a:	b8 00 00 00 00       	mov    $0x0,%eax
  80311f:	eb 1b                	jmp    80313c <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803128:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80312b:	eb 06                	jmp    803133 <log2_ceil.1520+0x28>
            x >>= 1;
  80312d:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803130:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803133:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803137:	75 f4                	jne    80312d <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803139:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80313c:	c9                   	leave  
  80313d:	c3                   	ret    

0080313e <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80313e:	55                   	push   %ebp
  80313f:	89 e5                	mov    %esp,%ebp
  803141:	83 ec 14             	sub    $0x14,%esp
  803144:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314b:	75 07                	jne    803154 <log2_ceil.1547+0x16>
  80314d:	b8 00 00 00 00       	mov    $0x0,%eax
  803152:	eb 1b                	jmp    80316f <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803154:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80315b:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80315e:	eb 06                	jmp    803166 <log2_ceil.1547+0x28>
			x >>= 1;
  803160:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803163:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316a:	75 f4                	jne    803160 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80316c:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80316f:	c9                   	leave  
  803170:	c3                   	ret    

00803171 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803171:	55                   	push   %ebp
  803172:	89 e5                	mov    %esp,%ebp
  803174:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803177:	8b 55 08             	mov    0x8(%ebp),%edx
  80317a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80317f:	39 c2                	cmp    %eax,%edx
  803181:	72 0c                	jb     80318f <free_block+0x1e>
  803183:	8b 55 08             	mov    0x8(%ebp),%edx
  803186:	a1 40 50 80 00       	mov    0x805040,%eax
  80318b:	39 c2                	cmp    %eax,%edx
  80318d:	72 19                	jb     8031a8 <free_block+0x37>
  80318f:	68 4c 47 80 00       	push   $0x80474c
  803194:	68 ce 46 80 00       	push   $0x8046ce
  803199:	68 d0 00 00 00       	push   $0xd0
  80319e:	68 6b 46 80 00       	push   $0x80466b
  8031a3:	e8 da d2 ff ff       	call   800482 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8031a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ac:	0f 84 42 03 00 00    	je     8034f4 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8031b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031ba:	39 c2                	cmp    %eax,%edx
  8031bc:	72 0c                	jb     8031ca <free_block+0x59>
  8031be:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c1:	a1 40 50 80 00       	mov    0x805040,%eax
  8031c6:	39 c2                	cmp    %eax,%edx
  8031c8:	72 17                	jb     8031e1 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 84 47 80 00       	push   $0x804784
  8031d2:	68 e6 00 00 00       	push   $0xe6
  8031d7:	68 6b 46 80 00       	push   $0x80466b
  8031dc:	e8 a1 d2 ff ff       	call   800482 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8031e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031e9:	29 c2                	sub    %eax,%edx
  8031eb:	89 d0                	mov    %edx,%eax
  8031ed:	83 e0 07             	and    $0x7,%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 17                	je     80320b <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 b8 47 80 00       	push   $0x8047b8
  8031fc:	68 ea 00 00 00       	push   $0xea
  803201:	68 6b 46 80 00       	push   $0x80466b
  803206:	e8 77 d2 ff ff       	call   800482 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	83 ec 0c             	sub    $0xc,%esp
  803211:	50                   	push   %eax
  803212:	e8 63 f7 ff ff       	call   80297a <to_page_info>
  803217:	83 c4 10             	add    $0x10,%esp
  80321a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80321d:	83 ec 0c             	sub    $0xc,%esp
  803220:	ff 75 08             	pushl  0x8(%ebp)
  803223:	e8 87 f9 ff ff       	call   802baf <get_block_size>
  803228:	83 c4 10             	add    $0x10,%esp
  80322b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80322e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803232:	75 17                	jne    80324b <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803234:	83 ec 04             	sub    $0x4,%esp
  803237:	68 e4 47 80 00       	push   $0x8047e4
  80323c:	68 f1 00 00 00       	push   $0xf1
  803241:	68 6b 46 80 00       	push   $0x80466b
  803246:	e8 37 d2 ff ff       	call   800482 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80324b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324e:	83 ec 0c             	sub    $0xc,%esp
  803251:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803254:	52                   	push   %edx
  803255:	89 c1                	mov    %eax,%ecx
  803257:	e8 e2 fe ff ff       	call   80313e <log2_ceil.1547>
  80325c:	83 c4 10             	add    $0x10,%esp
  80325f:	83 e8 03             	sub    $0x3,%eax
  803262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80326b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80326f:	75 17                	jne    803288 <free_block+0x117>
  803271:	83 ec 04             	sub    $0x4,%esp
  803274:	68 30 48 80 00       	push   $0x804830
  803279:	68 f6 00 00 00       	push   $0xf6
  80327e:	68 6b 46 80 00       	push   $0x80466b
  803283:	e8 fa d1 ff ff       	call   800482 <_panic>
  803288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328b:	c1 e0 04             	shl    $0x4,%eax
  80328e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803293:	8b 10                	mov    (%eax),%edx
  803295:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	74 15                	je     8032b8 <free_block+0x147>
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	c1 e0 04             	shl    $0x4,%eax
  8032a9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b3:	89 50 04             	mov    %edx,0x4(%eax)
  8032b6:	eb 11                	jmp    8032c9 <free_block+0x158>
  8032b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bb:	c1 e0 04             	shl    $0x4,%eax
  8032be:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8032c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c7:	89 02                	mov    %eax,(%edx)
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	c1 e0 04             	shl    $0x4,%eax
  8032cf:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8032d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d8:	89 02                	mov    %eax,(%edx)
  8032da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e7:	c1 e0 04             	shl    $0x4,%eax
  8032ea:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	8d 50 01             	lea    0x1(%eax),%edx
  8032f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f7:	c1 e0 04             	shl    $0x4,%eax
  8032fa:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032ff:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803301:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803304:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803308:	40                   	inc    %eax
  803309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80330c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803310:	8b 55 08             	mov    0x8(%ebp),%edx
  803313:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803318:	29 c2                	sub    %eax,%edx
  80331a:	89 d0                	mov    %edx,%eax
  80331c:	c1 e8 0c             	shr    $0xc,%eax
  80331f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803325:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803329:	0f b7 c8             	movzwl %ax,%ecx
  80332c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803331:	99                   	cltd   
  803332:	f7 7d e8             	idivl  -0x18(%ebp)
  803335:	39 c1                	cmp    %eax,%ecx
  803337:	0f 85 b8 01 00 00    	jne    8034f5 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80333d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803347:	c1 e0 04             	shl    $0x4,%eax
  80334a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803354:	e9 d5 00 00 00       	jmp    80342e <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803361:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803364:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803369:	29 c2                	sub    %eax,%edx
  80336b:	89 d0                	mov    %edx,%eax
  80336d:	c1 e8 0c             	shr    $0xc,%eax
  803370:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803373:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803376:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803379:	0f 85 a9 00 00 00    	jne    803428 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80337f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803383:	75 17                	jne    80339c <free_block+0x22b>
  803385:	83 ec 04             	sub    $0x4,%esp
  803388:	68 05 47 80 00       	push   $0x804705
  80338d:	68 04 01 00 00       	push   $0x104
  803392:	68 6b 46 80 00       	push   $0x80466b
  803397:	e8 e6 d0 ff ff       	call   800482 <_panic>
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 10                	je     8033b5 <free_block+0x244>
  8033a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033ad:	8b 52 04             	mov    0x4(%edx),%edx
  8033b0:	89 50 04             	mov    %edx,0x4(%eax)
  8033b3:	eb 14                	jmp    8033c9 <free_block+0x258>
  8033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b8:	8b 40 04             	mov    0x4(%eax),%eax
  8033bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033be:	c1 e2 04             	shl    $0x4,%edx
  8033c1:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8033c7:	89 02                	mov    %eax,(%edx)
  8033c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cc:	8b 40 04             	mov    0x4(%eax),%eax
  8033cf:	85 c0                	test   %eax,%eax
  8033d1:	74 0f                	je     8033e2 <free_block+0x271>
  8033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033dc:	8b 12                	mov    (%edx),%edx
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	eb 13                	jmp    8033f5 <free_block+0x284>
  8033e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ea:	c1 e2 04             	shl    $0x4,%edx
  8033ed:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033f3:	89 02                	mov    %eax,(%edx)
  8033f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340b:	c1 e0 04             	shl    $0x4,%eax
  80340e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	8d 50 ff             	lea    -0x1(%eax),%edx
  803418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341b:	c1 e0 04             	shl    $0x4,%eax
  80341e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803423:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803425:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803428:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80342b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80342e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803432:	0f 85 21 ff ff ff    	jne    803359 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803438:	b8 00 10 00 00       	mov    $0x1000,%eax
  80343d:	99                   	cltd   
  80343e:	f7 7d e8             	idivl  -0x18(%ebp)
  803441:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803444:	74 17                	je     80345d <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803446:	83 ec 04             	sub    $0x4,%esp
  803449:	68 54 48 80 00       	push   $0x804854
  80344e:	68 0c 01 00 00       	push   $0x10c
  803453:	68 6b 46 80 00       	push   $0x80466b
  803458:	e8 25 d0 ff ff       	call   800482 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80345d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803460:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803469:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80346f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803473:	75 17                	jne    80348c <free_block+0x31b>
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 24 47 80 00       	push   $0x804724
  80347d:	68 11 01 00 00       	push   $0x111
  803482:	68 6b 46 80 00       	push   $0x80466b
  803487:	e8 f6 cf ff ff       	call   800482 <_panic>
  80348c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803495:	89 50 04             	mov    %edx,0x4(%eax)
  803498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0c                	je     8034ae <free_block+0x33d>
  8034a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8034a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	eb 08                	jmp    8034b6 <free_block+0x345>
  8034ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b1:	a3 48 50 80 00       	mov    %eax,0x805048
  8034b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b9:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8034be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c7:	a1 54 50 80 00       	mov    0x805054,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8034d2:	83 ec 0c             	sub    $0xc,%esp
  8034d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8034d8:	e8 2b f4 ff ff       	call   802908 <to_page_va>
  8034dd:	83 c4 10             	add    $0x10,%esp
  8034e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8034e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034e6:	83 ec 0c             	sub    $0xc,%esp
  8034e9:	50                   	push   %eax
  8034ea:	e8 69 e8 ff ff       	call   801d58 <return_page>
  8034ef:	83 c4 10             	add    $0x10,%esp
  8034f2:	eb 01                	jmp    8034f5 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034f4:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
  8034fa:	83 ec 14             	sub    $0x14,%esp
  8034fd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803500:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803504:	77 07                	ja     80350d <nearest_pow2_ceil.1572+0x16>
      return 1;
  803506:	b8 01 00 00 00       	mov    $0x1,%eax
  80350b:	eb 20                	jmp    80352d <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80350d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803514:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803517:	eb 08                	jmp    803521 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80351c:	01 c0                	add    %eax,%eax
  80351e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803521:	d1 6d 08             	shrl   0x8(%ebp)
  803524:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803528:	75 ef                	jne    803519 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80352a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80352d:	c9                   	leave  
  80352e:	c3                   	ret    

0080352f <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80352f:	55                   	push   %ebp
  803530:	89 e5                	mov    %esp,%ebp
  803532:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803535:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803539:	75 13                	jne    80354e <realloc_block+0x1f>
    return alloc_block(new_size);
  80353b:	83 ec 0c             	sub    $0xc,%esp
  80353e:	ff 75 0c             	pushl  0xc(%ebp)
  803541:	e8 d1 f6 ff ff       	call   802c17 <alloc_block>
  803546:	83 c4 10             	add    $0x10,%esp
  803549:	e9 d9 00 00 00       	jmp    803627 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80354e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803552:	75 18                	jne    80356c <realloc_block+0x3d>
    free_block(va);
  803554:	83 ec 0c             	sub    $0xc,%esp
  803557:	ff 75 08             	pushl  0x8(%ebp)
  80355a:	e8 12 fc ff ff       	call   803171 <free_block>
  80355f:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803562:	b8 00 00 00 00       	mov    $0x0,%eax
  803567:	e9 bb 00 00 00       	jmp    803627 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80356c:	83 ec 0c             	sub    $0xc,%esp
  80356f:	ff 75 08             	pushl  0x8(%ebp)
  803572:	e8 38 f6 ff ff       	call   802baf <get_block_size>
  803577:	83 c4 10             	add    $0x10,%esp
  80357a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80357d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803584:	8b 45 0c             	mov    0xc(%ebp),%eax
  803587:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80358a:	73 06                	jae    803592 <realloc_block+0x63>
    new_size = min_block_size;
  80358c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358f:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803592:	83 ec 0c             	sub    $0xc,%esp
  803595:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803598:	ff 75 0c             	pushl  0xc(%ebp)
  80359b:	89 c1                	mov    %eax,%ecx
  80359d:	e8 55 ff ff ff       	call   8034f7 <nearest_pow2_ceil.1572>
  8035a2:	83 c4 10             	add    $0x10,%esp
  8035a5:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8035a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035ae:	75 05                	jne    8035b5 <realloc_block+0x86>
    return va;
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	eb 72                	jmp    803627 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8035b5:	83 ec 0c             	sub    $0xc,%esp
  8035b8:	ff 75 0c             	pushl  0xc(%ebp)
  8035bb:	e8 57 f6 ff ff       	call   802c17 <alloc_block>
  8035c0:	83 c4 10             	add    $0x10,%esp
  8035c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8035c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ca:	75 07                	jne    8035d3 <realloc_block+0xa4>
    return NULL;
  8035cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d1:	eb 54                	jmp    803627 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8035d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d9:	39 d0                	cmp    %edx,%eax
  8035db:	76 02                	jbe    8035df <realloc_block+0xb0>
  8035dd:	89 d0                	mov    %edx,%eax
  8035df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8035e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8035ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035f5:	eb 17                	jmp    80360e <realloc_block+0xdf>
    dst[i] = src[i];
  8035f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	01 c2                	add    %eax,%edx
  8035ff:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	01 c8                	add    %ecx,%eax
  803607:	8a 00                	mov    (%eax),%al
  803609:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80360b:	ff 45 f4             	incl   -0xc(%ebp)
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803614:	72 e1                	jb     8035f7 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803616:	83 ec 0c             	sub    $0xc,%esp
  803619:	ff 75 08             	pushl  0x8(%ebp)
  80361c:	e8 50 fb ff ff       	call   803171 <free_block>
  803621:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803627:	c9                   	leave  
  803628:	c3                   	ret    
  803629:	66 90                	xchg   %ax,%ax
  80362b:	90                   	nop

0080362c <__udivdi3>:
  80362c:	55                   	push   %ebp
  80362d:	57                   	push   %edi
  80362e:	56                   	push   %esi
  80362f:	53                   	push   %ebx
  803630:	83 ec 1c             	sub    $0x1c,%esp
  803633:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803637:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80363b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80363f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803643:	89 ca                	mov    %ecx,%edx
  803645:	89 f8                	mov    %edi,%eax
  803647:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80364b:	85 f6                	test   %esi,%esi
  80364d:	75 2d                	jne    80367c <__udivdi3+0x50>
  80364f:	39 cf                	cmp    %ecx,%edi
  803651:	77 65                	ja     8036b8 <__udivdi3+0x8c>
  803653:	89 fd                	mov    %edi,%ebp
  803655:	85 ff                	test   %edi,%edi
  803657:	75 0b                	jne    803664 <__udivdi3+0x38>
  803659:	b8 01 00 00 00       	mov    $0x1,%eax
  80365e:	31 d2                	xor    %edx,%edx
  803660:	f7 f7                	div    %edi
  803662:	89 c5                	mov    %eax,%ebp
  803664:	31 d2                	xor    %edx,%edx
  803666:	89 c8                	mov    %ecx,%eax
  803668:	f7 f5                	div    %ebp
  80366a:	89 c1                	mov    %eax,%ecx
  80366c:	89 d8                	mov    %ebx,%eax
  80366e:	f7 f5                	div    %ebp
  803670:	89 cf                	mov    %ecx,%edi
  803672:	89 fa                	mov    %edi,%edx
  803674:	83 c4 1c             	add    $0x1c,%esp
  803677:	5b                   	pop    %ebx
  803678:	5e                   	pop    %esi
  803679:	5f                   	pop    %edi
  80367a:	5d                   	pop    %ebp
  80367b:	c3                   	ret    
  80367c:	39 ce                	cmp    %ecx,%esi
  80367e:	77 28                	ja     8036a8 <__udivdi3+0x7c>
  803680:	0f bd fe             	bsr    %esi,%edi
  803683:	83 f7 1f             	xor    $0x1f,%edi
  803686:	75 40                	jne    8036c8 <__udivdi3+0x9c>
  803688:	39 ce                	cmp    %ecx,%esi
  80368a:	72 0a                	jb     803696 <__udivdi3+0x6a>
  80368c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803690:	0f 87 9e 00 00 00    	ja     803734 <__udivdi3+0x108>
  803696:	b8 01 00 00 00       	mov    $0x1,%eax
  80369b:	89 fa                	mov    %edi,%edx
  80369d:	83 c4 1c             	add    $0x1c,%esp
  8036a0:	5b                   	pop    %ebx
  8036a1:	5e                   	pop    %esi
  8036a2:	5f                   	pop    %edi
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    
  8036a5:	8d 76 00             	lea    0x0(%esi),%esi
  8036a8:	31 ff                	xor    %edi,%edi
  8036aa:	31 c0                	xor    %eax,%eax
  8036ac:	89 fa                	mov    %edi,%edx
  8036ae:	83 c4 1c             	add    $0x1c,%esp
  8036b1:	5b                   	pop    %ebx
  8036b2:	5e                   	pop    %esi
  8036b3:	5f                   	pop    %edi
  8036b4:	5d                   	pop    %ebp
  8036b5:	c3                   	ret    
  8036b6:	66 90                	xchg   %ax,%ax
  8036b8:	89 d8                	mov    %ebx,%eax
  8036ba:	f7 f7                	div    %edi
  8036bc:	31 ff                	xor    %edi,%edi
  8036be:	89 fa                	mov    %edi,%edx
  8036c0:	83 c4 1c             	add    $0x1c,%esp
  8036c3:	5b                   	pop    %ebx
  8036c4:	5e                   	pop    %esi
  8036c5:	5f                   	pop    %edi
  8036c6:	5d                   	pop    %ebp
  8036c7:	c3                   	ret    
  8036c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036cd:	89 eb                	mov    %ebp,%ebx
  8036cf:	29 fb                	sub    %edi,%ebx
  8036d1:	89 f9                	mov    %edi,%ecx
  8036d3:	d3 e6                	shl    %cl,%esi
  8036d5:	89 c5                	mov    %eax,%ebp
  8036d7:	88 d9                	mov    %bl,%cl
  8036d9:	d3 ed                	shr    %cl,%ebp
  8036db:	89 e9                	mov    %ebp,%ecx
  8036dd:	09 f1                	or     %esi,%ecx
  8036df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036e3:	89 f9                	mov    %edi,%ecx
  8036e5:	d3 e0                	shl    %cl,%eax
  8036e7:	89 c5                	mov    %eax,%ebp
  8036e9:	89 d6                	mov    %edx,%esi
  8036eb:	88 d9                	mov    %bl,%cl
  8036ed:	d3 ee                	shr    %cl,%esi
  8036ef:	89 f9                	mov    %edi,%ecx
  8036f1:	d3 e2                	shl    %cl,%edx
  8036f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f7:	88 d9                	mov    %bl,%cl
  8036f9:	d3 e8                	shr    %cl,%eax
  8036fb:	09 c2                	or     %eax,%edx
  8036fd:	89 d0                	mov    %edx,%eax
  8036ff:	89 f2                	mov    %esi,%edx
  803701:	f7 74 24 0c          	divl   0xc(%esp)
  803705:	89 d6                	mov    %edx,%esi
  803707:	89 c3                	mov    %eax,%ebx
  803709:	f7 e5                	mul    %ebp
  80370b:	39 d6                	cmp    %edx,%esi
  80370d:	72 19                	jb     803728 <__udivdi3+0xfc>
  80370f:	74 0b                	je     80371c <__udivdi3+0xf0>
  803711:	89 d8                	mov    %ebx,%eax
  803713:	31 ff                	xor    %edi,%edi
  803715:	e9 58 ff ff ff       	jmp    803672 <__udivdi3+0x46>
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803720:	89 f9                	mov    %edi,%ecx
  803722:	d3 e2                	shl    %cl,%edx
  803724:	39 c2                	cmp    %eax,%edx
  803726:	73 e9                	jae    803711 <__udivdi3+0xe5>
  803728:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80372b:	31 ff                	xor    %edi,%edi
  80372d:	e9 40 ff ff ff       	jmp    803672 <__udivdi3+0x46>
  803732:	66 90                	xchg   %ax,%ax
  803734:	31 c0                	xor    %eax,%eax
  803736:	e9 37 ff ff ff       	jmp    803672 <__udivdi3+0x46>
  80373b:	90                   	nop

0080373c <__umoddi3>:
  80373c:	55                   	push   %ebp
  80373d:	57                   	push   %edi
  80373e:	56                   	push   %esi
  80373f:	53                   	push   %ebx
  803740:	83 ec 1c             	sub    $0x1c,%esp
  803743:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803747:	8b 74 24 34          	mov    0x34(%esp),%esi
  80374b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80374f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803753:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803757:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80375b:	89 f3                	mov    %esi,%ebx
  80375d:	89 fa                	mov    %edi,%edx
  80375f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803763:	89 34 24             	mov    %esi,(%esp)
  803766:	85 c0                	test   %eax,%eax
  803768:	75 1a                	jne    803784 <__umoddi3+0x48>
  80376a:	39 f7                	cmp    %esi,%edi
  80376c:	0f 86 a2 00 00 00    	jbe    803814 <__umoddi3+0xd8>
  803772:	89 c8                	mov    %ecx,%eax
  803774:	89 f2                	mov    %esi,%edx
  803776:	f7 f7                	div    %edi
  803778:	89 d0                	mov    %edx,%eax
  80377a:	31 d2                	xor    %edx,%edx
  80377c:	83 c4 1c             	add    $0x1c,%esp
  80377f:	5b                   	pop    %ebx
  803780:	5e                   	pop    %esi
  803781:	5f                   	pop    %edi
  803782:	5d                   	pop    %ebp
  803783:	c3                   	ret    
  803784:	39 f0                	cmp    %esi,%eax
  803786:	0f 87 ac 00 00 00    	ja     803838 <__umoddi3+0xfc>
  80378c:	0f bd e8             	bsr    %eax,%ebp
  80378f:	83 f5 1f             	xor    $0x1f,%ebp
  803792:	0f 84 ac 00 00 00    	je     803844 <__umoddi3+0x108>
  803798:	bf 20 00 00 00       	mov    $0x20,%edi
  80379d:	29 ef                	sub    %ebp,%edi
  80379f:	89 fe                	mov    %edi,%esi
  8037a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037a5:	89 e9                	mov    %ebp,%ecx
  8037a7:	d3 e0                	shl    %cl,%eax
  8037a9:	89 d7                	mov    %edx,%edi
  8037ab:	89 f1                	mov    %esi,%ecx
  8037ad:	d3 ef                	shr    %cl,%edi
  8037af:	09 c7                	or     %eax,%edi
  8037b1:	89 e9                	mov    %ebp,%ecx
  8037b3:	d3 e2                	shl    %cl,%edx
  8037b5:	89 14 24             	mov    %edx,(%esp)
  8037b8:	89 d8                	mov    %ebx,%eax
  8037ba:	d3 e0                	shl    %cl,%eax
  8037bc:	89 c2                	mov    %eax,%edx
  8037be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037c2:	d3 e0                	shl    %cl,%eax
  8037c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037cc:	89 f1                	mov    %esi,%ecx
  8037ce:	d3 e8                	shr    %cl,%eax
  8037d0:	09 d0                	or     %edx,%eax
  8037d2:	d3 eb                	shr    %cl,%ebx
  8037d4:	89 da                	mov    %ebx,%edx
  8037d6:	f7 f7                	div    %edi
  8037d8:	89 d3                	mov    %edx,%ebx
  8037da:	f7 24 24             	mull   (%esp)
  8037dd:	89 c6                	mov    %eax,%esi
  8037df:	89 d1                	mov    %edx,%ecx
  8037e1:	39 d3                	cmp    %edx,%ebx
  8037e3:	0f 82 87 00 00 00    	jb     803870 <__umoddi3+0x134>
  8037e9:	0f 84 91 00 00 00    	je     803880 <__umoddi3+0x144>
  8037ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037f3:	29 f2                	sub    %esi,%edx
  8037f5:	19 cb                	sbb    %ecx,%ebx
  8037f7:	89 d8                	mov    %ebx,%eax
  8037f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037fd:	d3 e0                	shl    %cl,%eax
  8037ff:	89 e9                	mov    %ebp,%ecx
  803801:	d3 ea                	shr    %cl,%edx
  803803:	09 d0                	or     %edx,%eax
  803805:	89 e9                	mov    %ebp,%ecx
  803807:	d3 eb                	shr    %cl,%ebx
  803809:	89 da                	mov    %ebx,%edx
  80380b:	83 c4 1c             	add    $0x1c,%esp
  80380e:	5b                   	pop    %ebx
  80380f:	5e                   	pop    %esi
  803810:	5f                   	pop    %edi
  803811:	5d                   	pop    %ebp
  803812:	c3                   	ret    
  803813:	90                   	nop
  803814:	89 fd                	mov    %edi,%ebp
  803816:	85 ff                	test   %edi,%edi
  803818:	75 0b                	jne    803825 <__umoddi3+0xe9>
  80381a:	b8 01 00 00 00       	mov    $0x1,%eax
  80381f:	31 d2                	xor    %edx,%edx
  803821:	f7 f7                	div    %edi
  803823:	89 c5                	mov    %eax,%ebp
  803825:	89 f0                	mov    %esi,%eax
  803827:	31 d2                	xor    %edx,%edx
  803829:	f7 f5                	div    %ebp
  80382b:	89 c8                	mov    %ecx,%eax
  80382d:	f7 f5                	div    %ebp
  80382f:	89 d0                	mov    %edx,%eax
  803831:	e9 44 ff ff ff       	jmp    80377a <__umoddi3+0x3e>
  803836:	66 90                	xchg   %ax,%ax
  803838:	89 c8                	mov    %ecx,%eax
  80383a:	89 f2                	mov    %esi,%edx
  80383c:	83 c4 1c             	add    $0x1c,%esp
  80383f:	5b                   	pop    %ebx
  803840:	5e                   	pop    %esi
  803841:	5f                   	pop    %edi
  803842:	5d                   	pop    %ebp
  803843:	c3                   	ret    
  803844:	3b 04 24             	cmp    (%esp),%eax
  803847:	72 06                	jb     80384f <__umoddi3+0x113>
  803849:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80384d:	77 0f                	ja     80385e <__umoddi3+0x122>
  80384f:	89 f2                	mov    %esi,%edx
  803851:	29 f9                	sub    %edi,%ecx
  803853:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803857:	89 14 24             	mov    %edx,(%esp)
  80385a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80385e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803862:	8b 14 24             	mov    (%esp),%edx
  803865:	83 c4 1c             	add    $0x1c,%esp
  803868:	5b                   	pop    %ebx
  803869:	5e                   	pop    %esi
  80386a:	5f                   	pop    %edi
  80386b:	5d                   	pop    %ebp
  80386c:	c3                   	ret    
  80386d:	8d 76 00             	lea    0x0(%esi),%esi
  803870:	2b 04 24             	sub    (%esp),%eax
  803873:	19 fa                	sbb    %edi,%edx
  803875:	89 d1                	mov    %edx,%ecx
  803877:	89 c6                	mov    %eax,%esi
  803879:	e9 71 ff ff ff       	jmp    8037ef <__umoddi3+0xb3>
  80387e:	66 90                	xchg   %ax,%ax
  803880:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803884:	72 ea                	jb     803870 <__umoddi3+0x134>
  803886:	89 d9                	mov    %ebx,%ecx
  803888:	e9 62 ff ff ff       	jmp    8037ef <__umoddi3+0xb3>
