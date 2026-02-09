
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it frees them
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 37 80 00       	push   $0x803720
  80004a:	e8 87 1e 00 00       	call   801ed6 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 94 22 00 00       	call   8022f7 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 d7 22 00 00       	call   802342 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 37 80 00       	push   $0x803730
  800079:	e8 6d 05 00 00       	call   8005eb <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 b8 0b 00 00       	push   $0xbb8
  800094:	68 63 37 80 00       	push   $0x803763
  800099:	e8 b4 23 00 00       	call   802452 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 c1 23 00 00       	call   802470 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 35 22 00 00       	call   8022f7 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 6c 37 80 00       	push   $0x80376c
  8000cb:	e8 1b 05 00 00       	call   8005eb <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 ae 23 00 00       	call   80248c <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 11 22 00 00       	call   8022f7 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 54 22 00 00       	call   802342 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 2e                	je     800127 <_main+0xef>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d\n",
  8000f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000fc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	50                   	push   %eax
  800103:	ff 75 e4             	pushl  -0x1c(%ebp)
  800106:	68 a0 37 80 00       	push   $0x8037a0
  80010b:	e8 db 04 00 00       	call   8005eb <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before);
		panic("env_free() does not work correctly... check it again.");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 00 38 80 00       	push   $0x803800
  80011b:	6a 1f                	push   $0x1f
  80011d:	68 36 38 80 00       	push   $0x803836
  800122:	e8 d6 01 00 00       	call   8002fd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 4c 38 80 00       	push   $0x80384c
  800132:	e8 b4 04 00 00       	call   8005eb <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 ac 38 80 00       	push   $0x8038ac
  800142:	e8 a4 04 00 00       	call   8005eb <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	return;
  80014a:	90                   	nop
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800156:	e8 65 23 00 00       	call   8024c0 <sys_getenvindex>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80015e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800161:	89 d0                	mov    %edx,%eax
  800163:	01 c0                	add    %eax,%eax
  800165:	01 d0                	add    %edx,%eax
  800167:	c1 e0 02             	shl    $0x2,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	c1 e0 02             	shl    $0x2,%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	c1 e0 03             	shl    $0x3,%eax
  800174:	01 d0                	add    %edx,%eax
  800176:	c1 e0 02             	shl    $0x2,%eax
  800179:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800183:	a1 20 50 80 00       	mov    0x805020,%eax
  800188:	8a 40 20             	mov    0x20(%eax),%al
  80018b:	84 c0                	test   %al,%al
  80018d:	74 0d                	je     80019c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80018f:	a1 20 50 80 00       	mov    0x805020,%eax
  800194:	83 c0 20             	add    $0x20,%eax
  800197:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a0:	7e 0a                	jle    8001ac <libmain+0x5f>
		binaryname = argv[0];
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	8b 00                	mov    (%eax),%eax
  8001a7:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 0c             	pushl  0xc(%ebp)
  8001b2:	ff 75 08             	pushl  0x8(%ebp)
  8001b5:	e8 7e fe ff ff       	call   800038 <_main>
  8001ba:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001bd:	a1 00 50 80 00       	mov    0x805000,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	0f 84 01 01 00 00    	je     8002cb <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ca:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001d0:	bb f0 39 80 00       	mov    $0x8039f0,%ebx
  8001d5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001da:	89 c7                	mov    %eax,%edi
  8001dc:	89 de                	mov    %ebx,%esi
  8001de:	89 d1                	mov    %edx,%ecx
  8001e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001e2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001e5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001ea:	b0 00                	mov    $0x0,%al
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	50                   	push   %eax
  8001fe:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	e8 ec 24 00 00       	call   8026f6 <sys_utilities>
  80020a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80020d:	e8 35 20 00 00       	call   802247 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	68 10 39 80 00       	push   $0x803910
  80021a:	e8 cc 03 00 00       	call   8005eb <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	85 c0                	test   %eax,%eax
  800227:	74 18                	je     800241 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800229:	e8 e6 24 00 00       	call   802714 <sys_get_optimal_num_faults>
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	50                   	push   %eax
  800232:	68 38 39 80 00       	push   $0x803938
  800237:	e8 af 03 00 00       	call   8005eb <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	eb 59                	jmp    80029a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800241:	a1 20 50 80 00       	mov    0x805020,%eax
  800246:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80024c:	a1 20 50 80 00       	mov    0x805020,%eax
  800251:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	68 5c 39 80 00       	push   $0x80395c
  800261:	e8 85 03 00 00       	call   8005eb <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800269:	a1 20 50 80 00       	mov    0x805020,%eax
  80026e:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80027f:	a1 20 50 80 00       	mov    0x805020,%eax
  800284:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80028a:	51                   	push   %ecx
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 84 39 80 00       	push   $0x803984
  800292:	e8 54 03 00 00       	call   8005eb <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029a:	a1 20 50 80 00       	mov    0x805020,%eax
  80029f:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	50                   	push   %eax
  8002a9:	68 dc 39 80 00       	push   $0x8039dc
  8002ae:	e8 38 03 00 00       	call   8005eb <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 10 39 80 00       	push   $0x803910
  8002be:	e8 28 03 00 00       	call   8005eb <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002c6:	e8 96 1f 00 00       	call   802261 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002cb:	e8 1f 00 00 00       	call   8002ef <exit>
}
  8002d0:	90                   	nop
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	6a 00                	push   $0x0
  8002e4:	e8 a3 21 00 00       	call   80248c <sys_destroy_env>
  8002e9:	83 c4 10             	add    $0x10,%esp
}
  8002ec:	90                   	nop
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <exit>:

void
exit(void)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f5:	e8 f8 21 00 00       	call   8024f2 <sys_exit_env>
}
  8002fa:	90                   	nop
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800303:	8d 45 10             	lea    0x10(%ebp),%eax
  800306:	83 c0 04             	add    $0x4,%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030c:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800311:	85 c0                	test   %eax,%eax
  800313:	74 16                	je     80032b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800315:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	50                   	push   %eax
  80031e:	68 54 3a 80 00       	push   $0x803a54
  800323:	e8 c3 02 00 00       	call   8005eb <cprintf>
  800328:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80032b:	a1 04 50 80 00       	mov    0x805004,%eax
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	50                   	push   %eax
  80033a:	68 5c 3a 80 00       	push   $0x803a5c
  80033f:	6a 74                	push   $0x74
  800341:	e8 d2 02 00 00       	call   800618 <cprintf_colored>
  800346:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 f4             	pushl  -0xc(%ebp)
  800352:	50                   	push   %eax
  800353:	e8 24 02 00 00       	call   80057c <vcprintf>
  800358:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	6a 00                	push   $0x0
  800360:	68 84 3a 80 00       	push   $0x803a84
  800365:	e8 12 02 00 00       	call   80057c <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80036d:	e8 7d ff ff ff       	call   8002ef <exit>

	// should not return here
	while (1) ;
  800372:	eb fe                	jmp    800372 <_panic+0x75>

00800374 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	53                   	push   %ebx
  800378:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80037b:	a1 20 50 80 00       	mov    0x805020,%eax
  800380:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800386:	8b 45 0c             	mov    0xc(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 88 3a 80 00       	push   $0x803a88
  800395:	6a 26                	push   $0x26
  800397:	68 d4 3a 80 00       	push   $0x803ad4
  80039c:	e8 5c ff ff ff       	call   8002fd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003af:	e9 d9 00 00 00       	jmp    80048d <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8003b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	75 08                	jne    8003d1 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003c9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003cc:	e9 b9 00 00 00       	jmp    80048a <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003df:	eb 79                	jmp    80045a <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e6:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ef:	89 d0                	mov    %edx,%eax
  8003f1:	01 c0                	add    %eax,%eax
  8003f3:	01 d0                	add    %edx,%eax
  8003f5:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003fc:	01 d8                	add    %ebx,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8a 40 04             	mov    0x4(%eax),%al
  800405:	84 c0                	test   %al,%al
  800407:	75 4e                	jne    800457 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800409:	a1 20 50 80 00       	mov    0x805020,%eax
  80040e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800414:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800417:	89 d0                	mov    %edx,%eax
  800419:	01 c0                	add    %eax,%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800424:	01 d8                	add    %ebx,%eax
  800426:	01 d0                	add    %edx,%eax
  800428:	01 c8                	add    %ecx,%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800432:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800437:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	01 c8                	add    %ecx,%eax
  800448:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80044a:	39 c2                	cmp    %eax,%edx
  80044c:	75 09                	jne    800457 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80044e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800455:	eb 19                	jmp    800470 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800457:	ff 45 e8             	incl   -0x18(%ebp)
  80045a:	a1 20 50 80 00       	mov    0x805020,%eax
  80045f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	39 c2                	cmp    %eax,%edx
  80046a:	0f 87 71 ff ff ff    	ja     8003e1 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800474:	75 14                	jne    80048a <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 e0 3a 80 00       	push   $0x803ae0
  80047e:	6a 3a                	push   $0x3a
  800480:	68 d4 3a 80 00       	push   $0x803ad4
  800485:	e8 73 fe ff ff       	call   8002fd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80048a:	ff 45 f0             	incl   -0x10(%ebp)
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800493:	0f 8c 1b ff ff ff    	jl     8003b4 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800499:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a7:	eb 2e                	jmp    8004d7 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ae:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b7:	89 d0                	mov    %edx,%eax
  8004b9:	01 c0                	add    %eax,%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004c4:	01 d8                	add    %ebx,%eax
  8004c6:	01 d0                	add    %edx,%eax
  8004c8:	01 c8                	add    %ecx,%eax
  8004ca:	8a 40 04             	mov    0x4(%eax),%al
  8004cd:	3c 01                	cmp    $0x1,%al
  8004cf:	75 03                	jne    8004d4 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004d1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d4:	ff 45 e0             	incl   -0x20(%ebp)
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	39 c2                	cmp    %eax,%edx
  8004e7:	77 c0                	ja     8004a9 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ef:	74 14                	je     800505 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 34 3b 80 00       	push   $0x803b34
  8004f9:	6a 44                	push   $0x44
  8004fb:	68 d4 3a 80 00       	push   $0x803ad4
  800500:	e8 f8 fd ff ff       	call   8002fd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800505:	90                   	nop
  800506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	53                   	push   %ebx
  80050f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800512:	8b 45 0c             	mov    0xc(%ebp),%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	8d 48 01             	lea    0x1(%eax),%ecx
  80051a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051d:	89 0a                	mov    %ecx,(%edx)
  80051f:	8b 55 08             	mov    0x8(%ebp),%edx
  800522:	88 d1                	mov    %dl,%cl
  800524:	8b 55 0c             	mov    0xc(%ebp),%edx
  800527:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80052b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	3d ff 00 00 00       	cmp    $0xff,%eax
  800535:	75 30                	jne    800567 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800537:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80053d:	a0 44 50 80 00       	mov    0x805044,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800548:	8b 09                	mov    (%ecx),%ecx
  80054a:	89 cb                	mov    %ecx,%ebx
  80054c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054f:	83 c1 08             	add    $0x8,%ecx
  800552:	52                   	push   %edx
  800553:	50                   	push   %eax
  800554:	53                   	push   %ebx
  800555:	51                   	push   %ecx
  800556:	e8 a8 1c 00 00       	call   802203 <sys_cputs>
  80055b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056a:	8b 40 04             	mov    0x4(%eax),%eax
  80056d:	8d 50 01             	lea    0x1(%eax),%edx
  800570:	8b 45 0c             	mov    0xc(%ebp),%eax
  800573:	89 50 04             	mov    %edx,0x4(%eax)
}
  800576:	90                   	nop
  800577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800585:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058c:	00 00 00 
	b.cnt = 0;
  80058f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800596:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800599:	ff 75 0c             	pushl  0xc(%ebp)
  80059c:	ff 75 08             	pushl  0x8(%ebp)
  80059f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a5:	50                   	push   %eax
  8005a6:	68 0b 05 80 00       	push   $0x80050b
  8005ab:	e8 5a 02 00 00       	call   80080a <vprintfmt>
  8005b0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005b3:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8005b9:	a0 44 50 80 00       	mov    0x805044,%al
  8005be:	0f b6 c0             	movzbl %al,%eax
  8005c1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005c7:	52                   	push   %edx
  8005c8:	50                   	push   %eax
  8005c9:	51                   	push   %ecx
  8005ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d0:	83 c0 08             	add    $0x8,%eax
  8005d3:	50                   	push   %eax
  8005d4:	e8 2a 1c 00 00       	call   802203 <sys_cputs>
  8005d9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005dc:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f1:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005f8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	ff 75 f4             	pushl  -0xc(%ebp)
  800607:	50                   	push   %eax
  800608:	e8 6f ff ff ff       	call   80057c <vcprintf>
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800613:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061e:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	c1 e0 08             	shl    $0x8,%eax
  80062b:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800630:	8d 45 0c             	lea    0xc(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 f4             	pushl  -0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	e8 34 ff ff ff       	call   80057c <vcprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80064e:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800655:	07 00 00 

	return cnt;
  800658:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065b:	c9                   	leave  
  80065c:	c3                   	ret    

0080065d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80065d:	55                   	push   %ebp
  80065e:	89 e5                	mov    %esp,%ebp
  800660:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800663:	e8 df 1b 00 00       	call   802247 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800668:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 f4             	pushl  -0xc(%ebp)
  800677:	50                   	push   %eax
  800678:	e8 ff fe ff ff       	call   80057c <vcprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800683:	e8 d9 1b 00 00       	call   802261 <sys_unlock_cons>
	return cnt;
  800688:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068b:	c9                   	leave  
  80068c:	c3                   	ret    

0080068d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	53                   	push   %ebx
  800691:	83 ec 14             	sub    $0x14,%esp
  800694:	8b 45 10             	mov    0x10(%ebp),%eax
  800697:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a0:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ab:	77 55                	ja     800702 <printnum+0x75>
  8006ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b0:	72 05                	jb     8006b7 <printnum+0x2a>
  8006b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b5:	77 4b                	ja     800702 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ba:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cd:	e8 d2 2d 00 00       	call   8034a4 <__udivdi3>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	83 ec 04             	sub    $0x4,%esp
  8006d8:	ff 75 20             	pushl  0x20(%ebp)
  8006db:	53                   	push   %ebx
  8006dc:	ff 75 18             	pushl  0x18(%ebp)
  8006df:	52                   	push   %edx
  8006e0:	50                   	push   %eax
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	ff 75 08             	pushl  0x8(%ebp)
  8006e7:	e8 a1 ff ff ff       	call   80068d <printnum>
  8006ec:	83 c4 20             	add    $0x20,%esp
  8006ef:	eb 1a                	jmp    80070b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	ff 75 20             	pushl  0x20(%ebp)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	ff d0                	call   *%eax
  8006ff:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800702:	ff 4d 1c             	decl   0x1c(%ebp)
  800705:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800709:	7f e6                	jg     8006f1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80070e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800719:	53                   	push   %ebx
  80071a:	51                   	push   %ecx
  80071b:	52                   	push   %edx
  80071c:	50                   	push   %eax
  80071d:	e8 92 2e 00 00       	call   8035b4 <__umoddi3>
  800722:	83 c4 10             	add    $0x10,%esp
  800725:	05 94 3d 80 00       	add    $0x803d94,%eax
  80072a:	8a 00                	mov    (%eax),%al
  80072c:	0f be c0             	movsbl %al,%eax
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	50                   	push   %eax
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
}
  80073e:	90                   	nop
  80073f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 40                	jmp    8007a9 <getuint+0x65>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1e                	je     80078d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	eb 1c                	jmp    8007a9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b2:	7e 1c                	jle    8007d0 <getint+0x25>
		return va_arg(*ap, long long);
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	8d 50 08             	lea    0x8(%eax),%edx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	89 10                	mov    %edx,(%eax)
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	83 e8 08             	sub    $0x8,%eax
  8007c9:	8b 50 04             	mov    0x4(%eax),%edx
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	eb 38                	jmp    800808 <getint+0x5d>
	else if (lflag)
  8007d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d4:	74 1a                	je     8007f0 <getint+0x45>
		return va_arg(*ap, long);
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	8d 50 04             	lea    0x4(%eax),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	89 10                	mov    %edx,(%eax)
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	99                   	cltd   
  8007ee:	eb 18                	jmp    800808 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	8d 50 04             	lea    0x4(%eax),%edx
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	89 10                	mov    %edx,(%eax)
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	83 e8 04             	sub    $0x4,%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	99                   	cltd   
}
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	56                   	push   %esi
  80080e:	53                   	push   %ebx
  80080f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800812:	eb 17                	jmp    80082b <vprintfmt+0x21>
			if (ch == '\0')
  800814:	85 db                	test   %ebx,%ebx
  800816:	0f 84 c1 03 00 00    	je     800bdd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	53                   	push   %ebx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082b:	8b 45 10             	mov    0x10(%ebp),%eax
  80082e:	8d 50 01             	lea    0x1(%eax),%edx
  800831:	89 55 10             	mov    %edx,0x10(%ebp)
  800834:	8a 00                	mov    (%eax),%al
  800836:	0f b6 d8             	movzbl %al,%ebx
  800839:	83 fb 25             	cmp    $0x25,%ebx
  80083c:	75 d6                	jne    800814 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80083e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800842:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800849:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800850:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800857:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085e:	8b 45 10             	mov    0x10(%ebp),%eax
  800861:	8d 50 01             	lea    0x1(%eax),%edx
  800864:	89 55 10             	mov    %edx,0x10(%ebp)
  800867:	8a 00                	mov    (%eax),%al
  800869:	0f b6 d8             	movzbl %al,%ebx
  80086c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80086f:	83 f8 5b             	cmp    $0x5b,%eax
  800872:	0f 87 3d 03 00 00    	ja     800bb5 <vprintfmt+0x3ab>
  800878:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
  80087f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800881:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800885:	eb d7                	jmp    80085e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800887:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088b:	eb d1                	jmp    80085e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800894:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800897:	89 d0                	mov    %edx,%eax
  800899:	c1 e0 02             	shl    $0x2,%eax
  80089c:	01 d0                	add    %edx,%eax
  80089e:	01 c0                	add    %eax,%eax
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	83 e8 30             	sub    $0x30,%eax
  8008a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ab:	8a 00                	mov    (%eax),%al
  8008ad:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b0:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b3:	7e 3e                	jle    8008f3 <vprintfmt+0xe9>
  8008b5:	83 fb 39             	cmp    $0x39,%ebx
  8008b8:	7f 39                	jg     8008f3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ba:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bd:	eb d5                	jmp    800894 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 c0 04             	add    $0x4,%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	83 e8 04             	sub    $0x4,%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d3:	eb 1f                	jmp    8008f4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	79 83                	jns    80085e <vprintfmt+0x54>
				width = 0;
  8008db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e2:	e9 77 ff ff ff       	jmp    80085e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ee:	e9 6b ff ff ff       	jmp    80085e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f8:	0f 89 60 ff ff ff    	jns    80085e <vprintfmt+0x54>
				width = precision, precision = -1;
  8008fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800901:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800904:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090b:	e9 4e ff ff ff       	jmp    80085e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800910:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800913:	e9 46 ff ff ff       	jmp    80085e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	83 c0 04             	add    $0x4,%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	83 e8 04             	sub    $0x4,%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	50                   	push   %eax
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			break;
  800938:	e9 9b 02 00 00       	jmp    800bd8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 e8 04             	sub    $0x4,%eax
  80094c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80094e:	85 db                	test   %ebx,%ebx
  800950:	79 02                	jns    800954 <vprintfmt+0x14a>
				err = -err;
  800952:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800954:	83 fb 64             	cmp    $0x64,%ebx
  800957:	7f 0b                	jg     800964 <vprintfmt+0x15a>
  800959:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 19                	jne    80097d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800964:	53                   	push   %ebx
  800965:	68 a5 3d 80 00       	push   $0x803da5
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	ff 75 08             	pushl  0x8(%ebp)
  800970:	e8 70 02 00 00       	call   800be5 <printfmt>
  800975:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800978:	e9 5b 02 00 00       	jmp    800bd8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097d:	56                   	push   %esi
  80097e:	68 ae 3d 80 00       	push   $0x803dae
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	ff 75 08             	pushl  0x8(%ebp)
  800989:	e8 57 02 00 00       	call   800be5 <printfmt>
  80098e:	83 c4 10             	add    $0x10,%esp
			break;
  800991:	e9 42 02 00 00       	jmp    800bd8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	83 c0 04             	add    $0x4,%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 e8 04             	sub    $0x4,%eax
  8009a5:	8b 30                	mov    (%eax),%esi
  8009a7:	85 f6                	test   %esi,%esi
  8009a9:	75 05                	jne    8009b0 <vprintfmt+0x1a6>
				p = "(null)";
  8009ab:	be b1 3d 80 00       	mov    $0x803db1,%esi
			if (width > 0 && padc != '-')
  8009b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b4:	7e 6d                	jle    800a23 <vprintfmt+0x219>
  8009b6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ba:	74 67                	je     800a23 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	56                   	push   %esi
  8009c4:	e8 1e 03 00 00       	call   800ce7 <strnlen>
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009cf:	eb 16                	jmp    8009e7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009eb:	7f e4                	jg     8009d1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ed:	eb 34                	jmp    800a23 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f3:	74 1c                	je     800a11 <vprintfmt+0x207>
  8009f5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f8:	7e 05                	jle    8009ff <vprintfmt+0x1f5>
  8009fa:	83 fb 7e             	cmp    $0x7e,%ebx
  8009fd:	7e 12                	jle    800a11 <vprintfmt+0x207>
					putch('?', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 3f                	push   $0x3f
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
  800a0f:	eb 0f                	jmp    800a20 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a20:	ff 4d e4             	decl   -0x1c(%ebp)
  800a23:	89 f0                	mov    %esi,%eax
  800a25:	8d 70 01             	lea    0x1(%eax),%esi
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	0f be d8             	movsbl %al,%ebx
  800a2d:	85 db                	test   %ebx,%ebx
  800a2f:	74 24                	je     800a55 <vprintfmt+0x24b>
  800a31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a35:	78 b8                	js     8009ef <vprintfmt+0x1e5>
  800a37:	ff 4d e0             	decl   -0x20(%ebp)
  800a3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3e:	79 af                	jns    8009ef <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	eb 13                	jmp    800a55 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 20                	push   $0x20
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a52:	ff 4d e4             	decl   -0x1c(%ebp)
  800a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a59:	7f e7                	jg     800a42 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5b:	e9 78 01 00 00       	jmp    800bd8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	ff 75 e8             	pushl  -0x18(%ebp)
  800a66:	8d 45 14             	lea    0x14(%ebp),%eax
  800a69:	50                   	push   %eax
  800a6a:	e8 3c fd ff ff       	call   8007ab <getint>
  800a6f:	83 c4 10             	add    $0x10,%esp
  800a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	85 d2                	test   %edx,%edx
  800a80:	79 23                	jns    800aa5 <vprintfmt+0x29b>
				putch('-', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 2d                	push   $0x2d
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a98:	f7 d8                	neg    %eax
  800a9a:	83 d2 00             	adc    $0x0,%edx
  800a9d:	f7 da                	neg    %edx
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aac:	e9 bc 00 00 00       	jmp    800b6d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab7:	8d 45 14             	lea    0x14(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	e8 84 fc ff ff       	call   800744 <getuint>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ac9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad0:	e9 98 00 00 00       	jmp    800b6d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 58                	push   $0x58
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 58                	push   $0x58
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 58                	push   $0x58
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			break;
  800b05:	e9 ce 00 00 00       	jmp    800bd8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	6a 30                	push   $0x30
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	ff d0                	call   *%eax
  800b17:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	6a 78                	push   $0x78
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	ff d0                	call   *%eax
  800b27:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2d:	83 c0 04             	add    $0x4,%eax
  800b30:	89 45 14             	mov    %eax,0x14(%ebp)
  800b33:	8b 45 14             	mov    0x14(%ebp),%eax
  800b36:	83 e8 04             	sub    $0x4,%eax
  800b39:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4c:	eb 1f                	jmp    800b6d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 e8             	pushl  -0x18(%ebp)
  800b54:	8d 45 14             	lea    0x14(%ebp),%eax
  800b57:	50                   	push   %eax
  800b58:	e8 e7 fb ff ff       	call   800744 <getuint>
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b74:	83 ec 04             	sub    $0x4,%esp
  800b77:	52                   	push   %edx
  800b78:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7b:	50                   	push   %eax
  800b7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7f:	ff 75 f0             	pushl  -0x10(%ebp)
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 00 fb ff ff       	call   80068d <printnum>
  800b8d:	83 c4 20             	add    $0x20,%esp
			break;
  800b90:	eb 46                	jmp    800bd8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			break;
  800ba1:	eb 35                	jmp    800bd8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ba3:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800baa:	eb 2c                	jmp    800bd8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bac:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800bb3:	eb 23                	jmp    800bd8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	6a 25                	push   $0x25
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	ff d0                	call   *%eax
  800bc2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc5:	ff 4d 10             	decl   0x10(%ebp)
  800bc8:	eb 03                	jmp    800bcd <vprintfmt+0x3c3>
  800bca:	ff 4d 10             	decl   0x10(%ebp)
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	48                   	dec    %eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3c 25                	cmp    $0x25,%al
  800bd5:	75 f3                	jne    800bca <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bd7:	90                   	nop
		}
	}
  800bd8:	e9 35 fc ff ff       	jmp    800812 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800beb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bee:	83 c0 04             	add    $0x4,%eax
  800bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfa:	50                   	push   %eax
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	ff 75 08             	pushl  0x8(%ebp)
  800c01:	e8 04 fc ff ff       	call   80080a <vprintfmt>
  800c06:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c09:	90                   	nop
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	8b 40 08             	mov    0x8(%eax),%eax
  800c15:	8d 50 01             	lea    0x1(%eax),%edx
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 10                	mov    (%eax),%edx
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	8b 40 04             	mov    0x4(%eax),%eax
  800c29:	39 c2                	cmp    %eax,%edx
  800c2b:	73 12                	jae    800c3f <sprintputch+0x33>
		*b->buf++ = ch;
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	8d 48 01             	lea    0x1(%eax),%ecx
  800c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c38:	89 0a                	mov    %ecx,(%edx)
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	88 10                	mov    %dl,(%eax)
}
  800c3f:	90                   	nop
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	01 d0                	add    %edx,%eax
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c67:	74 06                	je     800c6f <vsnprintf+0x2d>
  800c69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6d:	7f 07                	jg     800c76 <vsnprintf+0x34>
		return -E_INVAL;
  800c6f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c74:	eb 20                	jmp    800c96 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c76:	ff 75 14             	pushl  0x14(%ebp)
  800c79:	ff 75 10             	pushl  0x10(%ebp)
  800c7c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c7f:	50                   	push   %eax
  800c80:	68 0c 0c 80 00       	push   $0x800c0c
  800c85:	e8 80 fb ff ff       	call   80080a <vprintfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c90:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c9e:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca1:	83 c0 04             	add    $0x4,%eax
  800ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  800caa:	ff 75 f4             	pushl  -0xc(%ebp)
  800cad:	50                   	push   %eax
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	ff 75 08             	pushl  0x8(%ebp)
  800cb4:	e8 89 ff ff ff       	call   800c42 <vsnprintf>
  800cb9:	83 c4 10             	add    $0x10,%esp
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd1:	eb 06                	jmp    800cd9 <strlen+0x15>
		n++;
  800cd3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 f1                	jne    800cd3 <strlen+0xf>
		n++;
	return n;
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ced:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf4:	eb 09                	jmp    800cff <strnlen+0x18>
		n++;
  800cf6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 4d 0c             	decl   0xc(%ebp)
  800cff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d03:	74 09                	je     800d0e <strnlen+0x27>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	75 e8                	jne    800cf6 <strnlen+0xf>
		n++;
	return n;
  800d0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d1f:	90                   	nop
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8d 50 01             	lea    0x1(%eax),%edx
  800d26:	89 55 08             	mov    %edx,0x8(%ebp)
  800d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d32:	8a 12                	mov    (%edx),%dl
  800d34:	88 10                	mov    %dl,(%eax)
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	84 c0                	test   %al,%al
  800d3a:	75 e4                	jne    800d20 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d54:	eb 1f                	jmp    800d75 <strncpy+0x34>
		*dst++ = *src;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8d 50 01             	lea    0x1(%eax),%edx
  800d5c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	8a 12                	mov    (%edx),%dl
  800d64:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	84 c0                	test   %al,%al
  800d6d:	74 03                	je     800d72 <strncpy+0x31>
			src++;
  800d6f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d72:	ff 45 fc             	incl   -0x4(%ebp)
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d78:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7b:	72 d9                	jb     800d56 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	74 30                	je     800dc4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d94:	eb 16                	jmp    800dac <strlcpy+0x2a>
			*dst++ = *src++;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da8:	8a 12                	mov    (%edx),%dl
  800daa:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dac:	ff 4d 10             	decl   0x10(%ebp)
  800daf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db3:	74 09                	je     800dbe <strlcpy+0x3c>
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	84 c0                	test   %al,%al
  800dbc:	75 d8                	jne    800d96 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dca:	29 c2                	sub    %eax,%edx
  800dcc:	89 d0                	mov    %edx,%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd3:	eb 06                	jmp    800ddb <strcmp+0xb>
		p++, q++;
  800dd5:	ff 45 08             	incl   0x8(%ebp)
  800dd8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	84 c0                	test   %al,%al
  800de2:	74 0e                	je     800df2 <strcmp+0x22>
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 10                	mov    (%eax),%dl
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	38 c2                	cmp    %al,%dl
  800df0:	74 e3                	je     800dd5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	0f b6 d0             	movzbl %al,%edx
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	0f b6 c0             	movzbl %al,%eax
  800e02:	29 c2                	sub    %eax,%edx
  800e04:	89 d0                	mov    %edx,%eax
}
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0b:	eb 09                	jmp    800e16 <strncmp+0xe>
		n--, p++, q++;
  800e0d:	ff 4d 10             	decl   0x10(%ebp)
  800e10:	ff 45 08             	incl   0x8(%ebp)
  800e13:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1a:	74 17                	je     800e33 <strncmp+0x2b>
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strncmp+0x2b>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 da                	je     800e0d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e37:	75 07                	jne    800e40 <strncmp+0x38>
		return 0;
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3e:	eb 14                	jmp    800e54 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	0f b6 d0             	movzbl %al,%edx
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 c0             	movzbl %al,%eax
  800e50:	29 c2                	sub    %eax,%edx
  800e52:	89 d0                	mov    %edx,%eax
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 04             	sub    $0x4,%esp
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e62:	eb 12                	jmp    800e76 <strchr+0x20>
		if (*s == c)
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6c:	75 05                	jne    800e73 <strchr+0x1d>
			return (char *) s;
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	eb 11                	jmp    800e84 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	84 c0                	test   %al,%al
  800e7d:	75 e5                	jne    800e64 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 04             	sub    $0x4,%esp
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e92:	eb 0d                	jmp    800ea1 <strfind+0x1b>
		if (*s == c)
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9c:	74 0e                	je     800eac <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 ea                	jne    800e94 <strfind+0xe>
  800eaa:	eb 01                	jmp    800ead <strfind+0x27>
		if (*s == c)
			break;
  800eac:	90                   	nop
	return (char *) s;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ebe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec2:	76 63                	jbe    800f27 <memset+0x75>
		uint64 data_block = c;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	99                   	cltd   
  800ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ecb:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed4:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ed8:	c1 e0 08             	shl    $0x8,%eax
  800edb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ede:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee7:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eeb:	c1 e0 10             	shl    $0x10,%eax
  800eee:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efa:	89 c2                	mov    %eax,%edx
  800efc:	b8 00 00 00 00       	mov    $0x0,%eax
  800f01:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f04:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f07:	eb 18                	jmp    800f21 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f09:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0c:	8d 41 08             	lea    0x8(%ecx),%eax
  800f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f18:	89 01                	mov    %eax,(%ecx)
  800f1a:	89 51 04             	mov    %edx,0x4(%ecx)
  800f1d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f21:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f25:	77 e2                	ja     800f09 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2b:	74 23                	je     800f50 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f33:	eb 0e                	jmp    800f43 <memset+0x91>
			*p8++ = (uint8)c;
  800f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f38:	8d 50 01             	lea    0x1(%eax),%edx
  800f3b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f41:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e5                	jne    800f35 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f67:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f6b:	76 24                	jbe    800f91 <memcpy+0x3c>
		while(n >= 8){
  800f6d:	eb 1c                	jmp    800f8b <memcpy+0x36>
			*d64 = *s64;
  800f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f72:	8b 50 04             	mov    0x4(%eax),%edx
  800f75:	8b 00                	mov    (%eax),%eax
  800f77:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f7a:	89 01                	mov    %eax,(%ecx)
  800f7c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f7f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f83:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f87:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f8b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8f:	77 de                	ja     800f6f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f95:	74 31                	je     800fc8 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fa3:	eb 16                	jmp    800fbb <memcpy+0x66>
			*d8++ = *s8++;
  800fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa8:	8d 50 01             	lea    0x1(%eax),%edx
  800fab:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb4:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fb7:	8a 12                	mov    (%edx),%dl
  800fb9:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	75 dd                	jne    800fa5 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe5:	73 50                	jae    801037 <memmove+0x6a>
  800fe7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fea:	8b 45 10             	mov    0x10(%ebp),%eax
  800fed:	01 d0                	add    %edx,%eax
  800fef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff2:	76 43                	jbe    801037 <memmove+0x6a>
		s += n;
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801000:	eb 10                	jmp    801012 <memmove+0x45>
			*--d = *--s;
  801002:	ff 4d f8             	decl   -0x8(%ebp)
  801005:	ff 4d fc             	decl   -0x4(%ebp)
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	8a 10                	mov    (%eax),%dl
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801012:	8b 45 10             	mov    0x10(%ebp),%eax
  801015:	8d 50 ff             	lea    -0x1(%eax),%edx
  801018:	89 55 10             	mov    %edx,0x10(%ebp)
  80101b:	85 c0                	test   %eax,%eax
  80101d:	75 e3                	jne    801002 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80101f:	eb 23                	jmp    801044 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8d 50 01             	lea    0x1(%eax),%edx
  801027:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801030:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801033:	8a 12                	mov    (%edx),%dl
  801035:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103d:	89 55 10             	mov    %edx,0x10(%ebp)
  801040:	85 c0                	test   %eax,%eax
  801042:	75 dd                	jne    801021 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80105b:	eb 2a                	jmp    801087 <memcmp+0x3e>
		if (*s1 != *s2)
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	8a 10                	mov    (%eax),%dl
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	38 c2                	cmp    %al,%dl
  801069:	74 16                	je     801081 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f b6 d0             	movzbl %al,%edx
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	29 c2                	sub    %eax,%edx
  80107d:	89 d0                	mov    %edx,%eax
  80107f:	eb 18                	jmp    801099 <memcmp+0x50>
		s1++, s2++;
  801081:	ff 45 fc             	incl   -0x4(%ebp)
  801084:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108d:	89 55 10             	mov    %edx,0x10(%ebp)
  801090:	85 c0                	test   %eax,%eax
  801092:	75 c9                	jne    80105d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010ac:	eb 15                	jmp    8010c3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	0f b6 d0             	movzbl %al,%edx
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	0f b6 c0             	movzbl %al,%eax
  8010bc:	39 c2                	cmp    %eax,%edx
  8010be:	74 0d                	je     8010cd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010c0:	ff 45 08             	incl   0x8(%ebp)
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010c9:	72 e3                	jb     8010ae <memfind+0x13>
  8010cb:	eb 01                	jmp    8010ce <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010cd:	90                   	nop
	return (void *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e7:	eb 03                	jmp    8010ec <strtol+0x19>
		s++;
  8010e9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 20                	cmp    $0x20,%al
  8010f3:	74 f4                	je     8010e9 <strtol+0x16>
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 09                	cmp    $0x9,%al
  8010fc:	74 eb                	je     8010e9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 2b                	cmp    $0x2b,%al
  801105:	75 05                	jne    80110c <strtol+0x39>
		s++;
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	eb 13                	jmp    80111f <strtol+0x4c>
	else if (*s == '-')
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 2d                	cmp    $0x2d,%al
  801113:	75 0a                	jne    80111f <strtol+0x4c>
		s++, neg = 1;
  801115:	ff 45 08             	incl   0x8(%ebp)
  801118:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80111f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801123:	74 06                	je     80112b <strtol+0x58>
  801125:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801129:	75 20                	jne    80114b <strtol+0x78>
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	3c 30                	cmp    $0x30,%al
  801132:	75 17                	jne    80114b <strtol+0x78>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	40                   	inc    %eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 78                	cmp    $0x78,%al
  80113c:	75 0d                	jne    80114b <strtol+0x78>
		s += 2, base = 16;
  80113e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801142:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801149:	eb 28                	jmp    801173 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80114b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114f:	75 15                	jne    801166 <strtol+0x93>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 30                	cmp    $0x30,%al
  801158:	75 0c                	jne    801166 <strtol+0x93>
		s++, base = 8;
  80115a:	ff 45 08             	incl   0x8(%ebp)
  80115d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801164:	eb 0d                	jmp    801173 <strtol+0xa0>
	else if (base == 0)
  801166:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116a:	75 07                	jne    801173 <strtol+0xa0>
		base = 10;
  80116c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 2f                	cmp    $0x2f,%al
  80117a:	7e 19                	jle    801195 <strtol+0xc2>
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 39                	cmp    $0x39,%al
  801183:	7f 10                	jg     801195 <strtol+0xc2>
			dig = *s - '0';
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	0f be c0             	movsbl %al,%eax
  80118d:	83 e8 30             	sub    $0x30,%eax
  801190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801193:	eb 42                	jmp    8011d7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 60                	cmp    $0x60,%al
  80119c:	7e 19                	jle    8011b7 <strtol+0xe4>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	3c 7a                	cmp    $0x7a,%al
  8011a5:	7f 10                	jg     8011b7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	0f be c0             	movsbl %al,%eax
  8011af:	83 e8 57             	sub    $0x57,%eax
  8011b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b5:	eb 20                	jmp    8011d7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 40                	cmp    $0x40,%al
  8011be:	7e 39                	jle    8011f9 <strtol+0x126>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 5a                	cmp    $0x5a,%al
  8011c7:	7f 30                	jg     8011f9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	0f be c0             	movsbl %al,%eax
  8011d1:	83 e8 37             	sub    $0x37,%eax
  8011d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011dd:	7d 19                	jge    8011f8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011e9:	89 c2                	mov    %eax,%edx
  8011eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ee:	01 d0                	add    %edx,%eax
  8011f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011f3:	e9 7b ff ff ff       	jmp    801173 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011f8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fd:	74 08                	je     801207 <strtol+0x134>
		*endptr = (char *) s;
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	8b 55 08             	mov    0x8(%ebp),%edx
  801205:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801207:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120b:	74 07                	je     801214 <strtol+0x141>
  80120d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801210:	f7 d8                	neg    %eax
  801212:	eb 03                	jmp    801217 <strtol+0x144>
  801214:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <ltostr>:

void
ltostr(long value, char *str)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80121f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801226:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80122d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801231:	79 13                	jns    801246 <ltostr+0x2d>
	{
		neg = 1;
  801233:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801240:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801243:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80124e:	99                   	cltd   
  80124f:	f7 f9                	idiv   %ecx
  801251:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801254:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	83 c2 30             	add    $0x30,%edx
  80126a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80126c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801274:	f7 e9                	imul   %ecx
  801276:	c1 fa 02             	sar    $0x2,%edx
  801279:	89 c8                	mov    %ecx,%eax
  80127b:	c1 f8 1f             	sar    $0x1f,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
  801282:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801289:	75 bb                	jne    801246 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80128b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801295:	48                   	dec    %eax
  801296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801299:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129d:	74 3d                	je     8012dc <ltostr+0xc3>
		start = 1 ;
  80129f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012a6:	eb 34                	jmp    8012dc <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c3:	01 c8                	add    %ecx,%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	01 c2                	add    %eax,%edx
  8012d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8012d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e2:	7c c4                	jl     8012a8 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ef:	90                   	nop
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012f8:	ff 75 08             	pushl  0x8(%ebp)
  8012fb:	e8 c4 f9 ff ff       	call   800cc4 <strlen>
  801300:	83 c4 04             	add    $0x4,%esp
  801303:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	e8 b6 f9 ff ff       	call   800cc4 <strlen>
  80130e:	83 c4 04             	add    $0x4,%esp
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80131b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801322:	eb 17                	jmp    80133b <strcconcat+0x49>
		final[s] = str1[s] ;
  801324:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 c2                	add    %eax,%edx
  80132c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	01 c8                	add    %ecx,%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801338:	ff 45 fc             	incl   -0x4(%ebp)
  80133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801341:	7c e1                	jl     801324 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801343:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80134a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801351:	eb 1f                	jmp    801372 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801353:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801356:	8d 50 01             	lea    0x1(%eax),%edx
  801359:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80135c:	89 c2                	mov    %eax,%edx
  80135e:	8b 45 10             	mov    0x10(%ebp),%eax
  801361:	01 c2                	add    %eax,%edx
  801363:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	01 c8                	add    %ecx,%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80136f:	ff 45 f8             	incl   -0x8(%ebp)
  801372:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801375:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801378:	7c d9                	jl     801353 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80137a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137d:	8b 45 10             	mov    0x10(%ebp),%eax
  801380:	01 d0                	add    %edx,%eax
  801382:	c6 00 00             	movb   $0x0,(%eax)
}
  801385:	90                   	nop
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80138b:	8b 45 14             	mov    0x14(%ebp),%eax
  80138e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ab:	eb 0c                	jmp    8013b9 <strsplit+0x31>
			*string++ = 0;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8d 50 01             	lea    0x1(%eax),%edx
  8013b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	84 c0                	test   %al,%al
  8013c0:	74 18                	je     8013da <strsplit+0x52>
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	0f be c0             	movsbl %al,%eax
  8013ca:	50                   	push   %eax
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	e8 83 fa ff ff       	call   800e56 <strchr>
  8013d3:	83 c4 08             	add    $0x8,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	75 d3                	jne    8013ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 5a                	je     80143d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	83 f8 0f             	cmp    $0xf,%eax
  8013eb:	75 07                	jne    8013f4 <strsplit+0x6c>
		{
			return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	eb 66                	jmp    80145a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f7:	8b 00                	mov    (%eax),%eax
  8013f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ff:	89 0a                	mov    %ecx,(%edx)
  801401:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801408:	8b 45 10             	mov    0x10(%ebp),%eax
  80140b:	01 c2                	add    %eax,%edx
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801412:	eb 03                	jmp    801417 <strsplit+0x8f>
			string++;
  801414:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	84 c0                	test   %al,%al
  80141e:	74 8b                	je     8013ab <strsplit+0x23>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f be c0             	movsbl %al,%eax
  801428:	50                   	push   %eax
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	e8 25 fa ff ff       	call   800e56 <strchr>
  801431:	83 c4 08             	add    $0x8,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	74 dc                	je     801414 <strsplit+0x8c>
			string++;
	}
  801438:	e9 6e ff ff ff       	jmp    8013ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80143d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	8b 00                	mov    (%eax),%eax
  801443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	01 d0                	add    %edx,%eax
  80144f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801455:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146f:	eb 4a                	jmp    8014bb <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	01 c2                	add    %eax,%edx
  801479:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147f:	01 c8                	add    %ecx,%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801485:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	3c 40                	cmp    $0x40,%al
  801491:	7e 25                	jle    8014b8 <str2lower+0x5c>
  801493:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801496:	8b 45 0c             	mov    0xc(%ebp),%eax
  801499:	01 d0                	add    %edx,%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 5a                	cmp    $0x5a,%al
  80149f:	7f 17                	jg     8014b8 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	01 d0                	add    %edx,%eax
  8014a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8014af:	01 ca                	add    %ecx,%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	83 c2 20             	add    $0x20,%edx
  8014b6:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014b8:	ff 45 fc             	incl   -0x4(%ebp)
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	e8 01 f8 ff ff       	call   800cc4 <strlen>
  8014c3:	83 c4 04             	add    $0x4,%esp
  8014c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014c9:	7f a6                	jg     801471 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	6a 10                	push   $0x10
  8014db:	e8 b2 15 00 00       	call   802a92 <alloc_block>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8014e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ea:	75 14                	jne    801500 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	68 28 3f 80 00       	push   $0x803f28
  8014f4:	6a 14                	push   $0x14
  8014f6:	68 51 3f 80 00       	push   $0x803f51
  8014fb:	e8 fd ed ff ff       	call   8002fd <_panic>

	node->start = start;
  801500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801503:	8b 55 08             	mov    0x8(%ebp),%edx
  801506:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801511:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801518:	a1 24 50 80 00       	mov    0x805024,%eax
  80151d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801520:	eb 18                	jmp    80153a <insert_page_alloc+0x6a>
		if (start < it->start)
  801522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80152a:	77 37                	ja     801563 <insert_page_alloc+0x93>
			break;
		prev = it;
  80152c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801532:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80153a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80153e:	74 08                	je     801548 <insert_page_alloc+0x78>
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	8b 40 08             	mov    0x8(%eax),%eax
  801546:	eb 05                	jmp    80154d <insert_page_alloc+0x7d>
  801548:	b8 00 00 00 00       	mov    $0x0,%eax
  80154d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801552:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801557:	85 c0                	test   %eax,%eax
  801559:	75 c7                	jne    801522 <insert_page_alloc+0x52>
  80155b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80155f:	75 c1                	jne    801522 <insert_page_alloc+0x52>
  801561:	eb 01                	jmp    801564 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801563:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801564:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801568:	75 64                	jne    8015ce <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80156a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80156e:	75 14                	jne    801584 <insert_page_alloc+0xb4>
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	68 60 3f 80 00       	push   $0x803f60
  801578:	6a 21                	push   $0x21
  80157a:	68 51 3f 80 00       	push   $0x803f51
  80157f:	e8 79 ed ff ff       	call   8002fd <_panic>
  801584:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80158a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158d:	89 50 08             	mov    %edx,0x8(%eax)
  801590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801593:	8b 40 08             	mov    0x8(%eax),%eax
  801596:	85 c0                	test   %eax,%eax
  801598:	74 0d                	je     8015a7 <insert_page_alloc+0xd7>
  80159a:	a1 24 50 80 00       	mov    0x805024,%eax
  80159f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015a2:	89 50 0c             	mov    %edx,0xc(%eax)
  8015a5:	eb 08                	jmp    8015af <insert_page_alloc+0xdf>
  8015a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015aa:	a3 28 50 80 00       	mov    %eax,0x805028
  8015af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b2:	a3 24 50 80 00       	mov    %eax,0x805024
  8015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8015c1:	a1 30 50 80 00       	mov    0x805030,%eax
  8015c6:	40                   	inc    %eax
  8015c7:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8015cc:	eb 71                	jmp    80163f <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8015ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d2:	74 06                	je     8015da <insert_page_alloc+0x10a>
  8015d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d8:	75 14                	jne    8015ee <insert_page_alloc+0x11e>
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	68 84 3f 80 00       	push   $0x803f84
  8015e2:	6a 23                	push   $0x23
  8015e4:	68 51 3f 80 00       	push   $0x803f51
  8015e9:	e8 0f ed ff ff       	call   8002fd <_panic>
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	8b 50 08             	mov    0x8(%eax),%edx
  8015f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f7:	89 50 08             	mov    %edx,0x8(%eax)
  8015fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fd:	8b 40 08             	mov    0x8(%eax),%eax
  801600:	85 c0                	test   %eax,%eax
  801602:	74 0c                	je     801610 <insert_page_alloc+0x140>
  801604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801607:	8b 40 08             	mov    0x8(%eax),%eax
  80160a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80160d:	89 50 0c             	mov    %edx,0xc(%eax)
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801616:	89 50 08             	mov    %edx,0x8(%eax)
  801619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161f:	89 50 0c             	mov    %edx,0xc(%eax)
  801622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801625:	8b 40 08             	mov    0x8(%eax),%eax
  801628:	85 c0                	test   %eax,%eax
  80162a:	75 08                	jne    801634 <insert_page_alloc+0x164>
  80162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162f:	a3 28 50 80 00       	mov    %eax,0x805028
  801634:	a1 30 50 80 00       	mov    0x805030,%eax
  801639:	40                   	inc    %eax
  80163a:	a3 30 50 80 00       	mov    %eax,0x805030
}
  80163f:	90                   	nop
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801648:	a1 24 50 80 00       	mov    0x805024,%eax
  80164d:	85 c0                	test   %eax,%eax
  80164f:	75 0c                	jne    80165d <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801651:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801656:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  80165b:	eb 67                	jmp    8016c4 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80165d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801662:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801665:	a1 24 50 80 00       	mov    0x805024,%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80166d:	eb 26                	jmp    801695 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8b 10                	mov    (%eax),%edx
  801674:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801677:	8b 40 04             	mov    0x4(%eax),%eax
  80167a:	01 d0                	add    %edx,%eax
  80167c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801685:	76 06                	jbe    80168d <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168a:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80168d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801692:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801695:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801699:	74 08                	je     8016a3 <recompute_page_alloc_break+0x61>
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169e:	8b 40 08             	mov    0x8(%eax),%eax
  8016a1:	eb 05                	jmp    8016a8 <recompute_page_alloc_break+0x66>
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	75 b9                	jne    80166f <recompute_page_alloc_break+0x2d>
  8016b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016ba:	75 b3                	jne    80166f <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8016bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bf:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8016cc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8016d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016d9:	01 d0                	add    %edx,%eax
  8016db:	48                   	dec    %eax
  8016dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	f7 75 d8             	divl   -0x28(%ebp)
  8016ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016ed:	29 d0                	sub    %edx,%eax
  8016ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8016f2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8016f6:	75 0a                	jne    801702 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	e9 7e 01 00 00       	jmp    801880 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801702:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801709:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80170d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801714:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80171b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801723:	a1 24 50 80 00       	mov    0x805024,%eax
  801728:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80172b:	eb 69                	jmp    801796 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80172d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801730:	8b 00                	mov    (%eax),%eax
  801732:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801735:	76 47                	jbe    80177e <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80173a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80173d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801745:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801748:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80174b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80174e:	72 2e                	jb     80177e <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801750:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801754:	75 14                	jne    80176a <alloc_pages_custom_fit+0xa4>
  801756:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801759:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80175c:	75 0c                	jne    80176a <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80175e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801761:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801764:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801768:	eb 14                	jmp    80177e <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80176a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80176d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801770:	76 0c                	jbe    80177e <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801772:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801775:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801778:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80177b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  80177e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801781:	8b 10                	mov    (%eax),%edx
  801783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801786:	8b 40 04             	mov    0x4(%eax),%eax
  801789:	01 d0                	add    %edx,%eax
  80178b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80178e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801793:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801796:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80179a:	74 08                	je     8017a4 <alloc_pages_custom_fit+0xde>
  80179c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179f:	8b 40 08             	mov    0x8(%eax),%eax
  8017a2:	eb 05                	jmp    8017a9 <alloc_pages_custom_fit+0xe3>
  8017a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	0f 85 72 ff ff ff    	jne    80172d <alloc_pages_custom_fit+0x67>
  8017bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017bf:	0f 85 68 ff ff ff    	jne    80172d <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8017c5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017ca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017cd:	76 47                	jbe    801816 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8017cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8017d5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017da:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8017dd:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8017e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017e3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017e6:	72 2e                	jb     801816 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8017e8:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017ec:	75 14                	jne    801802 <alloc_pages_custom_fit+0x13c>
  8017ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017f1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017f4:	75 0c                	jne    801802 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8017f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8017fc:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801800:	eb 14                	jmp    801816 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801802:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801805:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801808:	76 0c                	jbe    801816 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80180a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801810:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801813:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801816:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80181d:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801821:	74 08                	je     80182b <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801826:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801829:	eb 40                	jmp    80186b <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80182b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80182f:	74 08                	je     801839 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801837:	eb 32                	jmp    80186b <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801839:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80183e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801841:	89 c2                	mov    %eax,%edx
  801843:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801848:	39 c2                	cmp    %eax,%edx
  80184a:	73 07                	jae    801853 <alloc_pages_custom_fit+0x18d>
			return NULL;
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
  801851:	eb 2d                	jmp    801880 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801853:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801858:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80185b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801861:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801864:	01 d0                	add    %edx,%eax
  801866:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  80186b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 d0             	pushl  -0x30(%ebp)
  801874:	50                   	push   %eax
  801875:	e8 56 fc ff ff       	call   8014d0 <insert_page_alloc>
  80187a:	83 c4 10             	add    $0x10,%esp

	return result;
  80187d:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80188e:	a1 24 50 80 00       	mov    0x805024,%eax
  801893:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801896:	eb 1a                	jmp    8018b2 <find_allocated_size+0x30>
		if (it->start == va)
  801898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80189b:	8b 00                	mov    (%eax),%eax
  80189d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018a0:	75 08                	jne    8018aa <find_allocated_size+0x28>
			return it->size;
  8018a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a5:	8b 40 04             	mov    0x4(%eax),%eax
  8018a8:	eb 34                	jmp    8018de <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b6:	74 08                	je     8018c0 <find_allocated_size+0x3e>
  8018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018bb:	8b 40 08             	mov    0x8(%eax),%eax
  8018be:	eb 05                	jmp    8018c5 <find_allocated_size+0x43>
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	75 c5                	jne    801898 <find_allocated_size+0x16>
  8018d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d7:	75 bf                	jne    801898 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8018f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f4:	e9 e1 01 00 00       	jmp    801ada <free_pages+0x1fa>
		if (it->start == va) {
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	8b 00                	mov    (%eax),%eax
  8018fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801901:	0f 85 cb 01 00 00    	jne    801ad2 <free_pages+0x1f2>

			uint32 start = it->start;
  801907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	8b 40 04             	mov    0x4(%eax),%eax
  801915:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191b:	f7 d0                	not    %eax
  80191d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801920:	73 1d                	jae    80193f <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801922:	83 ec 0c             	sub    $0xc,%esp
  801925:	ff 75 e4             	pushl  -0x1c(%ebp)
  801928:	ff 75 e8             	pushl  -0x18(%ebp)
  80192b:	68 b8 3f 80 00       	push   $0x803fb8
  801930:	68 a5 00 00 00       	push   $0xa5
  801935:	68 51 3f 80 00       	push   $0x803f51
  80193a:	e8 be e9 ff ff       	call   8002fd <_panic>
			}

			uint32 start_end = start + size;
  80193f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80194a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	79 19                	jns    80196a <free_pages+0x8a>
  801951:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801958:	77 10                	ja     80196a <free_pages+0x8a>
  80195a:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801961:	77 07                	ja     80196a <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801966:	85 c0                	test   %eax,%eax
  801968:	78 2c                	js     801996 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80196a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	68 00 00 00 a0       	push   $0xa0000000
  801975:	ff 75 e0             	pushl  -0x20(%ebp)
  801978:	ff 75 e4             	pushl  -0x1c(%ebp)
  80197b:	ff 75 e8             	pushl  -0x18(%ebp)
  80197e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801981:	50                   	push   %eax
  801982:	68 fc 3f 80 00       	push   $0x803ffc
  801987:	68 ad 00 00 00       	push   $0xad
  80198c:	68 51 3f 80 00       	push   $0x803f51
  801991:	e8 67 e9 ff ff       	call   8002fd <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80199c:	e9 88 00 00 00       	jmp    801a29 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8019a1:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8019a8:	76 17                	jbe    8019c1 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8019aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ad:	68 60 40 80 00       	push   $0x804060
  8019b2:	68 b4 00 00 00       	push   $0xb4
  8019b7:	68 51 3f 80 00       	push   $0x803f51
  8019bc:	e8 3c e9 ff ff       	call   8002fd <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c4:	05 00 10 00 00       	add    $0x1000,%eax
  8019c9:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	79 2e                	jns    801a01 <free_pages+0x121>
  8019d3:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8019da:	77 25                	ja     801a01 <free_pages+0x121>
  8019dc:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8019e3:	77 1c                	ja     801a01 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	68 00 10 00 00       	push   $0x1000
  8019ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f0:	e8 38 0d 00 00       	call   80272d <sys_free_user_mem>
  8019f5:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019f8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8019ff:	eb 28                	jmp    801a29 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a04:	68 00 00 00 a0       	push   $0xa0000000
  801a09:	ff 75 dc             	pushl  -0x24(%ebp)
  801a0c:	68 00 10 00 00       	push   $0x1000
  801a11:	ff 75 f0             	pushl  -0x10(%ebp)
  801a14:	50                   	push   %eax
  801a15:	68 a0 40 80 00       	push   $0x8040a0
  801a1a:	68 bd 00 00 00       	push   $0xbd
  801a1f:	68 51 3f 80 00       	push   $0x803f51
  801a24:	e8 d4 e8 ff ff       	call   8002fd <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a2f:	0f 82 6c ff ff ff    	jb     8019a1 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a39:	75 17                	jne    801a52 <free_pages+0x172>
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 02 41 80 00       	push   $0x804102
  801a43:	68 c1 00 00 00       	push   $0xc1
  801a48:	68 51 3f 80 00       	push   $0x803f51
  801a4d:	e8 ab e8 ff ff       	call   8002fd <_panic>
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a55:	8b 40 08             	mov    0x8(%eax),%eax
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	74 11                	je     801a6d <free_pages+0x18d>
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5f:	8b 40 08             	mov    0x8(%eax),%eax
  801a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a65:	8b 52 0c             	mov    0xc(%edx),%edx
  801a68:	89 50 0c             	mov    %edx,0xc(%eax)
  801a6b:	eb 0b                	jmp    801a78 <free_pages+0x198>
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	a3 28 50 80 00       	mov    %eax,0x805028
  801a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	74 11                	je     801a93 <free_pages+0x1b3>
  801a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a85:	8b 40 0c             	mov    0xc(%eax),%eax
  801a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8b:	8b 52 08             	mov    0x8(%edx),%edx
  801a8e:	89 50 08             	mov    %edx,0x8(%eax)
  801a91:	eb 0b                	jmp    801a9e <free_pages+0x1be>
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	8b 40 08             	mov    0x8(%eax),%eax
  801a99:	a3 24 50 80 00       	mov    %eax,0x805024
  801a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ab2:	a1 30 50 80 00       	mov    0x805030,%eax
  801ab7:	48                   	dec    %eax
  801ab8:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801abd:	83 ec 0c             	sub    $0xc,%esp
  801ac0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac3:	e8 24 15 00 00       	call   802fec <free_block>
  801ac8:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801acb:	e8 72 fb ff ff       	call   801642 <recompute_page_alloc_break>

			return;
  801ad0:	eb 37                	jmp    801b09 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ad2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ade:	74 08                	je     801ae8 <free_pages+0x208>
  801ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae3:	8b 40 08             	mov    0x8(%eax),%eax
  801ae6:	eb 05                	jmp    801aed <free_pages+0x20d>
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801af2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801af7:	85 c0                	test   %eax,%eax
  801af9:	0f 85 fa fd ff ff    	jne    8018f9 <free_pages+0x19>
  801aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b03:	0f 85 f0 fd ff ff    	jne    8018f9 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b1b:	a1 08 50 80 00       	mov    0x805008,%eax
  801b20:	85 c0                	test   %eax,%eax
  801b22:	74 60                	je     801b84 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b24:	83 ec 08             	sub    $0x8,%esp
  801b27:	68 00 00 00 82       	push   $0x82000000
  801b2c:	68 00 00 00 80       	push   $0x80000000
  801b31:	e8 0d 0d 00 00       	call   802843 <initialize_dynamic_allocator>
  801b36:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b39:	e8 f3 0a 00 00       	call   802631 <sys_get_uheap_strategy>
  801b3e:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b43:	a1 40 50 80 00       	mov    0x805040,%eax
  801b48:	05 00 10 00 00       	add    $0x1000,%eax
  801b4d:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b52:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b57:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801b5c:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801b63:	00 00 00 
  801b66:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801b6d:	00 00 00 
  801b70:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801b77:	00 00 00 

		__firstTimeFlag = 0;
  801b7a:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801b81:	00 00 00 
	}
}
  801b84:	90                   	nop
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	68 06 04 00 00       	push   $0x406
  801ba3:	50                   	push   %eax
  801ba4:	e8 d2 06 00 00       	call   80227b <__sys_allocate_page>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801baf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb3:	79 17                	jns    801bcc <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	68 20 41 80 00       	push   $0x804120
  801bbd:	68 ea 00 00 00       	push   $0xea
  801bc2:	68 51 3f 80 00       	push   $0x803f51
  801bc7:	e8 31 e7 ff ff       	call   8002fd <_panic>
	return 0;
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 d2 06 00 00       	call   8022c2 <__sys_unmap_frame>
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bfa:	79 17                	jns    801c13 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801bfc:	83 ec 04             	sub    $0x4,%esp
  801bff:	68 5c 41 80 00       	push   $0x80415c
  801c04:	68 f5 00 00 00       	push   $0xf5
  801c09:	68 51 3f 80 00       	push   $0x803f51
  801c0e:	e8 ea e6 ff ff       	call   8002fd <_panic>
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c1c:	e8 f4 fe ff ff       	call   801b15 <uheap_init>
	if (size == 0) return NULL ;
  801c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c25:	75 0a                	jne    801c31 <malloc+0x1b>
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	e9 67 01 00 00       	jmp    801d98 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801c31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801c38:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c3f:	77 16                	ja     801c57 <malloc+0x41>
		result = alloc_block(size);
  801c41:	83 ec 0c             	sub    $0xc,%esp
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	e8 46 0e 00 00       	call   802a92 <alloc_block>
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c52:	e9 3e 01 00 00       	jmp    801d95 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801c57:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	48                   	dec    %eax
  801c67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c72:	f7 75 f0             	divl   -0x10(%ebp)
  801c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c78:	29 d0                	sub    %edx,%eax
  801c7a:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801c7d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c82:	85 c0                	test   %eax,%eax
  801c84:	75 0a                	jne    801c90 <malloc+0x7a>
			return NULL;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8b:	e9 08 01 00 00       	jmp    801d98 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801c90:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c95:	85 c0                	test   %eax,%eax
  801c97:	74 0f                	je     801ca8 <malloc+0x92>
  801c99:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801c9f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ca4:	39 c2                	cmp    %eax,%edx
  801ca6:	73 0a                	jae    801cb2 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801ca8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cad:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801cb2:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801cb7:	83 f8 05             	cmp    $0x5,%eax
  801cba:	75 11                	jne    801ccd <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	ff 75 e8             	pushl  -0x18(%ebp)
  801cc2:	e8 ff f9 ff ff       	call   8016c6 <alloc_pages_custom_fit>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd1:	0f 84 be 00 00 00    	je     801d95 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce3:	e8 9a fb ff ff       	call   801882 <find_allocated_size>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801cee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cf2:	75 17                	jne    801d0b <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf7:	68 9c 41 80 00       	push   $0x80419c
  801cfc:	68 24 01 00 00       	push   $0x124
  801d01:	68 51 3f 80 00       	push   $0x803f51
  801d06:	e8 f2 e5 ff ff       	call   8002fd <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d0e:	f7 d0                	not    %eax
  801d10:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d13:	73 1d                	jae    801d32 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	ff 75 e0             	pushl  -0x20(%ebp)
  801d1b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d1e:	68 e4 41 80 00       	push   $0x8041e4
  801d23:	68 29 01 00 00       	push   $0x129
  801d28:	68 51 3f 80 00       	push   $0x803f51
  801d2d:	e8 cb e5 ff ff       	call   8002fd <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801d32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d38:	01 d0                	add    %edx,%eax
  801d3a:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d40:	85 c0                	test   %eax,%eax
  801d42:	79 2c                	jns    801d70 <malloc+0x15a>
  801d44:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d4b:	77 23                	ja     801d70 <malloc+0x15a>
  801d4d:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d54:	77 1a                	ja     801d70 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	79 13                	jns    801d70 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	ff 75 e0             	pushl  -0x20(%ebp)
  801d63:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d66:	e8 de 09 00 00       	call   802749 <sys_allocate_user_mem>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	eb 25                	jmp    801d95 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801d70:	68 00 00 00 a0       	push   $0xa0000000
  801d75:	ff 75 dc             	pushl  -0x24(%ebp)
  801d78:	ff 75 e0             	pushl  -0x20(%ebp)
  801d7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d81:	68 20 42 80 00       	push   $0x804220
  801d86:	68 33 01 00 00       	push   $0x133
  801d8b:	68 51 3f 80 00       	push   $0x803f51
  801d90:	e8 68 e5 ff ff       	call   8002fd <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801da0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801da4:	0f 84 26 01 00 00    	je     801ed0 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	85 c0                	test   %eax,%eax
  801db5:	79 1c                	jns    801dd3 <free+0x39>
  801db7:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801dbe:	77 13                	ja     801dd3 <free+0x39>
		free_block(virtual_address);
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	e8 21 12 00 00       	call   802fec <free_block>
  801dcb:	83 c4 10             	add    $0x10,%esp
		return;
  801dce:	e9 01 01 00 00       	jmp    801ed4 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801dd3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dd8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801ddb:	0f 82 d8 00 00 00    	jb     801eb9 <free+0x11f>
  801de1:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801de8:	0f 87 cb 00 00 00    	ja     801eb9 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	25 ff 0f 00 00       	and    $0xfff,%eax
  801df6:	85 c0                	test   %eax,%eax
  801df8:	74 17                	je     801e11 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	68 90 42 80 00       	push   $0x804290
  801e02:	68 57 01 00 00       	push   $0x157
  801e07:	68 51 3f 80 00       	push   $0x803f51
  801e0c:	e8 ec e4 ff ff       	call   8002fd <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	e8 66 fa ff ff       	call   801882 <find_allocated_size>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801e22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e26:	0f 84 a7 00 00 00    	je     801ed3 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2f:	f7 d0                	not    %eax
  801e31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e34:	73 1d                	jae    801e53 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3f:	68 b8 42 80 00       	push   $0x8042b8
  801e44:	68 61 01 00 00       	push   $0x161
  801e49:	68 51 3f 80 00       	push   $0x803f51
  801e4e:	e8 aa e4 ff ff       	call   8002fd <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e59:	01 d0                	add    %edx,%eax
  801e5b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	79 19                	jns    801e7e <free+0xe4>
  801e65:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801e6c:	77 10                	ja     801e7e <free+0xe4>
  801e6e:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801e75:	77 07                	ja     801e7e <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 2b                	js     801ea9 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801e7e:	83 ec 0c             	sub    $0xc,%esp
  801e81:	68 00 00 00 a0       	push   $0xa0000000
  801e86:	ff 75 ec             	pushl  -0x14(%ebp)
  801e89:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	68 f4 42 80 00       	push   $0x8042f4
  801e9a:	68 69 01 00 00       	push   $0x169
  801e9f:	68 51 3f 80 00       	push   $0x803f51
  801ea4:	e8 54 e4 ff ff       	call   8002fd <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	ff 75 08             	pushl  0x8(%ebp)
  801eaf:	e8 2c fa ff ff       	call   8018e0 <free_pages>
  801eb4:	83 c4 10             	add    $0x10,%esp
		return;
  801eb7:	eb 1b                	jmp    801ed4 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	68 50 43 80 00       	push   $0x804350
  801ec1:	68 70 01 00 00       	push   $0x170
  801ec6:	68 51 3f 80 00       	push   $0x803f51
  801ecb:	e8 2d e4 ff ff       	call   8002fd <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ed0:	90                   	nop
  801ed1:	eb 01                	jmp    801ed4 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801ed3:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 38             	sub    $0x38,%esp
  801edc:	8b 45 10             	mov    0x10(%ebp),%eax
  801edf:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ee2:	e8 2e fc ff ff       	call   801b15 <uheap_init>
	if (size == 0) return NULL ;
  801ee7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eeb:	75 0a                	jne    801ef7 <smalloc+0x21>
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef2:	e9 3d 01 00 00       	jmp    802034 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f00:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f05:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801f08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f0c:	74 0e                	je     801f1c <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801f14:	05 00 10 00 00       	add    $0x1000,%eax
  801f19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	c1 e8 0c             	shr    $0xc,%eax
  801f22:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801f25:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 0a                	jne    801f38 <smalloc+0x62>
		return NULL;
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	e9 fc 00 00 00       	jmp    802034 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801f38:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	74 0f                	je     801f50 <smalloc+0x7a>
  801f41:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f47:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f4c:	39 c2                	cmp    %eax,%edx
  801f4e:	73 0a                	jae    801f5a <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f50:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f55:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801f5a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f5f:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f64:	29 c2                	sub    %eax,%edx
  801f66:	89 d0                	mov    %edx,%eax
  801f68:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801f6b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f71:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f76:	29 c2                	sub    %eax,%edx
  801f78:	89 d0                	mov    %edx,%eax
  801f7a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f83:	77 13                	ja     801f98 <smalloc+0xc2>
  801f85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f88:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f8b:	77 0b                	ja     801f98 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f90:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f93:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f96:	73 0a                	jae    801fa2 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9d:	e9 92 00 00 00       	jmp    802034 <smalloc+0x15e>
	}

	void *va = NULL;
  801fa2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801fa9:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801fae:	83 f8 05             	cmp    $0x5,%eax
  801fb1:	75 11                	jne    801fc4 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb9:	e8 08 f7 ff ff       	call   8016c6 <alloc_pages_custom_fit>
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801fc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc8:	75 27                	jne    801ff1 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801fca:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801fd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fd4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801fd7:	89 c2                	mov    %eax,%edx
  801fd9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fde:	39 c2                	cmp    %eax,%edx
  801fe0:	73 07                	jae    801fe9 <smalloc+0x113>
			return NULL;}
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	eb 4b                	jmp    802034 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801fe9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801ff1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ff5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff8:	50                   	push   %eax
  801ff9:	ff 75 0c             	pushl  0xc(%ebp)
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	e8 cb 03 00 00       	call   8023cf <sys_create_shared_object>
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80200a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80200e:	79 07                	jns    802017 <smalloc+0x141>
		return NULL;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	eb 1d                	jmp    802034 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802017:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80201c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80201f:	75 10                	jne    802031 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802021:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	01 d0                	add    %edx,%eax
  80202c:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802031:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80203c:	e8 d4 fa ff ff       	call   801b15 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802041:	83 ec 08             	sub    $0x8,%esp
  802044:	ff 75 0c             	pushl  0xc(%ebp)
  802047:	ff 75 08             	pushl  0x8(%ebp)
  80204a:	e8 aa 03 00 00       	call   8023f9 <sys_size_of_shared_object>
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802055:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802059:	7f 0a                	jg     802065 <sget+0x2f>
		return NULL;
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	e9 32 01 00 00       	jmp    802197 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80206b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802073:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802076:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80207a:	74 0e                	je     80208a <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802082:	05 00 10 00 00       	add    $0x1000,%eax
  802087:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80208a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80208f:	85 c0                	test   %eax,%eax
  802091:	75 0a                	jne    80209d <sget+0x67>
		return NULL;
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
  802098:	e9 fa 00 00 00       	jmp    802197 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80209d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	74 0f                	je     8020b5 <sget+0x7f>
  8020a6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020ac:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b1:	39 c2                	cmp    %eax,%edx
  8020b3:	73 0a                	jae    8020bf <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8020b5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020ba:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020bf:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020c4:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020c9:	29 c2                	sub    %eax,%edx
  8020cb:	89 d0                	mov    %edx,%eax
  8020cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020d0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020d6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020db:	29 c2                	sub    %eax,%edx
  8020dd:	89 d0                	mov    %edx,%eax
  8020df:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020e8:	77 13                	ja     8020fd <sget+0xc7>
  8020ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020f0:	77 0b                	ja     8020fd <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8020f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f5:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020f8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020fb:	73 0a                	jae    802107 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	e9 90 00 00 00       	jmp    802197 <sget+0x161>

	void *va = NULL;
  802107:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80210e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802113:	83 f8 05             	cmp    $0x5,%eax
  802116:	75 11                	jne    802129 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 f4             	pushl  -0xc(%ebp)
  80211e:	e8 a3 f5 ff ff       	call   8016c6 <alloc_pages_custom_fit>
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802129:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80212d:	75 27                	jne    802156 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80212f:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802136:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802139:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80213c:	89 c2                	mov    %eax,%edx
  80213e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802143:	39 c2                	cmp    %eax,%edx
  802145:	73 07                	jae    80214e <sget+0x118>
			return NULL;
  802147:	b8 00 00 00 00       	mov    $0x0,%eax
  80214c:	eb 49                	jmp    802197 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80214e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802153:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	ff 75 f0             	pushl  -0x10(%ebp)
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	ff 75 08             	pushl  0x8(%ebp)
  802162:	e8 af 02 00 00       	call   802416 <sys_get_shared_object>
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80216d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802171:	79 07                	jns    80217a <sget+0x144>
		return NULL;
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	eb 1d                	jmp    802197 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80217a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80217f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802182:	75 10                	jne    802194 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802184:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	01 d0                	add    %edx,%eax
  80218f:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80219f:	e8 71 f9 ff ff       	call   801b15 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	68 74 43 80 00       	push   $0x804374
  8021ac:	68 19 02 00 00       	push   $0x219
  8021b1:	68 51 3f 80 00       	push   $0x803f51
  8021b6:	e8 42 e1 ff ff       	call   8002fd <_panic>

008021bb <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	68 9c 43 80 00       	push   $0x80439c
  8021c9:	68 2b 02 00 00       	push   $0x22b
  8021ce:	68 51 3f 80 00       	push   $0x803f51
  8021d3:	e8 25 e1 ff ff       	call   8002fd <_panic>

008021d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	57                   	push   %edi
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021ed:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021f0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021f3:	cd 30                	int    $0x30
  8021f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5f                   	pop    %edi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    

00802203 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80220f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802212:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	51                   	push   %ecx
  80221c:	52                   	push   %edx
  80221d:	ff 75 0c             	pushl  0xc(%ebp)
  802220:	50                   	push   %eax
  802221:	6a 00                	push   $0x0
  802223:	e8 b0 ff ff ff       	call   8021d8 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	90                   	nop
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_cgetc>:

int
sys_cgetc(void)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 02                	push   $0x2
  80223d:	e8 96 ff ff ff       	call   8021d8 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 03                	push   $0x3
  802256:	e8 7d ff ff ff       	call   8021d8 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	90                   	nop
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 04                	push   $0x4
  802270:	e8 63 ff ff ff       	call   8021d8 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	90                   	nop
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	52                   	push   %edx
  80228b:	50                   	push   %eax
  80228c:	6a 08                	push   $0x8
  80228e:	e8 45 ff ff ff       	call   8021d8 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	56                   	push   %esi
  80229c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80229d:	8b 75 18             	mov    0x18(%ebp),%esi
  8022a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	51                   	push   %ecx
  8022af:	52                   	push   %edx
  8022b0:	50                   	push   %eax
  8022b1:	6a 09                	push   $0x9
  8022b3:	e8 20 ff ff ff       	call   8021d8 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	ff 75 08             	pushl  0x8(%ebp)
  8022d0:	6a 0a                	push   $0xa
  8022d2:	e8 01 ff ff ff       	call   8021d8 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	ff 75 0c             	pushl  0xc(%ebp)
  8022e8:	ff 75 08             	pushl  0x8(%ebp)
  8022eb:	6a 0b                	push   $0xb
  8022ed:	e8 e6 fe ff ff       	call   8021d8 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 0c                	push   $0xc
  802306:	e8 cd fe ff ff       	call   8021d8 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 0d                	push   $0xd
  80231f:	e8 b4 fe ff ff       	call   8021d8 <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 0e                	push   $0xe
  802338:	e8 9b fe ff ff       	call   8021d8 <syscall>
  80233d:	83 c4 18             	add    $0x18,%esp
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 0f                	push   $0xf
  802351:	e8 82 fe ff ff       	call   8021d8 <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 08             	pushl  0x8(%ebp)
  802369:	6a 10                	push   $0x10
  80236b:	e8 68 fe ff ff       	call   8021d8 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 11                	push   $0x11
  802384:	e8 4f fe ff ff       	call   8021d8 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	90                   	nop
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_cputc>:

void
sys_cputc(const char c)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80239b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	50                   	push   %eax
  8023a8:	6a 01                	push   $0x1
  8023aa:	e8 29 fe ff ff       	call   8021d8 <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
}
  8023b2:	90                   	nop
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 14                	push   $0x14
  8023c4:	e8 0f fe ff ff       	call   8021d8 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	90                   	nop
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	6a 00                	push   $0x0
  8023e7:	51                   	push   %ecx
  8023e8:	52                   	push   %edx
  8023e9:	ff 75 0c             	pushl  0xc(%ebp)
  8023ec:	50                   	push   %eax
  8023ed:	6a 15                	push   $0x15
  8023ef:	e8 e4 fd ff ff       	call   8021d8 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	52                   	push   %edx
  802409:	50                   	push   %eax
  80240a:	6a 16                	push   $0x16
  80240c:	e8 c7 fd ff ff       	call   8021d8 <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802419:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	51                   	push   %ecx
  802427:	52                   	push   %edx
  802428:	50                   	push   %eax
  802429:	6a 17                	push   $0x17
  80242b:	e8 a8 fd ff ff       	call   8021d8 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	52                   	push   %edx
  802445:	50                   	push   %eax
  802446:	6a 18                	push   $0x18
  802448:	e8 8b fd ff ff       	call   8021d8 <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	6a 00                	push   $0x0
  80245a:	ff 75 14             	pushl  0x14(%ebp)
  80245d:	ff 75 10             	pushl  0x10(%ebp)
  802460:	ff 75 0c             	pushl  0xc(%ebp)
  802463:	50                   	push   %eax
  802464:	6a 19                	push   $0x19
  802466:	e8 6d fd ff ff       	call   8021d8 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	50                   	push   %eax
  80247f:	6a 1a                	push   $0x1a
  802481:	e8 52 fd ff ff       	call   8021d8 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	50                   	push   %eax
  80249b:	6a 1b                	push   $0x1b
  80249d:	e8 36 fd ff ff       	call   8021d8 <syscall>
  8024a2:	83 c4 18             	add    $0x18,%esp
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 05                	push   $0x5
  8024b6:	e8 1d fd ff ff       	call   8021d8 <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 06                	push   $0x6
  8024cf:	e8 04 fd ff ff       	call   8021d8 <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 07                	push   $0x7
  8024e8:	e8 eb fc ff ff       	call   8021d8 <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_exit_env>:


void sys_exit_env(void)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 1c                	push   $0x1c
  802501:	e8 d2 fc ff ff       	call   8021d8 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	90                   	nop
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802512:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802515:	8d 50 04             	lea    0x4(%eax),%edx
  802518:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	6a 1d                	push   $0x1d
  802525:	e8 ae fc ff ff       	call   8021d8 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
	return result;
  80252d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802530:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802533:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802536:	89 01                	mov    %eax,(%ecx)
  802538:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	c9                   	leave  
  80253f:	c2 04 00             	ret    $0x4

00802542 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	ff 75 10             	pushl  0x10(%ebp)
  80254c:	ff 75 0c             	pushl  0xc(%ebp)
  80254f:	ff 75 08             	pushl  0x8(%ebp)
  802552:	6a 13                	push   $0x13
  802554:	e8 7f fc ff ff       	call   8021d8 <syscall>
  802559:	83 c4 18             	add    $0x18,%esp
	return ;
  80255c:	90                   	nop
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <sys_rcr2>:
uint32 sys_rcr2()
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 1e                	push   $0x1e
  80256e:	e8 65 fc ff ff       	call   8021d8 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802584:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	50                   	push   %eax
  802591:	6a 1f                	push   $0x1f
  802593:	e8 40 fc ff ff       	call   8021d8 <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
	return ;
  80259b:	90                   	nop
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <rsttst>:
void rsttst()
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 21                	push   $0x21
  8025ad:	e8 26 fc ff ff       	call   8021d8 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b5:	90                   	nop
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025c4:	8b 55 18             	mov    0x18(%ebp),%edx
  8025c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025cb:	52                   	push   %edx
  8025cc:	50                   	push   %eax
  8025cd:	ff 75 10             	pushl  0x10(%ebp)
  8025d0:	ff 75 0c             	pushl  0xc(%ebp)
  8025d3:	ff 75 08             	pushl  0x8(%ebp)
  8025d6:	6a 20                	push   $0x20
  8025d8:	e8 fb fb ff ff       	call   8021d8 <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e0:	90                   	nop
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <chktst>:
void chktst(uint32 n)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	ff 75 08             	pushl  0x8(%ebp)
  8025f1:	6a 22                	push   $0x22
  8025f3:	e8 e0 fb ff ff       	call   8021d8 <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fb:	90                   	nop
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <inctst>:

void inctst()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 23                	push   $0x23
  80260d:	e8 c6 fb ff ff       	call   8021d8 <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
	return ;
  802615:	90                   	nop
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <gettst>:
uint32 gettst()
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 24                	push   $0x24
  802627:	e8 ac fb ff ff       	call   8021d8 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 25                	push   $0x25
  802640:	e8 93 fb ff ff       	call   8021d8 <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
  802648:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80264d:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	ff 75 08             	pushl  0x8(%ebp)
  80266a:	6a 26                	push   $0x26
  80266c:	e8 67 fb ff ff       	call   8021d8 <syscall>
  802671:	83 c4 18             	add    $0x18,%esp
	return ;
  802674:	90                   	nop
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80267b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80267e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802681:	8b 55 0c             	mov    0xc(%ebp),%edx
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	6a 00                	push   $0x0
  802689:	53                   	push   %ebx
  80268a:	51                   	push   %ecx
  80268b:	52                   	push   %edx
  80268c:	50                   	push   %eax
  80268d:	6a 27                	push   $0x27
  80268f:	e8 44 fb ff ff       	call   8021d8 <syscall>
  802694:	83 c4 18             	add    $0x18,%esp
}
  802697:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80269f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	52                   	push   %edx
  8026ac:	50                   	push   %eax
  8026ad:	6a 28                	push   $0x28
  8026af:	e8 24 fb ff ff       	call   8021d8 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
}
  8026b7:	c9                   	leave  
  8026b8:	c3                   	ret    

008026b9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026bc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	6a 00                	push   $0x0
  8026c7:	51                   	push   %ecx
  8026c8:	ff 75 10             	pushl  0x10(%ebp)
  8026cb:	52                   	push   %edx
  8026cc:	50                   	push   %eax
  8026cd:	6a 29                	push   $0x29
  8026cf:	e8 04 fb ff ff       	call   8021d8 <syscall>
  8026d4:	83 c4 18             	add    $0x18,%esp
}
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	ff 75 10             	pushl  0x10(%ebp)
  8026e3:	ff 75 0c             	pushl  0xc(%ebp)
  8026e6:	ff 75 08             	pushl  0x8(%ebp)
  8026e9:	6a 12                	push   $0x12
  8026eb:	e8 e8 fa ff ff       	call   8021d8 <syscall>
  8026f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f3:	90                   	nop
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	52                   	push   %edx
  802706:	50                   	push   %eax
  802707:	6a 2a                	push   $0x2a
  802709:	e8 ca fa ff ff       	call   8021d8 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
	return;
  802711:	90                   	nop
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 2b                	push   $0x2b
  802723:	e8 b0 fa ff ff       	call   8021d8 <syscall>
  802728:	83 c4 18             	add    $0x18,%esp
}
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	ff 75 0c             	pushl  0xc(%ebp)
  802739:	ff 75 08             	pushl  0x8(%ebp)
  80273c:	6a 2d                	push   $0x2d
  80273e:	e8 95 fa ff ff       	call   8021d8 <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
	return;
  802746:	90                   	nop
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	ff 75 0c             	pushl  0xc(%ebp)
  802755:	ff 75 08             	pushl  0x8(%ebp)
  802758:	6a 2c                	push   $0x2c
  80275a:	e8 79 fa ff ff       	call   8021d8 <syscall>
  80275f:	83 c4 18             	add    $0x18,%esp
	return ;
  802762:	90                   	nop
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	52                   	push   %edx
  802775:	50                   	push   %eax
  802776:	6a 2e                	push   $0x2e
  802778:	e8 5b fa ff ff       	call   8021d8 <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
	return ;
  802780:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802789:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802790:	72 09                	jb     80279b <to_page_va+0x18>
  802792:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802799:	72 14                	jb     8027af <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 c0 43 80 00       	push   $0x8043c0
  8027a3:	6a 15                	push   $0x15
  8027a5:	68 eb 43 80 00       	push   $0x8043eb
  8027aa:	e8 4e db ff ff       	call   8002fd <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	ba 60 50 80 00       	mov    $0x805060,%edx
  8027b7:	29 d0                	sub    %edx,%eax
  8027b9:	c1 f8 02             	sar    $0x2,%eax
  8027bc:	89 c2                	mov    %eax,%edx
  8027be:	89 d0                	mov    %edx,%eax
  8027c0:	c1 e0 02             	shl    $0x2,%eax
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	c1 e0 02             	shl    $0x2,%eax
  8027c8:	01 d0                	add    %edx,%eax
  8027ca:	c1 e0 02             	shl    $0x2,%eax
  8027cd:	01 d0                	add    %edx,%eax
  8027cf:	89 c1                	mov    %eax,%ecx
  8027d1:	c1 e1 08             	shl    $0x8,%ecx
  8027d4:	01 c8                	add    %ecx,%eax
  8027d6:	89 c1                	mov    %eax,%ecx
  8027d8:	c1 e1 10             	shl    $0x10,%ecx
  8027db:	01 c8                	add    %ecx,%eax
  8027dd:	01 c0                	add    %eax,%eax
  8027df:	01 d0                	add    %edx,%eax
  8027e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	c1 e0 0c             	shl    $0xc,%eax
  8027ea:	89 c2                	mov    %eax,%edx
  8027ec:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027f1:	01 d0                	add    %edx,%eax
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8027fb:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802800:	8b 55 08             	mov    0x8(%ebp),%edx
  802803:	29 c2                	sub    %eax,%edx
  802805:	89 d0                	mov    %edx,%eax
  802807:	c1 e8 0c             	shr    $0xc,%eax
  80280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	78 09                	js     80281c <to_page_info+0x27>
  802813:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80281a:	7e 14                	jle    802830 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80281c:	83 ec 04             	sub    $0x4,%esp
  80281f:	68 04 44 80 00       	push   $0x804404
  802824:	6a 22                	push   $0x22
  802826:	68 eb 43 80 00       	push   $0x8043eb
  80282b:	e8 cd da ff ff       	call   8002fd <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802833:	89 d0                	mov    %edx,%eax
  802835:	01 c0                	add    %eax,%eax
  802837:	01 d0                	add    %edx,%eax
  802839:	c1 e0 02             	shl    $0x2,%eax
  80283c:	05 60 50 80 00       	add    $0x805060,%eax
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	05 00 00 00 02       	add    $0x2000000,%eax
  802851:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802854:	73 16                	jae    80286c <initialize_dynamic_allocator+0x29>
  802856:	68 28 44 80 00       	push   $0x804428
  80285b:	68 4e 44 80 00       	push   $0x80444e
  802860:	6a 34                	push   $0x34
  802862:	68 eb 43 80 00       	push   $0x8043eb
  802867:	e8 91 da ff ff       	call   8002fd <_panic>
		is_initialized = 1;
  80286c:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802873:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  80287e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802881:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802886:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80288d:	00 00 00 
  802890:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802897:	00 00 00 
  80289a:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8028a1:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8028a4:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8028ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028b2:	eb 36                	jmp    8028ea <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	c1 e0 04             	shl    $0x4,%eax
  8028ba:	05 80 d0 81 00       	add    $0x81d080,%eax
  8028bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	c1 e0 04             	shl    $0x4,%eax
  8028cb:	05 84 d0 81 00       	add    $0x81d084,%eax
  8028d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	c1 e0 04             	shl    $0x4,%eax
  8028dc:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8028e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8028e7:	ff 45 f4             	incl   -0xc(%ebp)
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028f0:	72 c2                	jb     8028b4 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8028f2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028f8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028fd:	29 c2                	sub    %eax,%edx
  8028ff:	89 d0                	mov    %edx,%eax
  802901:	c1 e8 0c             	shr    $0xc,%eax
  802904:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802907:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80290e:	e9 c8 00 00 00       	jmp    8029db <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802913:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802916:	89 d0                	mov    %edx,%eax
  802918:	01 c0                	add    %eax,%eax
  80291a:	01 d0                	add    %edx,%eax
  80291c:	c1 e0 02             	shl    $0x2,%eax
  80291f:	05 68 50 80 00       	add    $0x805068,%eax
  802924:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802929:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292c:	89 d0                	mov    %edx,%eax
  80292e:	01 c0                	add    %eax,%eax
  802930:	01 d0                	add    %edx,%eax
  802932:	c1 e0 02             	shl    $0x2,%eax
  802935:	05 6a 50 80 00       	add    $0x80506a,%eax
  80293a:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80293f:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802945:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802948:	89 c8                	mov    %ecx,%eax
  80294a:	01 c0                	add    %eax,%eax
  80294c:	01 c8                	add    %ecx,%eax
  80294e:	c1 e0 02             	shl    $0x2,%eax
  802951:	05 64 50 80 00       	add    $0x805064,%eax
  802956:	89 10                	mov    %edx,(%eax)
  802958:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295b:	89 d0                	mov    %edx,%eax
  80295d:	01 c0                	add    %eax,%eax
  80295f:	01 d0                	add    %edx,%eax
  802961:	c1 e0 02             	shl    $0x2,%eax
  802964:	05 64 50 80 00       	add    $0x805064,%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	74 1b                	je     80298a <initialize_dynamic_allocator+0x147>
  80296f:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802975:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802978:	89 c8                	mov    %ecx,%eax
  80297a:	01 c0                	add    %eax,%eax
  80297c:	01 c8                	add    %ecx,%eax
  80297e:	c1 e0 02             	shl    $0x2,%eax
  802981:	05 60 50 80 00       	add    $0x805060,%eax
  802986:	89 02                	mov    %eax,(%edx)
  802988:	eb 16                	jmp    8029a0 <initialize_dynamic_allocator+0x15d>
  80298a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298d:	89 d0                	mov    %edx,%eax
  80298f:	01 c0                	add    %eax,%eax
  802991:	01 d0                	add    %edx,%eax
  802993:	c1 e0 02             	shl    $0x2,%eax
  802996:	05 60 50 80 00       	add    $0x805060,%eax
  80299b:	a3 48 50 80 00       	mov    %eax,0x805048
  8029a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a3:	89 d0                	mov    %edx,%eax
  8029a5:	01 c0                	add    %eax,%eax
  8029a7:	01 d0                	add    %edx,%eax
  8029a9:	c1 e0 02             	shl    $0x2,%eax
  8029ac:	05 60 50 80 00       	add    $0x805060,%eax
  8029b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b9:	89 d0                	mov    %edx,%eax
  8029bb:	01 c0                	add    %eax,%eax
  8029bd:	01 d0                	add    %edx,%eax
  8029bf:	c1 e0 02             	shl    $0x2,%eax
  8029c2:	05 60 50 80 00       	add    $0x805060,%eax
  8029c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cd:	a1 54 50 80 00       	mov    0x805054,%eax
  8029d2:	40                   	inc    %eax
  8029d3:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8029d8:	ff 45 f0             	incl   -0x10(%ebp)
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029e1:	0f 82 2c ff ff ff    	jb     802913 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8029e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029ed:	eb 2f                	jmp    802a1e <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8029ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f2:	89 d0                	mov    %edx,%eax
  8029f4:	01 c0                	add    %eax,%eax
  8029f6:	01 d0                	add    %edx,%eax
  8029f8:	c1 e0 02             	shl    $0x2,%eax
  8029fb:	05 68 50 80 00       	add    $0x805068,%eax
  802a00:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a08:	89 d0                	mov    %edx,%eax
  802a0a:	01 c0                	add    %eax,%eax
  802a0c:	01 d0                	add    %edx,%eax
  802a0e:	c1 e0 02             	shl    $0x2,%eax
  802a11:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a16:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a1b:	ff 45 ec             	incl   -0x14(%ebp)
  802a1e:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802a25:	76 c8                	jbe    8029ef <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802a27:	90                   	nop
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802a30:	8b 55 08             	mov    0x8(%ebp),%edx
  802a33:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a38:	29 c2                	sub    %eax,%edx
  802a3a:	89 d0                	mov    %edx,%eax
  802a3c:	c1 e8 0c             	shr    $0xc,%eax
  802a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802a42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a45:	89 d0                	mov    %edx,%eax
  802a47:	01 c0                	add    %eax,%eax
  802a49:	01 d0                	add    %edx,%eax
  802a4b:	c1 e0 02             	shl    $0x2,%eax
  802a4e:	05 68 50 80 00       	add    $0x805068,%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
  802a5d:	83 ec 14             	sub    $0x14,%esp
  802a60:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802a63:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802a67:	77 07                	ja     802a70 <nearest_pow2_ceil.1513+0x16>
  802a69:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6e:	eb 20                	jmp    802a90 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802a70:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802a77:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802a7a:	eb 08                	jmp    802a84 <nearest_pow2_ceil.1513+0x2a>
  802a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a7f:	01 c0                	add    %eax,%eax
  802a81:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a84:	d1 6d 08             	shrl   0x8(%ebp)
  802a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8b:	75 ef                	jne    802a7c <nearest_pow2_ceil.1513+0x22>
        return power;
  802a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802a90:	c9                   	leave  
  802a91:	c3                   	ret    

00802a92 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
  802a95:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802a98:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802a9f:	76 16                	jbe    802ab7 <alloc_block+0x25>
  802aa1:	68 64 44 80 00       	push   $0x804464
  802aa6:	68 4e 44 80 00       	push   $0x80444e
  802aab:	6a 72                	push   $0x72
  802aad:	68 eb 43 80 00       	push   $0x8043eb
  802ab2:	e8 46 d8 ff ff       	call   8002fd <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802ab7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802abb:	75 0a                	jne    802ac7 <alloc_block+0x35>
  802abd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac2:	e9 bd 04 00 00       	jmp    802f84 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802ac7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ad4:	73 06                	jae    802adc <alloc_block+0x4a>
        size = min_block_size;
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802adc:	83 ec 0c             	sub    $0xc,%esp
  802adf:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802ae2:	ff 75 08             	pushl  0x8(%ebp)
  802ae5:	89 c1                	mov    %eax,%ecx
  802ae7:	e8 6e ff ff ff       	call   802a5a <nearest_pow2_ceil.1513>
  802aec:	83 c4 10             	add    $0x10,%esp
  802aef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802af2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af5:	83 ec 0c             	sub    $0xc,%esp
  802af8:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802afb:	52                   	push   %edx
  802afc:	89 c1                	mov    %eax,%ecx
  802afe:	e8 83 04 00 00       	call   802f86 <log2_ceil.1520>
  802b03:	83 c4 10             	add    $0x10,%esp
  802b06:	83 e8 03             	sub    $0x3,%eax
  802b09:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0f:	c1 e0 04             	shl    $0x4,%eax
  802b12:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	0f 84 d8 00 00 00    	je     802bf9 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b24:	c1 e0 04             	shl    $0x4,%eax
  802b27:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b35:	75 17                	jne    802b4e <alloc_block+0xbc>
  802b37:	83 ec 04             	sub    $0x4,%esp
  802b3a:	68 85 44 80 00       	push   $0x804485
  802b3f:	68 98 00 00 00       	push   $0x98
  802b44:	68 eb 43 80 00       	push   $0x8043eb
  802b49:	e8 af d7 ff ff       	call   8002fd <_panic>
  802b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	74 10                	je     802b67 <alloc_block+0xd5>
  802b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b5f:	8b 52 04             	mov    0x4(%edx),%edx
  802b62:	89 50 04             	mov    %edx,0x4(%eax)
  802b65:	eb 14                	jmp    802b7b <alloc_block+0xe9>
  802b67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6a:	8b 40 04             	mov    0x4(%eax),%eax
  802b6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b70:	c1 e2 04             	shl    $0x4,%edx
  802b73:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802b79:	89 02                	mov    %eax,(%edx)
  802b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 0f                	je     802b94 <alloc_block+0x102>
  802b85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b88:	8b 40 04             	mov    0x4(%eax),%eax
  802b8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b8e:	8b 12                	mov    (%edx),%edx
  802b90:	89 10                	mov    %edx,(%eax)
  802b92:	eb 13                	jmp    802ba7 <alloc_block+0x115>
  802b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b9c:	c1 e2 04             	shl    $0x4,%edx
  802b9f:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ba5:	89 02                	mov    %eax,(%edx)
  802ba7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbd:	c1 e0 04             	shl    $0x4,%eax
  802bc0:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  802bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcd:	c1 e0 04             	shl    $0x4,%eax
  802bd0:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bd5:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bda:	83 ec 0c             	sub    $0xc,%esp
  802bdd:	50                   	push   %eax
  802bde:	e8 12 fc ff ff       	call   8027f5 <to_page_info>
  802be3:	83 c4 10             	add    $0x10,%esp
  802be6:	89 c2                	mov    %eax,%edx
  802be8:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802bec:	48                   	dec    %eax
  802bed:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf4:	e9 8b 03 00 00       	jmp    802f84 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802bf9:	a1 48 50 80 00       	mov    0x805048,%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	0f 84 64 02 00 00    	je     802e6a <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802c06:	a1 48 50 80 00       	mov    0x805048,%eax
  802c0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c12:	75 17                	jne    802c2b <alloc_block+0x199>
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	68 85 44 80 00       	push   $0x804485
  802c1c:	68 a0 00 00 00       	push   $0xa0
  802c21:	68 eb 43 80 00       	push   $0x8043eb
  802c26:	e8 d2 d6 ff ff       	call   8002fd <_panic>
  802c2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 10                	je     802c44 <alloc_block+0x1b2>
  802c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c3c:	8b 52 04             	mov    0x4(%edx),%edx
  802c3f:	89 50 04             	mov    %edx,0x4(%eax)
  802c42:	eb 0b                	jmp    802c4f <alloc_block+0x1bd>
  802c44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 0f                	je     802c68 <alloc_block+0x1d6>
  802c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c62:	8b 12                	mov    (%edx),%edx
  802c64:	89 10                	mov    %edx,(%eax)
  802c66:	eb 0a                	jmp    802c72 <alloc_block+0x1e0>
  802c68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c6b:	8b 00                	mov    (%eax),%eax
  802c6d:	a3 48 50 80 00       	mov    %eax,0x805048
  802c72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c85:	a1 54 50 80 00       	mov    0x805054,%eax
  802c8a:	48                   	dec    %eax
  802c8b:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c96:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802c9a:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c9f:	99                   	cltd   
  802ca0:	f7 7d e8             	idivl  -0x18(%ebp)
  802ca3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ca6:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802caa:	83 ec 0c             	sub    $0xc,%esp
  802cad:	ff 75 dc             	pushl  -0x24(%ebp)
  802cb0:	e8 ce fa ff ff       	call   802783 <to_page_va>
  802cb5:	83 c4 10             	add    $0x10,%esp
  802cb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802cbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cbe:	83 ec 0c             	sub    $0xc,%esp
  802cc1:	50                   	push   %eax
  802cc2:	e8 c0 ee ff ff       	call   801b87 <get_page>
  802cc7:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cd1:	e9 aa 00 00 00       	jmp    802d80 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802cdd:	89 c2                	mov    %eax,%edx
  802cdf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802ce7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ceb:	75 17                	jne    802d04 <alloc_block+0x272>
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	68 a4 44 80 00       	push   $0x8044a4
  802cf5:	68 aa 00 00 00       	push   $0xaa
  802cfa:	68 eb 43 80 00       	push   $0x8043eb
  802cff:	e8 f9 d5 ff ff       	call   8002fd <_panic>
  802d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d07:	c1 e0 04             	shl    $0x4,%eax
  802d0a:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d0f:	8b 10                	mov    (%eax),%edx
  802d11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	74 14                	je     802d35 <alloc_block+0x2a3>
  802d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d24:	c1 e0 04             	shl    $0x4,%eax
  802d27:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	eb 11                	jmp    802d46 <alloc_block+0x2b4>
  802d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d38:	c1 e0 04             	shl    $0x4,%eax
  802d3b:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802d41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d44:	89 02                	mov    %eax,(%edx)
  802d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d49:	c1 e0 04             	shl    $0x4,%eax
  802d4c:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d55:	89 02                	mov    %eax,(%edx)
  802d57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d63:	c1 e0 04             	shl    $0x4,%eax
  802d66:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	8d 50 01             	lea    0x1(%eax),%edx
  802d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d73:	c1 e0 04             	shl    $0x4,%eax
  802d76:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d7b:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d7d:	ff 45 f4             	incl   -0xc(%ebp)
  802d80:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d85:	99                   	cltd   
  802d86:	f7 7d e8             	idivl  -0x18(%ebp)
  802d89:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d8c:	0f 8f 44 ff ff ff    	jg     802cd6 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d95:	c1 e0 04             	shl    $0x4,%eax
  802d98:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802da2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802da6:	75 17                	jne    802dbf <alloc_block+0x32d>
  802da8:	83 ec 04             	sub    $0x4,%esp
  802dab:	68 85 44 80 00       	push   $0x804485
  802db0:	68 ae 00 00 00       	push   $0xae
  802db5:	68 eb 43 80 00       	push   $0x8043eb
  802dba:	e8 3e d5 ff ff       	call   8002fd <_panic>
  802dbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 10                	je     802dd8 <alloc_block+0x346>
  802dc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dd0:	8b 52 04             	mov    0x4(%edx),%edx
  802dd3:	89 50 04             	mov    %edx,0x4(%eax)
  802dd6:	eb 14                	jmp    802dec <alloc_block+0x35a>
  802dd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ddb:	8b 40 04             	mov    0x4(%eax),%eax
  802dde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802de1:	c1 e2 04             	shl    $0x4,%edx
  802de4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802dea:	89 02                	mov    %eax,(%edx)
  802dec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	85 c0                	test   %eax,%eax
  802df4:	74 0f                	je     802e05 <alloc_block+0x373>
  802df6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dff:	8b 12                	mov    (%edx),%edx
  802e01:	89 10                	mov    %edx,(%eax)
  802e03:	eb 13                	jmp    802e18 <alloc_block+0x386>
  802e05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e08:	8b 00                	mov    (%eax),%eax
  802e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e0d:	c1 e2 04             	shl    $0x4,%edx
  802e10:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e16:	89 02                	mov    %eax,(%edx)
  802e18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2e:	c1 e0 04             	shl    $0x4,%eax
  802e31:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3e:	c1 e0 04             	shl    $0x4,%eax
  802e41:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e46:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	50                   	push   %eax
  802e4f:	e8 a1 f9 ff ff       	call   8027f5 <to_page_info>
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	89 c2                	mov    %eax,%edx
  802e59:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e5d:	48                   	dec    %eax
  802e5e:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802e62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e65:	e9 1a 01 00 00       	jmp    802f84 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6d:	40                   	inc    %eax
  802e6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e71:	e9 ed 00 00 00       	jmp    802f63 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	c1 e0 04             	shl    $0x4,%eax
  802e7c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	0f 84 d5 00 00 00    	je     802f60 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	c1 e0 04             	shl    $0x4,%eax
  802e91:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802e9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e9f:	75 17                	jne    802eb8 <alloc_block+0x426>
  802ea1:	83 ec 04             	sub    $0x4,%esp
  802ea4:	68 85 44 80 00       	push   $0x804485
  802ea9:	68 b8 00 00 00       	push   $0xb8
  802eae:	68 eb 43 80 00       	push   $0x8043eb
  802eb3:	e8 45 d4 ff ff       	call   8002fd <_panic>
  802eb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 10                	je     802ed1 <alloc_block+0x43f>
  802ec1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ec9:	8b 52 04             	mov    0x4(%edx),%edx
  802ecc:	89 50 04             	mov    %edx,0x4(%eax)
  802ecf:	eb 14                	jmp    802ee5 <alloc_block+0x453>
  802ed1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eda:	c1 e2 04             	shl    $0x4,%edx
  802edd:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ee3:	89 02                	mov    %eax,(%edx)
  802ee5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee8:	8b 40 04             	mov    0x4(%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0f                	je     802efe <alloc_block+0x46c>
  802eef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ef8:	8b 12                	mov    (%edx),%edx
  802efa:	89 10                	mov    %edx,(%eax)
  802efc:	eb 13                	jmp    802f11 <alloc_block+0x47f>
  802efe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f06:	c1 e2 04             	shl    $0x4,%edx
  802f09:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f0f:	89 02                	mov    %eax,(%edx)
  802f11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	c1 e0 04             	shl    $0x4,%eax
  802f2a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f37:	c1 e0 04             	shl    $0x4,%eax
  802f3a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f3f:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802f41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f44:	83 ec 0c             	sub    $0xc,%esp
  802f47:	50                   	push   %eax
  802f48:	e8 a8 f8 ff ff       	call   8027f5 <to_page_info>
  802f4d:	83 c4 10             	add    $0x10,%esp
  802f50:	89 c2                	mov    %eax,%edx
  802f52:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f56:	48                   	dec    %eax
  802f57:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802f5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5e:	eb 24                	jmp    802f84 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f60:	ff 45 f0             	incl   -0x10(%ebp)
  802f63:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802f67:	0f 8e 09 ff ff ff    	jle    802e76 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 c7 44 80 00       	push   $0x8044c7
  802f75:	68 bf 00 00 00       	push   $0xbf
  802f7a:	68 eb 43 80 00       	push   $0x8043eb
  802f7f:	e8 79 d3 ff ff       	call   8002fd <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802f84:	c9                   	leave  
  802f85:	c3                   	ret    

00802f86 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802f86:	55                   	push   %ebp
  802f87:	89 e5                	mov    %esp,%ebp
  802f89:	83 ec 14             	sub    $0x14,%esp
  802f8c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802f8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f93:	75 07                	jne    802f9c <log2_ceil.1520+0x16>
  802f95:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9a:	eb 1b                	jmp    802fb7 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802f9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802fa3:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802fa6:	eb 06                	jmp    802fae <log2_ceil.1520+0x28>
            x >>= 1;
  802fa8:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802fab:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802fae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb2:	75 f4                	jne    802fa8 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802fb7:	c9                   	leave  
  802fb8:	c3                   	ret    

00802fb9 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
  802fbc:	83 ec 14             	sub    $0x14,%esp
  802fbf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802fc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc6:	75 07                	jne    802fcf <log2_ceil.1547+0x16>
  802fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcd:	eb 1b                	jmp    802fea <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802fd6:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802fd9:	eb 06                	jmp    802fe1 <log2_ceil.1547+0x28>
			x >>= 1;
  802fdb:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802fde:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802fe1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe5:	75 f4                	jne    802fdb <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802fea:	c9                   	leave  
  802feb:	c3                   	ret    

00802fec <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802fec:	55                   	push   %ebp
  802fed:	89 e5                	mov    %esp,%ebp
  802fef:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802ffa:	39 c2                	cmp    %eax,%edx
  802ffc:	72 0c                	jb     80300a <free_block+0x1e>
  802ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  803001:	a1 40 50 80 00       	mov    0x805040,%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	72 19                	jb     803023 <free_block+0x37>
  80300a:	68 cc 44 80 00       	push   $0x8044cc
  80300f:	68 4e 44 80 00       	push   $0x80444e
  803014:	68 d0 00 00 00       	push   $0xd0
  803019:	68 eb 43 80 00       	push   $0x8043eb
  80301e:	e8 da d2 ff ff       	call   8002fd <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803023:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803027:	0f 84 42 03 00 00    	je     80336f <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80302d:	8b 55 08             	mov    0x8(%ebp),%edx
  803030:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803035:	39 c2                	cmp    %eax,%edx
  803037:	72 0c                	jb     803045 <free_block+0x59>
  803039:	8b 55 08             	mov    0x8(%ebp),%edx
  80303c:	a1 40 50 80 00       	mov    0x805040,%eax
  803041:	39 c2                	cmp    %eax,%edx
  803043:	72 17                	jb     80305c <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803045:	83 ec 04             	sub    $0x4,%esp
  803048:	68 04 45 80 00       	push   $0x804504
  80304d:	68 e6 00 00 00       	push   $0xe6
  803052:	68 eb 43 80 00       	push   $0x8043eb
  803057:	e8 a1 d2 ff ff       	call   8002fd <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80305c:	8b 55 08             	mov    0x8(%ebp),%edx
  80305f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803064:	29 c2                	sub    %eax,%edx
  803066:	89 d0                	mov    %edx,%eax
  803068:	83 e0 07             	and    $0x7,%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	74 17                	je     803086 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80306f:	83 ec 04             	sub    $0x4,%esp
  803072:	68 38 45 80 00       	push   $0x804538
  803077:	68 ea 00 00 00       	push   $0xea
  80307c:	68 eb 43 80 00       	push   $0x8043eb
  803081:	e8 77 d2 ff ff       	call   8002fd <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	83 ec 0c             	sub    $0xc,%esp
  80308c:	50                   	push   %eax
  80308d:	e8 63 f7 ff ff       	call   8027f5 <to_page_info>
  803092:	83 c4 10             	add    $0x10,%esp
  803095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803098:	83 ec 0c             	sub    $0xc,%esp
  80309b:	ff 75 08             	pushl  0x8(%ebp)
  80309e:	e8 87 f9 ff ff       	call   802a2a <get_block_size>
  8030a3:	83 c4 10             	add    $0x10,%esp
  8030a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8030a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ad:	75 17                	jne    8030c6 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 64 45 80 00       	push   $0x804564
  8030b7:	68 f1 00 00 00       	push   $0xf1
  8030bc:	68 eb 43 80 00       	push   $0x8043eb
  8030c1:	e8 37 d2 ff ff       	call   8002fd <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8030c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c9:	83 ec 0c             	sub    $0xc,%esp
  8030cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8030cf:	52                   	push   %edx
  8030d0:	89 c1                	mov    %eax,%ecx
  8030d2:	e8 e2 fe ff ff       	call   802fb9 <log2_ceil.1547>
  8030d7:	83 c4 10             	add    $0x10,%esp
  8030da:	83 e8 03             	sub    $0x3,%eax
  8030dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8030e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030ea:	75 17                	jne    803103 <free_block+0x117>
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 b0 45 80 00       	push   $0x8045b0
  8030f4:	68 f6 00 00 00       	push   $0xf6
  8030f9:	68 eb 43 80 00       	push   $0x8043eb
  8030fe:	e8 fa d1 ff ff       	call   8002fd <_panic>
  803103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803106:	c1 e0 04             	shl    $0x4,%eax
  803109:	05 80 d0 81 00       	add    $0x81d080,%eax
  80310e:	8b 10                	mov    (%eax),%edx
  803110:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803113:	89 10                	mov    %edx,(%eax)
  803115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 15                	je     803133 <free_block+0x147>
  80311e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803121:	c1 e0 04             	shl    $0x4,%eax
  803124:	05 80 d0 81 00       	add    $0x81d080,%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	eb 11                	jmp    803144 <free_block+0x158>
  803133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803136:	c1 e0 04             	shl    $0x4,%eax
  803139:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80313f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803142:	89 02                	mov    %eax,(%edx)
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	c1 e0 04             	shl    $0x4,%eax
  80314a:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803150:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803153:	89 02                	mov    %eax,(%edx)
  803155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803158:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803162:	c1 e0 04             	shl    $0x4,%eax
  803165:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	8d 50 01             	lea    0x1(%eax),%edx
  80316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803172:	c1 e0 04             	shl    $0x4,%eax
  803175:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80317a:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80317c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803183:	40                   	inc    %eax
  803184:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803187:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80318b:	8b 55 08             	mov    0x8(%ebp),%edx
  80318e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803193:	29 c2                	sub    %eax,%edx
  803195:	89 d0                	mov    %edx,%eax
  803197:	c1 e8 0c             	shr    $0xc,%eax
  80319a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80319d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8031a4:	0f b7 c8             	movzwl %ax,%ecx
  8031a7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031ac:	99                   	cltd   
  8031ad:	f7 7d e8             	idivl  -0x18(%ebp)
  8031b0:	39 c1                	cmp    %eax,%ecx
  8031b2:	0f 85 b8 01 00 00    	jne    803370 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8031b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8031bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c2:	c1 e0 04             	shl    $0x4,%eax
  8031c5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8031cf:	e9 d5 00 00 00       	jmp    8032a9 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8031dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031df:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031e4:	29 c2                	sub    %eax,%edx
  8031e6:	89 d0                	mov    %edx,%eax
  8031e8:	c1 e8 0c             	shr    $0xc,%eax
  8031eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8031ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8031f4:	0f 85 a9 00 00 00    	jne    8032a3 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8031fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031fe:	75 17                	jne    803217 <free_block+0x22b>
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	68 85 44 80 00       	push   $0x804485
  803208:	68 04 01 00 00       	push   $0x104
  80320d:	68 eb 43 80 00       	push   $0x8043eb
  803212:	e8 e6 d0 ff ff       	call   8002fd <_panic>
  803217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	74 10                	je     803230 <free_block+0x244>
  803220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803228:	8b 52 04             	mov    0x4(%edx),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	eb 14                	jmp    803244 <free_block+0x258>
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	8b 40 04             	mov    0x4(%eax),%eax
  803236:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803239:	c1 e2 04             	shl    $0x4,%edx
  80323c:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803242:	89 02                	mov    %eax,(%edx)
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	8b 40 04             	mov    0x4(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0f                	je     80325d <free_block+0x271>
  80324e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803251:	8b 40 04             	mov    0x4(%eax),%eax
  803254:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803257:	8b 12                	mov    (%edx),%edx
  803259:	89 10                	mov    %edx,(%eax)
  80325b:	eb 13                	jmp    803270 <free_block+0x284>
  80325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803265:	c1 e2 04             	shl    $0x4,%edx
  803268:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80326e:	89 02                	mov    %eax,(%edx)
  803270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803273:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803286:	c1 e0 04             	shl    $0x4,%eax
  803289:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	8d 50 ff             	lea    -0x1(%eax),%edx
  803293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803296:	c1 e0 04             	shl    $0x4,%eax
  803299:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80329e:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8032a0:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8032a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8032a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ad:	0f 85 21 ff ff ff    	jne    8031d4 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8032b3:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032b8:	99                   	cltd   
  8032b9:	f7 7d e8             	idivl  -0x18(%ebp)
  8032bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032bf:	74 17                	je     8032d8 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8032c1:	83 ec 04             	sub    $0x4,%esp
  8032c4:	68 d4 45 80 00       	push   $0x8045d4
  8032c9:	68 0c 01 00 00       	push   $0x10c
  8032ce:	68 eb 43 80 00       	push   $0x8043eb
  8032d3:	e8 25 d0 ff ff       	call   8002fd <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032db:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8032e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e4:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ee:	75 17                	jne    803307 <free_block+0x31b>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 a4 44 80 00       	push   $0x8044a4
  8032f8:	68 11 01 00 00       	push   $0x111
  8032fd:	68 eb 43 80 00       	push   $0x8043eb
  803302:	e8 f6 cf ff ff       	call   8002fd <_panic>
  803307:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80330d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803310:	89 50 04             	mov    %edx,0x4(%eax)
  803313:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803316:	8b 40 04             	mov    0x4(%eax),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	74 0c                	je     803329 <free_block+0x33d>
  80331d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803322:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803325:	89 10                	mov    %edx,(%eax)
  803327:	eb 08                	jmp    803331 <free_block+0x345>
  803329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332c:	a3 48 50 80 00       	mov    %eax,0x805048
  803331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803334:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803342:	a1 54 50 80 00       	mov    0x805054,%eax
  803347:	40                   	inc    %eax
  803348:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80334d:	83 ec 0c             	sub    $0xc,%esp
  803350:	ff 75 ec             	pushl  -0x14(%ebp)
  803353:	e8 2b f4 ff ff       	call   802783 <to_page_va>
  803358:	83 c4 10             	add    $0x10,%esp
  80335b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80335e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803361:	83 ec 0c             	sub    $0xc,%esp
  803364:	50                   	push   %eax
  803365:	e8 69 e8 ff ff       	call   801bd3 <return_page>
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	eb 01                	jmp    803370 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80336f:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803370:	c9                   	leave  
  803371:	c3                   	ret    

00803372 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803372:	55                   	push   %ebp
  803373:	89 e5                	mov    %esp,%ebp
  803375:	83 ec 14             	sub    $0x14,%esp
  803378:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  80337b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80337f:	77 07                	ja     803388 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803381:	b8 01 00 00 00       	mov    $0x1,%eax
  803386:	eb 20                	jmp    8033a8 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803388:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80338f:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803392:	eb 08                	jmp    80339c <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803397:	01 c0                	add    %eax,%eax
  803399:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80339c:	d1 6d 08             	shrl   0x8(%ebp)
  80339f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a3:	75 ef                	jne    803394 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8033a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8033a8:	c9                   	leave  
  8033a9:	c3                   	ret    

008033aa <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8033aa:	55                   	push   %ebp
  8033ab:	89 e5                	mov    %esp,%ebp
  8033ad:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8033b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b4:	75 13                	jne    8033c9 <realloc_block+0x1f>
    return alloc_block(new_size);
  8033b6:	83 ec 0c             	sub    $0xc,%esp
  8033b9:	ff 75 0c             	pushl  0xc(%ebp)
  8033bc:	e8 d1 f6 ff ff       	call   802a92 <alloc_block>
  8033c1:	83 c4 10             	add    $0x10,%esp
  8033c4:	e9 d9 00 00 00       	jmp    8034a2 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8033c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033cd:	75 18                	jne    8033e7 <realloc_block+0x3d>
    free_block(va);
  8033cf:	83 ec 0c             	sub    $0xc,%esp
  8033d2:	ff 75 08             	pushl  0x8(%ebp)
  8033d5:	e8 12 fc ff ff       	call   802fec <free_block>
  8033da:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8033dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e2:	e9 bb 00 00 00       	jmp    8034a2 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 08             	pushl  0x8(%ebp)
  8033ed:	e8 38 f6 ff ff       	call   802a2a <get_block_size>
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8033f8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803405:	73 06                	jae    80340d <realloc_block+0x63>
    new_size = min_block_size;
  803407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340a:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80340d:	83 ec 0c             	sub    $0xc,%esp
  803410:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803413:	ff 75 0c             	pushl  0xc(%ebp)
  803416:	89 c1                	mov    %eax,%ecx
  803418:	e8 55 ff ff ff       	call   803372 <nearest_pow2_ceil.1572>
  80341d:	83 c4 10             	add    $0x10,%esp
  803420:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803429:	75 05                	jne    803430 <realloc_block+0x86>
    return va;
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	eb 72                	jmp    8034a2 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803430:	83 ec 0c             	sub    $0xc,%esp
  803433:	ff 75 0c             	pushl  0xc(%ebp)
  803436:	e8 57 f6 ff ff       	call   802a92 <alloc_block>
  80343b:	83 c4 10             	add    $0x10,%esp
  80343e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803441:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803445:	75 07                	jne    80344e <realloc_block+0xa4>
    return NULL;
  803447:	b8 00 00 00 00       	mov    $0x0,%eax
  80344c:	eb 54                	jmp    8034a2 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80344e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803451:	8b 45 0c             	mov    0xc(%ebp),%eax
  803454:	39 d0                	cmp    %edx,%eax
  803456:	76 02                	jbe    80345a <realloc_block+0xb0>
  803458:	89 d0                	mov    %edx,%eax
  80345a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803466:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803470:	eb 17                	jmp    803489 <realloc_block+0xdf>
    dst[i] = src[i];
  803472:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	01 c2                	add    %eax,%edx
  80347a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	01 c8                	add    %ecx,%eax
  803482:	8a 00                	mov    (%eax),%al
  803484:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803486:	ff 45 f4             	incl   -0xc(%ebp)
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80348f:	72 e1                	jb     803472 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803491:	83 ec 0c             	sub    $0xc,%esp
  803494:	ff 75 08             	pushl  0x8(%ebp)
  803497:	e8 50 fb ff ff       	call   802fec <free_block>
  80349c:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80349f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8034a2:	c9                   	leave  
  8034a3:	c3                   	ret    

008034a4 <__udivdi3>:
  8034a4:	55                   	push   %ebp
  8034a5:	57                   	push   %edi
  8034a6:	56                   	push   %esi
  8034a7:	53                   	push   %ebx
  8034a8:	83 ec 1c             	sub    $0x1c,%esp
  8034ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034bb:	89 ca                	mov    %ecx,%edx
  8034bd:	89 f8                	mov    %edi,%eax
  8034bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034c3:	85 f6                	test   %esi,%esi
  8034c5:	75 2d                	jne    8034f4 <__udivdi3+0x50>
  8034c7:	39 cf                	cmp    %ecx,%edi
  8034c9:	77 65                	ja     803530 <__udivdi3+0x8c>
  8034cb:	89 fd                	mov    %edi,%ebp
  8034cd:	85 ff                	test   %edi,%edi
  8034cf:	75 0b                	jne    8034dc <__udivdi3+0x38>
  8034d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d6:	31 d2                	xor    %edx,%edx
  8034d8:	f7 f7                	div    %edi
  8034da:	89 c5                	mov    %eax,%ebp
  8034dc:	31 d2                	xor    %edx,%edx
  8034de:	89 c8                	mov    %ecx,%eax
  8034e0:	f7 f5                	div    %ebp
  8034e2:	89 c1                	mov    %eax,%ecx
  8034e4:	89 d8                	mov    %ebx,%eax
  8034e6:	f7 f5                	div    %ebp
  8034e8:	89 cf                	mov    %ecx,%edi
  8034ea:	89 fa                	mov    %edi,%edx
  8034ec:	83 c4 1c             	add    $0x1c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
  8034f4:	39 ce                	cmp    %ecx,%esi
  8034f6:	77 28                	ja     803520 <__udivdi3+0x7c>
  8034f8:	0f bd fe             	bsr    %esi,%edi
  8034fb:	83 f7 1f             	xor    $0x1f,%edi
  8034fe:	75 40                	jne    803540 <__udivdi3+0x9c>
  803500:	39 ce                	cmp    %ecx,%esi
  803502:	72 0a                	jb     80350e <__udivdi3+0x6a>
  803504:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803508:	0f 87 9e 00 00 00    	ja     8035ac <__udivdi3+0x108>
  80350e:	b8 01 00 00 00       	mov    $0x1,%eax
  803513:	89 fa                	mov    %edi,%edx
  803515:	83 c4 1c             	add    $0x1c,%esp
  803518:	5b                   	pop    %ebx
  803519:	5e                   	pop    %esi
  80351a:	5f                   	pop    %edi
  80351b:	5d                   	pop    %ebp
  80351c:	c3                   	ret    
  80351d:	8d 76 00             	lea    0x0(%esi),%esi
  803520:	31 ff                	xor    %edi,%edi
  803522:	31 c0                	xor    %eax,%eax
  803524:	89 fa                	mov    %edi,%edx
  803526:	83 c4 1c             	add    $0x1c,%esp
  803529:	5b                   	pop    %ebx
  80352a:	5e                   	pop    %esi
  80352b:	5f                   	pop    %edi
  80352c:	5d                   	pop    %ebp
  80352d:	c3                   	ret    
  80352e:	66 90                	xchg   %ax,%ax
  803530:	89 d8                	mov    %ebx,%eax
  803532:	f7 f7                	div    %edi
  803534:	31 ff                	xor    %edi,%edi
  803536:	89 fa                	mov    %edi,%edx
  803538:	83 c4 1c             	add    $0x1c,%esp
  80353b:	5b                   	pop    %ebx
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	bd 20 00 00 00       	mov    $0x20,%ebp
  803545:	89 eb                	mov    %ebp,%ebx
  803547:	29 fb                	sub    %edi,%ebx
  803549:	89 f9                	mov    %edi,%ecx
  80354b:	d3 e6                	shl    %cl,%esi
  80354d:	89 c5                	mov    %eax,%ebp
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 ed                	shr    %cl,%ebp
  803553:	89 e9                	mov    %ebp,%ecx
  803555:	09 f1                	or     %esi,%ecx
  803557:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80355b:	89 f9                	mov    %edi,%ecx
  80355d:	d3 e0                	shl    %cl,%eax
  80355f:	89 c5                	mov    %eax,%ebp
  803561:	89 d6                	mov    %edx,%esi
  803563:	88 d9                	mov    %bl,%cl
  803565:	d3 ee                	shr    %cl,%esi
  803567:	89 f9                	mov    %edi,%ecx
  803569:	d3 e2                	shl    %cl,%edx
  80356b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 e8                	shr    %cl,%eax
  803573:	09 c2                	or     %eax,%edx
  803575:	89 d0                	mov    %edx,%eax
  803577:	89 f2                	mov    %esi,%edx
  803579:	f7 74 24 0c          	divl   0xc(%esp)
  80357d:	89 d6                	mov    %edx,%esi
  80357f:	89 c3                	mov    %eax,%ebx
  803581:	f7 e5                	mul    %ebp
  803583:	39 d6                	cmp    %edx,%esi
  803585:	72 19                	jb     8035a0 <__udivdi3+0xfc>
  803587:	74 0b                	je     803594 <__udivdi3+0xf0>
  803589:	89 d8                	mov    %ebx,%eax
  80358b:	31 ff                	xor    %edi,%edi
  80358d:	e9 58 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  803592:	66 90                	xchg   %ax,%ax
  803594:	8b 54 24 08          	mov    0x8(%esp),%edx
  803598:	89 f9                	mov    %edi,%ecx
  80359a:	d3 e2                	shl    %cl,%edx
  80359c:	39 c2                	cmp    %eax,%edx
  80359e:	73 e9                	jae    803589 <__udivdi3+0xe5>
  8035a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035a3:	31 ff                	xor    %edi,%edi
  8035a5:	e9 40 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  8035aa:	66 90                	xchg   %ax,%ax
  8035ac:	31 c0                	xor    %eax,%eax
  8035ae:	e9 37 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  8035b3:	90                   	nop

008035b4 <__umoddi3>:
  8035b4:	55                   	push   %ebp
  8035b5:	57                   	push   %edi
  8035b6:	56                   	push   %esi
  8035b7:	53                   	push   %ebx
  8035b8:	83 ec 1c             	sub    $0x1c,%esp
  8035bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035d3:	89 f3                	mov    %esi,%ebx
  8035d5:	89 fa                	mov    %edi,%edx
  8035d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035db:	89 34 24             	mov    %esi,(%esp)
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	75 1a                	jne    8035fc <__umoddi3+0x48>
  8035e2:	39 f7                	cmp    %esi,%edi
  8035e4:	0f 86 a2 00 00 00    	jbe    80368c <__umoddi3+0xd8>
  8035ea:	89 c8                	mov    %ecx,%eax
  8035ec:	89 f2                	mov    %esi,%edx
  8035ee:	f7 f7                	div    %edi
  8035f0:	89 d0                	mov    %edx,%eax
  8035f2:	31 d2                	xor    %edx,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	39 f0                	cmp    %esi,%eax
  8035fe:	0f 87 ac 00 00 00    	ja     8036b0 <__umoddi3+0xfc>
  803604:	0f bd e8             	bsr    %eax,%ebp
  803607:	83 f5 1f             	xor    $0x1f,%ebp
  80360a:	0f 84 ac 00 00 00    	je     8036bc <__umoddi3+0x108>
  803610:	bf 20 00 00 00       	mov    $0x20,%edi
  803615:	29 ef                	sub    %ebp,%edi
  803617:	89 fe                	mov    %edi,%esi
  803619:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80361d:	89 e9                	mov    %ebp,%ecx
  80361f:	d3 e0                	shl    %cl,%eax
  803621:	89 d7                	mov    %edx,%edi
  803623:	89 f1                	mov    %esi,%ecx
  803625:	d3 ef                	shr    %cl,%edi
  803627:	09 c7                	or     %eax,%edi
  803629:	89 e9                	mov    %ebp,%ecx
  80362b:	d3 e2                	shl    %cl,%edx
  80362d:	89 14 24             	mov    %edx,(%esp)
  803630:	89 d8                	mov    %ebx,%eax
  803632:	d3 e0                	shl    %cl,%eax
  803634:	89 c2                	mov    %eax,%edx
  803636:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363a:	d3 e0                	shl    %cl,%eax
  80363c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803640:	8b 44 24 08          	mov    0x8(%esp),%eax
  803644:	89 f1                	mov    %esi,%ecx
  803646:	d3 e8                	shr    %cl,%eax
  803648:	09 d0                	or     %edx,%eax
  80364a:	d3 eb                	shr    %cl,%ebx
  80364c:	89 da                	mov    %ebx,%edx
  80364e:	f7 f7                	div    %edi
  803650:	89 d3                	mov    %edx,%ebx
  803652:	f7 24 24             	mull   (%esp)
  803655:	89 c6                	mov    %eax,%esi
  803657:	89 d1                	mov    %edx,%ecx
  803659:	39 d3                	cmp    %edx,%ebx
  80365b:	0f 82 87 00 00 00    	jb     8036e8 <__umoddi3+0x134>
  803661:	0f 84 91 00 00 00    	je     8036f8 <__umoddi3+0x144>
  803667:	8b 54 24 04          	mov    0x4(%esp),%edx
  80366b:	29 f2                	sub    %esi,%edx
  80366d:	19 cb                	sbb    %ecx,%ebx
  80366f:	89 d8                	mov    %ebx,%eax
  803671:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803675:	d3 e0                	shl    %cl,%eax
  803677:	89 e9                	mov    %ebp,%ecx
  803679:	d3 ea                	shr    %cl,%edx
  80367b:	09 d0                	or     %edx,%eax
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 eb                	shr    %cl,%ebx
  803681:	89 da                	mov    %ebx,%edx
  803683:	83 c4 1c             	add    $0x1c,%esp
  803686:	5b                   	pop    %ebx
  803687:	5e                   	pop    %esi
  803688:	5f                   	pop    %edi
  803689:	5d                   	pop    %ebp
  80368a:	c3                   	ret    
  80368b:	90                   	nop
  80368c:	89 fd                	mov    %edi,%ebp
  80368e:	85 ff                	test   %edi,%edi
  803690:	75 0b                	jne    80369d <__umoddi3+0xe9>
  803692:	b8 01 00 00 00       	mov    $0x1,%eax
  803697:	31 d2                	xor    %edx,%edx
  803699:	f7 f7                	div    %edi
  80369b:	89 c5                	mov    %eax,%ebp
  80369d:	89 f0                	mov    %esi,%eax
  80369f:	31 d2                	xor    %edx,%edx
  8036a1:	f7 f5                	div    %ebp
  8036a3:	89 c8                	mov    %ecx,%eax
  8036a5:	f7 f5                	div    %ebp
  8036a7:	89 d0                	mov    %edx,%eax
  8036a9:	e9 44 ff ff ff       	jmp    8035f2 <__umoddi3+0x3e>
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	89 c8                	mov    %ecx,%eax
  8036b2:	89 f2                	mov    %esi,%edx
  8036b4:	83 c4 1c             	add    $0x1c,%esp
  8036b7:	5b                   	pop    %ebx
  8036b8:	5e                   	pop    %esi
  8036b9:	5f                   	pop    %edi
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    
  8036bc:	3b 04 24             	cmp    (%esp),%eax
  8036bf:	72 06                	jb     8036c7 <__umoddi3+0x113>
  8036c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036c5:	77 0f                	ja     8036d6 <__umoddi3+0x122>
  8036c7:	89 f2                	mov    %esi,%edx
  8036c9:	29 f9                	sub    %edi,%ecx
  8036cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036cf:	89 14 24             	mov    %edx,(%esp)
  8036d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036da:	8b 14 24             	mov    (%esp),%edx
  8036dd:	83 c4 1c             	add    $0x1c,%esp
  8036e0:	5b                   	pop    %ebx
  8036e1:	5e                   	pop    %esi
  8036e2:	5f                   	pop    %edi
  8036e3:	5d                   	pop    %ebp
  8036e4:	c3                   	ret    
  8036e5:	8d 76 00             	lea    0x0(%esi),%esi
  8036e8:	2b 04 24             	sub    (%esp),%eax
  8036eb:	19 fa                	sbb    %edi,%edx
  8036ed:	89 d1                	mov    %edx,%ecx
  8036ef:	89 c6                	mov    %eax,%esi
  8036f1:	e9 71 ff ff ff       	jmp    803667 <__umoddi3+0xb3>
  8036f6:	66 90                	xchg   %ax,%ax
  8036f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036fc:	72 ea                	jb     8036e8 <__umoddi3+0x134>
  8036fe:	89 d9                	mov    %ebx,%ecx
  803700:	e9 62 ff ff ff       	jmp    803667 <__umoddi3+0xb3>
