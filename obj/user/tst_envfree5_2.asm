
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 7b 02 00 00       	call   8002b1 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 40 39 80 00       	push   $0x803940
  800050:	e8 e5 1f 00 00       	call   80203a <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 43 3b 80 00       	mov    $0x803b43,%ebx
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
  8000a1:	e8 b4 27 00 00       	call   80285a <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 ad 23 00 00       	call   80245b <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 f0 23 00 00       	call   8024a6 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 50 39 80 00       	push   $0x803950
  8000c4:	e8 86 06 00 00       	call   80074f <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,100, 50);
  8000cc:	6a 32                	push   $0x32
  8000ce:	6a 64                	push   $0x64
  8000d0:	68 b8 0b 00 00       	push   $0xbb8
  8000d5:	68 83 39 80 00       	push   $0x803983
  8000da:	e8 d7 24 00 00       	call   8025b6 <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 3000,100, 50);
  8000e5:	6a 32                	push   $0x32
  8000e7:	6a 64                	push   $0x64
  8000e9:	68 b8 0b 00 00       	push   $0xbb8
  8000ee:	68 8c 39 80 00       	push   $0x80398c
  8000f3:	e8 be 24 00 00       	call   8025b6 <sys_create_env>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 d8             	pushl  -0x28(%ebp)
  800104:	e8 cb 24 00 00       	call   8025d4 <sys_run_env>
  800109:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 98 3a 00 00       	push   $0x3a98
  800114:	e8 ef 34 00 00       	call   803608 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800122:	e8 ad 24 00 00       	call   8025d4 <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80012a:	90                   	nop
  80012b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	83 f8 02             	cmp    $0x2,%eax
  800133:	75 f6                	jne    80012b <_main+0xf3>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800135:	e8 21 23 00 00       	call   80245b <sys_calculate_free_frames>
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 98 39 80 00       	push   $0x803998
  800143:	e8 07 06 00 00       	call   80074f <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80014b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 f9 26 00 00       	call   80285a <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	bb a7 3b 80 00       	mov    $0x803ba7,%ebx
  80016f:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  800182:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	6a 00                	push   $0x0
  800192:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 bc 26 00 00       	call   80285a <sys_utilities>
  80019e:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a7:	e8 44 24 00 00       	call   8025f0 <sys_destroy_env>
  8001ac:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b5:	e8 36 24 00 00       	call   8025f0 <sys_destroy_env>
  8001ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	6a 01                	push   $0x1
  8001c2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 8c 26 00 00       	call   80285a <sys_utilities>
  8001ce:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001d1:	e8 85 22 00 00       	call   80245b <sys_calculate_free_frames>
  8001d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d9:	e8 c8 22 00 00       	call   8024a6 <sys_pf_calculate_allocated_pages>
  8001de:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001e1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001e8:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  8001ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	48                   	dec    %eax
  8001f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ff:	f7 75 c8             	divl   -0x38(%ebp)
  800202:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800205:	29 d0                	sub    %edx,%eax
  800207:	89 c1                	mov    %eax,%ecx
  800209:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800210:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800216:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	48                   	dec    %eax
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80021f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800222:	ba 00 00 00 00       	mov    $0x0,%edx
  800227:	f7 75 c0             	divl   -0x40(%ebp)
  80022a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80022d:	29 d0                	sub    %edx,%eax
  80022f:	29 c1                	sub    %eax,%ecx
  800231:	89 c8                	mov    %ecx,%eax
  800233:	c1 e8 0c             	shr    $0xc,%eax
  800236:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 b8             	pushl  -0x48(%ebp)
  80023f:	68 ca 39 80 00       	push   $0x8039ca
  800244:	e8 06 05 00 00       	call   80074f <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800252:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800255:	74 2e                	je     800285 <_main+0x24d>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	50                   	push   %eax
  800261:	ff 75 d0             	pushl  -0x30(%ebp)
  800264:	68 dc 39 80 00       	push   $0x8039dc
  800269:	e8 e1 04 00 00       	call   80074f <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 4c 3a 80 00       	push   $0x803a4c
  800279:	6a 36                	push   $0x36
  80027b:	68 82 3a 80 00       	push   $0x803a82
  800280:	e8 dc 01 00 00       	call   800461 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	ff 75 d0             	pushl  -0x30(%ebp)
  80028b:	68 98 3a 80 00       	push   $0x803a98
  800290:	e8 ba 04 00 00       	call   80074f <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 f8 3a 80 00       	push   $0x803af8
  8002a0:	e8 aa 04 00 00       	call   80074f <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	return;
  8002a8:	90                   	nop
}
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ba:	e8 65 23 00 00       	call   802624 <sys_getenvindex>
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	01 d0                	add    %edx,%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	c1 e0 02             	shl    $0x2,%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	c1 e0 03             	shl    $0x3,%eax
  8002d8:	01 d0                	add    %edx,%eax
  8002da:	c1 e0 02             	shl    $0x2,%eax
  8002dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8a 40 20             	mov    0x20(%eax),%al
  8002ef:	84 c0                	test   %al,%al
  8002f1:	74 0d                	je     800300 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f8:	83 c0 20             	add    $0x20,%eax
  8002fb:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800304:	7e 0a                	jle    800310 <libmain+0x5f>
		binaryname = argv[0];
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 0c             	pushl  0xc(%ebp)
  800316:	ff 75 08             	pushl  0x8(%ebp)
  800319:	e8 1a fd ff ff       	call   800038 <_main>
  80031e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800321:	a1 00 50 80 00       	mov    0x805000,%eax
  800326:	85 c0                	test   %eax,%eax
  800328:	0f 84 01 01 00 00    	je     80042f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80032e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800334:	bb 04 3d 80 00       	mov    $0x803d04,%ebx
  800339:	ba 0e 00 00 00       	mov    $0xe,%edx
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 de                	mov    %ebx,%esi
  800342:	89 d1                	mov    %edx,%ecx
  800344:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800346:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800349:	b9 56 00 00 00       	mov    $0x56,%ecx
  80034e:	b0 00                	mov    $0x0,%al
  800350:	89 d7                	mov    %edx,%edi
  800352:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800354:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80035b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	50                   	push   %eax
  800362:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800368:	50                   	push   %eax
  800369:	e8 ec 24 00 00       	call   80285a <sys_utilities>
  80036e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800371:	e8 35 20 00 00       	call   8023ab <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	68 24 3c 80 00       	push   $0x803c24
  80037e:	e8 cc 03 00 00       	call   80074f <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	85 c0                	test   %eax,%eax
  80038b:	74 18                	je     8003a5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80038d:	e8 e6 24 00 00       	call   802878 <sys_get_optimal_num_faults>
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	50                   	push   %eax
  800396:	68 4c 3c 80 00       	push   $0x803c4c
  80039b:	e8 af 03 00 00       	call   80074f <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp
  8003a3:	eb 59                	jmp    8003fe <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003aa:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b5:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	52                   	push   %edx
  8003bf:	50                   	push   %eax
  8003c0:	68 70 3c 80 00       	push   $0x803c70
  8003c5:	e8 85 03 00 00       	call   80074f <cprintf>
  8003ca:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d2:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003dd:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e8:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003ee:	51                   	push   %ecx
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	68 98 3c 80 00       	push   $0x803c98
  8003f6:	e8 54 03 00 00       	call   80074f <cprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800403:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	50                   	push   %eax
  80040d:	68 f0 3c 80 00       	push   $0x803cf0
  800412:	e8 38 03 00 00       	call   80074f <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 24 3c 80 00       	push   $0x803c24
  800422:	e8 28 03 00 00       	call   80074f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80042a:	e8 96 1f 00 00       	call   8023c5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80042f:	e8 1f 00 00 00       	call   800453 <exit>
}
  800434:	90                   	nop
  800435:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800438:	5b                   	pop    %ebx
  800439:	5e                   	pop    %esi
  80043a:	5f                   	pop    %edi
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	6a 00                	push   $0x0
  800448:	e8 a3 21 00 00       	call   8025f0 <sys_destroy_env>
  80044d:	83 c4 10             	add    $0x10,%esp
}
  800450:	90                   	nop
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <exit>:

void
exit(void)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800459:	e8 f8 21 00 00       	call   802656 <sys_exit_env>
}
  80045e:	90                   	nop
  80045f:	c9                   	leave  
  800460:	c3                   	ret    

00800461 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800467:	8d 45 10             	lea    0x10(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800470:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800475:	85 c0                	test   %eax,%eax
  800477:	74 16                	je     80048f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800479:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	50                   	push   %eax
  800482:	68 68 3d 80 00       	push   $0x803d68
  800487:	e8 c3 02 00 00       	call   80074f <cprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80048f:	a1 04 50 80 00       	mov    0x805004,%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	ff 75 08             	pushl  0x8(%ebp)
  80049d:	50                   	push   %eax
  80049e:	68 70 3d 80 00       	push   $0x803d70
  8004a3:	6a 74                	push   $0x74
  8004a5:	e8 d2 02 00 00       	call   80077c <cprintf_colored>
  8004aa:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b6:	50                   	push   %eax
  8004b7:	e8 24 02 00 00       	call   8006e0 <vcprintf>
  8004bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	6a 00                	push   $0x0
  8004c4:	68 98 3d 80 00       	push   $0x803d98
  8004c9:	e8 12 02 00 00       	call   8006e0 <vcprintf>
  8004ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d1:	e8 7d ff ff ff       	call   800453 <exit>

	// should not return here
	while (1) ;
  8004d6:	eb fe                	jmp    8004d6 <_panic+0x75>

008004d8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	53                   	push   %ebx
  8004dc:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004df:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	39 c2                	cmp    %eax,%edx
  8004ef:	74 14                	je     800505 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 9c 3d 80 00       	push   $0x803d9c
  8004f9:	6a 26                	push   $0x26
  8004fb:	68 e8 3d 80 00       	push   $0x803de8
  800500:	e8 5c ff ff ff       	call   800461 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80050c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800513:	e9 d9 00 00 00       	jmp    8005f1 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	85 c0                	test   %eax,%eax
  80052b:	75 08                	jne    800535 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80052d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800530:	e9 b9 00 00 00       	jmp    8005ee <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800543:	eb 79                	jmp    8005be <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800545:	a1 20 50 80 00       	mov    0x805020,%eax
  80054a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800550:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800553:	89 d0                	mov    %edx,%eax
  800555:	01 c0                	add    %eax,%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800560:	01 d8                	add    %ebx,%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	01 c8                	add    %ecx,%eax
  800566:	8a 40 04             	mov    0x4(%eax),%al
  800569:	84 c0                	test   %al,%al
  80056b:	75 4e                	jne    8005bb <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80056d:	a1 20 50 80 00       	mov    0x805020,%eax
  800572:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800578:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057b:	89 d0                	mov    %edx,%eax
  80057d:	01 c0                	add    %eax,%eax
  80057f:	01 d0                	add    %edx,%eax
  800581:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800588:	01 d8                	add    %ebx,%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800596:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80059d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ae:	39 c2                	cmp    %eax,%edx
  8005b0:	75 09                	jne    8005bb <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005b2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b9:	eb 19                	jmp    8005d4 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bb:	ff 45 e8             	incl   -0x18(%ebp)
  8005be:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cc:	39 c2                	cmp    %eax,%edx
  8005ce:	0f 87 71 ff ff ff    	ja     800545 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d8:	75 14                	jne    8005ee <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	68 f4 3d 80 00       	push   $0x803df4
  8005e2:	6a 3a                	push   $0x3a
  8005e4:	68 e8 3d 80 00       	push   $0x803de8
  8005e9:	e8 73 fe ff ff       	call   800461 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ee:	ff 45 f0             	incl   -0x10(%ebp)
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f7:	0f 8c 1b ff ff ff    	jl     800518 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800604:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80060b:	eb 2e                	jmp    80063b <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80060d:	a1 20 50 80 00       	mov    0x805020,%eax
  800612:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800618:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061b:	89 d0                	mov    %edx,%eax
  80061d:	01 c0                	add    %eax,%eax
  80061f:	01 d0                	add    %edx,%eax
  800621:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800628:	01 d8                	add    %ebx,%eax
  80062a:	01 d0                	add    %edx,%eax
  80062c:	01 c8                	add    %ecx,%eax
  80062e:	8a 40 04             	mov    0x4(%eax),%al
  800631:	3c 01                	cmp    $0x1,%al
  800633:	75 03                	jne    800638 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800635:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800638:	ff 45 e0             	incl   -0x20(%ebp)
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800649:	39 c2                	cmp    %eax,%edx
  80064b:	77 c0                	ja     80060d <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80064d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800650:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800653:	74 14                	je     800669 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	68 48 3e 80 00       	push   $0x803e48
  80065d:	6a 44                	push   $0x44
  80065f:	68 e8 3d 80 00       	push   $0x803de8
  800664:	e8 f8 fd ff ff       	call   800461 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800669:	90                   	nop
  80066a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	53                   	push   %ebx
  800673:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800676:	8b 45 0c             	mov    0xc(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	8d 48 01             	lea    0x1(%eax),%ecx
  80067e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800681:	89 0a                	mov    %ecx,(%edx)
  800683:	8b 55 08             	mov    0x8(%ebp),%edx
  800686:	88 d1                	mov    %dl,%cl
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	3d ff 00 00 00       	cmp    $0xff,%eax
  800699:	75 30                	jne    8006cb <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80069b:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006a1:	a0 44 50 80 00       	mov    0x805044,%al
  8006a6:	0f b6 c0             	movzbl %al,%eax
  8006a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ac:	8b 09                	mov    (%ecx),%ecx
  8006ae:	89 cb                	mov    %ecx,%ebx
  8006b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b3:	83 c1 08             	add    $0x8,%ecx
  8006b6:	52                   	push   %edx
  8006b7:	50                   	push   %eax
  8006b8:	53                   	push   %ebx
  8006b9:	51                   	push   %ecx
  8006ba:	e8 a8 1c 00 00       	call   802367 <sys_cputs>
  8006bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ce:	8b 40 04             	mov    0x4(%eax),%eax
  8006d1:	8d 50 01             	lea    0x1(%eax),%edx
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006da:	90                   	nop
  8006db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f0:	00 00 00 
	b.cnt = 0;
  8006f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006fd:	ff 75 0c             	pushl  0xc(%ebp)
  800700:	ff 75 08             	pushl  0x8(%ebp)
  800703:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	68 6f 06 80 00       	push   $0x80066f
  80070f:	e8 5a 02 00 00       	call   80096e <vprintfmt>
  800714:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800717:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80071d:	a0 44 50 80 00       	mov    0x805044,%al
  800722:	0f b6 c0             	movzbl %al,%eax
  800725:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80072b:	52                   	push   %edx
  80072c:	50                   	push   %eax
  80072d:	51                   	push   %ecx
  80072e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800734:	83 c0 08             	add    $0x8,%eax
  800737:	50                   	push   %eax
  800738:	e8 2a 1c 00 00       	call   802367 <sys_cputs>
  80073d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800740:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800747:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800755:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  80075c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 f4             	pushl  -0xc(%ebp)
  80076b:	50                   	push   %eax
  80076c:	e8 6f ff ff ff       	call   8006e0 <vcprintf>
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800777:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077a:	c9                   	leave  
  80077b:	c3                   	ret    

0080077c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800782:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	c1 e0 08             	shl    $0x8,%eax
  80078f:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800794:	8d 45 0c             	lea    0xc(%ebp),%eax
  800797:	83 c0 04             	add    $0x4,%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 34 ff ff ff       	call   8006e0 <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b2:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007b9:	07 00 00 

	return cnt;
  8007bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007c7:	e8 df 1b 00 00       	call   8023ab <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	e8 ff fe ff ff       	call   8006e0 <vcprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007e7:	e8 d9 1b 00 00       	call   8023c5 <sys_unlock_cons>
	return cnt;
  8007ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 14             	sub    $0x14,%esp
  8007f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800804:	8b 45 18             	mov    0x18(%ebp),%eax
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
  80080c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080f:	77 55                	ja     800866 <printnum+0x75>
  800811:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800814:	72 05                	jb     80081b <printnum+0x2a>
  800816:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800819:	77 4b                	ja     800866 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80081b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80081e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800821:	8b 45 18             	mov    0x18(%ebp),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	52                   	push   %edx
  80082a:	50                   	push   %eax
  80082b:	ff 75 f4             	pushl  -0xc(%ebp)
  80082e:	ff 75 f0             	pushl  -0x10(%ebp)
  800831:	e8 92 2e 00 00       	call   8036c8 <__udivdi3>
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	83 ec 04             	sub    $0x4,%esp
  80083c:	ff 75 20             	pushl  0x20(%ebp)
  80083f:	53                   	push   %ebx
  800840:	ff 75 18             	pushl  0x18(%ebp)
  800843:	52                   	push   %edx
  800844:	50                   	push   %eax
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 a1 ff ff ff       	call   8007f1 <printnum>
  800850:	83 c4 20             	add    $0x20,%esp
  800853:	eb 1a                	jmp    80086f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	ff 75 20             	pushl  0x20(%ebp)
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800866:	ff 4d 1c             	decl   0x1c(%ebp)
  800869:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80086d:	7f e6                	jg     800855 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80086f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800872:	bb 00 00 00 00       	mov    $0x0,%ebx
  800877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087d:	53                   	push   %ebx
  80087e:	51                   	push   %ecx
  80087f:	52                   	push   %edx
  800880:	50                   	push   %eax
  800881:	e8 52 2f 00 00       	call   8037d8 <__umoddi3>
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	05 b4 40 80 00       	add    $0x8040b4,%eax
  80088e:	8a 00                	mov    (%eax),%al
  800890:	0f be c0             	movsbl %al,%eax
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	50                   	push   %eax
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	ff d0                	call   *%eax
  80089f:	83 c4 10             	add    $0x10,%esp
}
  8008a2:	90                   	nop
  8008a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    

008008a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008af:	7e 1c                	jle    8008cd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 50 08             	lea    0x8(%eax),%edx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	89 10                	mov    %edx,(%eax)
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	83 e8 08             	sub    $0x8,%eax
  8008c6:	8b 50 04             	mov    0x4(%eax),%edx
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	eb 40                	jmp    80090d <getuint+0x65>
	else if (lflag)
  8008cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d1:	74 1e                	je     8008f1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	8d 50 04             	lea    0x4(%eax),%edx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	89 10                	mov    %edx,(%eax)
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	83 e8 04             	sub    $0x4,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ef:	eb 1c                	jmp    80090d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	8d 50 04             	lea    0x4(%eax),%edx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	89 10                	mov    %edx,(%eax)
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	83 e8 04             	sub    $0x4,%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800912:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800916:	7e 1c                	jle    800934 <getint+0x25>
		return va_arg(*ap, long long);
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	8d 50 08             	lea    0x8(%eax),%edx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	89 10                	mov    %edx,(%eax)
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	83 e8 08             	sub    $0x8,%eax
  80092d:	8b 50 04             	mov    0x4(%eax),%edx
  800930:	8b 00                	mov    (%eax),%eax
  800932:	eb 38                	jmp    80096c <getint+0x5d>
	else if (lflag)
  800934:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800938:	74 1a                	je     800954 <getint+0x45>
		return va_arg(*ap, long);
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 50 04             	lea    0x4(%eax),%edx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	89 10                	mov    %edx,(%eax)
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	99                   	cltd   
  800952:	eb 18                	jmp    80096c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	8d 50 04             	lea    0x4(%eax),%edx
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	89 10                	mov    %edx,(%eax)
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	83 e8 04             	sub    $0x4,%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	99                   	cltd   
}
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800976:	eb 17                	jmp    80098f <vprintfmt+0x21>
			if (ch == '\0')
  800978:	85 db                	test   %ebx,%ebx
  80097a:	0f 84 c1 03 00 00    	je     800d41 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	53                   	push   %ebx
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098f:	8b 45 10             	mov    0x10(%ebp),%eax
  800992:	8d 50 01             	lea    0x1(%eax),%edx
  800995:	89 55 10             	mov    %edx,0x10(%ebp)
  800998:	8a 00                	mov    (%eax),%al
  80099a:	0f b6 d8             	movzbl %al,%ebx
  80099d:	83 fb 25             	cmp    $0x25,%ebx
  8009a0:	75 d6                	jne    800978 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c5:	8d 50 01             	lea    0x1(%eax),%edx
  8009c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009cb:	8a 00                	mov    (%eax),%al
  8009cd:	0f b6 d8             	movzbl %al,%ebx
  8009d0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d3:	83 f8 5b             	cmp    $0x5b,%eax
  8009d6:	0f 87 3d 03 00 00    	ja     800d19 <vprintfmt+0x3ab>
  8009dc:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
  8009e3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009e5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e9:	eb d7                	jmp    8009c2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009eb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ef:	eb d1                	jmp    8009c2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009fb:	89 d0                	mov    %edx,%eax
  8009fd:	c1 e0 02             	shl    $0x2,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	01 c0                	add    %eax,%eax
  800a04:	01 d8                	add    %ebx,%eax
  800a06:	83 e8 30             	sub    $0x30,%eax
  800a09:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	8a 00                	mov    (%eax),%al
  800a11:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a14:	83 fb 2f             	cmp    $0x2f,%ebx
  800a17:	7e 3e                	jle    800a57 <vprintfmt+0xe9>
  800a19:	83 fb 39             	cmp    $0x39,%ebx
  800a1c:	7f 39                	jg     800a57 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a21:	eb d5                	jmp    8009f8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 c0 04             	add    $0x4,%eax
  800a29:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	83 e8 04             	sub    $0x4,%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a37:	eb 1f                	jmp    800a58 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3d:	79 83                	jns    8009c2 <vprintfmt+0x54>
				width = 0;
  800a3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a46:	e9 77 ff ff ff       	jmp    8009c2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a4b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a52:	e9 6b ff ff ff       	jmp    8009c2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a57:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5c:	0f 89 60 ff ff ff    	jns    8009c2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a6f:	e9 4e ff ff ff       	jmp    8009c2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a74:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a77:	e9 46 ff ff ff       	jmp    8009c2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	50                   	push   %eax
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	e9 9b 02 00 00       	jmp    800d3c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 c0 04             	add    $0x4,%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 e8 04             	sub    $0x4,%eax
  800ab0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab2:	85 db                	test   %ebx,%ebx
  800ab4:	79 02                	jns    800ab8 <vprintfmt+0x14a>
				err = -err;
  800ab6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab8:	83 fb 64             	cmp    $0x64,%ebx
  800abb:	7f 0b                	jg     800ac8 <vprintfmt+0x15a>
  800abd:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 19                	jne    800ae1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac8:	53                   	push   %ebx
  800ac9:	68 c5 40 80 00       	push   $0x8040c5
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	ff 75 08             	pushl  0x8(%ebp)
  800ad4:	e8 70 02 00 00       	call   800d49 <printfmt>
  800ad9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800adc:	e9 5b 02 00 00       	jmp    800d3c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae1:	56                   	push   %esi
  800ae2:	68 ce 40 80 00       	push   $0x8040ce
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	ff 75 08             	pushl  0x8(%ebp)
  800aed:	e8 57 02 00 00       	call   800d49 <printfmt>
  800af2:	83 c4 10             	add    $0x10,%esp
			break;
  800af5:	e9 42 02 00 00       	jmp    800d3c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	83 c0 04             	add    $0x4,%eax
  800b00:	89 45 14             	mov    %eax,0x14(%ebp)
  800b03:	8b 45 14             	mov    0x14(%ebp),%eax
  800b06:	83 e8 04             	sub    $0x4,%eax
  800b09:	8b 30                	mov    (%eax),%esi
  800b0b:	85 f6                	test   %esi,%esi
  800b0d:	75 05                	jne    800b14 <vprintfmt+0x1a6>
				p = "(null)";
  800b0f:	be d1 40 80 00       	mov    $0x8040d1,%esi
			if (width > 0 && padc != '-')
  800b14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b18:	7e 6d                	jle    800b87 <vprintfmt+0x219>
  800b1a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b1e:	74 67                	je     800b87 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	50                   	push   %eax
  800b27:	56                   	push   %esi
  800b28:	e8 1e 03 00 00       	call   800e4b <strnlen>
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b33:	eb 16                	jmp    800b4b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b35:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 0c             	pushl  0xc(%ebp)
  800b3f:	50                   	push   %eax
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b48:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4f:	7f e4                	jg     800b35 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b51:	eb 34                	jmp    800b87 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b53:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b57:	74 1c                	je     800b75 <vprintfmt+0x207>
  800b59:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5c:	7e 05                	jle    800b63 <vprintfmt+0x1f5>
  800b5e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b61:	7e 12                	jle    800b75 <vprintfmt+0x207>
					putch('?', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 3f                	push   $0x3f
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
  800b73:	eb 0f                	jmp    800b84 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b84:	ff 4d e4             	decl   -0x1c(%ebp)
  800b87:	89 f0                	mov    %esi,%eax
  800b89:	8d 70 01             	lea    0x1(%eax),%esi
  800b8c:	8a 00                	mov    (%eax),%al
  800b8e:	0f be d8             	movsbl %al,%ebx
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	74 24                	je     800bb9 <vprintfmt+0x24b>
  800b95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b99:	78 b8                	js     800b53 <vprintfmt+0x1e5>
  800b9b:	ff 4d e0             	decl   -0x20(%ebp)
  800b9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba2:	79 af                	jns    800b53 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba4:	eb 13                	jmp    800bb9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 20                	push   $0x20
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbd:	7f e7                	jg     800ba6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bbf:	e9 78 01 00 00       	jmp    800d3c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bca:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcd:	50                   	push   %eax
  800bce:	e8 3c fd ff ff       	call   80090f <getint>
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be2:	85 d2                	test   %edx,%edx
  800be4:	79 23                	jns    800c09 <vprintfmt+0x29b>
				putch('-', putdat);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	6a 2d                	push   $0x2d
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	ff d0                	call   *%eax
  800bf3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfc:	f7 d8                	neg    %eax
  800bfe:	83 d2 00             	adc    $0x0,%edx
  800c01:	f7 da                	neg    %edx
  800c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c10:	e9 bc 00 00 00       	jmp    800cd1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1e:	50                   	push   %eax
  800c1f:	e8 84 fc ff ff       	call   8008a8 <getuint>
  800c24:	83 c4 10             	add    $0x10,%esp
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c2d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c34:	e9 98 00 00 00       	jmp    800cd1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 58                	push   $0x58
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 58                	push   $0x58
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 58                	push   $0x58
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			break;
  800c69:	e9 ce 00 00 00       	jmp    800d3c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 30                	push   $0x30
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 78                	push   $0x78
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 14             	mov    %eax,0x14(%ebp)
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 e8 04             	sub    $0x4,%eax
  800c9d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb2:	83 ec 08             	sub    $0x8,%esp
  800cb5:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb8:	8d 45 14             	lea    0x14(%ebp),%eax
  800cbb:	50                   	push   %eax
  800cbc:	e8 e7 fb ff ff       	call   8008a8 <getuint>
  800cc1:	83 c4 10             	add    $0x10,%esp
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd8:	83 ec 04             	sub    $0x4,%esp
  800cdb:	52                   	push   %edx
  800cdc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cdf:	50                   	push   %eax
  800ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	ff 75 08             	pushl  0x8(%ebp)
  800cec:	e8 00 fb ff ff       	call   8007f1 <printnum>
  800cf1:	83 c4 20             	add    $0x20,%esp
			break;
  800cf4:	eb 46                	jmp    800d3c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	53                   	push   %ebx
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
			break;
  800d05:	eb 35                	jmp    800d3c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d07:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d0e:	eb 2c                	jmp    800d3c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d10:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3c3>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 35 fc ff ff       	jmp    800976 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 04 fc ff ff       	call   80096e <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 80 fb ff ff       	call   80096e <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801022:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801026:	76 63                	jbe    80108b <memset+0x75>
		uint64 data_block = c;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	99                   	cltd   
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801038:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80103c:	c1 e0 08             	shl    $0x8,%eax
  80103f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801042:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80104f:	c1 e0 10             	shl    $0x10,%eax
  801052:	09 45 f0             	or     %eax,-0x10(%ebp)
  801055:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105e:	89 c2                	mov    %eax,%edx
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	09 45 f0             	or     %eax,-0x10(%ebp)
  801068:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80106b:	eb 18                	jmp    801085 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80106d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801070:	8d 41 08             	lea    0x8(%ecx),%eax
  801073:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801079:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107c:	89 01                	mov    %eax,(%ecx)
  80107e:	89 51 04             	mov    %edx,0x4(%ecx)
  801081:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801085:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801089:	77 e2                	ja     80106d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80108b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108f:	74 23                	je     8010b4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801094:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801097:	eb 0e                	jmp    8010a7 <memset+0x91>
			*p8++ = (uint8)c;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	75 e5                	jne    801099 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010cb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010cf:	76 24                	jbe    8010f5 <memcpy+0x3c>
		while(n >= 8){
  8010d1:	eb 1c                	jmp    8010ef <memcpy+0x36>
			*d64 = *s64;
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	8b 50 04             	mov    0x4(%eax),%edx
  8010d9:	8b 00                	mov    (%eax),%eax
  8010db:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010de:	89 01                	mov    %eax,(%ecx)
  8010e0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010e7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010eb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f3:	77 de                	ja     8010d3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f9:	74 31                	je     80112c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801101:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801104:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801107:	eb 16                	jmp    80111f <memcpy+0x66>
			*d8++ = *s8++;
  801109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110c:	8d 50 01             	lea    0x1(%eax),%edx
  80110f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801115:	8d 4a 01             	lea    0x1(%edx),%ecx
  801118:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80111b:	8a 12                	mov    (%edx),%dl
  80111d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 dd                	jne    801109 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801146:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801149:	73 50                	jae    80119b <memmove+0x6a>
  80114b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	01 d0                	add    %edx,%eax
  801153:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801156:	76 43                	jbe    80119b <memmove+0x6a>
		s += n;
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801164:	eb 10                	jmp    801176 <memmove+0x45>
			*--d = *--s;
  801166:	ff 4d f8             	decl   -0x8(%ebp)
  801169:	ff 4d fc             	decl   -0x4(%ebp)
  80116c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116f:	8a 10                	mov    (%eax),%dl
  801171:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801174:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801176:	8b 45 10             	mov    0x10(%ebp),%eax
  801179:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117c:	89 55 10             	mov    %edx,0x10(%ebp)
  80117f:	85 c0                	test   %eax,%eax
  801181:	75 e3                	jne    801166 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801183:	eb 23                	jmp    8011a8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801191:	8d 4a 01             	lea    0x1(%edx),%ecx
  801194:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801197:	8a 12                	mov    (%edx),%dl
  801199:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	75 dd                	jne    801185 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011bf:	eb 2a                	jmp    8011eb <memcmp+0x3e>
		if (*s1 != *s2)
  8011c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c4:	8a 10                	mov    (%eax),%dl
  8011c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	38 c2                	cmp    %al,%dl
  8011cd:	74 16                	je     8011e5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f b6 d0             	movzbl %al,%edx
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	0f b6 c0             	movzbl %al,%eax
  8011df:	29 c2                	sub    %eax,%edx
  8011e1:	89 d0                	mov    %edx,%eax
  8011e3:	eb 18                	jmp    8011fd <memcmp+0x50>
		s1++, s2++;
  8011e5:	ff 45 fc             	incl   -0x4(%ebp)
  8011e8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	75 c9                	jne    8011c1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801205:	8b 55 08             	mov    0x8(%ebp),%edx
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801210:	eb 15                	jmp    801227 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f b6 d0             	movzbl %al,%edx
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	0f b6 c0             	movzbl %al,%eax
  801220:	39 c2                	cmp    %eax,%edx
  801222:	74 0d                	je     801231 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801224:	ff 45 08             	incl   0x8(%ebp)
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122d:	72 e3                	jb     801212 <memfind+0x13>
  80122f:	eb 01                	jmp    801232 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801231:	90                   	nop
	return (void *) s;
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80123d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801244:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124b:	eb 03                	jmp    801250 <strtol+0x19>
		s++;
  80124d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 20                	cmp    $0x20,%al
  801257:	74 f4                	je     80124d <strtol+0x16>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 09                	cmp    $0x9,%al
  801260:	74 eb                	je     80124d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 2b                	cmp    $0x2b,%al
  801269:	75 05                	jne    801270 <strtol+0x39>
		s++;
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	eb 13                	jmp    801283 <strtol+0x4c>
	else if (*s == '-')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2d                	cmp    $0x2d,%al
  801277:	75 0a                	jne    801283 <strtol+0x4c>
		s++, neg = 1;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801283:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801287:	74 06                	je     80128f <strtol+0x58>
  801289:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80128d:	75 20                	jne    8012af <strtol+0x78>
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	3c 30                	cmp    $0x30,%al
  801296:	75 17                	jne    8012af <strtol+0x78>
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	40                   	inc    %eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 78                	cmp    $0x78,%al
  8012a0:	75 0d                	jne    8012af <strtol+0x78>
		s += 2, base = 16;
  8012a2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012a6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ad:	eb 28                	jmp    8012d7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b3:	75 15                	jne    8012ca <strtol+0x93>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	3c 30                	cmp    $0x30,%al
  8012bc:	75 0c                	jne    8012ca <strtol+0x93>
		s++, base = 8;
  8012be:	ff 45 08             	incl   0x8(%ebp)
  8012c1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c8:	eb 0d                	jmp    8012d7 <strtol+0xa0>
	else if (base == 0)
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	75 07                	jne    8012d7 <strtol+0xa0>
		base = 10;
  8012d0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	3c 2f                	cmp    $0x2f,%al
  8012de:	7e 19                	jle    8012f9 <strtol+0xc2>
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	3c 39                	cmp    $0x39,%al
  8012e7:	7f 10                	jg     8012f9 <strtol+0xc2>
			dig = *s - '0';
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f be c0             	movsbl %al,%eax
  8012f1:	83 e8 30             	sub    $0x30,%eax
  8012f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f7:	eb 42                	jmp    80133b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8a 00                	mov    (%eax),%al
  8012fe:	3c 60                	cmp    $0x60,%al
  801300:	7e 19                	jle    80131b <strtol+0xe4>
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	8a 00                	mov    (%eax),%al
  801307:	3c 7a                	cmp    $0x7a,%al
  801309:	7f 10                	jg     80131b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	0f be c0             	movsbl %al,%eax
  801313:	83 e8 57             	sub    $0x57,%eax
  801316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801319:	eb 20                	jmp    80133b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	3c 40                	cmp    $0x40,%al
  801322:	7e 39                	jle    80135d <strtol+0x126>
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	3c 5a                	cmp    $0x5a,%al
  80132b:	7f 30                	jg     80135d <strtol+0x126>
			dig = *s - 'A' + 10;
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	0f be c0             	movsbl %al,%eax
  801335:	83 e8 37             	sub    $0x37,%eax
  801338:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80133b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801341:	7d 19                	jge    80135c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801343:	ff 45 08             	incl   0x8(%ebp)
  801346:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801349:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801352:	01 d0                	add    %edx,%eax
  801354:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801357:	e9 7b ff ff ff       	jmp    8012d7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80135c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80135d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801361:	74 08                	je     80136b <strtol+0x134>
		*endptr = (char *) s;
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
  801369:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80136b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80136f:	74 07                	je     801378 <strtol+0x141>
  801371:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801374:	f7 d8                	neg    %eax
  801376:	eb 03                	jmp    80137b <strtol+0x144>
  801378:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <ltostr>:

void
ltostr(long value, char *str)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80138a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801391:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801395:	79 13                	jns    8013aa <ltostr+0x2d>
	{
		neg = 1;
  801397:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b2:	99                   	cltd   
  8013b3:	f7 f9                	idiv   %ecx
  8013b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bb:	8d 50 01             	lea    0x1(%eax),%edx
  8013be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c1:	89 c2                	mov    %eax,%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013cb:	83 c2 30             	add    $0x30,%edx
  8013ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d8:	f7 e9                	imul   %ecx
  8013da:	c1 fa 02             	sar    $0x2,%edx
  8013dd:	89 c8                	mov    %ecx,%eax
  8013df:	c1 f8 1f             	sar    $0x1f,%eax
  8013e2:	29 c2                	sub    %eax,%edx
  8013e4:	89 d0                	mov    %edx,%eax
  8013e6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ed:	75 bb                	jne    8013aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	48                   	dec    %eax
  8013fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801401:	74 3d                	je     801440 <ltostr+0xc3>
		start = 1 ;
  801403:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80140a:	eb 34                	jmp    801440 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80140c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	01 d0                	add    %edx,%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141f:	01 c2                	add    %eax,%edx
  801421:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801424:	8b 45 0c             	mov    0xc(%ebp),%eax
  801427:	01 c8                	add    %ecx,%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80142d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	01 c2                	add    %eax,%edx
  801435:	8a 45 eb             	mov    -0x15(%ebp),%al
  801438:	88 02                	mov    %al,(%edx)
		start++ ;
  80143a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80143d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801446:	7c c4                	jl     80140c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801448:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	01 d0                	add    %edx,%eax
  801450:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801453:	90                   	nop
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80145c:	ff 75 08             	pushl  0x8(%ebp)
  80145f:	e8 c4 f9 ff ff       	call   800e28 <strlen>
  801464:	83 c4 04             	add    $0x4,%esp
  801467:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	e8 b6 f9 ff ff       	call   800e28 <strlen>
  801472:	83 c4 04             	add    $0x4,%esp
  801475:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80147f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801486:	eb 17                	jmp    80149f <strcconcat+0x49>
		final[s] = str1[s] ;
  801488:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 c2                	add    %eax,%edx
  801490:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	01 c8                	add    %ecx,%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80149c:	ff 45 fc             	incl   -0x4(%ebp)
  80149f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014a5:	7c e1                	jl     801488 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014b5:	eb 1f                	jmp    8014d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ba:	8d 50 01             	lea    0x1(%eax),%edx
  8014bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c0:	89 c2                	mov    %eax,%edx
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	01 c2                	add    %eax,%edx
  8014c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	01 c8                	add    %ecx,%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d3:	ff 45 f8             	incl   -0x8(%ebp)
  8014d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014dc:	7c d9                	jl     8014b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fb:	8b 00                	mov    (%eax),%eax
  8014fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	01 d0                	add    %edx,%eax
  801509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150f:	eb 0c                	jmp    80151d <strsplit+0x31>
			*string++ = 0;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8d 50 01             	lea    0x1(%eax),%edx
  801517:	89 55 08             	mov    %edx,0x8(%ebp)
  80151a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	84 c0                	test   %al,%al
  801524:	74 18                	je     80153e <strsplit+0x52>
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	50                   	push   %eax
  80152f:	ff 75 0c             	pushl  0xc(%ebp)
  801532:	e8 83 fa ff ff       	call   800fba <strchr>
  801537:	83 c4 08             	add    $0x8,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	75 d3                	jne    801511 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	84 c0                	test   %al,%al
  801545:	74 5a                	je     8015a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801547:	8b 45 14             	mov    0x14(%ebp),%eax
  80154a:	8b 00                	mov    (%eax),%eax
  80154c:	83 f8 0f             	cmp    $0xf,%eax
  80154f:	75 07                	jne    801558 <strsplit+0x6c>
		{
			return 0;
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	eb 66                	jmp    8015be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801558:	8b 45 14             	mov    0x14(%ebp),%eax
  80155b:	8b 00                	mov    (%eax),%eax
  80155d:	8d 48 01             	lea    0x1(%eax),%ecx
  801560:	8b 55 14             	mov    0x14(%ebp),%edx
  801563:	89 0a                	mov    %ecx,(%edx)
  801565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	01 c2                	add    %eax,%edx
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801576:	eb 03                	jmp    80157b <strsplit+0x8f>
			string++;
  801578:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	8a 00                	mov    (%eax),%al
  801580:	84 c0                	test   %al,%al
  801582:	74 8b                	je     80150f <strsplit+0x23>
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	0f be c0             	movsbl %al,%eax
  80158c:	50                   	push   %eax
  80158d:	ff 75 0c             	pushl  0xc(%ebp)
  801590:	e8 25 fa ff ff       	call   800fba <strchr>
  801595:	83 c4 08             	add    $0x8,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 dc                	je     801578 <strsplit+0x8c>
			string++;
	}
  80159c:	e9 6e ff ff ff       	jmp    80150f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a5:	8b 00                	mov    (%eax),%eax
  8015a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b1:	01 d0                	add    %edx,%eax
  8015b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 4a                	jmp    80161f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	01 d0                	add    %edx,%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	3c 40                	cmp    $0x40,%al
  8015f5:	7e 25                	jle    80161c <str2lower+0x5c>
  8015f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	01 d0                	add    %edx,%eax
  8015ff:	8a 00                	mov    (%eax),%al
  801601:	3c 5a                	cmp    $0x5a,%al
  801603:	7f 17                	jg     80161c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	01 d0                	add    %edx,%eax
  80160d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801610:	8b 55 08             	mov    0x8(%ebp),%edx
  801613:	01 ca                	add    %ecx,%edx
  801615:	8a 12                	mov    (%edx),%dl
  801617:	83 c2 20             	add    $0x20,%edx
  80161a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80161c:	ff 45 fc             	incl   -0x4(%ebp)
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	e8 01 f8 ff ff       	call   800e28 <strlen>
  801627:	83 c4 04             	add    $0x4,%esp
  80162a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80162d:	7f a6                	jg     8015d5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80162f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	6a 10                	push   $0x10
  80163f:	e8 b2 15 00 00       	call   802bf6 <alloc_block>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80164a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80164e:	75 14                	jne    801664 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	68 48 42 80 00       	push   $0x804248
  801658:	6a 14                	push   $0x14
  80165a:	68 71 42 80 00       	push   $0x804271
  80165f:	e8 fd ed ff ff       	call   800461 <_panic>

	node->start = start;
  801664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801667:	8b 55 08             	mov    0x8(%ebp),%edx
  80166a:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80166c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801672:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801675:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80167c:	a1 24 50 80 00       	mov    0x805024,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 18                	jmp    80169e <insert_page_alloc+0x6a>
		if (start < it->start)
  801686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801689:	8b 00                	mov    (%eax),%eax
  80168b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80168e:	77 37                	ja     8016c7 <insert_page_alloc+0x93>
			break;
		prev = it;
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801696:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80169b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a2:	74 08                	je     8016ac <insert_page_alloc+0x78>
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	8b 40 08             	mov    0x8(%eax),%eax
  8016aa:	eb 05                	jmp    8016b1 <insert_page_alloc+0x7d>
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 c7                	jne    801686 <insert_page_alloc+0x52>
  8016bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c3:	75 c1                	jne    801686 <insert_page_alloc+0x52>
  8016c5:	eb 01                	jmp    8016c8 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8016c7:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8016c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016cc:	75 64                	jne    801732 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8016ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d2:	75 14                	jne    8016e8 <insert_page_alloc+0xb4>
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	68 80 42 80 00       	push   $0x804280
  8016dc:	6a 21                	push   $0x21
  8016de:	68 71 42 80 00       	push   $0x804271
  8016e3:	e8 79 ed ff ff       	call   800461 <_panic>
  8016e8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f1:	89 50 08             	mov    %edx,0x8(%eax)
  8016f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f7:	8b 40 08             	mov    0x8(%eax),%eax
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	74 0d                	je     80170b <insert_page_alloc+0xd7>
  8016fe:	a1 24 50 80 00       	mov    0x805024,%eax
  801703:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801706:	89 50 0c             	mov    %edx,0xc(%eax)
  801709:	eb 08                	jmp    801713 <insert_page_alloc+0xdf>
  80170b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170e:	a3 28 50 80 00       	mov    %eax,0x805028
  801713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801716:	a3 24 50 80 00       	mov    %eax,0x805024
  80171b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801725:	a1 30 50 80 00       	mov    0x805030,%eax
  80172a:	40                   	inc    %eax
  80172b:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801730:	eb 71                	jmp    8017a3 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801732:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801736:	74 06                	je     80173e <insert_page_alloc+0x10a>
  801738:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80173c:	75 14                	jne    801752 <insert_page_alloc+0x11e>
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	68 a4 42 80 00       	push   $0x8042a4
  801746:	6a 23                	push   $0x23
  801748:	68 71 42 80 00       	push   $0x804271
  80174d:	e8 0f ed ff ff       	call   800461 <_panic>
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	8b 50 08             	mov    0x8(%eax),%edx
  801758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175b:	89 50 08             	mov    %edx,0x8(%eax)
  80175e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801761:	8b 40 08             	mov    0x8(%eax),%eax
  801764:	85 c0                	test   %eax,%eax
  801766:	74 0c                	je     801774 <insert_page_alloc+0x140>
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	8b 40 08             	mov    0x8(%eax),%eax
  80176e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801771:	89 50 0c             	mov    %edx,0xc(%eax)
  801774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801777:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80177a:	89 50 08             	mov    %edx,0x8(%eax)
  80177d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801780:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801783:	89 50 0c             	mov    %edx,0xc(%eax)
  801786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801789:	8b 40 08             	mov    0x8(%eax),%eax
  80178c:	85 c0                	test   %eax,%eax
  80178e:	75 08                	jne    801798 <insert_page_alloc+0x164>
  801790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801793:	a3 28 50 80 00       	mov    %eax,0x805028
  801798:	a1 30 50 80 00       	mov    0x805030,%eax
  80179d:	40                   	inc    %eax
  80179e:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8017a3:	90                   	nop
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8017ac:	a1 24 50 80 00       	mov    0x805024,%eax
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 0c                	jne    8017c1 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8017b5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017ba:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8017bf:	eb 67                	jmp    801828 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8017c1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8017ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017d1:	eb 26                	jmp    8017f9 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8017d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d6:	8b 10                	mov    (%eax),%edx
  8017d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017db:	8b 40 04             	mov    0x4(%eax),%eax
  8017de:	01 d0                	add    %edx,%eax
  8017e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017e9:	76 06                	jbe    8017f1 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017f9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017fd:	74 08                	je     801807 <recompute_page_alloc_break+0x61>
  8017ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801802:	8b 40 08             	mov    0x8(%eax),%eax
  801805:	eb 05                	jmp    80180c <recompute_page_alloc_break+0x66>
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
  80180c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801811:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801816:	85 c0                	test   %eax,%eax
  801818:	75 b9                	jne    8017d3 <recompute_page_alloc_break+0x2d>
  80181a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80181e:	75 b3                	jne    8017d3 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801830:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801837:	8b 55 08             	mov    0x8(%ebp),%edx
  80183a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80183d:	01 d0                	add    %edx,%eax
  80183f:	48                   	dec    %eax
  801840:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801843:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801846:	ba 00 00 00 00       	mov    $0x0,%edx
  80184b:	f7 75 d8             	divl   -0x28(%ebp)
  80184e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801851:	29 d0                	sub    %edx,%eax
  801853:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801856:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80185a:	75 0a                	jne    801866 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80185c:	b8 00 00 00 00       	mov    $0x0,%eax
  801861:	e9 7e 01 00 00       	jmp    8019e4 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80186d:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801871:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801878:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80187f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801884:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801887:	a1 24 50 80 00       	mov    0x805024,%eax
  80188c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80188f:	eb 69                	jmp    8018fa <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801894:	8b 00                	mov    (%eax),%eax
  801896:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801899:	76 47                	jbe    8018e2 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80189b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8018a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8018ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018af:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018b2:	72 2e                	jb     8018e2 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8018b4:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018b8:	75 14                	jne    8018ce <alloc_pages_custom_fit+0xa4>
  8018ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018bd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018c0:	75 0c                	jne    8018ce <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8018c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8018c8:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018cc:	eb 14                	jmp    8018e2 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8018ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018d1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018d4:	76 0c                	jbe    8018e2 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8018d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8018dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018df:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8018e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e5:	8b 10                	mov    (%eax),%edx
  8018e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ea:	8b 40 04             	mov    0x4(%eax),%eax
  8018ed:	01 d0                	add    %edx,%eax
  8018ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8018f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018fe:	74 08                	je     801908 <alloc_pages_custom_fit+0xde>
  801900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801903:	8b 40 08             	mov    0x8(%eax),%eax
  801906:	eb 05                	jmp    80190d <alloc_pages_custom_fit+0xe3>
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801912:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 85 72 ff ff ff    	jne    801891 <alloc_pages_custom_fit+0x67>
  80191f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801923:	0f 85 68 ff ff ff    	jne    801891 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801929:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80192e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801931:	76 47                	jbe    80197a <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801936:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801939:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80193e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801941:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801944:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801947:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80194a:	72 2e                	jb     80197a <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80194c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801950:	75 14                	jne    801966 <alloc_pages_custom_fit+0x13c>
  801952:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801955:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801958:	75 0c                	jne    801966 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80195a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80195d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801960:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801964:	eb 14                	jmp    80197a <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801966:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801969:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80196c:	76 0c                	jbe    80197a <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80196e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801971:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801974:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801977:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80197a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801981:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801985:	74 08                	je     80198f <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80198d:	eb 40                	jmp    8019cf <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80198f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801993:	74 08                	je     80199d <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801998:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80199b:	eb 32                	jmp    8019cf <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80199d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8019a2:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8019a5:	89 c2                	mov    %eax,%edx
  8019a7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019ac:	39 c2                	cmp    %eax,%edx
  8019ae:	73 07                	jae    8019b7 <alloc_pages_custom_fit+0x18d>
			return NULL;
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b5:	eb 2d                	jmp    8019e4 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8019b7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8019bf:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8019c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019c8:	01 d0                	add    %edx,%eax
  8019ca:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8019cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	ff 75 d0             	pushl  -0x30(%ebp)
  8019d8:	50                   	push   %eax
  8019d9:	e8 56 fc ff ff       	call   801634 <insert_page_alloc>
  8019de:	83 c4 10             	add    $0x10,%esp

	return result;
  8019e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8019f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8019fa:	eb 1a                	jmp    801a16 <find_allocated_size+0x30>
		if (it->start == va)
  8019fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a04:	75 08                	jne    801a0e <find_allocated_size+0x28>
			return it->size;
  801a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a09:	8b 40 04             	mov    0x4(%eax),%eax
  801a0c:	eb 34                	jmp    801a42 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a0e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a13:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a1a:	74 08                	je     801a24 <find_allocated_size+0x3e>
  801a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a1f:	8b 40 08             	mov    0x8(%eax),%eax
  801a22:	eb 05                	jmp    801a29 <find_allocated_size+0x43>
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a2e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a33:	85 c0                	test   %eax,%eax
  801a35:	75 c5                	jne    8019fc <find_allocated_size+0x16>
  801a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a3b:	75 bf                	jne    8019fc <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a50:	a1 24 50 80 00       	mov    0x805024,%eax
  801a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a58:	e9 e1 01 00 00       	jmp    801c3e <free_pages+0x1fa>
		if (it->start == va) {
  801a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a65:	0f 85 cb 01 00 00    	jne    801c36 <free_pages+0x1f2>

			uint32 start = it->start;
  801a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6e:	8b 00                	mov    (%eax),%eax
  801a70:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a76:	8b 40 04             	mov    0x4(%eax),%eax
  801a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7f:	f7 d0                	not    %eax
  801a81:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a84:	73 1d                	jae    801aa3 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a8c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a8f:	68 d8 42 80 00       	push   $0x8042d8
  801a94:	68 a5 00 00 00       	push   $0xa5
  801a99:	68 71 42 80 00       	push   $0x804271
  801a9e:	e8 be e9 ff ff       	call   800461 <_panic>
			}

			uint32 start_end = start + size;
  801aa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	79 19                	jns    801ace <free_pages+0x8a>
  801ab5:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801abc:	77 10                	ja     801ace <free_pages+0x8a>
  801abe:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801ac5:	77 07                	ja     801ace <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 2c                	js     801afa <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad1:	83 ec 0c             	sub    $0xc,%esp
  801ad4:	68 00 00 00 a0       	push   $0xa0000000
  801ad9:	ff 75 e0             	pushl  -0x20(%ebp)
  801adc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801adf:	ff 75 e8             	pushl  -0x18(%ebp)
  801ae2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ae5:	50                   	push   %eax
  801ae6:	68 1c 43 80 00       	push   $0x80431c
  801aeb:	68 ad 00 00 00       	push   $0xad
  801af0:	68 71 42 80 00       	push   $0x804271
  801af5:	e8 67 e9 ff ff       	call   800461 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b00:	e9 88 00 00 00       	jmp    801b8d <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801b05:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801b0c:	76 17                	jbe    801b25 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801b0e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b11:	68 80 43 80 00       	push   $0x804380
  801b16:	68 b4 00 00 00       	push   $0xb4
  801b1b:	68 71 42 80 00       	push   $0x804271
  801b20:	e8 3c e9 ff ff       	call   800461 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	05 00 10 00 00       	add    $0x1000,%eax
  801b2d:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	85 c0                	test   %eax,%eax
  801b35:	79 2e                	jns    801b65 <free_pages+0x121>
  801b37:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b3e:	77 25                	ja     801b65 <free_pages+0x121>
  801b40:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b47:	77 1c                	ja     801b65 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	68 00 10 00 00       	push   $0x1000
  801b51:	ff 75 f0             	pushl  -0x10(%ebp)
  801b54:	e8 38 0d 00 00       	call   802891 <sys_free_user_mem>
  801b59:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b5c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b63:	eb 28                	jmp    801b8d <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b68:	68 00 00 00 a0       	push   $0xa0000000
  801b6d:	ff 75 dc             	pushl  -0x24(%ebp)
  801b70:	68 00 10 00 00       	push   $0x1000
  801b75:	ff 75 f0             	pushl  -0x10(%ebp)
  801b78:	50                   	push   %eax
  801b79:	68 c0 43 80 00       	push   $0x8043c0
  801b7e:	68 bd 00 00 00       	push   $0xbd
  801b83:	68 71 42 80 00       	push   $0x804271
  801b88:	e8 d4 e8 ff ff       	call   800461 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b90:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b93:	0f 82 6c ff ff ff    	jb     801b05 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b9d:	75 17                	jne    801bb6 <free_pages+0x172>
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	68 22 44 80 00       	push   $0x804422
  801ba7:	68 c1 00 00 00       	push   $0xc1
  801bac:	68 71 42 80 00       	push   $0x804271
  801bb1:	e8 ab e8 ff ff       	call   800461 <_panic>
  801bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb9:	8b 40 08             	mov    0x8(%eax),%eax
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	74 11                	je     801bd1 <free_pages+0x18d>
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	8b 40 08             	mov    0x8(%eax),%eax
  801bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc9:	8b 52 0c             	mov    0xc(%edx),%edx
  801bcc:	89 50 0c             	mov    %edx,0xc(%eax)
  801bcf:	eb 0b                	jmp    801bdc <free_pages+0x198>
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd7:	a3 28 50 80 00       	mov    %eax,0x805028
  801bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  801be2:	85 c0                	test   %eax,%eax
  801be4:	74 11                	je     801bf7 <free_pages+0x1b3>
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bef:	8b 52 08             	mov    0x8(%edx),%edx
  801bf2:	89 50 08             	mov    %edx,0x8(%eax)
  801bf5:	eb 0b                	jmp    801c02 <free_pages+0x1be>
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	8b 40 08             	mov    0x8(%eax),%eax
  801bfd:	a3 24 50 80 00       	mov    %eax,0x805024
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c16:	a1 30 50 80 00       	mov    0x805030,%eax
  801c1b:	48                   	dec    %eax
  801c1c:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801c21:	83 ec 0c             	sub    $0xc,%esp
  801c24:	ff 75 f4             	pushl  -0xc(%ebp)
  801c27:	e8 24 15 00 00       	call   803150 <free_block>
  801c2c:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801c2f:	e8 72 fb ff ff       	call   8017a6 <recompute_page_alloc_break>

			return;
  801c34:	eb 37                	jmp    801c6d <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c36:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c42:	74 08                	je     801c4c <free_pages+0x208>
  801c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c47:	8b 40 08             	mov    0x8(%eax),%eax
  801c4a:	eb 05                	jmp    801c51 <free_pages+0x20d>
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c56:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	0f 85 fa fd ff ff    	jne    801a5d <free_pages+0x19>
  801c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c67:	0f 85 f0 fd ff ff    	jne    801a5d <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801c7f:	a1 08 50 80 00       	mov    0x805008,%eax
  801c84:	85 c0                	test   %eax,%eax
  801c86:	74 60                	je     801ce8 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c88:	83 ec 08             	sub    $0x8,%esp
  801c8b:	68 00 00 00 82       	push   $0x82000000
  801c90:	68 00 00 00 80       	push   $0x80000000
  801c95:	e8 0d 0d 00 00       	call   8029a7 <initialize_dynamic_allocator>
  801c9a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c9d:	e8 f3 0a 00 00       	call   802795 <sys_get_uheap_strategy>
  801ca2:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ca7:	a1 40 50 80 00       	mov    0x805040,%eax
  801cac:	05 00 10 00 00       	add    $0x1000,%eax
  801cb1:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cb6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cbb:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801cc0:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801cc7:	00 00 00 
  801cca:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801cd1:	00 00 00 
  801cd4:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801cdb:	00 00 00 

		__firstTimeFlag = 0;
  801cde:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801ce5:	00 00 00 
	}
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	68 06 04 00 00       	push   $0x406
  801d07:	50                   	push   %eax
  801d08:	e8 d2 06 00 00       	call   8023df <__sys_allocate_page>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d17:	79 17                	jns    801d30 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	68 40 44 80 00       	push   $0x804440
  801d21:	68 ea 00 00 00       	push   $0xea
  801d26:	68 71 42 80 00       	push   $0x804271
  801d2b:	e8 31 e7 ff ff       	call   800461 <_panic>
	return 0;
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d4b:	83 ec 0c             	sub    $0xc,%esp
  801d4e:	50                   	push   %eax
  801d4f:	e8 d2 06 00 00       	call   802426 <__sys_unmap_frame>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5e:	79 17                	jns    801d77 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	68 7c 44 80 00       	push   $0x80447c
  801d68:	68 f5 00 00 00       	push   $0xf5
  801d6d:	68 71 42 80 00       	push   $0x804271
  801d72:	e8 ea e6 ff ff       	call   800461 <_panic>
}
  801d77:	90                   	nop
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d80:	e8 f4 fe ff ff       	call   801c79 <uheap_init>
	if (size == 0) return NULL ;
  801d85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d89:	75 0a                	jne    801d95 <malloc+0x1b>
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d90:	e9 67 01 00 00       	jmp    801efc <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801d95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801d9c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801da3:	77 16                	ja     801dbb <malloc+0x41>
		result = alloc_block(size);
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	e8 46 0e 00 00       	call   802bf6 <alloc_block>
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db6:	e9 3e 01 00 00       	jmp    801ef9 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801dbb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc8:	01 d0                	add    %edx,%eax
  801dca:	48                   	dec    %eax
  801dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd6:	f7 75 f0             	divl   -0x10(%ebp)
  801dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ddc:	29 d0                	sub    %edx,%eax
  801dde:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801de1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801de6:	85 c0                	test   %eax,%eax
  801de8:	75 0a                	jne    801df4 <malloc+0x7a>
			return NULL;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	e9 08 01 00 00       	jmp    801efc <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801df4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	74 0f                	je     801e0c <malloc+0x92>
  801dfd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e03:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e08:	39 c2                	cmp    %eax,%edx
  801e0a:	73 0a                	jae    801e16 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801e0c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e11:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801e16:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801e1b:	83 f8 05             	cmp    $0x5,%eax
  801e1e:	75 11                	jne    801e31 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	ff 75 e8             	pushl  -0x18(%ebp)
  801e26:	e8 ff f9 ff ff       	call   80182a <alloc_pages_custom_fit>
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e35:	0f 84 be 00 00 00    	je     801ef9 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	ff 75 f4             	pushl  -0xc(%ebp)
  801e47:	e8 9a fb ff ff       	call   8019e6 <find_allocated_size>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801e52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e56:	75 17                	jne    801e6f <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801e58:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5b:	68 bc 44 80 00       	push   $0x8044bc
  801e60:	68 24 01 00 00       	push   $0x124
  801e65:	68 71 42 80 00       	push   $0x804271
  801e6a:	e8 f2 e5 ff ff       	call   800461 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e72:	f7 d0                	not    %eax
  801e74:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e77:	73 1d                	jae    801e96 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	ff 75 e0             	pushl  -0x20(%ebp)
  801e7f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e82:	68 04 45 80 00       	push   $0x804504
  801e87:	68 29 01 00 00       	push   $0x129
  801e8c:	68 71 42 80 00       	push   $0x804271
  801e91:	e8 cb e5 ff ff       	call   800461 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801e96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	79 2c                	jns    801ed4 <malloc+0x15a>
  801ea8:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801eaf:	77 23                	ja     801ed4 <malloc+0x15a>
  801eb1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801eb8:	77 1a                	ja     801ed4 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801eba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	79 13                	jns    801ed4 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	ff 75 e0             	pushl  -0x20(%ebp)
  801ec7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eca:	e8 de 09 00 00       	call   8028ad <sys_allocate_user_mem>
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	eb 25                	jmp    801ef9 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801ed4:	68 00 00 00 a0       	push   $0xa0000000
  801ed9:	ff 75 dc             	pushl  -0x24(%ebp)
  801edc:	ff 75 e0             	pushl  -0x20(%ebp)
  801edf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee5:	68 40 45 80 00       	push   $0x804540
  801eea:	68 33 01 00 00       	push   $0x133
  801eef:	68 71 42 80 00       	push   $0x804271
  801ef4:	e8 68 e5 ff ff       	call   800461 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f08:	0f 84 26 01 00 00    	je     802034 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	85 c0                	test   %eax,%eax
  801f19:	79 1c                	jns    801f37 <free+0x39>
  801f1b:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801f22:	77 13                	ja     801f37 <free+0x39>
		free_block(virtual_address);
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	e8 21 12 00 00       	call   803150 <free_block>
  801f2f:	83 c4 10             	add    $0x10,%esp
		return;
  801f32:	e9 01 01 00 00       	jmp    802038 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801f37:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f3c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f3f:	0f 82 d8 00 00 00    	jb     80201d <free+0x11f>
  801f45:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801f4c:	0f 87 cb 00 00 00    	ja     80201d <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	74 17                	je     801f75 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	68 b0 45 80 00       	push   $0x8045b0
  801f66:	68 57 01 00 00       	push   $0x157
  801f6b:	68 71 42 80 00       	push   $0x804271
  801f70:	e8 ec e4 ff ff       	call   800461 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	ff 75 08             	pushl  0x8(%ebp)
  801f7b:	e8 66 fa ff ff       	call   8019e6 <find_allocated_size>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801f86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8a:	0f 84 a7 00 00 00    	je     802037 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f93:	f7 d0                	not    %eax
  801f95:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f98:	73 1d                	jae    801fb7 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa3:	68 d8 45 80 00       	push   $0x8045d8
  801fa8:	68 61 01 00 00       	push   $0x161
  801fad:	68 71 42 80 00       	push   $0x804271
  801fb2:	e8 aa e4 ff ff       	call   800461 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	79 19                	jns    801fe2 <free+0xe4>
  801fc9:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801fd0:	77 10                	ja     801fe2 <free+0xe4>
  801fd2:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801fd9:	77 07                	ja     801fe2 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	78 2b                	js     80200d <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	68 00 00 00 a0       	push   $0xa0000000
  801fea:	ff 75 ec             	pushl  -0x14(%ebp)
  801fed:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff6:	ff 75 08             	pushl  0x8(%ebp)
  801ff9:	68 14 46 80 00       	push   $0x804614
  801ffe:	68 69 01 00 00       	push   $0x169
  802003:	68 71 42 80 00       	push   $0x804271
  802008:	e8 54 e4 ff ff       	call   800461 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	ff 75 08             	pushl  0x8(%ebp)
  802013:	e8 2c fa ff ff       	call   801a44 <free_pages>
  802018:	83 c4 10             	add    $0x10,%esp
		return;
  80201b:	eb 1b                	jmp    802038 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	68 70 46 80 00       	push   $0x804670
  802025:	68 70 01 00 00       	push   $0x170
  80202a:	68 71 42 80 00       	push   $0x804271
  80202f:	e8 2d e4 ff ff       	call   800461 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802034:	90                   	nop
  802035:	eb 01                	jmp    802038 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802037:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 38             	sub    $0x38,%esp
  802040:	8b 45 10             	mov    0x10(%ebp),%eax
  802043:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802046:	e8 2e fc ff ff       	call   801c79 <uheap_init>
	if (size == 0) return NULL ;
  80204b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80204f:	75 0a                	jne    80205b <smalloc+0x21>
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
  802056:	e9 3d 01 00 00       	jmp    802198 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80205b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802061:	8b 45 0c             	mov    0xc(%ebp),%eax
  802064:	25 ff 0f 00 00       	and    $0xfff,%eax
  802069:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80206c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802070:	74 0e                	je     802080 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802078:	05 00 10 00 00       	add    $0x1000,%eax
  80207d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	c1 e8 0c             	shr    $0xc,%eax
  802086:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802089:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 0a                	jne    80209c <smalloc+0x62>
		return NULL;
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	e9 fc 00 00 00       	jmp    802198 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80209c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	74 0f                	je     8020b4 <smalloc+0x7a>
  8020a5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020ab:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b0:	39 c2                	cmp    %eax,%edx
  8020b2:	73 0a                	jae    8020be <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8020b4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b9:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020be:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020c3:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020c8:	29 c2                	sub    %eax,%edx
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020cf:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020d5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020da:	29 c2                	sub    %eax,%edx
  8020dc:	89 d0                	mov    %edx,%eax
  8020de:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020e7:	77 13                	ja     8020fc <smalloc+0xc2>
  8020e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020ef:	77 0b                	ja     8020fc <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8020f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f4:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020fa:	73 0a                	jae    802106 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	e9 92 00 00 00       	jmp    802198 <smalloc+0x15e>
	}

	void *va = NULL;
  802106:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80210d:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802112:	83 f8 05             	cmp    $0x5,%eax
  802115:	75 11                	jne    802128 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	ff 75 f4             	pushl  -0xc(%ebp)
  80211d:	e8 08 f7 ff ff       	call   80182a <alloc_pages_custom_fit>
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802128:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80212c:	75 27                	jne    802155 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80212e:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802135:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802138:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80213b:	89 c2                	mov    %eax,%edx
  80213d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802142:	39 c2                	cmp    %eax,%edx
  802144:	73 07                	jae    80214d <smalloc+0x113>
			return NULL;}
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	eb 4b                	jmp    802198 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80214d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802152:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802155:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802159:	ff 75 f0             	pushl  -0x10(%ebp)
  80215c:	50                   	push   %eax
  80215d:	ff 75 0c             	pushl  0xc(%ebp)
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	e8 cb 03 00 00       	call   802533 <sys_create_shared_object>
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80216e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802172:	79 07                	jns    80217b <smalloc+0x141>
		return NULL;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	eb 1d                	jmp    802198 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80217b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802180:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802183:	75 10                	jne    802195 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802185:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	01 d0                	add    %edx,%eax
  802190:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802195:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021a0:	e8 d4 fa ff ff       	call   801c79 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021a5:	83 ec 08             	sub    $0x8,%esp
  8021a8:	ff 75 0c             	pushl  0xc(%ebp)
  8021ab:	ff 75 08             	pushl  0x8(%ebp)
  8021ae:	e8 aa 03 00 00       	call   80255d <sys_size_of_shared_object>
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8021b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021bd:	7f 0a                	jg     8021c9 <sget+0x2f>
		return NULL;
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	e9 32 01 00 00       	jmp    8022fb <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8021c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8021cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8021da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021de:	74 0e                	je     8021ee <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8021e6:	05 00 10 00 00       	add    $0x1000,%eax
  8021eb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8021ee:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	75 0a                	jne    802201 <sget+0x67>
		return NULL;
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fc:	e9 fa 00 00 00       	jmp    8022fb <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802201:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	74 0f                	je     802219 <sget+0x7f>
  80220a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802210:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802215:	39 c2                	cmp    %eax,%edx
  802217:	73 0a                	jae    802223 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802219:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80221e:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802223:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802228:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80222d:	29 c2                	sub    %eax,%edx
  80222f:	89 d0                	mov    %edx,%eax
  802231:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802234:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80223a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80223f:	29 c2                	sub    %eax,%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80224c:	77 13                	ja     802261 <sget+0xc7>
  80224e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802251:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802254:	77 0b                	ja     802261 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802256:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802259:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80225c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80225f:	73 0a                	jae    80226b <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
  802266:	e9 90 00 00 00       	jmp    8022fb <sget+0x161>

	void *va = NULL;
  80226b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802272:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802277:	83 f8 05             	cmp    $0x5,%eax
  80227a:	75 11                	jne    80228d <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80227c:	83 ec 0c             	sub    $0xc,%esp
  80227f:	ff 75 f4             	pushl  -0xc(%ebp)
  802282:	e8 a3 f5 ff ff       	call   80182a <alloc_pages_custom_fit>
  802287:	83 c4 10             	add    $0x10,%esp
  80228a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80228d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802291:	75 27                	jne    8022ba <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802293:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80229a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80229d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8022a0:	89 c2                	mov    %eax,%edx
  8022a2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022a7:	39 c2                	cmp    %eax,%edx
  8022a9:	73 07                	jae    8022b2 <sget+0x118>
			return NULL;
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b0:	eb 49                	jmp    8022fb <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8022b2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c0:	ff 75 0c             	pushl  0xc(%ebp)
  8022c3:	ff 75 08             	pushl  0x8(%ebp)
  8022c6:	e8 af 02 00 00       	call   80257a <sys_get_shared_object>
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8022d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022d5:	79 07                	jns    8022de <sget+0x144>
		return NULL;
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	eb 1d                	jmp    8022fb <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8022de:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022e3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8022e6:	75 10                	jne    8022f8 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8022e8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	01 d0                	add    %edx,%eax
  8022f3:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802303:	e8 71 f9 ff ff       	call   801c79 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802308:	83 ec 04             	sub    $0x4,%esp
  80230b:	68 94 46 80 00       	push   $0x804694
  802310:	68 19 02 00 00       	push   $0x219
  802315:	68 71 42 80 00       	push   $0x804271
  80231a:	e8 42 e1 ff ff       	call   800461 <_panic>

0080231f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	68 bc 46 80 00       	push   $0x8046bc
  80232d:	68 2b 02 00 00       	push   $0x22b
  802332:	68 71 42 80 00       	push   $0x804271
  802337:	e8 25 e1 ff ff       	call   800461 <_panic>

0080233c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	57                   	push   %edi
  802340:	56                   	push   %esi
  802341:	53                   	push   %ebx
  802342:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802351:	8b 7d 18             	mov    0x18(%ebp),%edi
  802354:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802357:	cd 30                	int    $0x30
  802359:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80235c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	5b                   	pop    %ebx
  802363:	5e                   	pop    %esi
  802364:	5f                   	pop    %edi
  802365:	5d                   	pop    %ebp
  802366:	c3                   	ret    

00802367 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	8b 45 10             	mov    0x10(%ebp),%eax
  802370:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802373:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802376:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	6a 00                	push   $0x0
  80237f:	51                   	push   %ecx
  802380:	52                   	push   %edx
  802381:	ff 75 0c             	pushl  0xc(%ebp)
  802384:	50                   	push   %eax
  802385:	6a 00                	push   $0x0
  802387:	e8 b0 ff ff ff       	call   80233c <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	90                   	nop
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_cgetc>:

int
sys_cgetc(void)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 02                	push   $0x2
  8023a1:	e8 96 ff ff ff       	call   80233c <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_lock_cons>:

void sys_lock_cons(void)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 03                	push   $0x3
  8023ba:	e8 7d ff ff ff       	call   80233c <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	90                   	nop
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 04                	push   $0x4
  8023d4:	e8 63 ff ff ff       	call   80233c <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
}
  8023dc:	90                   	nop
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	52                   	push   %edx
  8023ef:	50                   	push   %eax
  8023f0:	6a 08                	push   $0x8
  8023f2:	e8 45 ff ff ff       	call   80233c <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802401:	8b 75 18             	mov    0x18(%ebp),%esi
  802404:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802407:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	51                   	push   %ecx
  802413:	52                   	push   %edx
  802414:	50                   	push   %eax
  802415:	6a 09                	push   $0x9
  802417:	e8 20 ff ff ff       	call   80233c <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
}
  80241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802422:	5b                   	pop    %ebx
  802423:	5e                   	pop    %esi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    

00802426 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	ff 75 08             	pushl  0x8(%ebp)
  802434:	6a 0a                	push   $0xa
  802436:	e8 01 ff ff ff       	call   80233c <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	ff 75 0c             	pushl  0xc(%ebp)
  80244c:	ff 75 08             	pushl  0x8(%ebp)
  80244f:	6a 0b                	push   $0xb
  802451:	e8 e6 fe ff ff       	call   80233c <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 0c                	push   $0xc
  80246a:	e8 cd fe ff ff       	call   80233c <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 0d                	push   $0xd
  802483:	e8 b4 fe ff ff       	call   80233c <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 0e                	push   $0xe
  80249c:	e8 9b fe ff ff       	call   80233c <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 0f                	push   $0xf
  8024b5:	e8 82 fe ff ff       	call   80233c <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	ff 75 08             	pushl  0x8(%ebp)
  8024cd:	6a 10                	push   $0x10
  8024cf:	e8 68 fe ff ff       	call   80233c <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 11                	push   $0x11
  8024e8:	e8 4f fe ff ff       	call   80233c <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
}
  8024f0:	90                   	nop
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 04             	sub    $0x4,%esp
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	50                   	push   %eax
  80250c:	6a 01                	push   $0x1
  80250e:	e8 29 fe ff ff       	call   80233c <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	90                   	nop
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 14                	push   $0x14
  802528:	e8 0f fe ff ff       	call   80233c <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	90                   	nop
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	8b 45 10             	mov    0x10(%ebp),%eax
  80253c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80253f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802542:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	6a 00                	push   $0x0
  80254b:	51                   	push   %ecx
  80254c:	52                   	push   %edx
  80254d:	ff 75 0c             	pushl  0xc(%ebp)
  802550:	50                   	push   %eax
  802551:	6a 15                	push   $0x15
  802553:	e8 e4 fd ff ff       	call   80233c <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802560:	8b 55 0c             	mov    0xc(%ebp),%edx
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	52                   	push   %edx
  80256d:	50                   	push   %eax
  80256e:	6a 16                	push   $0x16
  802570:	e8 c7 fd ff ff       	call   80233c <syscall>
  802575:	83 c4 18             	add    $0x18,%esp
}
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80257d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	51                   	push   %ecx
  80258b:	52                   	push   %edx
  80258c:	50                   	push   %eax
  80258d:	6a 17                	push   $0x17
  80258f:	e8 a8 fd ff ff       	call   80233c <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80259c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	52                   	push   %edx
  8025a9:	50                   	push   %eax
  8025aa:	6a 18                	push   $0x18
  8025ac:	e8 8b fd ff ff       	call   80233c <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	6a 00                	push   $0x0
  8025be:	ff 75 14             	pushl  0x14(%ebp)
  8025c1:	ff 75 10             	pushl  0x10(%ebp)
  8025c4:	ff 75 0c             	pushl  0xc(%ebp)
  8025c7:	50                   	push   %eax
  8025c8:	6a 19                	push   $0x19
  8025ca:	e8 6d fd ff ff       	call   80233c <syscall>
  8025cf:	83 c4 18             	add    $0x18,%esp
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	50                   	push   %eax
  8025e3:	6a 1a                	push   $0x1a
  8025e5:	e8 52 fd ff ff       	call   80233c <syscall>
  8025ea:	83 c4 18             	add    $0x18,%esp
}
  8025ed:	90                   	nop
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	50                   	push   %eax
  8025ff:	6a 1b                	push   $0x1b
  802601:	e8 36 fd ff ff       	call   80233c <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 05                	push   $0x5
  80261a:	e8 1d fd ff ff       	call   80233c <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 06                	push   $0x6
  802633:	e8 04 fd ff ff       	call   80233c <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 07                	push   $0x7
  80264c:	e8 eb fc ff ff       	call   80233c <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <sys_exit_env>:


void sys_exit_env(void)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 1c                	push   $0x1c
  802665:	e8 d2 fc ff ff       	call   80233c <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
}
  80266d:	90                   	nop
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802676:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802679:	8d 50 04             	lea    0x4(%eax),%edx
  80267c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	52                   	push   %edx
  802686:	50                   	push   %eax
  802687:	6a 1d                	push   $0x1d
  802689:	e8 ae fc ff ff       	call   80233c <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
	return result;
  802691:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802694:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802697:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80269a:	89 01                	mov    %eax,(%ecx)
  80269c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	c9                   	leave  
  8026a3:	c2 04 00             	ret    $0x4

008026a6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	ff 75 10             	pushl  0x10(%ebp)
  8026b0:	ff 75 0c             	pushl  0xc(%ebp)
  8026b3:	ff 75 08             	pushl  0x8(%ebp)
  8026b6:	6a 13                	push   $0x13
  8026b8:	e8 7f fc ff ff       	call   80233c <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c0:	90                   	nop
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 1e                	push   $0x1e
  8026d2:	e8 65 fc ff ff       	call   80233c <syscall>
  8026d7:	83 c4 18             	add    $0x18,%esp
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026e8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	50                   	push   %eax
  8026f5:	6a 1f                	push   $0x1f
  8026f7:	e8 40 fc ff ff       	call   80233c <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ff:	90                   	nop
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <rsttst>:
void rsttst()
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 21                	push   $0x21
  802711:	e8 26 fc ff ff       	call   80233c <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
	return ;
  802719:	90                   	nop
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	8b 45 14             	mov    0x14(%ebp),%eax
  802725:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802728:	8b 55 18             	mov    0x18(%ebp),%edx
  80272b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80272f:	52                   	push   %edx
  802730:	50                   	push   %eax
  802731:	ff 75 10             	pushl  0x10(%ebp)
  802734:	ff 75 0c             	pushl  0xc(%ebp)
  802737:	ff 75 08             	pushl  0x8(%ebp)
  80273a:	6a 20                	push   $0x20
  80273c:	e8 fb fb ff ff       	call   80233c <syscall>
  802741:	83 c4 18             	add    $0x18,%esp
	return ;
  802744:	90                   	nop
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <chktst>:
void chktst(uint32 n)
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	ff 75 08             	pushl  0x8(%ebp)
  802755:	6a 22                	push   $0x22
  802757:	e8 e0 fb ff ff       	call   80233c <syscall>
  80275c:	83 c4 18             	add    $0x18,%esp
	return ;
  80275f:	90                   	nop
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <inctst>:

void inctst()
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 23                	push   $0x23
  802771:	e8 c6 fb ff ff       	call   80233c <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
	return ;
  802779:	90                   	nop
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <gettst>:
uint32 gettst()
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 24                	push   $0x24
  80278b:	e8 ac fb ff ff       	call   80233c <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 25                	push   $0x25
  8027a4:	e8 93 fb ff ff       	call   80233c <syscall>
  8027a9:	83 c4 18             	add    $0x18,%esp
  8027ac:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8027b1:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	ff 75 08             	pushl  0x8(%ebp)
  8027ce:	6a 26                	push   $0x26
  8027d0:	e8 67 fb ff ff       	call   80233c <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d8:	90                   	nop
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	6a 00                	push   $0x0
  8027ed:	53                   	push   %ebx
  8027ee:	51                   	push   %ecx
  8027ef:	52                   	push   %edx
  8027f0:	50                   	push   %eax
  8027f1:	6a 27                	push   $0x27
  8027f3:	e8 44 fb ff ff       	call   80233c <syscall>
  8027f8:	83 c4 18             	add    $0x18,%esp
}
  8027fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802803:	8b 55 0c             	mov    0xc(%ebp),%edx
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	52                   	push   %edx
  802810:	50                   	push   %eax
  802811:	6a 28                	push   $0x28
  802813:	e8 24 fb ff ff       	call   80233c <syscall>
  802818:	83 c4 18             	add    $0x18,%esp
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802820:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802823:	8b 55 0c             	mov    0xc(%ebp),%edx
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	6a 00                	push   $0x0
  80282b:	51                   	push   %ecx
  80282c:	ff 75 10             	pushl  0x10(%ebp)
  80282f:	52                   	push   %edx
  802830:	50                   	push   %eax
  802831:	6a 29                	push   $0x29
  802833:	e8 04 fb ff ff       	call   80233c <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	ff 75 10             	pushl  0x10(%ebp)
  802847:	ff 75 0c             	pushl  0xc(%ebp)
  80284a:	ff 75 08             	pushl  0x8(%ebp)
  80284d:	6a 12                	push   $0x12
  80284f:	e8 e8 fa ff ff       	call   80233c <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
	return ;
  802857:	90                   	nop
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80285d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	52                   	push   %edx
  80286a:	50                   	push   %eax
  80286b:	6a 2a                	push   $0x2a
  80286d:	e8 ca fa ff ff       	call   80233c <syscall>
  802872:	83 c4 18             	add    $0x18,%esp
	return;
  802875:	90                   	nop
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 2b                	push   $0x2b
  802887:	e8 b0 fa ff ff       	call   80233c <syscall>
  80288c:	83 c4 18             	add    $0x18,%esp
}
  80288f:	c9                   	leave  
  802890:	c3                   	ret    

00802891 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	ff 75 0c             	pushl  0xc(%ebp)
  80289d:	ff 75 08             	pushl  0x8(%ebp)
  8028a0:	6a 2d                	push   $0x2d
  8028a2:	e8 95 fa ff ff       	call   80233c <syscall>
  8028a7:	83 c4 18             	add    $0x18,%esp
	return;
  8028aa:	90                   	nop
}
  8028ab:	c9                   	leave  
  8028ac:	c3                   	ret    

008028ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	ff 75 0c             	pushl  0xc(%ebp)
  8028b9:	ff 75 08             	pushl  0x8(%ebp)
  8028bc:	6a 2c                	push   $0x2c
  8028be:	e8 79 fa ff ff       	call   80233c <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028c6:	90                   	nop
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8028cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	52                   	push   %edx
  8028d9:	50                   	push   %eax
  8028da:	6a 2e                	push   $0x2e
  8028dc:	e8 5b fa ff ff       	call   80233c <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e4:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8028ed:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8028f4:	72 09                	jb     8028ff <to_page_va+0x18>
  8028f6:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8028fd:	72 14                	jb     802913 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	68 e0 46 80 00       	push   $0x8046e0
  802907:	6a 15                	push   $0x15
  802909:	68 0b 47 80 00       	push   $0x80470b
  80290e:	e8 4e db ff ff       	call   800461 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	ba 60 50 80 00       	mov    $0x805060,%edx
  80291b:	29 d0                	sub    %edx,%eax
  80291d:	c1 f8 02             	sar    $0x2,%eax
  802920:	89 c2                	mov    %eax,%edx
  802922:	89 d0                	mov    %edx,%eax
  802924:	c1 e0 02             	shl    $0x2,%eax
  802927:	01 d0                	add    %edx,%eax
  802929:	c1 e0 02             	shl    $0x2,%eax
  80292c:	01 d0                	add    %edx,%eax
  80292e:	c1 e0 02             	shl    $0x2,%eax
  802931:	01 d0                	add    %edx,%eax
  802933:	89 c1                	mov    %eax,%ecx
  802935:	c1 e1 08             	shl    $0x8,%ecx
  802938:	01 c8                	add    %ecx,%eax
  80293a:	89 c1                	mov    %eax,%ecx
  80293c:	c1 e1 10             	shl    $0x10,%ecx
  80293f:	01 c8                	add    %ecx,%eax
  802941:	01 c0                	add    %eax,%eax
  802943:	01 d0                	add    %edx,%eax
  802945:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	c1 e0 0c             	shl    $0xc,%eax
  80294e:	89 c2                	mov    %eax,%edx
  802950:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802955:	01 d0                	add    %edx,%eax
}
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
  80295c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80295f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802964:	8b 55 08             	mov    0x8(%ebp),%edx
  802967:	29 c2                	sub    %eax,%edx
  802969:	89 d0                	mov    %edx,%eax
  80296b:	c1 e8 0c             	shr    $0xc,%eax
  80296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802975:	78 09                	js     802980 <to_page_info+0x27>
  802977:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80297e:	7e 14                	jle    802994 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 24 47 80 00       	push   $0x804724
  802988:	6a 22                	push   $0x22
  80298a:	68 0b 47 80 00       	push   $0x80470b
  80298f:	e8 cd da ff ff       	call   800461 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802997:	89 d0                	mov    %edx,%eax
  802999:	01 c0                	add    %eax,%eax
  80299b:	01 d0                	add    %edx,%eax
  80299d:	c1 e0 02             	shl    $0x2,%eax
  8029a0:	05 60 50 80 00       	add    $0x805060,%eax
}
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
  8029aa:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	05 00 00 00 02       	add    $0x2000000,%eax
  8029b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029b8:	73 16                	jae    8029d0 <initialize_dynamic_allocator+0x29>
  8029ba:	68 48 47 80 00       	push   $0x804748
  8029bf:	68 6e 47 80 00       	push   $0x80476e
  8029c4:	6a 34                	push   $0x34
  8029c6:	68 0b 47 80 00       	push   $0x80470b
  8029cb:	e8 91 da ff ff       	call   800461 <_panic>
		is_initialized = 1;
  8029d0:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8029d7:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8029e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e5:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8029ea:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8029f1:	00 00 00 
  8029f4:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8029fb:	00 00 00 
  8029fe:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802a05:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802a08:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802a0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a16:	eb 36                	jmp    802a4e <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	c1 e0 04             	shl    $0x4,%eax
  802a1e:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	c1 e0 04             	shl    $0x4,%eax
  802a2f:	05 84 d0 81 00       	add    $0x81d084,%eax
  802a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	c1 e0 04             	shl    $0x4,%eax
  802a40:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802a4b:	ff 45 f4             	incl   -0xc(%ebp)
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a54:	72 c2                	jb     802a18 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802a56:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a5c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a61:	29 c2                	sub    %eax,%edx
  802a63:	89 d0                	mov    %edx,%eax
  802a65:	c1 e8 0c             	shr    $0xc,%eax
  802a68:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a72:	e9 c8 00 00 00       	jmp    802b3f <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a7a:	89 d0                	mov    %edx,%eax
  802a7c:	01 c0                	add    %eax,%eax
  802a7e:	01 d0                	add    %edx,%eax
  802a80:	c1 e0 02             	shl    $0x2,%eax
  802a83:	05 68 50 80 00       	add    $0x805068,%eax
  802a88:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	01 c0                	add    %eax,%eax
  802a94:	01 d0                	add    %edx,%eax
  802a96:	c1 e0 02             	shl    $0x2,%eax
  802a99:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a9e:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802aa3:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802aa9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802aac:	89 c8                	mov    %ecx,%eax
  802aae:	01 c0                	add    %eax,%eax
  802ab0:	01 c8                	add    %ecx,%eax
  802ab2:	c1 e0 02             	shl    $0x2,%eax
  802ab5:	05 64 50 80 00       	add    $0x805064,%eax
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abf:	89 d0                	mov    %edx,%eax
  802ac1:	01 c0                	add    %eax,%eax
  802ac3:	01 d0                	add    %edx,%eax
  802ac5:	c1 e0 02             	shl    $0x2,%eax
  802ac8:	05 64 50 80 00       	add    $0x805064,%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	74 1b                	je     802aee <initialize_dynamic_allocator+0x147>
  802ad3:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ad9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802adc:	89 c8                	mov    %ecx,%eax
  802ade:	01 c0                	add    %eax,%eax
  802ae0:	01 c8                	add    %ecx,%eax
  802ae2:	c1 e0 02             	shl    $0x2,%eax
  802ae5:	05 60 50 80 00       	add    $0x805060,%eax
  802aea:	89 02                	mov    %eax,(%edx)
  802aec:	eb 16                	jmp    802b04 <initialize_dynamic_allocator+0x15d>
  802aee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af1:	89 d0                	mov    %edx,%eax
  802af3:	01 c0                	add    %eax,%eax
  802af5:	01 d0                	add    %edx,%eax
  802af7:	c1 e0 02             	shl    $0x2,%eax
  802afa:	05 60 50 80 00       	add    $0x805060,%eax
  802aff:	a3 48 50 80 00       	mov    %eax,0x805048
  802b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b07:	89 d0                	mov    %edx,%eax
  802b09:	01 c0                	add    %eax,%eax
  802b0b:	01 d0                	add    %edx,%eax
  802b0d:	c1 e0 02             	shl    $0x2,%eax
  802b10:	05 60 50 80 00       	add    $0x805060,%eax
  802b15:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1d:	89 d0                	mov    %edx,%eax
  802b1f:	01 c0                	add    %eax,%eax
  802b21:	01 d0                	add    %edx,%eax
  802b23:	c1 e0 02             	shl    $0x2,%eax
  802b26:	05 60 50 80 00       	add    $0x805060,%eax
  802b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b31:	a1 54 50 80 00       	mov    0x805054,%eax
  802b36:	40                   	inc    %eax
  802b37:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802b3c:	ff 45 f0             	incl   -0x10(%ebp)
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b45:	0f 82 2c ff ff ff    	jb     802a77 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b51:	eb 2f                	jmp    802b82 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802b53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b56:	89 d0                	mov    %edx,%eax
  802b58:	01 c0                	add    %eax,%eax
  802b5a:	01 d0                	add    %edx,%eax
  802b5c:	c1 e0 02             	shl    $0x2,%eax
  802b5f:	05 68 50 80 00       	add    $0x805068,%eax
  802b64:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6c:	89 d0                	mov    %edx,%eax
  802b6e:	01 c0                	add    %eax,%eax
  802b70:	01 d0                	add    %edx,%eax
  802b72:	c1 e0 02             	shl    $0x2,%eax
  802b75:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b7a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b7f:	ff 45 ec             	incl   -0x14(%ebp)
  802b82:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802b89:	76 c8                	jbe    802b53 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802b8b:	90                   	nop
  802b8c:	c9                   	leave  
  802b8d:	c3                   	ret    

00802b8e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802b8e:	55                   	push   %ebp
  802b8f:	89 e5                	mov    %esp,%ebp
  802b91:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802b94:	8b 55 08             	mov    0x8(%ebp),%edx
  802b97:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b9c:	29 c2                	sub    %eax,%edx
  802b9e:	89 d0                	mov    %edx,%eax
  802ba0:	c1 e8 0c             	shr    $0xc,%eax
  802ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802ba6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ba9:	89 d0                	mov    %edx,%eax
  802bab:	01 c0                	add    %eax,%eax
  802bad:	01 d0                	add    %edx,%eax
  802baf:	c1 e0 02             	shl    $0x2,%eax
  802bb2:	05 68 50 80 00       	add    $0x805068,%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802bbc:	c9                   	leave  
  802bbd:	c3                   	ret    

00802bbe <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802bbe:	55                   	push   %ebp
  802bbf:	89 e5                	mov    %esp,%ebp
  802bc1:	83 ec 14             	sub    $0x14,%esp
  802bc4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802bc7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802bcb:	77 07                	ja     802bd4 <nearest_pow2_ceil.1513+0x16>
  802bcd:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd2:	eb 20                	jmp    802bf4 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802bd4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802bdb:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802bde:	eb 08                	jmp    802be8 <nearest_pow2_ceil.1513+0x2a>
  802be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802be3:	01 c0                	add    %eax,%eax
  802be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802be8:	d1 6d 08             	shrl   0x8(%ebp)
  802beb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bef:	75 ef                	jne    802be0 <nearest_pow2_ceil.1513+0x22>
        return power;
  802bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802bf4:	c9                   	leave  
  802bf5:	c3                   	ret    

00802bf6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
  802bf9:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802bfc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802c03:	76 16                	jbe    802c1b <alloc_block+0x25>
  802c05:	68 84 47 80 00       	push   $0x804784
  802c0a:	68 6e 47 80 00       	push   $0x80476e
  802c0f:	6a 72                	push   $0x72
  802c11:	68 0b 47 80 00       	push   $0x80470b
  802c16:	e8 46 d8 ff ff       	call   800461 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802c1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1f:	75 0a                	jne    802c2b <alloc_block+0x35>
  802c21:	b8 00 00 00 00       	mov    $0x0,%eax
  802c26:	e9 bd 04 00 00       	jmp    8030e8 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802c2b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c38:	73 06                	jae    802c40 <alloc_block+0x4a>
        size = min_block_size;
  802c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3d:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802c40:	83 ec 0c             	sub    $0xc,%esp
  802c43:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c46:	ff 75 08             	pushl  0x8(%ebp)
  802c49:	89 c1                	mov    %eax,%ecx
  802c4b:	e8 6e ff ff ff       	call   802bbe <nearest_pow2_ceil.1513>
  802c50:	83 c4 10             	add    $0x10,%esp
  802c53:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802c56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c59:	83 ec 0c             	sub    $0xc,%esp
  802c5c:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c5f:	52                   	push   %edx
  802c60:	89 c1                	mov    %eax,%ecx
  802c62:	e8 83 04 00 00       	call   8030ea <log2_ceil.1520>
  802c67:	83 c4 10             	add    $0x10,%esp
  802c6a:	83 e8 03             	sub    $0x3,%eax
  802c6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c73:	c1 e0 04             	shl    $0x4,%eax
  802c76:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	0f 84 d8 00 00 00    	je     802d5d <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c88:	c1 e0 04             	shl    $0x4,%eax
  802c8b:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802c95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c99:	75 17                	jne    802cb2 <alloc_block+0xbc>
  802c9b:	83 ec 04             	sub    $0x4,%esp
  802c9e:	68 a5 47 80 00       	push   $0x8047a5
  802ca3:	68 98 00 00 00       	push   $0x98
  802ca8:	68 0b 47 80 00       	push   $0x80470b
  802cad:	e8 af d7 ff ff       	call   800461 <_panic>
  802cb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 10                	je     802ccb <alloc_block+0xd5>
  802cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc3:	8b 52 04             	mov    0x4(%edx),%edx
  802cc6:	89 50 04             	mov    %edx,0x4(%eax)
  802cc9:	eb 14                	jmp    802cdf <alloc_block+0xe9>
  802ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cd4:	c1 e2 04             	shl    $0x4,%edx
  802cd7:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802cdd:	89 02                	mov    %eax,(%edx)
  802cdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 0f                	je     802cf8 <alloc_block+0x102>
  802ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cec:	8b 40 04             	mov    0x4(%eax),%eax
  802cef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf2:	8b 12                	mov    (%edx),%edx
  802cf4:	89 10                	mov    %edx,(%eax)
  802cf6:	eb 13                	jmp    802d0b <alloc_block+0x115>
  802cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d00:	c1 e2 04             	shl    $0x4,%edx
  802d03:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d09:	89 02                	mov    %eax,(%edx)
  802d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d21:	c1 e0 04             	shl    $0x4,%eax
  802d24:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d31:	c1 e0 04             	shl    $0x4,%eax
  802d34:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d39:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3e:	83 ec 0c             	sub    $0xc,%esp
  802d41:	50                   	push   %eax
  802d42:	e8 12 fc ff ff       	call   802959 <to_page_info>
  802d47:	83 c4 10             	add    $0x10,%esp
  802d4a:	89 c2                	mov    %eax,%edx
  802d4c:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d50:	48                   	dec    %eax
  802d51:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d58:	e9 8b 03 00 00       	jmp    8030e8 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802d5d:	a1 48 50 80 00       	mov    0x805048,%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	0f 84 64 02 00 00    	je     802fce <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d6a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d6f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d76:	75 17                	jne    802d8f <alloc_block+0x199>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 a5 47 80 00       	push   $0x8047a5
  802d80:	68 a0 00 00 00       	push   $0xa0
  802d85:	68 0b 47 80 00       	push   $0x80470b
  802d8a:	e8 d2 d6 ff ff       	call   800461 <_panic>
  802d8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 10                	je     802da8 <alloc_block+0x1b2>
  802d98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da0:	8b 52 04             	mov    0x4(%edx),%edx
  802da3:	89 50 04             	mov    %edx,0x4(%eax)
  802da6:	eb 0b                	jmp    802db3 <alloc_block+0x1bd>
  802da8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	74 0f                	je     802dcc <alloc_block+0x1d6>
  802dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc0:	8b 40 04             	mov    0x4(%eax),%eax
  802dc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dc6:	8b 12                	mov    (%edx),%edx
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	eb 0a                	jmp    802dd6 <alloc_block+0x1e0>
  802dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	a3 48 50 80 00       	mov    %eax,0x805048
  802dd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de9:	a1 54 50 80 00       	mov    0x805054,%eax
  802dee:	48                   	dec    %eax
  802def:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dfa:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802dfe:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e03:	99                   	cltd   
  802e04:	f7 7d e8             	idivl  -0x18(%ebp)
  802e07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e0a:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802e0e:	83 ec 0c             	sub    $0xc,%esp
  802e11:	ff 75 dc             	pushl  -0x24(%ebp)
  802e14:	e8 ce fa ff ff       	call   8028e7 <to_page_va>
  802e19:	83 c4 10             	add    $0x10,%esp
  802e1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802e1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	50                   	push   %eax
  802e26:	e8 c0 ee ff ff       	call   801ceb <get_page>
  802e2b:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e35:	e9 aa 00 00 00       	jmp    802ee4 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802e41:	89 c2                	mov    %eax,%edx
  802e43:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e46:	01 d0                	add    %edx,%eax
  802e48:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802e4b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e4f:	75 17                	jne    802e68 <alloc_block+0x272>
  802e51:	83 ec 04             	sub    $0x4,%esp
  802e54:	68 c4 47 80 00       	push   $0x8047c4
  802e59:	68 aa 00 00 00       	push   $0xaa
  802e5e:	68 0b 47 80 00       	push   $0x80470b
  802e63:	e8 f9 d5 ff ff       	call   800461 <_panic>
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	c1 e0 04             	shl    $0x4,%eax
  802e6e:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e73:	8b 10                	mov    (%eax),%edx
  802e75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e78:	89 50 04             	mov    %edx,0x4(%eax)
  802e7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 14                	je     802e99 <alloc_block+0x2a3>
  802e85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e88:	c1 e0 04             	shl    $0x4,%eax
  802e8b:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e95:	89 10                	mov    %edx,(%eax)
  802e97:	eb 11                	jmp    802eaa <alloc_block+0x2b4>
  802e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9c:	c1 e0 04             	shl    $0x4,%eax
  802e9f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802ea5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea8:	89 02                	mov    %eax,(%edx)
  802eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ead:	c1 e0 04             	shl    $0x4,%eax
  802eb0:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802eb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eb9:	89 02                	mov    %eax,(%edx)
  802ebb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec7:	c1 e0 04             	shl    $0x4,%eax
  802eca:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	8d 50 01             	lea    0x1(%eax),%edx
  802ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed7:	c1 e0 04             	shl    $0x4,%eax
  802eda:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802edf:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802ee1:	ff 45 f4             	incl   -0xc(%ebp)
  802ee4:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ee9:	99                   	cltd   
  802eea:	f7 7d e8             	idivl  -0x18(%ebp)
  802eed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ef0:	0f 8f 44 ff ff ff    	jg     802e3a <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef9:	c1 e0 04             	shl    $0x4,%eax
  802efc:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802f06:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f0a:	75 17                	jne    802f23 <alloc_block+0x32d>
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 a5 47 80 00       	push   $0x8047a5
  802f14:	68 ae 00 00 00       	push   $0xae
  802f19:	68 0b 47 80 00       	push   $0x80470b
  802f1e:	e8 3e d5 ff ff       	call   800461 <_panic>
  802f23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 10                	je     802f3c <alloc_block+0x346>
  802f2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f34:	8b 52 04             	mov    0x4(%edx),%edx
  802f37:	89 50 04             	mov    %edx,0x4(%eax)
  802f3a:	eb 14                	jmp    802f50 <alloc_block+0x35a>
  802f3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f45:	c1 e2 04             	shl    $0x4,%edx
  802f48:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f4e:	89 02                	mov    %eax,(%edx)
  802f50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0f                	je     802f69 <alloc_block+0x373>
  802f5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f63:	8b 12                	mov    (%edx),%edx
  802f65:	89 10                	mov    %edx,(%eax)
  802f67:	eb 13                	jmp    802f7c <alloc_block+0x386>
  802f69:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f71:	c1 e2 04             	shl    $0x4,%edx
  802f74:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f7a:	89 02                	mov    %eax,(%edx)
  802f7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f85:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f92:	c1 e0 04             	shl    $0x4,%eax
  802f95:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa2:	c1 e0 04             	shl    $0x4,%eax
  802fa5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802faa:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802fac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802faf:	83 ec 0c             	sub    $0xc,%esp
  802fb2:	50                   	push   %eax
  802fb3:	e8 a1 f9 ff ff       	call   802959 <to_page_info>
  802fb8:	83 c4 10             	add    $0x10,%esp
  802fbb:	89 c2                	mov    %eax,%edx
  802fbd:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fc1:	48                   	dec    %eax
  802fc2:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802fc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fc9:	e9 1a 01 00 00       	jmp    8030e8 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd1:	40                   	inc    %eax
  802fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fd5:	e9 ed 00 00 00       	jmp    8030c7 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdd:	c1 e0 04             	shl    $0x4,%eax
  802fe0:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	0f 84 d5 00 00 00    	je     8030c4 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	c1 e0 04             	shl    $0x4,%eax
  802ff5:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802fff:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803003:	75 17                	jne    80301c <alloc_block+0x426>
  803005:	83 ec 04             	sub    $0x4,%esp
  803008:	68 a5 47 80 00       	push   $0x8047a5
  80300d:	68 b8 00 00 00       	push   $0xb8
  803012:	68 0b 47 80 00       	push   $0x80470b
  803017:	e8 45 d4 ff ff       	call   800461 <_panic>
  80301c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 10                	je     803035 <alloc_block+0x43f>
  803025:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80302d:	8b 52 04             	mov    0x4(%edx),%edx
  803030:	89 50 04             	mov    %edx,0x4(%eax)
  803033:	eb 14                	jmp    803049 <alloc_block+0x453>
  803035:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303e:	c1 e2 04             	shl    $0x4,%edx
  803041:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803047:	89 02                	mov    %eax,(%edx)
  803049:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	74 0f                	je     803062 <alloc_block+0x46c>
  803053:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803056:	8b 40 04             	mov    0x4(%eax),%eax
  803059:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80305c:	8b 12                	mov    (%edx),%edx
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	eb 13                	jmp    803075 <alloc_block+0x47f>
  803062:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306a:	c1 e2 04             	shl    $0x4,%edx
  80306d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803073:	89 02                	mov    %eax,(%edx)
  803075:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803078:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	c1 e0 04             	shl    $0x4,%eax
  80308e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	8d 50 ff             	lea    -0x1(%eax),%edx
  803098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309b:	c1 e0 04             	shl    $0x4,%eax
  80309e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030a3:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8030a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a8:	83 ec 0c             	sub    $0xc,%esp
  8030ab:	50                   	push   %eax
  8030ac:	e8 a8 f8 ff ff       	call   802959 <to_page_info>
  8030b1:	83 c4 10             	add    $0x10,%esp
  8030b4:	89 c2                	mov    %eax,%edx
  8030b6:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8030ba:	48                   	dec    %eax
  8030bb:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8030bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c2:	eb 24                	jmp    8030e8 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030c4:	ff 45 f0             	incl   -0x10(%ebp)
  8030c7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030cb:	0f 8e 09 ff ff ff    	jle    802fda <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	68 e7 47 80 00       	push   $0x8047e7
  8030d9:	68 bf 00 00 00       	push   $0xbf
  8030de:	68 0b 47 80 00       	push   $0x80470b
  8030e3:	e8 79 d3 ff ff       	call   800461 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    

008030ea <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
  8030ed:	83 ec 14             	sub    $0x14,%esp
  8030f0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8030f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f7:	75 07                	jne    803100 <log2_ceil.1520+0x16>
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fe:	eb 1b                	jmp    80311b <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803107:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80310a:	eb 06                	jmp    803112 <log2_ceil.1520+0x28>
            x >>= 1;
  80310c:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80310f:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803116:	75 f4                	jne    80310c <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803118:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80311b:	c9                   	leave  
  80311c:	c3                   	ret    

0080311d <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80311d:	55                   	push   %ebp
  80311e:	89 e5                	mov    %esp,%ebp
  803120:	83 ec 14             	sub    $0x14,%esp
  803123:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312a:	75 07                	jne    803133 <log2_ceil.1547+0x16>
  80312c:	b8 00 00 00 00       	mov    $0x0,%eax
  803131:	eb 1b                	jmp    80314e <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80313a:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80313d:	eb 06                	jmp    803145 <log2_ceil.1547+0x28>
			x >>= 1;
  80313f:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803142:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803145:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803149:	75 f4                	jne    80313f <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80314b:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80314e:	c9                   	leave  
  80314f:	c3                   	ret    

00803150 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
  803153:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803156:	8b 55 08             	mov    0x8(%ebp),%edx
  803159:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80315e:	39 c2                	cmp    %eax,%edx
  803160:	72 0c                	jb     80316e <free_block+0x1e>
  803162:	8b 55 08             	mov    0x8(%ebp),%edx
  803165:	a1 40 50 80 00       	mov    0x805040,%eax
  80316a:	39 c2                	cmp    %eax,%edx
  80316c:	72 19                	jb     803187 <free_block+0x37>
  80316e:	68 ec 47 80 00       	push   $0x8047ec
  803173:	68 6e 47 80 00       	push   $0x80476e
  803178:	68 d0 00 00 00       	push   $0xd0
  80317d:	68 0b 47 80 00       	push   $0x80470b
  803182:	e8 da d2 ff ff       	call   800461 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318b:	0f 84 42 03 00 00    	je     8034d3 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803191:	8b 55 08             	mov    0x8(%ebp),%edx
  803194:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803199:	39 c2                	cmp    %eax,%edx
  80319b:	72 0c                	jb     8031a9 <free_block+0x59>
  80319d:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a0:	a1 40 50 80 00       	mov    0x805040,%eax
  8031a5:	39 c2                	cmp    %eax,%edx
  8031a7:	72 17                	jb     8031c0 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	68 24 48 80 00       	push   $0x804824
  8031b1:	68 e6 00 00 00       	push   $0xe6
  8031b6:	68 0b 47 80 00       	push   $0x80470b
  8031bb:	e8 a1 d2 ff ff       	call   800461 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8031c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031c8:	29 c2                	sub    %eax,%edx
  8031ca:	89 d0                	mov    %edx,%eax
  8031cc:	83 e0 07             	and    $0x7,%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 17                	je     8031ea <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 58 48 80 00       	push   $0x804858
  8031db:	68 ea 00 00 00       	push   $0xea
  8031e0:	68 0b 47 80 00       	push   $0x80470b
  8031e5:	e8 77 d2 ff ff       	call   800461 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	83 ec 0c             	sub    $0xc,%esp
  8031f0:	50                   	push   %eax
  8031f1:	e8 63 f7 ff ff       	call   802959 <to_page_info>
  8031f6:	83 c4 10             	add    $0x10,%esp
  8031f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8031fc:	83 ec 0c             	sub    $0xc,%esp
  8031ff:	ff 75 08             	pushl  0x8(%ebp)
  803202:	e8 87 f9 ff ff       	call   802b8e <get_block_size>
  803207:	83 c4 10             	add    $0x10,%esp
  80320a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80320d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803211:	75 17                	jne    80322a <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803213:	83 ec 04             	sub    $0x4,%esp
  803216:	68 84 48 80 00       	push   $0x804884
  80321b:	68 f1 00 00 00       	push   $0xf1
  803220:	68 0b 47 80 00       	push   $0x80470b
  803225:	e8 37 d2 ff ff       	call   800461 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80322a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322d:	83 ec 0c             	sub    $0xc,%esp
  803230:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803233:	52                   	push   %edx
  803234:	89 c1                	mov    %eax,%ecx
  803236:	e8 e2 fe ff ff       	call   80311d <log2_ceil.1547>
  80323b:	83 c4 10             	add    $0x10,%esp
  80323e:	83 e8 03             	sub    $0x3,%eax
  803241:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80324a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80324e:	75 17                	jne    803267 <free_block+0x117>
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 d0 48 80 00       	push   $0x8048d0
  803258:	68 f6 00 00 00       	push   $0xf6
  80325d:	68 0b 47 80 00       	push   $0x80470b
  803262:	e8 fa d1 ff ff       	call   800461 <_panic>
  803267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326a:	c1 e0 04             	shl    $0x4,%eax
  80326d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803272:	8b 10                	mov    (%eax),%edx
  803274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803277:	89 10                	mov    %edx,(%eax)
  803279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 15                	je     803297 <free_block+0x147>
  803282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803285:	c1 e0 04             	shl    $0x4,%eax
  803288:	05 80 d0 81 00       	add    $0x81d080,%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803292:	89 50 04             	mov    %edx,0x4(%eax)
  803295:	eb 11                	jmp    8032a8 <free_block+0x158>
  803297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329a:	c1 e0 04             	shl    $0x4,%eax
  80329d:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8032a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a6:	89 02                	mov    %eax,(%edx)
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	c1 e0 04             	shl    $0x4,%eax
  8032ae:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8032b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b7:	89 02                	mov    %eax,(%edx)
  8032b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c6:	c1 e0 04             	shl    $0x4,%eax
  8032c9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	8d 50 01             	lea    0x1(%eax),%edx
  8032d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d6:	c1 e0 04             	shl    $0x4,%eax
  8032d9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032de:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8032e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032e7:	40                   	inc    %eax
  8032e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032eb:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8032ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032f7:	29 c2                	sub    %eax,%edx
  8032f9:	89 d0                	mov    %edx,%eax
  8032fb:	c1 e8 0c             	shr    $0xc,%eax
  8032fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803301:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803304:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803308:	0f b7 c8             	movzwl %ax,%ecx
  80330b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803310:	99                   	cltd   
  803311:	f7 7d e8             	idivl  -0x18(%ebp)
  803314:	39 c1                	cmp    %eax,%ecx
  803316:	0f 85 b8 01 00 00    	jne    8034d4 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80331c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803326:	c1 e0 04             	shl    $0x4,%eax
  803329:	05 80 d0 81 00       	add    $0x81d080,%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803333:	e9 d5 00 00 00       	jmp    80340d <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803340:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803343:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803348:	29 c2                	sub    %eax,%edx
  80334a:	89 d0                	mov    %edx,%eax
  80334c:	c1 e8 0c             	shr    $0xc,%eax
  80334f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803352:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803355:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803358:	0f 85 a9 00 00 00    	jne    803407 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80335e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803362:	75 17                	jne    80337b <free_block+0x22b>
  803364:	83 ec 04             	sub    $0x4,%esp
  803367:	68 a5 47 80 00       	push   $0x8047a5
  80336c:	68 04 01 00 00       	push   $0x104
  803371:	68 0b 47 80 00       	push   $0x80470b
  803376:	e8 e6 d0 ff ff       	call   800461 <_panic>
  80337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337e:	8b 00                	mov    (%eax),%eax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 10                	je     803394 <free_block+0x244>
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338c:	8b 52 04             	mov    0x4(%edx),%edx
  80338f:	89 50 04             	mov    %edx,0x4(%eax)
  803392:	eb 14                	jmp    8033a8 <free_block+0x258>
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 40 04             	mov    0x4(%eax),%eax
  80339a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80339d:	c1 e2 04             	shl    $0x4,%edx
  8033a0:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8033a6:	89 02                	mov    %eax,(%edx)
  8033a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ab:	8b 40 04             	mov    0x4(%eax),%eax
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	74 0f                	je     8033c1 <free_block+0x271>
  8033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b5:	8b 40 04             	mov    0x4(%eax),%eax
  8033b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033bb:	8b 12                	mov    (%edx),%edx
  8033bd:	89 10                	mov    %edx,(%eax)
  8033bf:	eb 13                	jmp    8033d4 <free_block+0x284>
  8033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c4:	8b 00                	mov    (%eax),%eax
  8033c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c9:	c1 e2 04             	shl    $0x4,%edx
  8033cc:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033d2:	89 02                	mov    %eax,(%edx)
  8033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ea:	c1 e0 04             	shl    $0x4,%eax
  8033ed:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fa:	c1 e0 04             	shl    $0x4,%eax
  8033fd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803402:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803404:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803407:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80340a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80340d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803411:	0f 85 21 ff ff ff    	jne    803338 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803417:	b8 00 10 00 00       	mov    $0x1000,%eax
  80341c:	99                   	cltd   
  80341d:	f7 7d e8             	idivl  -0x18(%ebp)
  803420:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803423:	74 17                	je     80343c <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	68 f4 48 80 00       	push   $0x8048f4
  80342d:	68 0c 01 00 00       	push   $0x10c
  803432:	68 0b 47 80 00       	push   $0x80470b
  803437:	e8 25 d0 ff ff       	call   800461 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803448:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80344e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803452:	75 17                	jne    80346b <free_block+0x31b>
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	68 c4 47 80 00       	push   $0x8047c4
  80345c:	68 11 01 00 00       	push   $0x111
  803461:	68 0b 47 80 00       	push   $0x80470b
  803466:	e8 f6 cf ff ff       	call   800461 <_panic>
  80346b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803474:	89 50 04             	mov    %edx,0x4(%eax)
  803477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347a:	8b 40 04             	mov    0x4(%eax),%eax
  80347d:	85 c0                	test   %eax,%eax
  80347f:	74 0c                	je     80348d <free_block+0x33d>
  803481:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803486:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803489:	89 10                	mov    %edx,(%eax)
  80348b:	eb 08                	jmp    803495 <free_block+0x345>
  80348d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803490:	a3 48 50 80 00       	mov    %eax,0x805048
  803495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803498:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80349d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a6:	a1 54 50 80 00       	mov    0x805054,%eax
  8034ab:	40                   	inc    %eax
  8034ac:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8034b1:	83 ec 0c             	sub    $0xc,%esp
  8034b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8034b7:	e8 2b f4 ff ff       	call   8028e7 <to_page_va>
  8034bc:	83 c4 10             	add    $0x10,%esp
  8034bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8034c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034c5:	83 ec 0c             	sub    $0xc,%esp
  8034c8:	50                   	push   %eax
  8034c9:	e8 69 e8 ff ff       	call   801d37 <return_page>
  8034ce:	83 c4 10             	add    $0x10,%esp
  8034d1:	eb 01                	jmp    8034d4 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034d3:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8034d4:	c9                   	leave  
  8034d5:	c3                   	ret    

008034d6 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8034d6:	55                   	push   %ebp
  8034d7:	89 e5                	mov    %esp,%ebp
  8034d9:	83 ec 14             	sub    $0x14,%esp
  8034dc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8034df:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8034e3:	77 07                	ja     8034ec <nearest_pow2_ceil.1572+0x16>
      return 1;
  8034e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ea:	eb 20                	jmp    80350c <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8034ec:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8034f3:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8034f6:	eb 08                	jmp    803500 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8034f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034fb:	01 c0                	add    %eax,%eax
  8034fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803500:	d1 6d 08             	shrl   0x8(%ebp)
  803503:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803507:	75 ef                	jne    8034f8 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803509:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80350c:	c9                   	leave  
  80350d:	c3                   	ret    

0080350e <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80350e:	55                   	push   %ebp
  80350f:	89 e5                	mov    %esp,%ebp
  803511:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803514:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803518:	75 13                	jne    80352d <realloc_block+0x1f>
    return alloc_block(new_size);
  80351a:	83 ec 0c             	sub    $0xc,%esp
  80351d:	ff 75 0c             	pushl  0xc(%ebp)
  803520:	e8 d1 f6 ff ff       	call   802bf6 <alloc_block>
  803525:	83 c4 10             	add    $0x10,%esp
  803528:	e9 d9 00 00 00       	jmp    803606 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80352d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803531:	75 18                	jne    80354b <realloc_block+0x3d>
    free_block(va);
  803533:	83 ec 0c             	sub    $0xc,%esp
  803536:	ff 75 08             	pushl  0x8(%ebp)
  803539:	e8 12 fc ff ff       	call   803150 <free_block>
  80353e:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803541:	b8 00 00 00 00       	mov    $0x0,%eax
  803546:	e9 bb 00 00 00       	jmp    803606 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80354b:	83 ec 0c             	sub    $0xc,%esp
  80354e:	ff 75 08             	pushl  0x8(%ebp)
  803551:	e8 38 f6 ff ff       	call   802b8e <get_block_size>
  803556:	83 c4 10             	add    $0x10,%esp
  803559:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80355c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803563:	8b 45 0c             	mov    0xc(%ebp),%eax
  803566:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803569:	73 06                	jae    803571 <realloc_block+0x63>
    new_size = min_block_size;
  80356b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356e:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803571:	83 ec 0c             	sub    $0xc,%esp
  803574:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803577:	ff 75 0c             	pushl  0xc(%ebp)
  80357a:	89 c1                	mov    %eax,%ecx
  80357c:	e8 55 ff ff ff       	call   8034d6 <nearest_pow2_ceil.1572>
  803581:	83 c4 10             	add    $0x10,%esp
  803584:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80358d:	75 05                	jne    803594 <realloc_block+0x86>
    return va;
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	eb 72                	jmp    803606 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803594:	83 ec 0c             	sub    $0xc,%esp
  803597:	ff 75 0c             	pushl  0xc(%ebp)
  80359a:	e8 57 f6 ff ff       	call   802bf6 <alloc_block>
  80359f:	83 c4 10             	add    $0x10,%esp
  8035a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8035a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a9:	75 07                	jne    8035b2 <realloc_block+0xa4>
    return NULL;
  8035ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b0:	eb 54                	jmp    803606 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8035b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b8:	39 d0                	cmp    %edx,%eax
  8035ba:	76 02                	jbe    8035be <realloc_block+0xb0>
  8035bc:	89 d0                	mov    %edx,%eax
  8035be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8035c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8035cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035d4:	eb 17                	jmp    8035ed <realloc_block+0xdf>
    dst[i] = src[i];
  8035d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dc:	01 c2                	add    %eax,%edx
  8035de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	01 c8                	add    %ecx,%eax
  8035e6:	8a 00                	mov    (%eax),%al
  8035e8:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8035ea:	ff 45 f4             	incl   -0xc(%ebp)
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035f3:	72 e1                	jb     8035d6 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8035f5:	83 ec 0c             	sub    $0xc,%esp
  8035f8:	ff 75 08             	pushl  0x8(%ebp)
  8035fb:	e8 50 fb ff ff       	call   803150 <free_block>
  803600:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803606:	c9                   	leave  
  803607:	c3                   	ret    

00803608 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803608:	55                   	push   %ebp
  803609:	89 e5                	mov    %esp,%ebp
  80360b:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80360e:	8b 55 08             	mov    0x8(%ebp),%edx
  803611:	89 d0                	mov    %edx,%eax
  803613:	c1 e0 02             	shl    $0x2,%eax
  803616:	01 d0                	add    %edx,%eax
  803618:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80361f:	01 d0                	add    %edx,%eax
  803621:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803628:	01 d0                	add    %edx,%eax
  80362a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803631:	01 d0                	add    %edx,%eax
  803633:	c1 e0 04             	shl    $0x4,%eax
  803636:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803639:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803640:	0f 31                	rdtsc  
  803642:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803645:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80364e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803651:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803654:	eb 46                	jmp    80369c <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803656:	0f 31                	rdtsc  
  803658:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80365b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80365e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803661:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803664:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803667:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80366a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80366d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803670:	29 c2                	sub    %eax,%edx
  803672:	89 d0                	mov    %edx,%eax
  803674:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803677:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	89 d1                	mov    %edx,%ecx
  80367f:	29 c1                	sub    %eax,%ecx
  803681:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803687:	39 c2                	cmp    %eax,%edx
  803689:	0f 97 c0             	seta   %al
  80368c:	0f b6 c0             	movzbl %al,%eax
  80368f:	29 c1                	sub    %eax,%ecx
  803691:	89 c8                	mov    %ecx,%eax
  803693:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803696:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803699:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80369c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80369f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036a2:	72 b2                	jb     803656 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8036a4:	90                   	nop
  8036a5:	c9                   	leave  
  8036a6:	c3                   	ret    

008036a7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036a7:	55                   	push   %ebp
  8036a8:	89 e5                	mov    %esp,%ebp
  8036aa:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036b4:	eb 03                	jmp    8036b9 <busy_wait+0x12>
  8036b6:	ff 45 fc             	incl   -0x4(%ebp)
  8036b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036bf:	72 f5                	jb     8036b6 <busy_wait+0xf>
	return i;
  8036c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036c4:	c9                   	leave  
  8036c5:	c3                   	ret    
  8036c6:	66 90                	xchg   %ax,%ax

008036c8 <__udivdi3>:
  8036c8:	55                   	push   %ebp
  8036c9:	57                   	push   %edi
  8036ca:	56                   	push   %esi
  8036cb:	53                   	push   %ebx
  8036cc:	83 ec 1c             	sub    $0x1c,%esp
  8036cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036df:	89 ca                	mov    %ecx,%edx
  8036e1:	89 f8                	mov    %edi,%eax
  8036e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036e7:	85 f6                	test   %esi,%esi
  8036e9:	75 2d                	jne    803718 <__udivdi3+0x50>
  8036eb:	39 cf                	cmp    %ecx,%edi
  8036ed:	77 65                	ja     803754 <__udivdi3+0x8c>
  8036ef:	89 fd                	mov    %edi,%ebp
  8036f1:	85 ff                	test   %edi,%edi
  8036f3:	75 0b                	jne    803700 <__udivdi3+0x38>
  8036f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036fa:	31 d2                	xor    %edx,%edx
  8036fc:	f7 f7                	div    %edi
  8036fe:	89 c5                	mov    %eax,%ebp
  803700:	31 d2                	xor    %edx,%edx
  803702:	89 c8                	mov    %ecx,%eax
  803704:	f7 f5                	div    %ebp
  803706:	89 c1                	mov    %eax,%ecx
  803708:	89 d8                	mov    %ebx,%eax
  80370a:	f7 f5                	div    %ebp
  80370c:	89 cf                	mov    %ecx,%edi
  80370e:	89 fa                	mov    %edi,%edx
  803710:	83 c4 1c             	add    $0x1c,%esp
  803713:	5b                   	pop    %ebx
  803714:	5e                   	pop    %esi
  803715:	5f                   	pop    %edi
  803716:	5d                   	pop    %ebp
  803717:	c3                   	ret    
  803718:	39 ce                	cmp    %ecx,%esi
  80371a:	77 28                	ja     803744 <__udivdi3+0x7c>
  80371c:	0f bd fe             	bsr    %esi,%edi
  80371f:	83 f7 1f             	xor    $0x1f,%edi
  803722:	75 40                	jne    803764 <__udivdi3+0x9c>
  803724:	39 ce                	cmp    %ecx,%esi
  803726:	72 0a                	jb     803732 <__udivdi3+0x6a>
  803728:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80372c:	0f 87 9e 00 00 00    	ja     8037d0 <__udivdi3+0x108>
  803732:	b8 01 00 00 00       	mov    $0x1,%eax
  803737:	89 fa                	mov    %edi,%edx
  803739:	83 c4 1c             	add    $0x1c,%esp
  80373c:	5b                   	pop    %ebx
  80373d:	5e                   	pop    %esi
  80373e:	5f                   	pop    %edi
  80373f:	5d                   	pop    %ebp
  803740:	c3                   	ret    
  803741:	8d 76 00             	lea    0x0(%esi),%esi
  803744:	31 ff                	xor    %edi,%edi
  803746:	31 c0                	xor    %eax,%eax
  803748:	89 fa                	mov    %edi,%edx
  80374a:	83 c4 1c             	add    $0x1c,%esp
  80374d:	5b                   	pop    %ebx
  80374e:	5e                   	pop    %esi
  80374f:	5f                   	pop    %edi
  803750:	5d                   	pop    %ebp
  803751:	c3                   	ret    
  803752:	66 90                	xchg   %ax,%ax
  803754:	89 d8                	mov    %ebx,%eax
  803756:	f7 f7                	div    %edi
  803758:	31 ff                	xor    %edi,%edi
  80375a:	89 fa                	mov    %edi,%edx
  80375c:	83 c4 1c             	add    $0x1c,%esp
  80375f:	5b                   	pop    %ebx
  803760:	5e                   	pop    %esi
  803761:	5f                   	pop    %edi
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    
  803764:	bd 20 00 00 00       	mov    $0x20,%ebp
  803769:	89 eb                	mov    %ebp,%ebx
  80376b:	29 fb                	sub    %edi,%ebx
  80376d:	89 f9                	mov    %edi,%ecx
  80376f:	d3 e6                	shl    %cl,%esi
  803771:	89 c5                	mov    %eax,%ebp
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 ed                	shr    %cl,%ebp
  803777:	89 e9                	mov    %ebp,%ecx
  803779:	09 f1                	or     %esi,%ecx
  80377b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80377f:	89 f9                	mov    %edi,%ecx
  803781:	d3 e0                	shl    %cl,%eax
  803783:	89 c5                	mov    %eax,%ebp
  803785:	89 d6                	mov    %edx,%esi
  803787:	88 d9                	mov    %bl,%cl
  803789:	d3 ee                	shr    %cl,%esi
  80378b:	89 f9                	mov    %edi,%ecx
  80378d:	d3 e2                	shl    %cl,%edx
  80378f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803793:	88 d9                	mov    %bl,%cl
  803795:	d3 e8                	shr    %cl,%eax
  803797:	09 c2                	or     %eax,%edx
  803799:	89 d0                	mov    %edx,%eax
  80379b:	89 f2                	mov    %esi,%edx
  80379d:	f7 74 24 0c          	divl   0xc(%esp)
  8037a1:	89 d6                	mov    %edx,%esi
  8037a3:	89 c3                	mov    %eax,%ebx
  8037a5:	f7 e5                	mul    %ebp
  8037a7:	39 d6                	cmp    %edx,%esi
  8037a9:	72 19                	jb     8037c4 <__udivdi3+0xfc>
  8037ab:	74 0b                	je     8037b8 <__udivdi3+0xf0>
  8037ad:	89 d8                	mov    %ebx,%eax
  8037af:	31 ff                	xor    %edi,%edi
  8037b1:	e9 58 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037bc:	89 f9                	mov    %edi,%ecx
  8037be:	d3 e2                	shl    %cl,%edx
  8037c0:	39 c2                	cmp    %eax,%edx
  8037c2:	73 e9                	jae    8037ad <__udivdi3+0xe5>
  8037c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037c7:	31 ff                	xor    %edi,%edi
  8037c9:	e9 40 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037ce:	66 90                	xchg   %ax,%ax
  8037d0:	31 c0                	xor    %eax,%eax
  8037d2:	e9 37 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037d7:	90                   	nop

008037d8 <__umoddi3>:
  8037d8:	55                   	push   %ebp
  8037d9:	57                   	push   %edi
  8037da:	56                   	push   %esi
  8037db:	53                   	push   %ebx
  8037dc:	83 ec 1c             	sub    $0x1c,%esp
  8037df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037f7:	89 f3                	mov    %esi,%ebx
  8037f9:	89 fa                	mov    %edi,%edx
  8037fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ff:	89 34 24             	mov    %esi,(%esp)
  803802:	85 c0                	test   %eax,%eax
  803804:	75 1a                	jne    803820 <__umoddi3+0x48>
  803806:	39 f7                	cmp    %esi,%edi
  803808:	0f 86 a2 00 00 00    	jbe    8038b0 <__umoddi3+0xd8>
  80380e:	89 c8                	mov    %ecx,%eax
  803810:	89 f2                	mov    %esi,%edx
  803812:	f7 f7                	div    %edi
  803814:	89 d0                	mov    %edx,%eax
  803816:	31 d2                	xor    %edx,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	39 f0                	cmp    %esi,%eax
  803822:	0f 87 ac 00 00 00    	ja     8038d4 <__umoddi3+0xfc>
  803828:	0f bd e8             	bsr    %eax,%ebp
  80382b:	83 f5 1f             	xor    $0x1f,%ebp
  80382e:	0f 84 ac 00 00 00    	je     8038e0 <__umoddi3+0x108>
  803834:	bf 20 00 00 00       	mov    $0x20,%edi
  803839:	29 ef                	sub    %ebp,%edi
  80383b:	89 fe                	mov    %edi,%esi
  80383d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803841:	89 e9                	mov    %ebp,%ecx
  803843:	d3 e0                	shl    %cl,%eax
  803845:	89 d7                	mov    %edx,%edi
  803847:	89 f1                	mov    %esi,%ecx
  803849:	d3 ef                	shr    %cl,%edi
  80384b:	09 c7                	or     %eax,%edi
  80384d:	89 e9                	mov    %ebp,%ecx
  80384f:	d3 e2                	shl    %cl,%edx
  803851:	89 14 24             	mov    %edx,(%esp)
  803854:	89 d8                	mov    %ebx,%eax
  803856:	d3 e0                	shl    %cl,%eax
  803858:	89 c2                	mov    %eax,%edx
  80385a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80385e:	d3 e0                	shl    %cl,%eax
  803860:	89 44 24 04          	mov    %eax,0x4(%esp)
  803864:	8b 44 24 08          	mov    0x8(%esp),%eax
  803868:	89 f1                	mov    %esi,%ecx
  80386a:	d3 e8                	shr    %cl,%eax
  80386c:	09 d0                	or     %edx,%eax
  80386e:	d3 eb                	shr    %cl,%ebx
  803870:	89 da                	mov    %ebx,%edx
  803872:	f7 f7                	div    %edi
  803874:	89 d3                	mov    %edx,%ebx
  803876:	f7 24 24             	mull   (%esp)
  803879:	89 c6                	mov    %eax,%esi
  80387b:	89 d1                	mov    %edx,%ecx
  80387d:	39 d3                	cmp    %edx,%ebx
  80387f:	0f 82 87 00 00 00    	jb     80390c <__umoddi3+0x134>
  803885:	0f 84 91 00 00 00    	je     80391c <__umoddi3+0x144>
  80388b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80388f:	29 f2                	sub    %esi,%edx
  803891:	19 cb                	sbb    %ecx,%ebx
  803893:	89 d8                	mov    %ebx,%eax
  803895:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803899:	d3 e0                	shl    %cl,%eax
  80389b:	89 e9                	mov    %ebp,%ecx
  80389d:	d3 ea                	shr    %cl,%edx
  80389f:	09 d0                	or     %edx,%eax
  8038a1:	89 e9                	mov    %ebp,%ecx
  8038a3:	d3 eb                	shr    %cl,%ebx
  8038a5:	89 da                	mov    %ebx,%edx
  8038a7:	83 c4 1c             	add    $0x1c,%esp
  8038aa:	5b                   	pop    %ebx
  8038ab:	5e                   	pop    %esi
  8038ac:	5f                   	pop    %edi
  8038ad:	5d                   	pop    %ebp
  8038ae:	c3                   	ret    
  8038af:	90                   	nop
  8038b0:	89 fd                	mov    %edi,%ebp
  8038b2:	85 ff                	test   %edi,%edi
  8038b4:	75 0b                	jne    8038c1 <__umoddi3+0xe9>
  8038b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038bb:	31 d2                	xor    %edx,%edx
  8038bd:	f7 f7                	div    %edi
  8038bf:	89 c5                	mov    %eax,%ebp
  8038c1:	89 f0                	mov    %esi,%eax
  8038c3:	31 d2                	xor    %edx,%edx
  8038c5:	f7 f5                	div    %ebp
  8038c7:	89 c8                	mov    %ecx,%eax
  8038c9:	f7 f5                	div    %ebp
  8038cb:	89 d0                	mov    %edx,%eax
  8038cd:	e9 44 ff ff ff       	jmp    803816 <__umoddi3+0x3e>
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	89 c8                	mov    %ecx,%eax
  8038d6:	89 f2                	mov    %esi,%edx
  8038d8:	83 c4 1c             	add    $0x1c,%esp
  8038db:	5b                   	pop    %ebx
  8038dc:	5e                   	pop    %esi
  8038dd:	5f                   	pop    %edi
  8038de:	5d                   	pop    %ebp
  8038df:	c3                   	ret    
  8038e0:	3b 04 24             	cmp    (%esp),%eax
  8038e3:	72 06                	jb     8038eb <__umoddi3+0x113>
  8038e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038e9:	77 0f                	ja     8038fa <__umoddi3+0x122>
  8038eb:	89 f2                	mov    %esi,%edx
  8038ed:	29 f9                	sub    %edi,%ecx
  8038ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038f3:	89 14 24             	mov    %edx,(%esp)
  8038f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038fe:	8b 14 24             	mov    (%esp),%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d 76 00             	lea    0x0(%esi),%esi
  80390c:	2b 04 24             	sub    (%esp),%eax
  80390f:	19 fa                	sbb    %edi,%edx
  803911:	89 d1                	mov    %edx,%ecx
  803913:	89 c6                	mov    %eax,%esi
  803915:	e9 71 ff ff ff       	jmp    80388b <__umoddi3+0xb3>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803920:	72 ea                	jb     80390c <__umoddi3+0x134>
  803922:	89 d9                	mov    %ebx,%ecx
  803924:	e9 62 ff ff ff       	jmp    80388b <__umoddi3+0xb3>
