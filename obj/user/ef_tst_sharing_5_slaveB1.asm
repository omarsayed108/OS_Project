
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 0c 01 00 00       	call   800142 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	printStats = 0;
  80003e:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800045:	00 00 00 

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800048:	a1 20 50 80 00       	mov    0x805020,%eax
  80004d:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800053:	a1 20 50 80 00       	mov    0x805020,%eax
  800058:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005e:	39 c2                	cmp    %eax,%edx
  800060:	72 14                	jb     800076 <_main+0x3e>
			panic("Please increase the WS size");
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	68 c0 37 80 00       	push   $0x8037c0
  80006a:	6a 0f                	push   $0xf
  80006c:	68 dc 37 80 00       	push   $0x8037dc
  800071:	e8 7c 02 00 00       	call   8002f2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  80007d:	e8 4c 24 00 00       	call   8024ce <sys_getparentenvid>
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 fc 37 80 00       	push   $0x8037fc
  80008a:	50                   	push   %eax
  80008b:	e8 9b 1f 00 00       	call   80202b <sget>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 00 38 80 00       	push   $0x803800
  80009e:	e8 3d 05 00 00       	call   8005e0 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000a6:	e8 48 25 00 00       	call   8025f3 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 28 38 80 00       	push   $0x803828
  8000b3:	e8 28 05 00 00       	call   8005e0 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z and be completed.
	env_sleep(6000);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 70 17 00 00       	push   $0x1770
  8000c3:	e8 d1 33 00 00       	call   803499 <env_sleep>
  8000c8:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=4) ;// panic("test failed");
  8000cb:	90                   	nop
  8000cc:	e8 3c 25 00 00       	call   80260d <gettst>
  8000d1:	83 f8 04             	cmp    $0x4,%eax
  8000d4:	75 f6                	jne    8000cc <_main+0x94>

	freeFrames = sys_calculate_free_frames() ;
  8000d6:	e8 11 22 00 00       	call   8022ec <sys_calculate_free_frames>
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e4:	e8 c7 20 00 00       	call   8021b0 <sfree>
  8000e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 48 38 80 00       	push   $0x803848
  8000f4:	e8 e7 04 00 00       	call   8005e0 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
	expected = 2+1; /*2pages+1table*/
  8000fc:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of x\nframes_storage of x: should be cleared now\n", expected);
  800103:	e8 e4 21 00 00       	call   8022ec <sys_calculate_free_frames>
  800108:	89 c2                	mov    %eax,%edx
  80010a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010d:	29 c2                	sub    %eax,%edx
  80010f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800112:	39 c2                	cmp    %eax,%edx
  800114:	74 14                	je     80012a <_main+0xf2>
  800116:	ff 75 e8             	pushl  -0x18(%ebp)
  800119:	68 60 38 80 00       	push   $0x803860
  80011e:	6a 29                	push   $0x29
  800120:	68 dc 37 80 00       	push   $0x8037dc
  800125:	e8 c8 01 00 00       	call   8002f2 <_panic>

	//To indicate that it's completed successfully
	cprintf("SlaveB1 is completed.\n");
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	68 f0 38 80 00       	push   $0x8038f0
  800132:	e8 a9 04 00 00       	call   8005e0 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp
	inctst();
  80013a:	e8 b4 24 00 00       	call   8025f3 <inctst>
	return;
  80013f:	90                   	nop
}
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
  800148:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80014b:	e8 65 23 00 00       	call   8024b5 <sys_getenvindex>
  800150:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800153:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800156:	89 d0                	mov    %edx,%eax
  800158:	01 c0                	add    %eax,%eax
  80015a:	01 d0                	add    %edx,%eax
  80015c:	c1 e0 02             	shl    $0x2,%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	c1 e0 02             	shl    $0x2,%eax
  800164:	01 d0                	add    %edx,%eax
  800166:	c1 e0 03             	shl    $0x3,%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 02             	shl    $0x2,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 50 80 00       	mov    0x805020,%eax
  80017d:	8a 40 20             	mov    0x20(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0d                	je     800191 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800184:	a1 20 50 80 00       	mov    0x805020,%eax
  800189:	83 c0 20             	add    $0x20,%eax
  80018c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800195:	7e 0a                	jle    8001a1 <libmain+0x5f>
		binaryname = argv[0];
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 89 fe ff ff       	call   800038 <_main>
  8001af:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b2:	a1 00 50 80 00       	mov    0x805000,%eax
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	0f 84 01 01 00 00    	je     8002c0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001bf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c5:	bb 00 3a 80 00       	mov    $0x803a00,%ebx
  8001ca:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cf:	89 c7                	mov    %eax,%edi
  8001d1:	89 de                	mov    %ebx,%esi
  8001d3:	89 d1                	mov    %edx,%ecx
  8001d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001da:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001df:	b0 00                	mov    $0x0,%al
  8001e1:	89 d7                	mov    %edx,%edi
  8001e3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	50                   	push   %eax
  8001f3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 ec 24 00 00       	call   8026eb <sys_utilities>
  8001ff:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800202:	e8 35 20 00 00       	call   80223c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 20 39 80 00       	push   $0x803920
  80020f:	e8 cc 03 00 00       	call   8005e0 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021a:	85 c0                	test   %eax,%eax
  80021c:	74 18                	je     800236 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80021e:	e8 e6 24 00 00       	call   802709 <sys_get_optimal_num_faults>
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	50                   	push   %eax
  800227:	68 48 39 80 00       	push   $0x803948
  80022c:	e8 af 03 00 00       	call   8005e0 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	eb 59                	jmp    80028f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800236:	a1 20 50 80 00       	mov    0x805020,%eax
  80023b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800241:	a1 20 50 80 00       	mov    0x805020,%eax
  800246:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	52                   	push   %edx
  800250:	50                   	push   %eax
  800251:	68 6c 39 80 00       	push   $0x80396c
  800256:	e8 85 03 00 00       	call   8005e0 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025e:	a1 20 50 80 00       	mov    0x805020,%eax
  800263:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800269:	a1 20 50 80 00       	mov    0x805020,%eax
  80026e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80027f:	51                   	push   %ecx
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 94 39 80 00       	push   $0x803994
  800287:	e8 54 03 00 00       	call   8005e0 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 ec 39 80 00       	push   $0x8039ec
  8002a3:	e8 38 03 00 00       	call   8005e0 <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 20 39 80 00       	push   $0x803920
  8002b3:	e8 28 03 00 00       	call   8005e0 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002bb:	e8 96 1f 00 00       	call   802256 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002c0:	e8 1f 00 00 00       	call   8002e4 <exit>
}
  8002c5:	90                   	nop
  8002c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c9:	5b                   	pop    %ebx
  8002ca:	5e                   	pop    %esi
  8002cb:	5f                   	pop    %edi
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    

008002ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	6a 00                	push   $0x0
  8002d9:	e8 a3 21 00 00       	call   802481 <sys_destroy_env>
  8002de:	83 c4 10             	add    $0x10,%esp
}
  8002e1:	90                   	nop
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <exit>:

void
exit(void)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ea:	e8 f8 21 00 00       	call   8024e7 <sys_exit_env>
}
  8002ef:	90                   	nop
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002fb:	83 c0 04             	add    $0x4,%eax
  8002fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800301:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	74 16                	je     800320 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80030a:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	50                   	push   %eax
  800313:	68 64 3a 80 00       	push   $0x803a64
  800318:	e8 c3 02 00 00       	call   8005e0 <cprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800320:	a1 04 50 80 00       	mov    0x805004,%eax
  800325:	83 ec 0c             	sub    $0xc,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	50                   	push   %eax
  80032f:	68 6c 3a 80 00       	push   $0x803a6c
  800334:	6a 74                	push   $0x74
  800336:	e8 d2 02 00 00       	call   80060d <cprintf_colored>
  80033b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80033e:	8b 45 10             	mov    0x10(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	50                   	push   %eax
  800348:	e8 24 02 00 00       	call   800571 <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	6a 00                	push   $0x0
  800355:	68 94 3a 80 00       	push   $0x803a94
  80035a:	e8 12 02 00 00       	call   800571 <vcprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800362:	e8 7d ff ff ff       	call   8002e4 <exit>

	// should not return here
	while (1) ;
  800367:	eb fe                	jmp    800367 <_panic+0x75>

00800369 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	53                   	push   %ebx
  80036d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800370:	a1 20 50 80 00       	mov    0x805020,%eax
  800375:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037e:	39 c2                	cmp    %eax,%edx
  800380:	74 14                	je     800396 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	68 98 3a 80 00       	push   $0x803a98
  80038a:	6a 26                	push   $0x26
  80038c:	68 e4 3a 80 00       	push   $0x803ae4
  800391:	e8 5c ff ff ff       	call   8002f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a4:	e9 d9 00 00 00       	jmp    800482 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	85 c0                	test   %eax,%eax
  8003bc:	75 08                	jne    8003c6 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003be:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c1:	e9 b9 00 00 00       	jmp    80047f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d4:	eb 79                	jmp    80044f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003db:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e4:	89 d0                	mov    %edx,%eax
  8003e6:	01 c0                	add    %eax,%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003f1:	01 d8                	add    %ebx,%eax
  8003f3:	01 d0                	add    %edx,%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8a 40 04             	mov    0x4(%eax),%al
  8003fa:	84 c0                	test   %al,%al
  8003fc:	75 4e                	jne    80044c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800403:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800409:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040c:	89 d0                	mov    %edx,%eax
  80040e:	01 c0                	add    %eax,%eax
  800410:	01 d0                	add    %edx,%eax
  800412:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800419:	01 d8                	add    %ebx,%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800424:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80042c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800431:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	01 c8                	add    %ecx,%eax
  80043d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	75 09                	jne    80044c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800443:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80044a:	eb 19                	jmp    800465 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044c:	ff 45 e8             	incl   -0x18(%ebp)
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80045a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045d:	39 c2                	cmp    %eax,%edx
  80045f:	0f 87 71 ff ff ff    	ja     8003d6 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800465:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800469:	75 14                	jne    80047f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80046b:	83 ec 04             	sub    $0x4,%esp
  80046e:	68 f0 3a 80 00       	push   $0x803af0
  800473:	6a 3a                	push   $0x3a
  800475:	68 e4 3a 80 00       	push   $0x803ae4
  80047a:	e8 73 fe ff ff       	call   8002f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80047f:	ff 45 f0             	incl   -0x10(%ebp)
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800485:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800488:	0f 8c 1b ff ff ff    	jl     8003a9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80048e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800495:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049c:	eb 2e                	jmp    8004cc <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80049e:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ac:	89 d0                	mov    %edx,%eax
  8004ae:	01 c0                	add    %eax,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004b9:	01 d8                	add    %ebx,%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	01 c8                	add    %ecx,%eax
  8004bf:	8a 40 04             	mov    0x4(%eax),%al
  8004c2:	3c 01                	cmp    $0x1,%al
  8004c4:	75 03                	jne    8004c9 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c9:	ff 45 e0             	incl   -0x20(%ebp)
  8004cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004da:	39 c2                	cmp    %eax,%edx
  8004dc:	77 c0                	ja     80049e <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e4:	74 14                	je     8004fa <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 44 3b 80 00       	push   $0x803b44
  8004ee:	6a 44                	push   $0x44
  8004f0:	68 e4 3a 80 00       	push   $0x803ae4
  8004f5:	e8 f8 fd ff ff       	call   8002f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fa:	90                   	nop
  8004fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	53                   	push   %ebx
  800504:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	8d 48 01             	lea    0x1(%eax),%ecx
  80050f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800512:	89 0a                	mov    %ecx,(%edx)
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  800517:	88 d1                	mov    %dl,%cl
  800519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052a:	75 30                	jne    80055c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80052c:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800532:	a0 44 50 80 00       	mov    0x805044,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80053d:	8b 09                	mov    (%ecx),%ecx
  80053f:	89 cb                	mov    %ecx,%ebx
  800541:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800544:	83 c1 08             	add    $0x8,%ecx
  800547:	52                   	push   %edx
  800548:	50                   	push   %eax
  800549:	53                   	push   %ebx
  80054a:	51                   	push   %ecx
  80054b:	e8 a8 1c 00 00       	call   8021f8 <sys_cputs>
  800550:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055f:	8b 40 04             	mov    0x4(%eax),%eax
  800562:	8d 50 01             	lea    0x1(%eax),%edx
  800565:	8b 45 0c             	mov    0xc(%ebp),%eax
  800568:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056b:	90                   	nop
  80056c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800581:	00 00 00 
	b.cnt = 0;
  800584:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058e:	ff 75 0c             	pushl  0xc(%ebp)
  800591:	ff 75 08             	pushl  0x8(%ebp)
  800594:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059a:	50                   	push   %eax
  80059b:	68 00 05 80 00       	push   $0x800500
  8005a0:	e8 5a 02 00 00       	call   8007ff <vprintfmt>
  8005a5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005a8:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8005ae:	a0 44 50 80 00       	mov    0x805044,%al
  8005b3:	0f b6 c0             	movzbl %al,%eax
  8005b6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005bc:	52                   	push   %edx
  8005bd:	50                   	push   %eax
  8005be:	51                   	push   %ecx
  8005bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c5:	83 c0 08             	add    $0x8,%eax
  8005c8:	50                   	push   %eax
  8005c9:	e8 2a 1c 00 00       	call   8021f8 <sys_cputs>
  8005ce:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005d1:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e6:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fc:	50                   	push   %eax
  8005fd:	e8 6f ff ff ff       	call   800571 <vcprintf>
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060b:	c9                   	leave  
  80060c:	c3                   	ret    

0080060d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800613:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	c1 e0 08             	shl    $0x8,%eax
  800620:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800625:	8d 45 0c             	lea    0xc(%ebp),%eax
  800628:	83 c0 04             	add    $0x4,%eax
  80062b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	50                   	push   %eax
  800638:	e8 34 ff ff ff       	call   800571 <vcprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800643:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  80064a:	07 00 00 

	return cnt;
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800650:	c9                   	leave  
  800651:	c3                   	ret    

00800652 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800658:	e8 df 1b 00 00       	call   80223c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80065d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	ff 75 f4             	pushl  -0xc(%ebp)
  80066c:	50                   	push   %eax
  80066d:	e8 ff fe ff ff       	call   800571 <vcprintf>
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800678:	e8 d9 1b 00 00       	call   802256 <sys_unlock_cons>
	return cnt;
  80067d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	53                   	push   %ebx
  800686:	83 ec 14             	sub    $0x14,%esp
  800689:	8b 45 10             	mov    0x10(%ebp),%eax
  80068c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800695:	8b 45 18             	mov    0x18(%ebp),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a0:	77 55                	ja     8006f7 <printnum+0x75>
  8006a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a5:	72 05                	jb     8006ac <printnum+0x2a>
  8006a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006aa:	77 4b                	ja     8006f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8006c2:	e8 91 2e 00 00       	call   803558 <__udivdi3>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	ff 75 20             	pushl  0x20(%ebp)
  8006d0:	53                   	push   %ebx
  8006d1:	ff 75 18             	pushl  0x18(%ebp)
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 0c             	pushl  0xc(%ebp)
  8006d9:	ff 75 08             	pushl  0x8(%ebp)
  8006dc:	e8 a1 ff ff ff       	call   800682 <printnum>
  8006e1:	83 c4 20             	add    $0x20,%esp
  8006e4:	eb 1a                	jmp    800700 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fe:	7f e6                	jg     8006e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800700:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800703:	bb 00 00 00 00       	mov    $0x0,%ebx
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070e:	53                   	push   %ebx
  80070f:	51                   	push   %ecx
  800710:	52                   	push   %edx
  800711:	50                   	push   %eax
  800712:	e8 51 2f 00 00       	call   803668 <__umoddi3>
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	05 b4 3d 80 00       	add    $0x803db4,%eax
  80071f:	8a 00                	mov    (%eax),%al
  800721:	0f be c0             	movsbl %al,%eax
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	50                   	push   %eax
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	ff d0                	call   *%eax
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800737:	c9                   	leave  
  800738:	c3                   	ret    

00800739 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80073c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800740:	7e 1c                	jle    80075e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 08             	lea    0x8(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 08             	sub    $0x8,%eax
  800757:	8b 50 04             	mov    0x4(%eax),%edx
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	eb 40                	jmp    80079e <getuint+0x65>
	else if (lflag)
  80075e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800762:	74 1e                	je     800782 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	8d 50 04             	lea    0x4(%eax),%edx
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	89 10                	mov    %edx,(%eax)
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	83 e8 04             	sub    $0x4,%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	eb 1c                	jmp    80079e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	89 10                	mov    %edx,(%eax)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	83 e8 04             	sub    $0x4,%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a7:	7e 1c                	jle    8007c5 <getint+0x25>
		return va_arg(*ap, long long);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 08             	lea    0x8(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 08             	sub    $0x8,%eax
  8007be:	8b 50 04             	mov    0x4(%eax),%edx
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	eb 38                	jmp    8007fd <getint+0x5d>
	else if (lflag)
  8007c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c9:	74 1a                	je     8007e5 <getint+0x45>
		return va_arg(*ap, long);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	8d 50 04             	lea    0x4(%eax),%edx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	89 10                	mov    %edx,(%eax)
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	83 e8 04             	sub    $0x4,%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	99                   	cltd   
  8007e3:	eb 18                	jmp    8007fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	99                   	cltd   
}
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	56                   	push   %esi
  800803:	53                   	push   %ebx
  800804:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800807:	eb 17                	jmp    800820 <vprintfmt+0x21>
			if (ch == '\0')
  800809:	85 db                	test   %ebx,%ebx
  80080b:	0f 84 c1 03 00 00    	je     800bd2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	53                   	push   %ebx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8d 50 01             	lea    0x1(%eax),%edx
  800826:	89 55 10             	mov    %edx,0x10(%ebp)
  800829:	8a 00                	mov    (%eax),%al
  80082b:	0f b6 d8             	movzbl %al,%ebx
  80082e:	83 fb 25             	cmp    $0x25,%ebx
  800831:	75 d6                	jne    800809 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800833:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800837:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800845:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80084c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800853:	8b 45 10             	mov    0x10(%ebp),%eax
  800856:	8d 50 01             	lea    0x1(%eax),%edx
  800859:	89 55 10             	mov    %edx,0x10(%ebp)
  80085c:	8a 00                	mov    (%eax),%al
  80085e:	0f b6 d8             	movzbl %al,%ebx
  800861:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800864:	83 f8 5b             	cmp    $0x5b,%eax
  800867:	0f 87 3d 03 00 00    	ja     800baa <vprintfmt+0x3ab>
  80086d:	8b 04 85 d8 3d 80 00 	mov    0x803dd8(,%eax,4),%eax
  800874:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800876:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80087a:	eb d7                	jmp    800853 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80087c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800880:	eb d1                	jmp    800853 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800882:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800889:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80088c:	89 d0                	mov    %edx,%eax
  80088e:	c1 e0 02             	shl    $0x2,%eax
  800891:	01 d0                	add    %edx,%eax
  800893:	01 c0                	add    %eax,%eax
  800895:	01 d8                	add    %ebx,%eax
  800897:	83 e8 30             	sub    $0x30,%eax
  80089a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a8:	7e 3e                	jle    8008e8 <vprintfmt+0xe9>
  8008aa:	83 fb 39             	cmp    $0x39,%ebx
  8008ad:	7f 39                	jg     8008e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008b2:	eb d5                	jmp    800889 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	83 c0 04             	add    $0x4,%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c8:	eb 1f                	jmp    8008e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ce:	79 83                	jns    800853 <vprintfmt+0x54>
				width = 0;
  8008d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d7:	e9 77 ff ff ff       	jmp    800853 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e3:	e9 6b ff ff ff       	jmp    800853 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	0f 89 60 ff ff ff    	jns    800853 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800900:	e9 4e ff ff ff       	jmp    800853 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800905:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800908:	e9 46 ff ff ff       	jmp    800853 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	83 e8 04             	sub    $0x4,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	50                   	push   %eax
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	ff d0                	call   *%eax
  80092a:	83 c4 10             	add    $0x10,%esp
			break;
  80092d:	e9 9b 02 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 c0 04             	add    $0x4,%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800943:	85 db                	test   %ebx,%ebx
  800945:	79 02                	jns    800949 <vprintfmt+0x14a>
				err = -err;
  800947:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800949:	83 fb 64             	cmp    $0x64,%ebx
  80094c:	7f 0b                	jg     800959 <vprintfmt+0x15a>
  80094e:	8b 34 9d 20 3c 80 00 	mov    0x803c20(,%ebx,4),%esi
  800955:	85 f6                	test   %esi,%esi
  800957:	75 19                	jne    800972 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800959:	53                   	push   %ebx
  80095a:	68 c5 3d 80 00       	push   $0x803dc5
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	ff 75 08             	pushl  0x8(%ebp)
  800965:	e8 70 02 00 00       	call   800bda <printfmt>
  80096a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096d:	e9 5b 02 00 00       	jmp    800bcd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800972:	56                   	push   %esi
  800973:	68 ce 3d 80 00       	push   $0x803dce
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	ff 75 08             	pushl  0x8(%ebp)
  80097e:	e8 57 02 00 00       	call   800bda <printfmt>
  800983:	83 c4 10             	add    $0x10,%esp
			break;
  800986:	e9 42 02 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 c0 04             	add    $0x4,%eax
  800991:	89 45 14             	mov    %eax,0x14(%ebp)
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 30                	mov    (%eax),%esi
  80099c:	85 f6                	test   %esi,%esi
  80099e:	75 05                	jne    8009a5 <vprintfmt+0x1a6>
				p = "(null)";
  8009a0:	be d1 3d 80 00       	mov    $0x803dd1,%esi
			if (width > 0 && padc != '-')
  8009a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a9:	7e 6d                	jle    800a18 <vprintfmt+0x219>
  8009ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009af:	74 67                	je     800a18 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	50                   	push   %eax
  8009b8:	56                   	push   %esi
  8009b9:	e8 1e 03 00 00       	call   800cdc <strnlen>
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c4:	eb 16                	jmp    8009dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	50                   	push   %eax
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e0:	7f e4                	jg     8009c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e2:	eb 34                	jmp    800a18 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e8:	74 1c                	je     800a06 <vprintfmt+0x207>
  8009ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ed:	7e 05                	jle    8009f4 <vprintfmt+0x1f5>
  8009ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8009f2:	7e 12                	jle    800a06 <vprintfmt+0x207>
					putch('?', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 3f                	push   $0x3f
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	eb 0f                	jmp    800a15 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a15:	ff 4d e4             	decl   -0x1c(%ebp)
  800a18:	89 f0                	mov    %esi,%eax
  800a1a:	8d 70 01             	lea    0x1(%eax),%esi
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	0f be d8             	movsbl %al,%ebx
  800a22:	85 db                	test   %ebx,%ebx
  800a24:	74 24                	je     800a4a <vprintfmt+0x24b>
  800a26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2a:	78 b8                	js     8009e4 <vprintfmt+0x1e5>
  800a2c:	ff 4d e0             	decl   -0x20(%ebp)
  800a2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a33:	79 af                	jns    8009e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a35:	eb 13                	jmp    800a4a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 20                	push   $0x20
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a47:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4e:	7f e7                	jg     800a37 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a50:	e9 78 01 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5e:	50                   	push   %eax
  800a5f:	e8 3c fd ff ff       	call   8007a0 <getint>
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a73:	85 d2                	test   %edx,%edx
  800a75:	79 23                	jns    800a9a <vprintfmt+0x29b>
				putch('-', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 2d                	push   $0x2d
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8d:	f7 d8                	neg    %eax
  800a8f:	83 d2 00             	adc    $0x0,%edx
  800a92:	f7 da                	neg    %edx
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a9a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa1:	e9 bc 00 00 00       	jmp    800b62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 e8             	pushl  -0x18(%ebp)
  800aac:	8d 45 14             	lea    0x14(%ebp),%eax
  800aaf:	50                   	push   %eax
  800ab0:	e8 84 fc ff ff       	call   800739 <getuint>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac5:	e9 98 00 00 00       	jmp    800b62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 58                	push   $0x58
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 58                	push   $0x58
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 58                	push   $0x58
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			break;
  800afa:	e9 ce 00 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	6a 30                	push   $0x30
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 78                	push   $0x78
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 c0 04             	add    $0x4,%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b41:	eb 1f                	jmp    800b62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 e8             	pushl  -0x18(%ebp)
  800b49:	8d 45 14             	lea    0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	e8 e7 fb ff ff       	call   800739 <getuint>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	52                   	push   %edx
  800b6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b70:	50                   	push   %eax
  800b71:	ff 75 f4             	pushl  -0xc(%ebp)
  800b74:	ff 75 f0             	pushl  -0x10(%ebp)
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	ff 75 08             	pushl  0x8(%ebp)
  800b7d:	e8 00 fb ff ff       	call   800682 <printnum>
  800b82:	83 c4 20             	add    $0x20,%esp
			break;
  800b85:	eb 46                	jmp    800bcd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			break;
  800b96:	eb 35                	jmp    800bcd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b98:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b9f:	eb 2c                	jmp    800bcd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ba1:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800ba8:	eb 23                	jmp    800bcd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	6a 25                	push   $0x25
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	ff d0                	call   *%eax
  800bb7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	eb 03                	jmp    800bc2 <vprintfmt+0x3c3>
  800bbf:	ff 4d 10             	decl   0x10(%ebp)
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	48                   	dec    %eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	3c 25                	cmp    $0x25,%al
  800bca:	75 f3                	jne    800bbf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bcc:	90                   	nop
		}
	}
  800bcd:	e9 35 fc ff ff       	jmp    800807 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800be0:	8d 45 10             	lea    0x10(%ebp),%eax
  800be3:	83 c0 04             	add    $0x4,%eax
  800be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bec:	ff 75 f4             	pushl  -0xc(%ebp)
  800bef:	50                   	push   %eax
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	e8 04 fc ff ff       	call   8007ff <vprintfmt>
  800bfb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bfe:	90                   	nop
  800bff:	c9                   	leave  
  800c00:	c3                   	ret    

00800c01 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	8b 40 08             	mov    0x8(%eax),%eax
  800c0a:	8d 50 01             	lea    0x1(%eax),%edx
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 10                	mov    (%eax),%edx
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8b 40 04             	mov    0x4(%eax),%eax
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	73 12                	jae    800c34 <sprintputch+0x33>
		*b->buf++ = ch;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	8d 48 01             	lea    0x1(%eax),%ecx
  800c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2d:	89 0a                	mov    %ecx,(%edx)
  800c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c32:	88 10                	mov    %dl,(%eax)
}
  800c34:	90                   	nop
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	01 d0                	add    %edx,%eax
  800c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c5c:	74 06                	je     800c64 <vsnprintf+0x2d>
  800c5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c62:	7f 07                	jg     800c6b <vsnprintf+0x34>
		return -E_INVAL;
  800c64:	b8 03 00 00 00       	mov    $0x3,%eax
  800c69:	eb 20                	jmp    800c8b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c6b:	ff 75 14             	pushl  0x14(%ebp)
  800c6e:	ff 75 10             	pushl  0x10(%ebp)
  800c71:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	68 01 0c 80 00       	push   $0x800c01
  800c7a:	e8 80 fb ff ff       	call   8007ff <vprintfmt>
  800c7f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c85:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c93:	8d 45 10             	lea    0x10(%ebp),%eax
  800c96:	83 c0 04             	add    $0x4,%eax
  800c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca2:	50                   	push   %eax
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 08             	pushl  0x8(%ebp)
  800ca9:	e8 89 ff ff ff       	call   800c37 <vsnprintf>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc6:	eb 06                	jmp    800cce <strlen+0x15>
		n++;
  800cc8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccb:	ff 45 08             	incl   0x8(%ebp)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	75 f1                	jne    800cc8 <strlen+0xf>
		n++;
	return n;
  800cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce9:	eb 09                	jmp    800cf4 <strnlen+0x18>
		n++;
  800ceb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cee:	ff 45 08             	incl   0x8(%ebp)
  800cf1:	ff 4d 0c             	decl   0xc(%ebp)
  800cf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf8:	74 09                	je     800d03 <strnlen+0x27>
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	84 c0                	test   %al,%al
  800d01:	75 e8                	jne    800ceb <strnlen+0xf>
		n++;
	return n;
  800d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d14:	90                   	nop
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8d 50 01             	lea    0x1(%eax),%edx
  800d1b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d21:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d24:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d27:	8a 12                	mov    (%edx),%dl
  800d29:	88 10                	mov    %dl,(%eax)
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	84 c0                	test   %al,%al
  800d2f:	75 e4                	jne    800d15 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d49:	eb 1f                	jmp    800d6a <strncpy+0x34>
		*dst++ = *src;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8d 50 01             	lea    0x1(%eax),%edx
  800d51:	89 55 08             	mov    %edx,0x8(%ebp)
  800d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d57:	8a 12                	mov    (%edx),%dl
  800d59:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	84 c0                	test   %al,%al
  800d62:	74 03                	je     800d67 <strncpy+0x31>
			src++;
  800d64:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d67:	ff 45 fc             	incl   -0x4(%ebp)
  800d6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d70:	72 d9                	jb     800d4b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 30                	je     800db9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d89:	eb 16                	jmp    800da1 <strlcpy+0x2a>
			*dst++ = *src++;
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8d 50 01             	lea    0x1(%eax),%edx
  800d91:	89 55 08             	mov    %edx,0x8(%ebp)
  800d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d9d:	8a 12                	mov    (%edx),%dl
  800d9f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800da1:	ff 4d 10             	decl   0x10(%ebp)
  800da4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da8:	74 09                	je     800db3 <strlcpy+0x3c>
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	84 c0                	test   %al,%al
  800db1:	75 d8                	jne    800d8b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	29 c2                	sub    %eax,%edx
  800dc1:	89 d0                	mov    %edx,%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc8:	eb 06                	jmp    800dd0 <strcmp+0xb>
		p++, q++;
  800dca:	ff 45 08             	incl   0x8(%ebp)
  800dcd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	74 0e                	je     800de7 <strcmp+0x22>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 10                	mov    (%eax),%dl
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	38 c2                	cmp    %al,%dl
  800de5:	74 e3                	je     800dca <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e00:	eb 09                	jmp    800e0b <strncmp+0xe>
		n--, p++, q++;
  800e02:	ff 4d 10             	decl   0x10(%ebp)
  800e05:	ff 45 08             	incl   0x8(%ebp)
  800e08:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0f:	74 17                	je     800e28 <strncmp+0x2b>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	74 0e                	je     800e28 <strncmp+0x2b>
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 10                	mov    (%eax),%dl
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	38 c2                	cmp    %al,%dl
  800e26:	74 da                	je     800e02 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2c:	75 07                	jne    800e35 <strncmp+0x38>
		return 0;
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e33:	eb 14                	jmp    800e49 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	0f b6 d0             	movzbl %al,%edx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	0f b6 c0             	movzbl %al,%eax
  800e45:	29 c2                	sub    %eax,%edx
  800e47:	89 d0                	mov    %edx,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e57:	eb 12                	jmp    800e6b <strchr+0x20>
		if (*s == c)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e61:	75 05                	jne    800e68 <strchr+0x1d>
			return (char *) s;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	eb 11                	jmp    800e79 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e68:	ff 45 08             	incl   0x8(%ebp)
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	84 c0                	test   %al,%al
  800e72:	75 e5                	jne    800e59 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e79:	c9                   	leave  
  800e7a:	c3                   	ret    

00800e7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 04             	sub    $0x4,%esp
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e87:	eb 0d                	jmp    800e96 <strfind+0x1b>
		if (*s == c)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e91:	74 0e                	je     800ea1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	84 c0                	test   %al,%al
  800e9d:	75 ea                	jne    800e89 <strfind+0xe>
  800e9f:	eb 01                	jmp    800ea2 <strfind+0x27>
		if (*s == c)
			break;
  800ea1:	90                   	nop
	return (char *) s;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea5:	c9                   	leave  
  800ea6:	c3                   	ret    

00800ea7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800eb3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb7:	76 63                	jbe    800f1c <memset+0x75>
		uint64 data_block = c;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	99                   	cltd   
  800ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ecd:	c1 e0 08             	shl    $0x8,%eax
  800ed0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ee0:	c1 e0 10             	shl    $0x10,%eax
  800ee3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800efc:	eb 18                	jmp    800f16 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800efe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f01:	8d 41 08             	lea    0x8(%ecx),%eax
  800f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0d:	89 01                	mov    %eax,(%ecx)
  800f0f:	89 51 04             	mov    %edx,0x4(%ecx)
  800f12:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f16:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f1a:	77 e2                	ja     800efe <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f20:	74 23                	je     800f45 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f28:	eb 0e                	jmp    800f38 <memset+0x91>
			*p8++ = (uint8)c;
  800f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f36:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	75 e5                	jne    800f2a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f5c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f60:	76 24                	jbe    800f86 <memcpy+0x3c>
		while(n >= 8){
  800f62:	eb 1c                	jmp    800f80 <memcpy+0x36>
			*d64 = *s64;
  800f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f67:	8b 50 04             	mov    0x4(%eax),%edx
  800f6a:	8b 00                	mov    (%eax),%eax
  800f6c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f6f:	89 01                	mov    %eax,(%ecx)
  800f71:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f74:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f78:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f7c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f80:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f84:	77 de                	ja     800f64 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8a:	74 31                	je     800fbd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f98:	eb 16                	jmp    800fb0 <memcpy+0x66>
			*d8++ = *s8++;
  800f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9d:	8d 50 01             	lea    0x1(%eax),%edx
  800fa0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fac:	8a 12                	mov    (%edx),%dl
  800fae:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 dd                	jne    800f9a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fda:	73 50                	jae    80102c <memmove+0x6a>
  800fdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	01 d0                	add    %edx,%eax
  800fe4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe7:	76 43                	jbe    80102c <memmove+0x6a>
		s += n;
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ff5:	eb 10                	jmp    801007 <memmove+0x45>
			*--d = *--s;
  800ff7:	ff 4d f8             	decl   -0x8(%ebp)
  800ffa:	ff 4d fc             	decl   -0x4(%ebp)
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 10                	mov    (%eax),%dl
  801002:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801005:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 e3                	jne    800ff7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801014:	eb 23                	jmp    801039 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	8d 50 01             	lea    0x1(%eax),%edx
  80101c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801022:	8d 4a 01             	lea    0x1(%edx),%ecx
  801025:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801028:	8a 12                	mov    (%edx),%dl
  80102a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	89 55 10             	mov    %edx,0x10(%ebp)
  801035:	85 c0                	test   %eax,%eax
  801037:	75 dd                	jne    801016 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801050:	eb 2a                	jmp    80107c <memcmp+0x3e>
		if (*s1 != *s2)
  801052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801055:	8a 10                	mov    (%eax),%dl
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	38 c2                	cmp    %al,%dl
  80105e:	74 16                	je     801076 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	0f b6 d0             	movzbl %al,%edx
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	0f b6 c0             	movzbl %al,%eax
  801070:	29 c2                	sub    %eax,%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	eb 18                	jmp    80108e <memcmp+0x50>
		s1++, s2++;
  801076:	ff 45 fc             	incl   -0x4(%ebp)
  801079:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 c9                	jne    801052 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010a1:	eb 15                	jmp    8010b8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	0f b6 d0             	movzbl %al,%edx
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	0f b6 c0             	movzbl %al,%eax
  8010b1:	39 c2                	cmp    %eax,%edx
  8010b3:	74 0d                	je     8010c2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010b5:	ff 45 08             	incl   0x8(%ebp)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010be:	72 e3                	jb     8010a3 <memfind+0x13>
  8010c0:	eb 01                	jmp    8010c3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010c2:	90                   	nop
	return (void *) s;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010dc:	eb 03                	jmp    8010e1 <strtol+0x19>
		s++;
  8010de:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 20                	cmp    $0x20,%al
  8010e8:	74 f4                	je     8010de <strtol+0x16>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 09                	cmp    $0x9,%al
  8010f1:	74 eb                	je     8010de <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	3c 2b                	cmp    $0x2b,%al
  8010fa:	75 05                	jne    801101 <strtol+0x39>
		s++;
  8010fc:	ff 45 08             	incl   0x8(%ebp)
  8010ff:	eb 13                	jmp    801114 <strtol+0x4c>
	else if (*s == '-')
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 2d                	cmp    $0x2d,%al
  801108:	75 0a                	jne    801114 <strtol+0x4c>
		s++, neg = 1;
  80110a:	ff 45 08             	incl   0x8(%ebp)
  80110d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801114:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801118:	74 06                	je     801120 <strtol+0x58>
  80111a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80111e:	75 20                	jne    801140 <strtol+0x78>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 30                	cmp    $0x30,%al
  801127:	75 17                	jne    801140 <strtol+0x78>
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	40                   	inc    %eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 78                	cmp    $0x78,%al
  801131:	75 0d                	jne    801140 <strtol+0x78>
		s += 2, base = 16;
  801133:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801137:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80113e:	eb 28                	jmp    801168 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801144:	75 15                	jne    80115b <strtol+0x93>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	3c 30                	cmp    $0x30,%al
  80114d:	75 0c                	jne    80115b <strtol+0x93>
		s++, base = 8;
  80114f:	ff 45 08             	incl   0x8(%ebp)
  801152:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801159:	eb 0d                	jmp    801168 <strtol+0xa0>
	else if (base == 0)
  80115b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115f:	75 07                	jne    801168 <strtol+0xa0>
		base = 10;
  801161:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2f                	cmp    $0x2f,%al
  80116f:	7e 19                	jle    80118a <strtol+0xc2>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	3c 39                	cmp    $0x39,%al
  801178:	7f 10                	jg     80118a <strtol+0xc2>
			dig = *s - '0';
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f be c0             	movsbl %al,%eax
  801182:	83 e8 30             	sub    $0x30,%eax
  801185:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801188:	eb 42                	jmp    8011cc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 60                	cmp    $0x60,%al
  801191:	7e 19                	jle    8011ac <strtol+0xe4>
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	3c 7a                	cmp    $0x7a,%al
  80119a:	7f 10                	jg     8011ac <strtol+0xe4>
			dig = *s - 'a' + 10;
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	0f be c0             	movsbl %al,%eax
  8011a4:	83 e8 57             	sub    $0x57,%eax
  8011a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011aa:	eb 20                	jmp    8011cc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 40                	cmp    $0x40,%al
  8011b3:	7e 39                	jle    8011ee <strtol+0x126>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 5a                	cmp    $0x5a,%al
  8011bc:	7f 30                	jg     8011ee <strtol+0x126>
			dig = *s - 'A' + 10;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	0f be c0             	movsbl %al,%eax
  8011c6:	83 e8 37             	sub    $0x37,%eax
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011d2:	7d 19                	jge    8011ed <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011d4:	ff 45 08             	incl   0x8(%ebp)
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011de:	89 c2                	mov    %eax,%edx
  8011e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e3:	01 d0                	add    %edx,%eax
  8011e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011e8:	e9 7b ff ff ff       	jmp    801168 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ed:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f2:	74 08                	je     8011fc <strtol+0x134>
		*endptr = (char *) s;
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801200:	74 07                	je     801209 <strtol+0x141>
  801202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801205:	f7 d8                	neg    %eax
  801207:	eb 03                	jmp    80120c <strtol+0x144>
  801209:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <ltostr>:

void
ltostr(long value, char *str)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801214:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80121b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801226:	79 13                	jns    80123b <ltostr+0x2d>
	{
		neg = 1;
  801228:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801235:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801238:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801243:	99                   	cltd   
  801244:	f7 f9                	idiv   %ecx
  801246:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	89 c2                	mov    %eax,%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80125c:	83 c2 30             	add    $0x30,%edx
  80125f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801261:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801264:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801269:	f7 e9                	imul   %ecx
  80126b:	c1 fa 02             	sar    $0x2,%edx
  80126e:	89 c8                	mov    %ecx,%eax
  801270:	c1 f8 1f             	sar    $0x1f,%eax
  801273:	29 c2                	sub    %eax,%edx
  801275:	89 d0                	mov    %edx,%eax
  801277:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80127a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127e:	75 bb                	jne    80123b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801287:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128a:	48                   	dec    %eax
  80128b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80128e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801292:	74 3d                	je     8012d1 <ltostr+0xc3>
		start = 1 ;
  801294:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80129b:	eb 34                	jmp    8012d1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80129d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 c2                	add    %eax,%edx
  8012b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 c8                	add    %ecx,%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012cb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ce:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d7:	7c c4                	jl     80129d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 d0                	add    %edx,%eax
  8012e1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ed:	ff 75 08             	pushl  0x8(%ebp)
  8012f0:	e8 c4 f9 ff ff       	call   800cb9 <strlen>
  8012f5:	83 c4 04             	add    $0x4,%esp
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	e8 b6 f9 ff ff       	call   800cb9 <strlen>
  801303:	83 c4 04             	add    $0x4,%esp
  801306:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801310:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801317:	eb 17                	jmp    801330 <strcconcat+0x49>
		final[s] = str1[s] ;
  801319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
  80131f:	01 c2                	add    %eax,%edx
  801321:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	01 c8                	add    %ecx,%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80132d:	ff 45 fc             	incl   -0x4(%ebp)
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801336:	7c e1                	jl     801319 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80133f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801346:	eb 1f                	jmp    801367 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134b:	8d 50 01             	lea    0x1(%eax),%edx
  80134e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 c2                	add    %eax,%edx
  801358:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 c8                	add    %ecx,%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801364:	ff 45 f8             	incl   -0x8(%ebp)
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136d:	7c d9                	jl     801348 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	c6 00 00             	movb   $0x0,(%eax)
}
  80137a:	90                   	nop
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801389:	8b 45 14             	mov    0x14(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a0:	eb 0c                	jmp    8013ae <strsplit+0x31>
			*string++ = 0;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8d 50 01             	lea    0x1(%eax),%edx
  8013a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ab:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	84 c0                	test   %al,%al
  8013b5:	74 18                	je     8013cf <strsplit+0x52>
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	0f be c0             	movsbl %al,%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	e8 83 fa ff ff       	call   800e4b <strchr>
  8013c8:	83 c4 08             	add    $0x8,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 d3                	jne    8013a2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	84 c0                	test   %al,%al
  8013d6:	74 5a                	je     801432 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	83 f8 0f             	cmp    $0xf,%eax
  8013e0:	75 07                	jne    8013e9 <strsplit+0x6c>
		{
			return 0;
  8013e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e7:	eb 66                	jmp    80144f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8013f1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013f4:	89 0a                	mov    %ecx,(%edx)
  8013f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	01 c2                	add    %eax,%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801407:	eb 03                	jmp    80140c <strsplit+0x8f>
			string++;
  801409:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	84 c0                	test   %al,%al
  801413:	74 8b                	je     8013a0 <strsplit+0x23>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	0f be c0             	movsbl %al,%eax
  80141d:	50                   	push   %eax
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	e8 25 fa ff ff       	call   800e4b <strchr>
  801426:	83 c4 08             	add    $0x8,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 dc                	je     801409 <strsplit+0x8c>
			string++;
	}
  80142d:	e9 6e ff ff ff       	jmp    8013a0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801432:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143f:	8b 45 10             	mov    0x10(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80144a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801464:	eb 4a                	jmp    8014b0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801466:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	01 c2                	add    %eax,%edx
  80146e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 c8                	add    %ecx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80147a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 40                	cmp    $0x40,%al
  801486:	7e 25                	jle    8014ad <str2lower+0x5c>
  801488:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	3c 5a                	cmp    $0x5a,%al
  801494:	7f 17                	jg     8014ad <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	01 d0                	add    %edx,%eax
  80149e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a4:	01 ca                	add    %ecx,%edx
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	83 c2 20             	add    $0x20,%edx
  8014ab:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014ad:	ff 45 fc             	incl   -0x4(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	e8 01 f8 ff ff       	call   800cb9 <strlen>
  8014b8:	83 c4 04             	add    $0x4,%esp
  8014bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014be:	7f a6                	jg     801466 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8014cb:	83 ec 0c             	sub    $0xc,%esp
  8014ce:	6a 10                	push   $0x10
  8014d0:	e8 b2 15 00 00       	call   802a87 <alloc_block>
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8014db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014df:	75 14                	jne    8014f5 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	68 48 3f 80 00       	push   $0x803f48
  8014e9:	6a 14                	push   $0x14
  8014eb:	68 71 3f 80 00       	push   $0x803f71
  8014f0:	e8 fd ed ff ff       	call   8002f2 <_panic>

	node->start = start;
  8014f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fb:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8014fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801500:	8b 55 0c             	mov    0xc(%ebp),%edx
  801503:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801506:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80150d:	a1 24 50 80 00       	mov    0x805024,%eax
  801512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801515:	eb 18                	jmp    80152f <insert_page_alloc+0x6a>
		if (start < it->start)
  801517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151a:	8b 00                	mov    (%eax),%eax
  80151c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80151f:	77 37                	ja     801558 <insert_page_alloc+0x93>
			break;
		prev = it;
  801521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801524:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801527:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80152c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80152f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801533:	74 08                	je     80153d <insert_page_alloc+0x78>
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	8b 40 08             	mov    0x8(%eax),%eax
  80153b:	eb 05                	jmp    801542 <insert_page_alloc+0x7d>
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801547:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 c7                	jne    801517 <insert_page_alloc+0x52>
  801550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801554:	75 c1                	jne    801517 <insert_page_alloc+0x52>
  801556:	eb 01                	jmp    801559 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801558:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155d:	75 64                	jne    8015c3 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80155f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801563:	75 14                	jne    801579 <insert_page_alloc+0xb4>
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	68 80 3f 80 00       	push   $0x803f80
  80156d:	6a 21                	push   $0x21
  80156f:	68 71 3f 80 00       	push   $0x803f71
  801574:	e8 79 ed ff ff       	call   8002f2 <_panic>
  801579:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80157f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801582:	89 50 08             	mov    %edx,0x8(%eax)
  801585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801588:	8b 40 08             	mov    0x8(%eax),%eax
  80158b:	85 c0                	test   %eax,%eax
  80158d:	74 0d                	je     80159c <insert_page_alloc+0xd7>
  80158f:	a1 24 50 80 00       	mov    0x805024,%eax
  801594:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801597:	89 50 0c             	mov    %edx,0xc(%eax)
  80159a:	eb 08                	jmp    8015a4 <insert_page_alloc+0xdf>
  80159c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159f:	a3 28 50 80 00       	mov    %eax,0x805028
  8015a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a7:	a3 24 50 80 00       	mov    %eax,0x805024
  8015ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8015b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8015bb:	40                   	inc    %eax
  8015bc:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8015c1:	eb 71                	jmp    801634 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8015c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015c7:	74 06                	je     8015cf <insert_page_alloc+0x10a>
  8015c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015cd:	75 14                	jne    8015e3 <insert_page_alloc+0x11e>
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 a4 3f 80 00       	push   $0x803fa4
  8015d7:	6a 23                	push   $0x23
  8015d9:	68 71 3f 80 00       	push   $0x803f71
  8015de:	e8 0f ed ff ff       	call   8002f2 <_panic>
  8015e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e6:	8b 50 08             	mov    0x8(%eax),%edx
  8015e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ec:	89 50 08             	mov    %edx,0x8(%eax)
  8015ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f2:	8b 40 08             	mov    0x8(%eax),%eax
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	74 0c                	je     801605 <insert_page_alloc+0x140>
  8015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fc:	8b 40 08             	mov    0x8(%eax),%eax
  8015ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801602:	89 50 0c             	mov    %edx,0xc(%eax)
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80160b:	89 50 08             	mov    %edx,0x8(%eax)
  80160e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801611:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801614:	89 50 0c             	mov    %edx,0xc(%eax)
  801617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161a:	8b 40 08             	mov    0x8(%eax),%eax
  80161d:	85 c0                	test   %eax,%eax
  80161f:	75 08                	jne    801629 <insert_page_alloc+0x164>
  801621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801624:	a3 28 50 80 00       	mov    %eax,0x805028
  801629:	a1 30 50 80 00       	mov    0x805030,%eax
  80162e:	40                   	inc    %eax
  80162f:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80163d:	a1 24 50 80 00       	mov    0x805024,%eax
  801642:	85 c0                	test   %eax,%eax
  801644:	75 0c                	jne    801652 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801646:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80164b:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801650:	eb 67                	jmp    8016b9 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801652:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801657:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80165a:	a1 24 50 80 00       	mov    0x805024,%eax
  80165f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801662:	eb 26                	jmp    80168a <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801664:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801667:	8b 10                	mov    (%eax),%edx
  801669:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166c:	8b 40 04             	mov    0x4(%eax),%eax
  80166f:	01 d0                	add    %edx,%eax
  801671:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80167a:	76 06                	jbe    801682 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80167c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801682:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801687:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80168a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80168e:	74 08                	je     801698 <recompute_page_alloc_break+0x61>
  801690:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801693:	8b 40 08             	mov    0x8(%eax),%eax
  801696:	eb 05                	jmp    80169d <recompute_page_alloc_break+0x66>
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
  80169d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	75 b9                	jne    801664 <recompute_page_alloc_break+0x2d>
  8016ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016af:	75 b3                	jne    801664 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8016b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b4:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8016c1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8016c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016ce:	01 d0                	add    %edx,%eax
  8016d0:	48                   	dec    %eax
  8016d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dc:	f7 75 d8             	divl   -0x28(%ebp)
  8016df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016e2:	29 d0                	sub    %edx,%eax
  8016e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8016e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8016eb:	75 0a                	jne    8016f7 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	e9 7e 01 00 00       	jmp    801875 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8016f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8016fe:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801702:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801709:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801710:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801718:	a1 24 50 80 00       	mov    0x805024,%eax
  80171d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801720:	eb 69                	jmp    80178b <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80172a:	76 47                	jbe    801773 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80172c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80173a:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80173d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801740:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801743:	72 2e                	jb     801773 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801745:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801749:	75 14                	jne    80175f <alloc_pages_custom_fit+0xa4>
  80174b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80174e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801751:	75 0c                	jne    80175f <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801753:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801759:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80175d:	eb 14                	jmp    801773 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80175f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801762:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801765:	76 0c                	jbe    801773 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801767:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80176a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80176d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801770:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801773:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801776:	8b 10                	mov    (%eax),%edx
  801778:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177b:	8b 40 04             	mov    0x4(%eax),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801783:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801788:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80178b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80178f:	74 08                	je     801799 <alloc_pages_custom_fit+0xde>
  801791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801794:	8b 40 08             	mov    0x8(%eax),%eax
  801797:	eb 05                	jmp    80179e <alloc_pages_custom_fit+0xe3>
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	0f 85 72 ff ff ff    	jne    801722 <alloc_pages_custom_fit+0x67>
  8017b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017b4:	0f 85 68 ff ff ff    	jne    801722 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8017ba:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017c2:	76 47                	jbe    80180b <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8017c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8017ca:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017cf:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8017d2:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8017d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017d8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017db:	72 2e                	jb     80180b <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8017dd:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017e1:	75 14                	jne    8017f7 <alloc_pages_custom_fit+0x13c>
  8017e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017e6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017e9:	75 0c                	jne    8017f7 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8017eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8017f1:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8017f5:	eb 14                	jmp    80180b <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8017f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017fa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017fd:	76 0c                	jbe    80180b <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8017ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801802:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801805:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801808:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80180b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801812:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801816:	74 08                	je     801820 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80181e:	eb 40                	jmp    801860 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801820:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801824:	74 08                	je     80182e <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801829:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80182c:	eb 32                	jmp    801860 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80182e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801833:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801836:	89 c2                	mov    %eax,%edx
  801838:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80183d:	39 c2                	cmp    %eax,%edx
  80183f:	73 07                	jae    801848 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	eb 2d                	jmp    801875 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801848:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80184d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801850:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801856:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801859:	01 d0                	add    %edx,%eax
  80185b:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801860:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	ff 75 d0             	pushl  -0x30(%ebp)
  801869:	50                   	push   %eax
  80186a:	e8 56 fc ff ff       	call   8014c5 <insert_page_alloc>
  80186f:	83 c4 10             	add    $0x10,%esp

	return result;
  801872:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801883:	a1 24 50 80 00       	mov    0x805024,%eax
  801888:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80188b:	eb 1a                	jmp    8018a7 <find_allocated_size+0x30>
		if (it->start == va)
  80188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801890:	8b 00                	mov    (%eax),%eax
  801892:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801895:	75 08                	jne    80189f <find_allocated_size+0x28>
			return it->size;
  801897:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80189a:	8b 40 04             	mov    0x4(%eax),%eax
  80189d:	eb 34                	jmp    8018d3 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80189f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 08                	je     8018b5 <find_allocated_size+0x3e>
  8018ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b0:	8b 40 08             	mov    0x8(%eax),%eax
  8018b3:	eb 05                	jmp    8018ba <find_allocated_size+0x43>
  8018b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018bf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 c5                	jne    80188d <find_allocated_size+0x16>
  8018c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018cc:	75 bf                	jne    80188d <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8018ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018e1:	a1 24 50 80 00       	mov    0x805024,%eax
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018e9:	e9 e1 01 00 00       	jmp    801acf <free_pages+0x1fa>
		if (it->start == va) {
  8018ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f1:	8b 00                	mov    (%eax),%eax
  8018f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8018f6:	0f 85 cb 01 00 00    	jne    801ac7 <free_pages+0x1f2>

			uint32 start = it->start;
  8018fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	8b 40 04             	mov    0x4(%eax),%eax
  80190a:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80190d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801910:	f7 d0                	not    %eax
  801912:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801915:	73 1d                	jae    801934 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80191d:	ff 75 e8             	pushl  -0x18(%ebp)
  801920:	68 d8 3f 80 00       	push   $0x803fd8
  801925:	68 a5 00 00 00       	push   $0xa5
  80192a:	68 71 3f 80 00       	push   $0x803f71
  80192f:	e8 be e9 ff ff       	call   8002f2 <_panic>
			}

			uint32 start_end = start + size;
  801934:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80193f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801942:	85 c0                	test   %eax,%eax
  801944:	79 19                	jns    80195f <free_pages+0x8a>
  801946:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80194d:	77 10                	ja     80195f <free_pages+0x8a>
  80194f:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801956:	77 07                	ja     80195f <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195b:	85 c0                	test   %eax,%eax
  80195d:	78 2c                	js     80198b <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80195f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	68 00 00 00 a0       	push   $0xa0000000
  80196a:	ff 75 e0             	pushl  -0x20(%ebp)
  80196d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801970:	ff 75 e8             	pushl  -0x18(%ebp)
  801973:	ff 75 e4             	pushl  -0x1c(%ebp)
  801976:	50                   	push   %eax
  801977:	68 1c 40 80 00       	push   $0x80401c
  80197c:	68 ad 00 00 00       	push   $0xad
  801981:	68 71 3f 80 00       	push   $0x803f71
  801986:	e8 67 e9 ff ff       	call   8002f2 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80198b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80198e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801991:	e9 88 00 00 00       	jmp    801a1e <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801996:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  80199d:	76 17                	jbe    8019b6 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  80199f:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a2:	68 80 40 80 00       	push   $0x804080
  8019a7:	68 b4 00 00 00       	push   $0xb4
  8019ac:	68 71 3f 80 00       	push   $0x803f71
  8019b1:	e8 3c e9 ff ff       	call   8002f2 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8019b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b9:	05 00 10 00 00       	add    $0x1000,%eax
  8019be:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	79 2e                	jns    8019f6 <free_pages+0x121>
  8019c8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8019cf:	77 25                	ja     8019f6 <free_pages+0x121>
  8019d1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8019d8:	77 1c                	ja     8019f6 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	68 00 10 00 00       	push   $0x1000
  8019e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e5:	e8 38 0d 00 00       	call   802722 <sys_free_user_mem>
  8019ea:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019ed:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8019f4:	eb 28                	jmp    801a1e <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8019f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f9:	68 00 00 00 a0       	push   $0xa0000000
  8019fe:	ff 75 dc             	pushl  -0x24(%ebp)
  801a01:	68 00 10 00 00       	push   $0x1000
  801a06:	ff 75 f0             	pushl  -0x10(%ebp)
  801a09:	50                   	push   %eax
  801a0a:	68 c0 40 80 00       	push   $0x8040c0
  801a0f:	68 bd 00 00 00       	push   $0xbd
  801a14:	68 71 3f 80 00       	push   $0x803f71
  801a19:	e8 d4 e8 ff ff       	call   8002f2 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a24:	0f 82 6c ff ff ff    	jb     801996 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a2e:	75 17                	jne    801a47 <free_pages+0x172>
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	68 22 41 80 00       	push   $0x804122
  801a38:	68 c1 00 00 00       	push   $0xc1
  801a3d:	68 71 3f 80 00       	push   $0x803f71
  801a42:	e8 ab e8 ff ff       	call   8002f2 <_panic>
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	8b 40 08             	mov    0x8(%eax),%eax
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	74 11                	je     801a62 <free_pages+0x18d>
  801a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a54:	8b 40 08             	mov    0x8(%eax),%eax
  801a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a5d:	89 50 0c             	mov    %edx,0xc(%eax)
  801a60:	eb 0b                	jmp    801a6d <free_pages+0x198>
  801a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a65:	8b 40 0c             	mov    0xc(%eax),%eax
  801a68:	a3 28 50 80 00       	mov    %eax,0x805028
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	85 c0                	test   %eax,%eax
  801a75:	74 11                	je     801a88 <free_pages+0x1b3>
  801a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a80:	8b 52 08             	mov    0x8(%edx),%edx
  801a83:	89 50 08             	mov    %edx,0x8(%eax)
  801a86:	eb 0b                	jmp    801a93 <free_pages+0x1be>
  801a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8b:	8b 40 08             	mov    0x8(%eax),%eax
  801a8e:	a3 24 50 80 00       	mov    %eax,0x805024
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801aa7:	a1 30 50 80 00       	mov    0x805030,%eax
  801aac:	48                   	dec    %eax
  801aad:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab8:	e8 24 15 00 00       	call   802fe1 <free_block>
  801abd:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801ac0:	e8 72 fb ff ff       	call   801637 <recompute_page_alloc_break>

			return;
  801ac5:	eb 37                	jmp    801afe <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ac7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ad3:	74 08                	je     801add <free_pages+0x208>
  801ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad8:	8b 40 08             	mov    0x8(%eax),%eax
  801adb:	eb 05                	jmp    801ae2 <free_pages+0x20d>
  801add:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ae7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	0f 85 fa fd ff ff    	jne    8018ee <free_pages+0x19>
  801af4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af8:	0f 85 f0 fd ff ff    	jne    8018ee <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b10:	a1 08 50 80 00       	mov    0x805008,%eax
  801b15:	85 c0                	test   %eax,%eax
  801b17:	74 60                	je     801b79 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b19:	83 ec 08             	sub    $0x8,%esp
  801b1c:	68 00 00 00 82       	push   $0x82000000
  801b21:	68 00 00 00 80       	push   $0x80000000
  801b26:	e8 0d 0d 00 00       	call   802838 <initialize_dynamic_allocator>
  801b2b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b2e:	e8 f3 0a 00 00       	call   802626 <sys_get_uheap_strategy>
  801b33:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b38:	a1 40 50 80 00       	mov    0x805040,%eax
  801b3d:	05 00 10 00 00       	add    $0x1000,%eax
  801b42:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b47:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b4c:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801b51:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801b58:	00 00 00 
  801b5b:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801b62:	00 00 00 
  801b65:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801b6c:	00 00 00 

		__firstTimeFlag = 0;
  801b6f:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801b76:	00 00 00 
	}
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b90:	83 ec 08             	sub    $0x8,%esp
  801b93:	68 06 04 00 00       	push   $0x406
  801b98:	50                   	push   %eax
  801b99:	e8 d2 06 00 00       	call   802270 <__sys_allocate_page>
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ba4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba8:	79 17                	jns    801bc1 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	68 40 41 80 00       	push   $0x804140
  801bb2:	68 ea 00 00 00       	push   $0xea
  801bb7:	68 71 3f 80 00       	push   $0x803f71
  801bbc:	e8 31 e7 ff ff       	call   8002f2 <_panic>
	return 0;
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bdc:	83 ec 0c             	sub    $0xc,%esp
  801bdf:	50                   	push   %eax
  801be0:	e8 d2 06 00 00       	call   8022b7 <__sys_unmap_frame>
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801beb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bef:	79 17                	jns    801c08 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	68 7c 41 80 00       	push   $0x80417c
  801bf9:	68 f5 00 00 00       	push   $0xf5
  801bfe:	68 71 3f 80 00       	push   $0x803f71
  801c03:	e8 ea e6 ff ff       	call   8002f2 <_panic>
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c11:	e8 f4 fe ff ff       	call   801b0a <uheap_init>
	if (size == 0) return NULL ;
  801c16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c1a:	75 0a                	jne    801c26 <malloc+0x1b>
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c21:	e9 67 01 00 00       	jmp    801d8d <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801c26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801c2d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c34:	77 16                	ja     801c4c <malloc+0x41>
		result = alloc_block(size);
  801c36:	83 ec 0c             	sub    $0xc,%esp
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	e8 46 0e 00 00       	call   802a87 <alloc_block>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c47:	e9 3e 01 00 00       	jmp    801d8a <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801c4c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c53:	8b 55 08             	mov    0x8(%ebp),%edx
  801c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	48                   	dec    %eax
  801c5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
  801c67:	f7 75 f0             	divl   -0x10(%ebp)
  801c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6d:	29 d0                	sub    %edx,%eax
  801c6f:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801c72:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c77:	85 c0                	test   %eax,%eax
  801c79:	75 0a                	jne    801c85 <malloc+0x7a>
			return NULL;
  801c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c80:	e9 08 01 00 00       	jmp    801d8d <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801c85:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	74 0f                	je     801c9d <malloc+0x92>
  801c8e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801c94:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c99:	39 c2                	cmp    %eax,%edx
  801c9b:	73 0a                	jae    801ca7 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801c9d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ca2:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801ca7:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801cac:	83 f8 05             	cmp    $0x5,%eax
  801caf:	75 11                	jne    801cc2 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801cb1:	83 ec 0c             	sub    $0xc,%esp
  801cb4:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb7:	e8 ff f9 ff ff       	call   8016bb <alloc_pages_custom_fit>
  801cbc:	83 c4 10             	add    $0x10,%esp
  801cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801cc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc6:	0f 84 be 00 00 00    	je     801d8a <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd8:	e8 9a fb ff ff       	call   801877 <find_allocated_size>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801ce3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ce7:	75 17                	jne    801d00 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801ce9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cec:	68 bc 41 80 00       	push   $0x8041bc
  801cf1:	68 24 01 00 00       	push   $0x124
  801cf6:	68 71 3f 80 00       	push   $0x803f71
  801cfb:	e8 f2 e5 ff ff       	call   8002f2 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d03:	f7 d0                	not    %eax
  801d05:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d08:	73 1d                	jae    801d27 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	ff 75 e0             	pushl  -0x20(%ebp)
  801d10:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d13:	68 04 42 80 00       	push   $0x804204
  801d18:	68 29 01 00 00       	push   $0x129
  801d1d:	68 71 3f 80 00       	push   $0x803f71
  801d22:	e8 cb e5 ff ff       	call   8002f2 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801d27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2d:	01 d0                	add    %edx,%eax
  801d2f:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d35:	85 c0                	test   %eax,%eax
  801d37:	79 2c                	jns    801d65 <malloc+0x15a>
  801d39:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d40:	77 23                	ja     801d65 <malloc+0x15a>
  801d42:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d49:	77 1a                	ja     801d65 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	79 13                	jns    801d65 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801d52:	83 ec 08             	sub    $0x8,%esp
  801d55:	ff 75 e0             	pushl  -0x20(%ebp)
  801d58:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d5b:	e8 de 09 00 00       	call   80273e <sys_allocate_user_mem>
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	eb 25                	jmp    801d8a <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801d65:	68 00 00 00 a0       	push   $0xa0000000
  801d6a:	ff 75 dc             	pushl  -0x24(%ebp)
  801d6d:	ff 75 e0             	pushl  -0x20(%ebp)
  801d70:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d73:	ff 75 f4             	pushl  -0xc(%ebp)
  801d76:	68 40 42 80 00       	push   $0x804240
  801d7b:	68 33 01 00 00       	push   $0x133
  801d80:	68 71 3f 80 00       	push   $0x803f71
  801d85:	e8 68 e5 ff ff       	call   8002f2 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801d95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d99:	0f 84 26 01 00 00    	je     801ec5 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	85 c0                	test   %eax,%eax
  801daa:	79 1c                	jns    801dc8 <free+0x39>
  801dac:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801db3:	77 13                	ja     801dc8 <free+0x39>
		free_block(virtual_address);
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	e8 21 12 00 00       	call   802fe1 <free_block>
  801dc0:	83 c4 10             	add    $0x10,%esp
		return;
  801dc3:	e9 01 01 00 00       	jmp    801ec9 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801dc8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dcd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801dd0:	0f 82 d8 00 00 00    	jb     801eae <free+0x11f>
  801dd6:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801ddd:	0f 87 cb 00 00 00    	ja     801eae <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	25 ff 0f 00 00       	and    $0xfff,%eax
  801deb:	85 c0                	test   %eax,%eax
  801ded:	74 17                	je     801e06 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	68 b0 42 80 00       	push   $0x8042b0
  801df7:	68 57 01 00 00       	push   $0x157
  801dfc:	68 71 3f 80 00       	push   $0x803f71
  801e01:	e8 ec e4 ff ff       	call   8002f2 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801e06:	83 ec 0c             	sub    $0xc,%esp
  801e09:	ff 75 08             	pushl  0x8(%ebp)
  801e0c:	e8 66 fa ff ff       	call   801877 <find_allocated_size>
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801e17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1b:	0f 84 a7 00 00 00    	je     801ec8 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e24:	f7 d0                	not    %eax
  801e26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e29:	73 1d                	jae    801e48 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e31:	ff 75 f4             	pushl  -0xc(%ebp)
  801e34:	68 d8 42 80 00       	push   $0x8042d8
  801e39:	68 61 01 00 00       	push   $0x161
  801e3e:	68 71 3f 80 00       	push   $0x803f71
  801e43:	e8 aa e4 ff ff       	call   8002f2 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4e:	01 d0                	add    %edx,%eax
  801e50:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e56:	85 c0                	test   %eax,%eax
  801e58:	79 19                	jns    801e73 <free+0xe4>
  801e5a:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801e61:	77 10                	ja     801e73 <free+0xe4>
  801e63:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801e6a:	77 07                	ja     801e73 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 2b                	js     801e9e <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801e73:	83 ec 0c             	sub    $0xc,%esp
  801e76:	68 00 00 00 a0       	push   $0xa0000000
  801e7b:	ff 75 ec             	pushl  -0x14(%ebp)
  801e7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e81:	ff 75 f4             	pushl  -0xc(%ebp)
  801e84:	ff 75 f0             	pushl  -0x10(%ebp)
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	68 14 43 80 00       	push   $0x804314
  801e8f:	68 69 01 00 00       	push   $0x169
  801e94:	68 71 3f 80 00       	push   $0x803f71
  801e99:	e8 54 e4 ff ff       	call   8002f2 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	e8 2c fa ff ff       	call   8018d5 <free_pages>
  801ea9:	83 c4 10             	add    $0x10,%esp
		return;
  801eac:	eb 1b                	jmp    801ec9 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	68 70 43 80 00       	push   $0x804370
  801eb6:	68 70 01 00 00       	push   $0x170
  801ebb:	68 71 3f 80 00       	push   $0x803f71
  801ec0:	e8 2d e4 ff ff       	call   8002f2 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ec5:	90                   	nop
  801ec6:	eb 01                	jmp    801ec9 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801ec8:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 38             	sub    $0x38,%esp
  801ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ed7:	e8 2e fc ff ff       	call   801b0a <uheap_init>
	if (size == 0) return NULL ;
  801edc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ee0:	75 0a                	jne    801eec <smalloc+0x21>
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	e9 3d 01 00 00       	jmp    802029 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef5:	25 ff 0f 00 00       	and    $0xfff,%eax
  801efa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801efd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f01:	74 0e                	je     801f11 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f06:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801f09:	05 00 10 00 00       	add    $0x1000,%eax
  801f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	c1 e8 0c             	shr    $0xc,%eax
  801f17:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801f1a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	75 0a                	jne    801f2d <smalloc+0x62>
		return NULL;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	e9 fc 00 00 00       	jmp    802029 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801f2d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	74 0f                	je     801f45 <smalloc+0x7a>
  801f36:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f3c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f41:	39 c2                	cmp    %eax,%edx
  801f43:	73 0a                	jae    801f4f <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f45:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f4a:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801f4f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f54:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f59:	29 c2                	sub    %eax,%edx
  801f5b:	89 d0                	mov    %edx,%eax
  801f5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801f60:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f66:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f6b:	29 c2                	sub    %eax,%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f78:	77 13                	ja     801f8d <smalloc+0xc2>
  801f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f80:	77 0b                	ja     801f8d <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f85:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f88:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f8b:	73 0a                	jae    801f97 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	e9 92 00 00 00       	jmp    802029 <smalloc+0x15e>
	}

	void *va = NULL;
  801f97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801f9e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801fa3:	83 f8 05             	cmp    $0x5,%eax
  801fa6:	75 11                	jne    801fb9 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	ff 75 f4             	pushl  -0xc(%ebp)
  801fae:	e8 08 f7 ff ff       	call   8016bb <alloc_pages_custom_fit>
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801fb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fbd:	75 27                	jne    801fe6 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801fbf:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801fc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fc9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fd3:	39 c2                	cmp    %eax,%edx
  801fd5:	73 07                	jae    801fde <smalloc+0x113>
			return NULL;}
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	eb 4b                	jmp    802029 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801fde:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801fe6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fea:	ff 75 f0             	pushl  -0x10(%ebp)
  801fed:	50                   	push   %eax
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	e8 cb 03 00 00       	call   8023c4 <sys_create_shared_object>
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801fff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802003:	79 07                	jns    80200c <smalloc+0x141>
		return NULL;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	eb 1d                	jmp    802029 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80200c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802011:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802014:	75 10                	jne    802026 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802016:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	01 d0                	add    %edx,%eax
  802021:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802031:	e8 d4 fa ff ff       	call   801b0a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	e8 aa 03 00 00       	call   8023ee <sys_size_of_shared_object>
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80204a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80204e:	7f 0a                	jg     80205a <sget+0x2f>
		return NULL;
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
  802055:	e9 32 01 00 00       	jmp    80218c <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80205a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802060:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802063:	25 ff 0f 00 00       	and    $0xfff,%eax
  802068:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80206b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80206f:	74 0e                	je     80207f <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802077:	05 00 10 00 00       	add    $0x1000,%eax
  80207c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80207f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802084:	85 c0                	test   %eax,%eax
  802086:	75 0a                	jne    802092 <sget+0x67>
		return NULL;
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
  80208d:	e9 fa 00 00 00       	jmp    80218c <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802092:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802097:	85 c0                	test   %eax,%eax
  802099:	74 0f                	je     8020aa <sget+0x7f>
  80209b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020a1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020a6:	39 c2                	cmp    %eax,%edx
  8020a8:	73 0a                	jae    8020b4 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8020aa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020af:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020b4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020be:	29 c2                	sub    %eax,%edx
  8020c0:	89 d0                	mov    %edx,%eax
  8020c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020c5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020cb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020d0:	29 c2                	sub    %eax,%edx
  8020d2:	89 d0                	mov    %edx,%eax
  8020d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020dd:	77 13                	ja     8020f2 <sget+0xc7>
  8020df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020e5:	77 0b                	ja     8020f2 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8020e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ea:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020ed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020f0:	73 0a                	jae    8020fc <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	e9 90 00 00 00       	jmp    80218c <sget+0x161>

	void *va = NULL;
  8020fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802103:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802108:	83 f8 05             	cmp    $0x5,%eax
  80210b:	75 11                	jne    80211e <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	ff 75 f4             	pushl  -0xc(%ebp)
  802113:	e8 a3 f5 ff ff       	call   8016bb <alloc_pages_custom_fit>
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80211e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802122:	75 27                	jne    80214b <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802124:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80212b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80212e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802131:	89 c2                	mov    %eax,%edx
  802133:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802138:	39 c2                	cmp    %eax,%edx
  80213a:	73 07                	jae    802143 <sget+0x118>
			return NULL;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
  802141:	eb 49                	jmp    80218c <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802143:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802148:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	ff 75 f0             	pushl  -0x10(%ebp)
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	ff 75 08             	pushl  0x8(%ebp)
  802157:	e8 af 02 00 00       	call   80240b <sys_get_shared_object>
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802162:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802166:	79 07                	jns    80216f <sget+0x144>
		return NULL;
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
  80216d:	eb 1d                	jmp    80218c <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80216f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802174:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802177:	75 10                	jne    802189 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802179:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	01 d0                	add    %edx,%eax
  802184:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802194:	e8 71 f9 ff ff       	call   801b0a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 94 43 80 00       	push   $0x804394
  8021a1:	68 19 02 00 00       	push   $0x219
  8021a6:	68 71 3f 80 00       	push   $0x803f71
  8021ab:	e8 42 e1 ff ff       	call   8002f2 <_panic>

008021b0 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	68 bc 43 80 00       	push   $0x8043bc
  8021be:	68 2b 02 00 00       	push   $0x22b
  8021c3:	68 71 3f 80 00       	push   $0x803f71
  8021c8:	e8 25 e1 ff ff       	call   8002f2 <_panic>

008021cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	57                   	push   %edi
  8021d1:	56                   	push   %esi
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021e2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021e5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021e8:	cd 30                	int    $0x30
  8021ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8021ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	5b                   	pop    %ebx
  8021f4:	5e                   	pop    %esi
  8021f5:	5f                   	pop    %edi
  8021f6:	5d                   	pop    %ebp
  8021f7:	c3                   	ret    

008021f8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 04             	sub    $0x4,%esp
  8021fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802201:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802204:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802207:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	6a 00                	push   $0x0
  802210:	51                   	push   %ecx
  802211:	52                   	push   %edx
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	50                   	push   %eax
  802216:	6a 00                	push   $0x0
  802218:	e8 b0 ff ff ff       	call   8021cd <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	90                   	nop
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_cgetc>:

int
sys_cgetc(void)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 02                	push   $0x2
  802232:	e8 96 ff ff ff       	call   8021cd <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 03                	push   $0x3
  80224b:	e8 7d ff ff ff       	call   8021cd <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	90                   	nop
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 04                	push   $0x4
  802265:	e8 63 ff ff ff       	call   8021cd <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	90                   	nop
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802273:	8b 55 0c             	mov    0xc(%ebp),%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	6a 08                	push   $0x8
  802283:	e8 45 ff ff ff       	call   8021cd <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802292:	8b 75 18             	mov    0x18(%ebp),%esi
  802295:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802298:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	56                   	push   %esi
  8022a2:	53                   	push   %ebx
  8022a3:	51                   	push   %ecx
  8022a4:	52                   	push   %edx
  8022a5:	50                   	push   %eax
  8022a6:	6a 09                	push   $0x9
  8022a8:	e8 20 ff ff ff       	call   8021cd <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b3:	5b                   	pop    %ebx
  8022b4:	5e                   	pop    %esi
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    

008022b7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	ff 75 08             	pushl  0x8(%ebp)
  8022c5:	6a 0a                	push   $0xa
  8022c7:	e8 01 ff ff ff       	call   8021cd <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	ff 75 0c             	pushl  0xc(%ebp)
  8022dd:	ff 75 08             	pushl  0x8(%ebp)
  8022e0:	6a 0b                	push   $0xb
  8022e2:	e8 e6 fe ff ff       	call   8021cd <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 0c                	push   $0xc
  8022fb:	e8 cd fe ff ff       	call   8021cd <syscall>
  802300:	83 c4 18             	add    $0x18,%esp
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 0d                	push   $0xd
  802314:	e8 b4 fe ff ff       	call   8021cd <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 0e                	push   $0xe
  80232d:	e8 9b fe ff ff       	call   8021cd <syscall>
  802332:	83 c4 18             	add    $0x18,%esp
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 0f                	push   $0xf
  802346:	e8 82 fe ff ff       	call   8021cd <syscall>
  80234b:	83 c4 18             	add    $0x18,%esp
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	ff 75 08             	pushl  0x8(%ebp)
  80235e:	6a 10                	push   $0x10
  802360:	e8 68 fe ff ff       	call   8021cd <syscall>
  802365:	83 c4 18             	add    $0x18,%esp
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 11                	push   $0x11
  802379:	e8 4f fe ff ff       	call   8021cd <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	90                   	nop
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_cputc>:

void
sys_cputc(const char c)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802390:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	50                   	push   %eax
  80239d:	6a 01                	push   $0x1
  80239f:	e8 29 fe ff ff       	call   8021cd <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	90                   	nop
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 14                	push   $0x14
  8023b9:	e8 0f fe ff ff       	call   8021cd <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	90                   	nop
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	6a 00                	push   $0x0
  8023dc:	51                   	push   %ecx
  8023dd:	52                   	push   %edx
  8023de:	ff 75 0c             	pushl  0xc(%ebp)
  8023e1:	50                   	push   %eax
  8023e2:	6a 15                	push   $0x15
  8023e4:	e8 e4 fd ff ff       	call   8021cd <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	52                   	push   %edx
  8023fe:	50                   	push   %eax
  8023ff:	6a 16                	push   $0x16
  802401:	e8 c7 fd ff ff       	call   8021cd <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80240e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802411:	8b 55 0c             	mov    0xc(%ebp),%edx
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	51                   	push   %ecx
  80241c:	52                   	push   %edx
  80241d:	50                   	push   %eax
  80241e:	6a 17                	push   $0x17
  802420:	e8 a8 fd ff ff       	call   8021cd <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80242d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	52                   	push   %edx
  80243a:	50                   	push   %eax
  80243b:	6a 18                	push   $0x18
  80243d:	e8 8b fd ff ff       	call   8021cd <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	6a 00                	push   $0x0
  80244f:	ff 75 14             	pushl  0x14(%ebp)
  802452:	ff 75 10             	pushl  0x10(%ebp)
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	50                   	push   %eax
  802459:	6a 19                	push   $0x19
  80245b:	e8 6d fd ff ff       	call   8021cd <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	50                   	push   %eax
  802474:	6a 1a                	push   $0x1a
  802476:	e8 52 fd ff ff       	call   8021cd <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	90                   	nop
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	50                   	push   %eax
  802490:	6a 1b                	push   $0x1b
  802492:	e8 36 fd ff ff       	call   8021cd <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 05                	push   $0x5
  8024ab:	e8 1d fd ff ff       	call   8021cd <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 06                	push   $0x6
  8024c4:	e8 04 fd ff ff       	call   8021cd <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 07                	push   $0x7
  8024dd:	e8 eb fc ff ff       	call   8021cd <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <sys_exit_env>:


void sys_exit_env(void)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 1c                	push   $0x1c
  8024f6:	e8 d2 fc ff ff       	call   8021cd <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
}
  8024fe:	90                   	nop
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    

00802501 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802507:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80250a:	8d 50 04             	lea    0x4(%eax),%edx
  80250d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	52                   	push   %edx
  802517:	50                   	push   %eax
  802518:	6a 1d                	push   $0x1d
  80251a:	e8 ae fc ff ff       	call   8021cd <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
	return result;
  802522:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802525:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802528:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80252b:	89 01                	mov    %eax,(%ecx)
  80252d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	c9                   	leave  
  802534:	c2 04 00             	ret    $0x4

00802537 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	ff 75 10             	pushl  0x10(%ebp)
  802541:	ff 75 0c             	pushl  0xc(%ebp)
  802544:	ff 75 08             	pushl  0x8(%ebp)
  802547:	6a 13                	push   $0x13
  802549:	e8 7f fc ff ff       	call   8021cd <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
	return ;
  802551:	90                   	nop
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <sys_rcr2>:
uint32 sys_rcr2()
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 1e                	push   $0x1e
  802563:	e8 65 fc ff ff       	call   8021cd <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	83 ec 04             	sub    $0x4,%esp
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802579:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	50                   	push   %eax
  802586:	6a 1f                	push   $0x1f
  802588:	e8 40 fc ff ff       	call   8021cd <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
	return ;
  802590:	90                   	nop
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <rsttst>:
void rsttst()
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 21                	push   $0x21
  8025a2:	e8 26 fc ff ff       	call   8021cd <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025aa:	90                   	nop
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025b9:	8b 55 18             	mov    0x18(%ebp),%edx
  8025bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025c0:	52                   	push   %edx
  8025c1:	50                   	push   %eax
  8025c2:	ff 75 10             	pushl  0x10(%ebp)
  8025c5:	ff 75 0c             	pushl  0xc(%ebp)
  8025c8:	ff 75 08             	pushl  0x8(%ebp)
  8025cb:	6a 20                	push   $0x20
  8025cd:	e8 fb fb ff ff       	call   8021cd <syscall>
  8025d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d5:	90                   	nop
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <chktst>:
void chktst(uint32 n)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	ff 75 08             	pushl  0x8(%ebp)
  8025e6:	6a 22                	push   $0x22
  8025e8:	e8 e0 fb ff ff       	call   8021cd <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f0:	90                   	nop
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <inctst>:

void inctst()
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 23                	push   $0x23
  802602:	e8 c6 fb ff ff       	call   8021cd <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
	return ;
  80260a:	90                   	nop
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <gettst>:
uint32 gettst()
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 24                	push   $0x24
  80261c:	e8 ac fb ff ff       	call   8021cd <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 25                	push   $0x25
  802635:	e8 93 fb ff ff       	call   8021cd <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
  80263d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802642:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	ff 75 08             	pushl  0x8(%ebp)
  80265f:	6a 26                	push   $0x26
  802661:	e8 67 fb ff ff       	call   8021cd <syscall>
  802666:	83 c4 18             	add    $0x18,%esp
	return ;
  802669:	90                   	nop
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802670:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802673:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802676:	8b 55 0c             	mov    0xc(%ebp),%edx
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	6a 00                	push   $0x0
  80267e:	53                   	push   %ebx
  80267f:	51                   	push   %ecx
  802680:	52                   	push   %edx
  802681:	50                   	push   %eax
  802682:	6a 27                	push   $0x27
  802684:	e8 44 fb ff ff       	call   8021cd <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
}
  80268c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802694:	8b 55 0c             	mov    0xc(%ebp),%edx
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	52                   	push   %edx
  8026a1:	50                   	push   %eax
  8026a2:	6a 28                	push   $0x28
  8026a4:	e8 24 fb ff ff       	call   8021cd <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	6a 00                	push   $0x0
  8026bc:	51                   	push   %ecx
  8026bd:	ff 75 10             	pushl  0x10(%ebp)
  8026c0:	52                   	push   %edx
  8026c1:	50                   	push   %eax
  8026c2:	6a 29                	push   $0x29
  8026c4:	e8 04 fb ff ff       	call   8021cd <syscall>
  8026c9:	83 c4 18             	add    $0x18,%esp
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	ff 75 10             	pushl  0x10(%ebp)
  8026d8:	ff 75 0c             	pushl  0xc(%ebp)
  8026db:	ff 75 08             	pushl  0x8(%ebp)
  8026de:	6a 12                	push   $0x12
  8026e0:	e8 e8 fa ff ff       	call   8021cd <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e8:	90                   	nop
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	52                   	push   %edx
  8026fb:	50                   	push   %eax
  8026fc:	6a 2a                	push   $0x2a
  8026fe:	e8 ca fa ff ff       	call   8021cd <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
	return;
  802706:	90                   	nop
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 2b                	push   $0x2b
  802718:	e8 b0 fa ff ff       	call   8021cd <syscall>
  80271d:	83 c4 18             	add    $0x18,%esp
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	ff 75 0c             	pushl  0xc(%ebp)
  80272e:	ff 75 08             	pushl  0x8(%ebp)
  802731:	6a 2d                	push   $0x2d
  802733:	e8 95 fa ff ff       	call   8021cd <syscall>
  802738:	83 c4 18             	add    $0x18,%esp
	return;
  80273b:	90                   	nop
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	ff 75 0c             	pushl  0xc(%ebp)
  80274a:	ff 75 08             	pushl  0x8(%ebp)
  80274d:	6a 2c                	push   $0x2c
  80274f:	e8 79 fa ff ff       	call   8021cd <syscall>
  802754:	83 c4 18             	add    $0x18,%esp
	return ;
  802757:	90                   	nop
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80275d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	52                   	push   %edx
  80276a:	50                   	push   %eax
  80276b:	6a 2e                	push   $0x2e
  80276d:	e8 5b fa ff ff       	call   8021cd <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
	return ;
  802775:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80277e:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802785:	72 09                	jb     802790 <to_page_va+0x18>
  802787:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  80278e:	72 14                	jb     8027a4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	68 e0 43 80 00       	push   $0x8043e0
  802798:	6a 15                	push   $0x15
  80279a:	68 0b 44 80 00       	push   $0x80440b
  80279f:	e8 4e db ff ff       	call   8002f2 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	ba 60 50 80 00       	mov    $0x805060,%edx
  8027ac:	29 d0                	sub    %edx,%eax
  8027ae:	c1 f8 02             	sar    $0x2,%eax
  8027b1:	89 c2                	mov    %eax,%edx
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	c1 e0 02             	shl    $0x2,%eax
  8027b8:	01 d0                	add    %edx,%eax
  8027ba:	c1 e0 02             	shl    $0x2,%eax
  8027bd:	01 d0                	add    %edx,%eax
  8027bf:	c1 e0 02             	shl    $0x2,%eax
  8027c2:	01 d0                	add    %edx,%eax
  8027c4:	89 c1                	mov    %eax,%ecx
  8027c6:	c1 e1 08             	shl    $0x8,%ecx
  8027c9:	01 c8                	add    %ecx,%eax
  8027cb:	89 c1                	mov    %eax,%ecx
  8027cd:	c1 e1 10             	shl    $0x10,%ecx
  8027d0:	01 c8                	add    %ecx,%eax
  8027d2:	01 c0                	add    %eax,%eax
  8027d4:	01 d0                	add    %edx,%eax
  8027d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	c1 e0 0c             	shl    $0xc,%eax
  8027df:	89 c2                	mov    %eax,%edx
  8027e1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027e6:	01 d0                	add    %edx,%eax
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8027f0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f8:	29 c2                	sub    %eax,%edx
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	c1 e8 0c             	shr    $0xc,%eax
  8027ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802806:	78 09                	js     802811 <to_page_info+0x27>
  802808:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80280f:	7e 14                	jle    802825 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	68 24 44 80 00       	push   $0x804424
  802819:	6a 22                	push   $0x22
  80281b:	68 0b 44 80 00       	push   $0x80440b
  802820:	e8 cd da ff ff       	call   8002f2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802828:	89 d0                	mov    %edx,%eax
  80282a:	01 c0                	add    %eax,%eax
  80282c:	01 d0                	add    %edx,%eax
  80282e:	c1 e0 02             	shl    $0x2,%eax
  802831:	05 60 50 80 00       	add    $0x805060,%eax
}
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	05 00 00 00 02       	add    $0x2000000,%eax
  802846:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802849:	73 16                	jae    802861 <initialize_dynamic_allocator+0x29>
  80284b:	68 48 44 80 00       	push   $0x804448
  802850:	68 6e 44 80 00       	push   $0x80446e
  802855:	6a 34                	push   $0x34
  802857:	68 0b 44 80 00       	push   $0x80440b
  80285c:	e8 91 da ff ff       	call   8002f2 <_panic>
		is_initialized = 1;
  802861:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802868:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802873:	8b 45 0c             	mov    0xc(%ebp),%eax
  802876:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  80287b:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802882:	00 00 00 
  802885:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80288c:	00 00 00 
  80288f:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802896:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802899:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8028a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028a7:	eb 36                	jmp    8028df <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	c1 e0 04             	shl    $0x4,%eax
  8028af:	05 80 d0 81 00       	add    $0x81d080,%eax
  8028b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	c1 e0 04             	shl    $0x4,%eax
  8028c0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8028c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	c1 e0 04             	shl    $0x4,%eax
  8028d1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8028d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8028dc:	ff 45 f4             	incl   -0xc(%ebp)
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028e5:	72 c2                	jb     8028a9 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8028e7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028ed:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028f2:	29 c2                	sub    %eax,%edx
  8028f4:	89 d0                	mov    %edx,%eax
  8028f6:	c1 e8 0c             	shr    $0xc,%eax
  8028f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8028fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802903:	e9 c8 00 00 00       	jmp    8029d0 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290b:	89 d0                	mov    %edx,%eax
  80290d:	01 c0                	add    %eax,%eax
  80290f:	01 d0                	add    %edx,%eax
  802911:	c1 e0 02             	shl    $0x2,%eax
  802914:	05 68 50 80 00       	add    $0x805068,%eax
  802919:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80291e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802921:	89 d0                	mov    %edx,%eax
  802923:	01 c0                	add    %eax,%eax
  802925:	01 d0                	add    %edx,%eax
  802927:	c1 e0 02             	shl    $0x2,%eax
  80292a:	05 6a 50 80 00       	add    $0x80506a,%eax
  80292f:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802934:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80293a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80293d:	89 c8                	mov    %ecx,%eax
  80293f:	01 c0                	add    %eax,%eax
  802941:	01 c8                	add    %ecx,%eax
  802943:	c1 e0 02             	shl    $0x2,%eax
  802946:	05 64 50 80 00       	add    $0x805064,%eax
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802950:	89 d0                	mov    %edx,%eax
  802952:	01 c0                	add    %eax,%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	c1 e0 02             	shl    $0x2,%eax
  802959:	05 64 50 80 00       	add    $0x805064,%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	74 1b                	je     80297f <initialize_dynamic_allocator+0x147>
  802964:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80296a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80296d:	89 c8                	mov    %ecx,%eax
  80296f:	01 c0                	add    %eax,%eax
  802971:	01 c8                	add    %ecx,%eax
  802973:	c1 e0 02             	shl    $0x2,%eax
  802976:	05 60 50 80 00       	add    $0x805060,%eax
  80297b:	89 02                	mov    %eax,(%edx)
  80297d:	eb 16                	jmp    802995 <initialize_dynamic_allocator+0x15d>
  80297f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802982:	89 d0                	mov    %edx,%eax
  802984:	01 c0                	add    %eax,%eax
  802986:	01 d0                	add    %edx,%eax
  802988:	c1 e0 02             	shl    $0x2,%eax
  80298b:	05 60 50 80 00       	add    $0x805060,%eax
  802990:	a3 48 50 80 00       	mov    %eax,0x805048
  802995:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802998:	89 d0                	mov    %edx,%eax
  80299a:	01 c0                	add    %eax,%eax
  80299c:	01 d0                	add    %edx,%eax
  80299e:	c1 e0 02             	shl    $0x2,%eax
  8029a1:	05 60 50 80 00       	add    $0x805060,%eax
  8029a6:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ae:	89 d0                	mov    %edx,%eax
  8029b0:	01 c0                	add    %eax,%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	c1 e0 02             	shl    $0x2,%eax
  8029b7:	05 60 50 80 00       	add    $0x805060,%eax
  8029bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c2:	a1 54 50 80 00       	mov    0x805054,%eax
  8029c7:	40                   	inc    %eax
  8029c8:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8029cd:	ff 45 f0             	incl   -0x10(%ebp)
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029d6:	0f 82 2c ff ff ff    	jb     802908 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8029dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029e2:	eb 2f                	jmp    802a13 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8029e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e7:	89 d0                	mov    %edx,%eax
  8029e9:	01 c0                	add    %eax,%eax
  8029eb:	01 d0                	add    %edx,%eax
  8029ed:	c1 e0 02             	shl    $0x2,%eax
  8029f0:	05 68 50 80 00       	add    $0x805068,%eax
  8029f5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8029fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fd:	89 d0                	mov    %edx,%eax
  8029ff:	01 c0                	add    %eax,%eax
  802a01:	01 d0                	add    %edx,%eax
  802a03:	c1 e0 02             	shl    $0x2,%eax
  802a06:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a0b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a10:	ff 45 ec             	incl   -0x14(%ebp)
  802a13:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802a1a:	76 c8                	jbe    8029e4 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802a1c:	90                   	nop
  802a1d:	c9                   	leave  
  802a1e:	c3                   	ret    

00802a1f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802a1f:	55                   	push   %ebp
  802a20:	89 e5                	mov    %esp,%ebp
  802a22:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802a25:	8b 55 08             	mov    0x8(%ebp),%edx
  802a28:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a2d:	29 c2                	sub    %eax,%edx
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	c1 e8 0c             	shr    $0xc,%eax
  802a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802a37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a3a:	89 d0                	mov    %edx,%eax
  802a3c:	01 c0                	add    %eax,%eax
  802a3e:	01 d0                	add    %edx,%eax
  802a40:	c1 e0 02             	shl    $0x2,%eax
  802a43:	05 68 50 80 00       	add    $0x805068,%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	83 ec 14             	sub    $0x14,%esp
  802a55:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802a58:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802a5c:	77 07                	ja     802a65 <nearest_pow2_ceil.1513+0x16>
  802a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a63:	eb 20                	jmp    802a85 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802a65:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802a6c:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802a6f:	eb 08                	jmp    802a79 <nearest_pow2_ceil.1513+0x2a>
  802a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a74:	01 c0                	add    %eax,%eax
  802a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a79:	d1 6d 08             	shrl   0x8(%ebp)
  802a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a80:	75 ef                	jne    802a71 <nearest_pow2_ceil.1513+0x22>
        return power;
  802a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802a8d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802a94:	76 16                	jbe    802aac <alloc_block+0x25>
  802a96:	68 84 44 80 00       	push   $0x804484
  802a9b:	68 6e 44 80 00       	push   $0x80446e
  802aa0:	6a 72                	push   $0x72
  802aa2:	68 0b 44 80 00       	push   $0x80440b
  802aa7:	e8 46 d8 ff ff       	call   8002f2 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802aac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab0:	75 0a                	jne    802abc <alloc_block+0x35>
  802ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab7:	e9 bd 04 00 00       	jmp    802f79 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802abc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ac9:	73 06                	jae    802ad1 <alloc_block+0x4a>
        size = min_block_size;
  802acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ace:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802ad1:	83 ec 0c             	sub    $0xc,%esp
  802ad4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802ad7:	ff 75 08             	pushl  0x8(%ebp)
  802ada:	89 c1                	mov    %eax,%ecx
  802adc:	e8 6e ff ff ff       	call   802a4f <nearest_pow2_ceil.1513>
  802ae1:	83 c4 10             	add    $0x10,%esp
  802ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802ae7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aea:	83 ec 0c             	sub    $0xc,%esp
  802aed:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802af0:	52                   	push   %edx
  802af1:	89 c1                	mov    %eax,%ecx
  802af3:	e8 83 04 00 00       	call   802f7b <log2_ceil.1520>
  802af8:	83 c4 10             	add    $0x10,%esp
  802afb:	83 e8 03             	sub    $0x3,%eax
  802afe:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b04:	c1 e0 04             	shl    $0x4,%eax
  802b07:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	0f 84 d8 00 00 00    	je     802bee <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b19:	c1 e0 04             	shl    $0x4,%eax
  802b1c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b2a:	75 17                	jne    802b43 <alloc_block+0xbc>
  802b2c:	83 ec 04             	sub    $0x4,%esp
  802b2f:	68 a5 44 80 00       	push   $0x8044a5
  802b34:	68 98 00 00 00       	push   $0x98
  802b39:	68 0b 44 80 00       	push   $0x80440b
  802b3e:	e8 af d7 ff ff       	call   8002f2 <_panic>
  802b43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	74 10                	je     802b5c <alloc_block+0xd5>
  802b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4f:	8b 00                	mov    (%eax),%eax
  802b51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b54:	8b 52 04             	mov    0x4(%edx),%edx
  802b57:	89 50 04             	mov    %edx,0x4(%eax)
  802b5a:	eb 14                	jmp    802b70 <alloc_block+0xe9>
  802b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5f:	8b 40 04             	mov    0x4(%eax),%eax
  802b62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b65:	c1 e2 04             	shl    $0x4,%edx
  802b68:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802b6e:	89 02                	mov    %eax,(%edx)
  802b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 0f                	je     802b89 <alloc_block+0x102>
  802b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b83:	8b 12                	mov    (%edx),%edx
  802b85:	89 10                	mov    %edx,(%eax)
  802b87:	eb 13                	jmp    802b9c <alloc_block+0x115>
  802b89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b91:	c1 e2 04             	shl    $0x4,%edx
  802b94:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802b9a:	89 02                	mov    %eax,(%edx)
  802b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb2:	c1 e0 04             	shl    $0x4,%eax
  802bb5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  802bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc2:	c1 e0 04             	shl    $0x4,%eax
  802bc5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bca:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802bcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcf:	83 ec 0c             	sub    $0xc,%esp
  802bd2:	50                   	push   %eax
  802bd3:	e8 12 fc ff ff       	call   8027ea <to_page_info>
  802bd8:	83 c4 10             	add    $0x10,%esp
  802bdb:	89 c2                	mov    %eax,%edx
  802bdd:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802be1:	48                   	dec    %eax
  802be2:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be9:	e9 8b 03 00 00       	jmp    802f79 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802bee:	a1 48 50 80 00       	mov    0x805048,%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	0f 84 64 02 00 00    	je     802e5f <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802bfb:	a1 48 50 80 00       	mov    0x805048,%eax
  802c00:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802c03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c07:	75 17                	jne    802c20 <alloc_block+0x199>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 a5 44 80 00       	push   $0x8044a5
  802c11:	68 a0 00 00 00       	push   $0xa0
  802c16:	68 0b 44 80 00       	push   $0x80440b
  802c1b:	e8 d2 d6 ff ff       	call   8002f2 <_panic>
  802c20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 10                	je     802c39 <alloc_block+0x1b2>
  802c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c31:	8b 52 04             	mov    0x4(%edx),%edx
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	eb 0b                	jmp    802c44 <alloc_block+0x1bd>
  802c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	74 0f                	je     802c5d <alloc_block+0x1d6>
  802c4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c57:	8b 12                	mov    (%edx),%edx
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	eb 0a                	jmp    802c67 <alloc_block+0x1e0>
  802c5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	a3 48 50 80 00       	mov    %eax,0x805048
  802c67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7a:	a1 54 50 80 00       	mov    0x805054,%eax
  802c7f:	48                   	dec    %eax
  802c80:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802c85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c8b:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802c8f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c94:	99                   	cltd   
  802c95:	f7 7d e8             	idivl  -0x18(%ebp)
  802c98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c9b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802c9f:	83 ec 0c             	sub    $0xc,%esp
  802ca2:	ff 75 dc             	pushl  -0x24(%ebp)
  802ca5:	e8 ce fa ff ff       	call   802778 <to_page_va>
  802caa:	83 c4 10             	add    $0x10,%esp
  802cad:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802cb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cb3:	83 ec 0c             	sub    $0xc,%esp
  802cb6:	50                   	push   %eax
  802cb7:	e8 c0 ee ff ff       	call   801b7c <get_page>
  802cbc:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cc6:	e9 aa 00 00 00       	jmp    802d75 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802cd2:	89 c2                	mov    %eax,%edx
  802cd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cd7:	01 d0                	add    %edx,%eax
  802cd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802cdc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ce0:	75 17                	jne    802cf9 <alloc_block+0x272>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 c4 44 80 00       	push   $0x8044c4
  802cea:	68 aa 00 00 00       	push   $0xaa
  802cef:	68 0b 44 80 00       	push   $0x80440b
  802cf4:	e8 f9 d5 ff ff       	call   8002f2 <_panic>
  802cf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfc:	c1 e0 04             	shl    $0x4,%eax
  802cff:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d04:	8b 10                	mov    (%eax),%edx
  802d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d09:	89 50 04             	mov    %edx,0x4(%eax)
  802d0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 14                	je     802d2a <alloc_block+0x2a3>
  802d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d19:	c1 e0 04             	shl    $0x4,%eax
  802d1c:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	eb 11                	jmp    802d3b <alloc_block+0x2b4>
  802d2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2d:	c1 e0 04             	shl    $0x4,%eax
  802d30:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802d36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d39:	89 02                	mov    %eax,(%edx)
  802d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3e:	c1 e0 04             	shl    $0x4,%eax
  802d41:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d4a:	89 02                	mov    %eax,(%edx)
  802d4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d58:	c1 e0 04             	shl    $0x4,%eax
  802d5b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	8d 50 01             	lea    0x1(%eax),%edx
  802d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d68:	c1 e0 04             	shl    $0x4,%eax
  802d6b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d70:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d72:	ff 45 f4             	incl   -0xc(%ebp)
  802d75:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d7a:	99                   	cltd   
  802d7b:	f7 7d e8             	idivl  -0x18(%ebp)
  802d7e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d81:	0f 8f 44 ff ff ff    	jg     802ccb <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8a:	c1 e0 04             	shl    $0x4,%eax
  802d8d:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802d97:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802d9b:	75 17                	jne    802db4 <alloc_block+0x32d>
  802d9d:	83 ec 04             	sub    $0x4,%esp
  802da0:	68 a5 44 80 00       	push   $0x8044a5
  802da5:	68 ae 00 00 00       	push   $0xae
  802daa:	68 0b 44 80 00       	push   $0x80440b
  802daf:	e8 3e d5 ff ff       	call   8002f2 <_panic>
  802db4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	74 10                	je     802dcd <alloc_block+0x346>
  802dbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dc5:	8b 52 04             	mov    0x4(%edx),%edx
  802dc8:	89 50 04             	mov    %edx,0x4(%eax)
  802dcb:	eb 14                	jmp    802de1 <alloc_block+0x35a>
  802dcd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd6:	c1 e2 04             	shl    $0x4,%edx
  802dd9:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ddf:	89 02                	mov    %eax,(%edx)
  802de1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0f                	je     802dfa <alloc_block+0x373>
  802deb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802df4:	8b 12                	mov    (%edx),%edx
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	eb 13                	jmp    802e0d <alloc_block+0x386>
  802dfa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e02:	c1 e2 04             	shl    $0x4,%edx
  802e05:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e0b:	89 02                	mov    %eax,(%edx)
  802e0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e23:	c1 e0 04             	shl    $0x4,%eax
  802e26:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e33:	c1 e0 04             	shl    $0x4,%eax
  802e36:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e3b:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e40:	83 ec 0c             	sub    $0xc,%esp
  802e43:	50                   	push   %eax
  802e44:	e8 a1 f9 ff ff       	call   8027ea <to_page_info>
  802e49:	83 c4 10             	add    $0x10,%esp
  802e4c:	89 c2                	mov    %eax,%edx
  802e4e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e52:	48                   	dec    %eax
  802e53:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802e57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e5a:	e9 1a 01 00 00       	jmp    802f79 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e62:	40                   	inc    %eax
  802e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e66:	e9 ed 00 00 00       	jmp    802f58 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	c1 e0 04             	shl    $0x4,%eax
  802e71:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	0f 84 d5 00 00 00    	je     802f55 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	c1 e0 04             	shl    $0x4,%eax
  802e86:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802e90:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e94:	75 17                	jne    802ead <alloc_block+0x426>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 a5 44 80 00       	push   $0x8044a5
  802e9e:	68 b8 00 00 00       	push   $0xb8
  802ea3:	68 0b 44 80 00       	push   $0x80440b
  802ea8:	e8 45 d4 ff ff       	call   8002f2 <_panic>
  802ead:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 10                	je     802ec6 <alloc_block+0x43f>
  802eb6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ebe:	8b 52 04             	mov    0x4(%edx),%edx
  802ec1:	89 50 04             	mov    %edx,0x4(%eax)
  802ec4:	eb 14                	jmp    802eda <alloc_block+0x453>
  802ec6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecf:	c1 e2 04             	shl    $0x4,%edx
  802ed2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ed8:	89 02                	mov    %eax,(%edx)
  802eda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	74 0f                	je     802ef3 <alloc_block+0x46c>
  802ee4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eed:	8b 12                	mov    (%edx),%edx
  802eef:	89 10                	mov    %edx,(%eax)
  802ef1:	eb 13                	jmp    802f06 <alloc_block+0x47f>
  802ef3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efb:	c1 e2 04             	shl    $0x4,%edx
  802efe:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f04:	89 02                	mov    %eax,(%edx)
  802f06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1c:	c1 e0 04             	shl    $0x4,%eax
  802f1f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	c1 e0 04             	shl    $0x4,%eax
  802f2f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f34:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802f36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f39:	83 ec 0c             	sub    $0xc,%esp
  802f3c:	50                   	push   %eax
  802f3d:	e8 a8 f8 ff ff       	call   8027ea <to_page_info>
  802f42:	83 c4 10             	add    $0x10,%esp
  802f45:	89 c2                	mov    %eax,%edx
  802f47:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f4b:	48                   	dec    %eax
  802f4c:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802f50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f53:	eb 24                	jmp    802f79 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f55:	ff 45 f0             	incl   -0x10(%ebp)
  802f58:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802f5c:	0f 8e 09 ff ff ff    	jle    802e6b <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 e7 44 80 00       	push   $0x8044e7
  802f6a:	68 bf 00 00 00       	push   $0xbf
  802f6f:	68 0b 44 80 00       	push   $0x80440b
  802f74:	e8 79 d3 ff ff       	call   8002f2 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
  802f7e:	83 ec 14             	sub    $0x14,%esp
  802f81:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f88:	75 07                	jne    802f91 <log2_ceil.1520+0x16>
  802f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8f:	eb 1b                	jmp    802fac <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802f98:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802f9b:	eb 06                	jmp    802fa3 <log2_ceil.1520+0x28>
            x >>= 1;
  802f9d:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802fa0:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802fa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa7:	75 f4                	jne    802f9d <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
  802fb1:	83 ec 14             	sub    $0x14,%esp
  802fb4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802fb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbb:	75 07                	jne    802fc4 <log2_ceil.1547+0x16>
  802fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc2:	eb 1b                	jmp    802fdf <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802fcb:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802fce:	eb 06                	jmp    802fd6 <log2_ceil.1547+0x28>
			x >>= 1;
  802fd0:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802fd3:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802fd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fda:	75 f4                	jne    802fd0 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802fdf:	c9                   	leave  
  802fe0:	c3                   	ret    

00802fe1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802fe1:	55                   	push   %ebp
  802fe2:	89 e5                	mov    %esp,%ebp
  802fe4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fea:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fef:	39 c2                	cmp    %eax,%edx
  802ff1:	72 0c                	jb     802fff <free_block+0x1e>
  802ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff6:	a1 40 50 80 00       	mov    0x805040,%eax
  802ffb:	39 c2                	cmp    %eax,%edx
  802ffd:	72 19                	jb     803018 <free_block+0x37>
  802fff:	68 ec 44 80 00       	push   $0x8044ec
  803004:	68 6e 44 80 00       	push   $0x80446e
  803009:	68 d0 00 00 00       	push   $0xd0
  80300e:	68 0b 44 80 00       	push   $0x80440b
  803013:	e8 da d2 ff ff       	call   8002f2 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803018:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301c:	0f 84 42 03 00 00    	je     803364 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803022:	8b 55 08             	mov    0x8(%ebp),%edx
  803025:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80302a:	39 c2                	cmp    %eax,%edx
  80302c:	72 0c                	jb     80303a <free_block+0x59>
  80302e:	8b 55 08             	mov    0x8(%ebp),%edx
  803031:	a1 40 50 80 00       	mov    0x805040,%eax
  803036:	39 c2                	cmp    %eax,%edx
  803038:	72 17                	jb     803051 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80303a:	83 ec 04             	sub    $0x4,%esp
  80303d:	68 24 45 80 00       	push   $0x804524
  803042:	68 e6 00 00 00       	push   $0xe6
  803047:	68 0b 44 80 00       	push   $0x80440b
  80304c:	e8 a1 d2 ff ff       	call   8002f2 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803059:	29 c2                	sub    %eax,%edx
  80305b:	89 d0                	mov    %edx,%eax
  80305d:	83 e0 07             	and    $0x7,%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 17                	je     80307b <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 58 45 80 00       	push   $0x804558
  80306c:	68 ea 00 00 00       	push   $0xea
  803071:	68 0b 44 80 00       	push   $0x80440b
  803076:	e8 77 d2 ff ff       	call   8002f2 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	83 ec 0c             	sub    $0xc,%esp
  803081:	50                   	push   %eax
  803082:	e8 63 f7 ff ff       	call   8027ea <to_page_info>
  803087:	83 c4 10             	add    $0x10,%esp
  80308a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80308d:	83 ec 0c             	sub    $0xc,%esp
  803090:	ff 75 08             	pushl  0x8(%ebp)
  803093:	e8 87 f9 ff ff       	call   802a1f <get_block_size>
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80309e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a2:	75 17                	jne    8030bb <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 84 45 80 00       	push   $0x804584
  8030ac:	68 f1 00 00 00       	push   $0xf1
  8030b1:	68 0b 44 80 00       	push   $0x80440b
  8030b6:	e8 37 d2 ff ff       	call   8002f2 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8030bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030be:	83 ec 0c             	sub    $0xc,%esp
  8030c1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8030c4:	52                   	push   %edx
  8030c5:	89 c1                	mov    %eax,%ecx
  8030c7:	e8 e2 fe ff ff       	call   802fae <log2_ceil.1547>
  8030cc:	83 c4 10             	add    $0x10,%esp
  8030cf:	83 e8 03             	sub    $0x3,%eax
  8030d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8030db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030df:	75 17                	jne    8030f8 <free_block+0x117>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 d0 45 80 00       	push   $0x8045d0
  8030e9:	68 f6 00 00 00       	push   $0xf6
  8030ee:	68 0b 44 80 00       	push   $0x80440b
  8030f3:	e8 fa d1 ff ff       	call   8002f2 <_panic>
  8030f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fb:	c1 e0 04             	shl    $0x4,%eax
  8030fe:	05 80 d0 81 00       	add    $0x81d080,%eax
  803103:	8b 10                	mov    (%eax),%edx
  803105:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803108:	89 10                	mov    %edx,(%eax)
  80310a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	74 15                	je     803128 <free_block+0x147>
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	c1 e0 04             	shl    $0x4,%eax
  803119:	05 80 d0 81 00       	add    $0x81d080,%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803123:	89 50 04             	mov    %edx,0x4(%eax)
  803126:	eb 11                	jmp    803139 <free_block+0x158>
  803128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312b:	c1 e0 04             	shl    $0x4,%eax
  80312e:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803137:	89 02                	mov    %eax,(%edx)
  803139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313c:	c1 e0 04             	shl    $0x4,%eax
  80313f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803145:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803148:	89 02                	mov    %eax,(%edx)
  80314a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	c1 e0 04             	shl    $0x4,%eax
  80315a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	8d 50 01             	lea    0x1(%eax),%edx
  803164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803167:	c1 e0 04             	shl    $0x4,%eax
  80316a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80316f:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803174:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803178:	40                   	inc    %eax
  803179:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80317c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803188:	29 c2                	sub    %eax,%edx
  80318a:	89 d0                	mov    %edx,%eax
  80318c:	c1 e8 0c             	shr    $0xc,%eax
  80318f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803195:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803199:	0f b7 c8             	movzwl %ax,%ecx
  80319c:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031a1:	99                   	cltd   
  8031a2:	f7 7d e8             	idivl  -0x18(%ebp)
  8031a5:	39 c1                	cmp    %eax,%ecx
  8031a7:	0f 85 b8 01 00 00    	jne    803365 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8031ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8031b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b7:	c1 e0 04             	shl    $0x4,%eax
  8031ba:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8031c4:	e9 d5 00 00 00       	jmp    80329e <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 00                	mov    (%eax),%eax
  8031ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8031d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031d9:	29 c2                	sub    %eax,%edx
  8031db:	89 d0                	mov    %edx,%eax
  8031dd:	c1 e8 0c             	shr    $0xc,%eax
  8031e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8031e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8031e9:	0f 85 a9 00 00 00    	jne    803298 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8031ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f3:	75 17                	jne    80320c <free_block+0x22b>
  8031f5:	83 ec 04             	sub    $0x4,%esp
  8031f8:	68 a5 44 80 00       	push   $0x8044a5
  8031fd:	68 04 01 00 00       	push   $0x104
  803202:	68 0b 44 80 00       	push   $0x80440b
  803207:	e8 e6 d0 ff ff       	call   8002f2 <_panic>
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	74 10                	je     803225 <free_block+0x244>
  803215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321d:	8b 52 04             	mov    0x4(%edx),%edx
  803220:	89 50 04             	mov    %edx,0x4(%eax)
  803223:	eb 14                	jmp    803239 <free_block+0x258>
  803225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803228:	8b 40 04             	mov    0x4(%eax),%eax
  80322b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80322e:	c1 e2 04             	shl    $0x4,%edx
  803231:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803237:	89 02                	mov    %eax,(%edx)
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 0f                	je     803252 <free_block+0x271>
  803243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324c:	8b 12                	mov    (%edx),%edx
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	eb 13                	jmp    803265 <free_block+0x284>
  803252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80325a:	c1 e2 04             	shl    $0x4,%edx
  80325d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803263:	89 02                	mov    %eax,(%edx)
  803265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327b:	c1 e0 04             	shl    $0x4,%eax
  80327e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	8d 50 ff             	lea    -0x1(%eax),%edx
  803288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328b:	c1 e0 04             	shl    $0x4,%eax
  80328e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803293:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803295:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803298:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80329b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80329e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a2:	0f 85 21 ff ff ff    	jne    8031c9 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8032a8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032ad:	99                   	cltd   
  8032ae:	f7 7d e8             	idivl  -0x18(%ebp)
  8032b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032b4:	74 17                	je     8032cd <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8032b6:	83 ec 04             	sub    $0x4,%esp
  8032b9:	68 f4 45 80 00       	push   $0x8045f4
  8032be:	68 0c 01 00 00       	push   $0x10c
  8032c3:	68 0b 44 80 00       	push   $0x80440b
  8032c8:	e8 25 d0 ff ff       	call   8002f2 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8032cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8032df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032e3:	75 17                	jne    8032fc <free_block+0x31b>
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	68 c4 44 80 00       	push   $0x8044c4
  8032ed:	68 11 01 00 00       	push   $0x111
  8032f2:	68 0b 44 80 00       	push   $0x80440b
  8032f7:	e8 f6 cf ff ff       	call   8002f2 <_panic>
  8032fc:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803302:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803305:	89 50 04             	mov    %edx,0x4(%eax)
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0c                	je     80331e <free_block+0x33d>
  803312:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803317:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80331a:	89 10                	mov    %edx,(%eax)
  80331c:	eb 08                	jmp    803326 <free_block+0x345>
  80331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803321:	a3 48 50 80 00       	mov    %eax,0x805048
  803326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803329:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803331:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803337:	a1 54 50 80 00       	mov    0x805054,%eax
  80333c:	40                   	inc    %eax
  80333d:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803342:	83 ec 0c             	sub    $0xc,%esp
  803345:	ff 75 ec             	pushl  -0x14(%ebp)
  803348:	e8 2b f4 ff ff       	call   802778 <to_page_va>
  80334d:	83 c4 10             	add    $0x10,%esp
  803350:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803353:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803356:	83 ec 0c             	sub    $0xc,%esp
  803359:	50                   	push   %eax
  80335a:	e8 69 e8 ff ff       	call   801bc8 <return_page>
  80335f:	83 c4 10             	add    $0x10,%esp
  803362:	eb 01                	jmp    803365 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803364:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803365:	c9                   	leave  
  803366:	c3                   	ret    

00803367 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 14             	sub    $0x14,%esp
  80336d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803370:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803374:	77 07                	ja     80337d <nearest_pow2_ceil.1572+0x16>
      return 1;
  803376:	b8 01 00 00 00       	mov    $0x1,%eax
  80337b:	eb 20                	jmp    80339d <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80337d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803384:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803387:	eb 08                	jmp    803391 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803389:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80338c:	01 c0                	add    %eax,%eax
  80338e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803391:	d1 6d 08             	shrl   0x8(%ebp)
  803394:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803398:	75 ef                	jne    803389 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80339a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80339d:	c9                   	leave  
  80339e:	c3                   	ret    

0080339f <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80339f:	55                   	push   %ebp
  8033a0:	89 e5                	mov    %esp,%ebp
  8033a2:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8033a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a9:	75 13                	jne    8033be <realloc_block+0x1f>
    return alloc_block(new_size);
  8033ab:	83 ec 0c             	sub    $0xc,%esp
  8033ae:	ff 75 0c             	pushl  0xc(%ebp)
  8033b1:	e8 d1 f6 ff ff       	call   802a87 <alloc_block>
  8033b6:	83 c4 10             	add    $0x10,%esp
  8033b9:	e9 d9 00 00 00       	jmp    803497 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8033be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033c2:	75 18                	jne    8033dc <realloc_block+0x3d>
    free_block(va);
  8033c4:	83 ec 0c             	sub    $0xc,%esp
  8033c7:	ff 75 08             	pushl  0x8(%ebp)
  8033ca:	e8 12 fc ff ff       	call   802fe1 <free_block>
  8033cf:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	e9 bb 00 00 00       	jmp    803497 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8033dc:	83 ec 0c             	sub    $0xc,%esp
  8033df:	ff 75 08             	pushl  0x8(%ebp)
  8033e2:	e8 38 f6 ff ff       	call   802a1f <get_block_size>
  8033e7:	83 c4 10             	add    $0x10,%esp
  8033ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8033ed:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8033f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8033fa:	73 06                	jae    803402 <realloc_block+0x63>
    new_size = min_block_size;
  8033fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ff:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803402:	83 ec 0c             	sub    $0xc,%esp
  803405:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803408:	ff 75 0c             	pushl  0xc(%ebp)
  80340b:	89 c1                	mov    %eax,%ecx
  80340d:	e8 55 ff ff ff       	call   803367 <nearest_pow2_ceil.1572>
  803412:	83 c4 10             	add    $0x10,%esp
  803415:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80341e:	75 05                	jne    803425 <realloc_block+0x86>
    return va;
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	eb 72                	jmp    803497 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803425:	83 ec 0c             	sub    $0xc,%esp
  803428:	ff 75 0c             	pushl  0xc(%ebp)
  80342b:	e8 57 f6 ff ff       	call   802a87 <alloc_block>
  803430:	83 c4 10             	add    $0x10,%esp
  803433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803436:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80343a:	75 07                	jne    803443 <realloc_block+0xa4>
    return NULL;
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
  803441:	eb 54                	jmp    803497 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803446:	8b 45 0c             	mov    0xc(%ebp),%eax
  803449:	39 d0                	cmp    %edx,%eax
  80344b:	76 02                	jbe    80344f <realloc_block+0xb0>
  80344d:	89 d0                	mov    %edx,%eax
  80344f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80345e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803465:	eb 17                	jmp    80347e <realloc_block+0xdf>
    dst[i] = src[i];
  803467:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	01 c2                	add    %eax,%edx
  80346f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	01 c8                	add    %ecx,%eax
  803477:	8a 00                	mov    (%eax),%al
  803479:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80347b:	ff 45 f4             	incl   -0xc(%ebp)
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803484:	72 e1                	jb     803467 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803486:	83 ec 0c             	sub    $0xc,%esp
  803489:	ff 75 08             	pushl  0x8(%ebp)
  80348c:	e8 50 fb ff ff       	call   802fe1 <free_block>
  803491:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803497:	c9                   	leave  
  803498:	c3                   	ret    

00803499 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803499:	55                   	push   %ebp
  80349a:	89 e5                	mov    %esp,%ebp
  80349c:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80349f:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a2:	89 d0                	mov    %edx,%eax
  8034a4:	c1 e0 02             	shl    $0x2,%eax
  8034a7:	01 d0                	add    %edx,%eax
  8034a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034b0:	01 d0                	add    %edx,%eax
  8034b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034b9:	01 d0                	add    %edx,%eax
  8034bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034c2:	01 d0                	add    %edx,%eax
  8034c4:	c1 e0 04             	shl    $0x4,%eax
  8034c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8034ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8034d1:	0f 31                	rdtsc  
  8034d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8034d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8034d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8034e2:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8034e5:	eb 46                	jmp    80352d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8034e7:	0f 31                	rdtsc  
  8034e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8034ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8034ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8034f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8034fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803501:	29 c2                	sub    %eax,%edx
  803503:	89 d0                	mov    %edx,%eax
  803505:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	89 d1                	mov    %edx,%ecx
  803510:	29 c1                	sub    %eax,%ecx
  803512:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803518:	39 c2                	cmp    %eax,%edx
  80351a:	0f 97 c0             	seta   %al
  80351d:	0f b6 c0             	movzbl %al,%eax
  803520:	29 c1                	sub    %eax,%ecx
  803522:	89 c8                	mov    %ecx,%eax
  803524:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803527:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80352a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80352d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803530:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803533:	72 b2                	jb     8034e7 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803535:	90                   	nop
  803536:	c9                   	leave  
  803537:	c3                   	ret    

00803538 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803538:	55                   	push   %ebp
  803539:	89 e5                	mov    %esp,%ebp
  80353b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80353e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803545:	eb 03                	jmp    80354a <busy_wait+0x12>
  803547:	ff 45 fc             	incl   -0x4(%ebp)
  80354a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80354d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803550:	72 f5                	jb     803547 <busy_wait+0xf>
	return i;
  803552:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803555:	c9                   	leave  
  803556:	c3                   	ret    
  803557:	90                   	nop

00803558 <__udivdi3>:
  803558:	55                   	push   %ebp
  803559:	57                   	push   %edi
  80355a:	56                   	push   %esi
  80355b:	53                   	push   %ebx
  80355c:	83 ec 1c             	sub    $0x1c,%esp
  80355f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803563:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803567:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80356f:	89 ca                	mov    %ecx,%edx
  803571:	89 f8                	mov    %edi,%eax
  803573:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803577:	85 f6                	test   %esi,%esi
  803579:	75 2d                	jne    8035a8 <__udivdi3+0x50>
  80357b:	39 cf                	cmp    %ecx,%edi
  80357d:	77 65                	ja     8035e4 <__udivdi3+0x8c>
  80357f:	89 fd                	mov    %edi,%ebp
  803581:	85 ff                	test   %edi,%edi
  803583:	75 0b                	jne    803590 <__udivdi3+0x38>
  803585:	b8 01 00 00 00       	mov    $0x1,%eax
  80358a:	31 d2                	xor    %edx,%edx
  80358c:	f7 f7                	div    %edi
  80358e:	89 c5                	mov    %eax,%ebp
  803590:	31 d2                	xor    %edx,%edx
  803592:	89 c8                	mov    %ecx,%eax
  803594:	f7 f5                	div    %ebp
  803596:	89 c1                	mov    %eax,%ecx
  803598:	89 d8                	mov    %ebx,%eax
  80359a:	f7 f5                	div    %ebp
  80359c:	89 cf                	mov    %ecx,%edi
  80359e:	89 fa                	mov    %edi,%edx
  8035a0:	83 c4 1c             	add    $0x1c,%esp
  8035a3:	5b                   	pop    %ebx
  8035a4:	5e                   	pop    %esi
  8035a5:	5f                   	pop    %edi
  8035a6:	5d                   	pop    %ebp
  8035a7:	c3                   	ret    
  8035a8:	39 ce                	cmp    %ecx,%esi
  8035aa:	77 28                	ja     8035d4 <__udivdi3+0x7c>
  8035ac:	0f bd fe             	bsr    %esi,%edi
  8035af:	83 f7 1f             	xor    $0x1f,%edi
  8035b2:	75 40                	jne    8035f4 <__udivdi3+0x9c>
  8035b4:	39 ce                	cmp    %ecx,%esi
  8035b6:	72 0a                	jb     8035c2 <__udivdi3+0x6a>
  8035b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035bc:	0f 87 9e 00 00 00    	ja     803660 <__udivdi3+0x108>
  8035c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c7:	89 fa                	mov    %edi,%edx
  8035c9:	83 c4 1c             	add    $0x1c,%esp
  8035cc:	5b                   	pop    %ebx
  8035cd:	5e                   	pop    %esi
  8035ce:	5f                   	pop    %edi
  8035cf:	5d                   	pop    %ebp
  8035d0:	c3                   	ret    
  8035d1:	8d 76 00             	lea    0x0(%esi),%esi
  8035d4:	31 ff                	xor    %edi,%edi
  8035d6:	31 c0                	xor    %eax,%eax
  8035d8:	89 fa                	mov    %edi,%edx
  8035da:	83 c4 1c             	add    $0x1c,%esp
  8035dd:	5b                   	pop    %ebx
  8035de:	5e                   	pop    %esi
  8035df:	5f                   	pop    %edi
  8035e0:	5d                   	pop    %ebp
  8035e1:	c3                   	ret    
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	89 d8                	mov    %ebx,%eax
  8035e6:	f7 f7                	div    %edi
  8035e8:	31 ff                	xor    %edi,%edi
  8035ea:	89 fa                	mov    %edi,%edx
  8035ec:	83 c4 1c             	add    $0x1c,%esp
  8035ef:	5b                   	pop    %ebx
  8035f0:	5e                   	pop    %esi
  8035f1:	5f                   	pop    %edi
  8035f2:	5d                   	pop    %ebp
  8035f3:	c3                   	ret    
  8035f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035f9:	89 eb                	mov    %ebp,%ebx
  8035fb:	29 fb                	sub    %edi,%ebx
  8035fd:	89 f9                	mov    %edi,%ecx
  8035ff:	d3 e6                	shl    %cl,%esi
  803601:	89 c5                	mov    %eax,%ebp
  803603:	88 d9                	mov    %bl,%cl
  803605:	d3 ed                	shr    %cl,%ebp
  803607:	89 e9                	mov    %ebp,%ecx
  803609:	09 f1                	or     %esi,%ecx
  80360b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80360f:	89 f9                	mov    %edi,%ecx
  803611:	d3 e0                	shl    %cl,%eax
  803613:	89 c5                	mov    %eax,%ebp
  803615:	89 d6                	mov    %edx,%esi
  803617:	88 d9                	mov    %bl,%cl
  803619:	d3 ee                	shr    %cl,%esi
  80361b:	89 f9                	mov    %edi,%ecx
  80361d:	d3 e2                	shl    %cl,%edx
  80361f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803623:	88 d9                	mov    %bl,%cl
  803625:	d3 e8                	shr    %cl,%eax
  803627:	09 c2                	or     %eax,%edx
  803629:	89 d0                	mov    %edx,%eax
  80362b:	89 f2                	mov    %esi,%edx
  80362d:	f7 74 24 0c          	divl   0xc(%esp)
  803631:	89 d6                	mov    %edx,%esi
  803633:	89 c3                	mov    %eax,%ebx
  803635:	f7 e5                	mul    %ebp
  803637:	39 d6                	cmp    %edx,%esi
  803639:	72 19                	jb     803654 <__udivdi3+0xfc>
  80363b:	74 0b                	je     803648 <__udivdi3+0xf0>
  80363d:	89 d8                	mov    %ebx,%eax
  80363f:	31 ff                	xor    %edi,%edi
  803641:	e9 58 ff ff ff       	jmp    80359e <__udivdi3+0x46>
  803646:	66 90                	xchg   %ax,%ax
  803648:	8b 54 24 08          	mov    0x8(%esp),%edx
  80364c:	89 f9                	mov    %edi,%ecx
  80364e:	d3 e2                	shl    %cl,%edx
  803650:	39 c2                	cmp    %eax,%edx
  803652:	73 e9                	jae    80363d <__udivdi3+0xe5>
  803654:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803657:	31 ff                	xor    %edi,%edi
  803659:	e9 40 ff ff ff       	jmp    80359e <__udivdi3+0x46>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	31 c0                	xor    %eax,%eax
  803662:	e9 37 ff ff ff       	jmp    80359e <__udivdi3+0x46>
  803667:	90                   	nop

00803668 <__umoddi3>:
  803668:	55                   	push   %ebp
  803669:	57                   	push   %edi
  80366a:	56                   	push   %esi
  80366b:	53                   	push   %ebx
  80366c:	83 ec 1c             	sub    $0x1c,%esp
  80366f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803673:	8b 74 24 34          	mov    0x34(%esp),%esi
  803677:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80367b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80367f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803683:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803687:	89 f3                	mov    %esi,%ebx
  803689:	89 fa                	mov    %edi,%edx
  80368b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80368f:	89 34 24             	mov    %esi,(%esp)
  803692:	85 c0                	test   %eax,%eax
  803694:	75 1a                	jne    8036b0 <__umoddi3+0x48>
  803696:	39 f7                	cmp    %esi,%edi
  803698:	0f 86 a2 00 00 00    	jbe    803740 <__umoddi3+0xd8>
  80369e:	89 c8                	mov    %ecx,%eax
  8036a0:	89 f2                	mov    %esi,%edx
  8036a2:	f7 f7                	div    %edi
  8036a4:	89 d0                	mov    %edx,%eax
  8036a6:	31 d2                	xor    %edx,%edx
  8036a8:	83 c4 1c             	add    $0x1c,%esp
  8036ab:	5b                   	pop    %ebx
  8036ac:	5e                   	pop    %esi
  8036ad:	5f                   	pop    %edi
  8036ae:	5d                   	pop    %ebp
  8036af:	c3                   	ret    
  8036b0:	39 f0                	cmp    %esi,%eax
  8036b2:	0f 87 ac 00 00 00    	ja     803764 <__umoddi3+0xfc>
  8036b8:	0f bd e8             	bsr    %eax,%ebp
  8036bb:	83 f5 1f             	xor    $0x1f,%ebp
  8036be:	0f 84 ac 00 00 00    	je     803770 <__umoddi3+0x108>
  8036c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036c9:	29 ef                	sub    %ebp,%edi
  8036cb:	89 fe                	mov    %edi,%esi
  8036cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036d1:	89 e9                	mov    %ebp,%ecx
  8036d3:	d3 e0                	shl    %cl,%eax
  8036d5:	89 d7                	mov    %edx,%edi
  8036d7:	89 f1                	mov    %esi,%ecx
  8036d9:	d3 ef                	shr    %cl,%edi
  8036db:	09 c7                	or     %eax,%edi
  8036dd:	89 e9                	mov    %ebp,%ecx
  8036df:	d3 e2                	shl    %cl,%edx
  8036e1:	89 14 24             	mov    %edx,(%esp)
  8036e4:	89 d8                	mov    %ebx,%eax
  8036e6:	d3 e0                	shl    %cl,%eax
  8036e8:	89 c2                	mov    %eax,%edx
  8036ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ee:	d3 e0                	shl    %cl,%eax
  8036f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f8:	89 f1                	mov    %esi,%ecx
  8036fa:	d3 e8                	shr    %cl,%eax
  8036fc:	09 d0                	or     %edx,%eax
  8036fe:	d3 eb                	shr    %cl,%ebx
  803700:	89 da                	mov    %ebx,%edx
  803702:	f7 f7                	div    %edi
  803704:	89 d3                	mov    %edx,%ebx
  803706:	f7 24 24             	mull   (%esp)
  803709:	89 c6                	mov    %eax,%esi
  80370b:	89 d1                	mov    %edx,%ecx
  80370d:	39 d3                	cmp    %edx,%ebx
  80370f:	0f 82 87 00 00 00    	jb     80379c <__umoddi3+0x134>
  803715:	0f 84 91 00 00 00    	je     8037ac <__umoddi3+0x144>
  80371b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80371f:	29 f2                	sub    %esi,%edx
  803721:	19 cb                	sbb    %ecx,%ebx
  803723:	89 d8                	mov    %ebx,%eax
  803725:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803729:	d3 e0                	shl    %cl,%eax
  80372b:	89 e9                	mov    %ebp,%ecx
  80372d:	d3 ea                	shr    %cl,%edx
  80372f:	09 d0                	or     %edx,%eax
  803731:	89 e9                	mov    %ebp,%ecx
  803733:	d3 eb                	shr    %cl,%ebx
  803735:	89 da                	mov    %ebx,%edx
  803737:	83 c4 1c             	add    $0x1c,%esp
  80373a:	5b                   	pop    %ebx
  80373b:	5e                   	pop    %esi
  80373c:	5f                   	pop    %edi
  80373d:	5d                   	pop    %ebp
  80373e:	c3                   	ret    
  80373f:	90                   	nop
  803740:	89 fd                	mov    %edi,%ebp
  803742:	85 ff                	test   %edi,%edi
  803744:	75 0b                	jne    803751 <__umoddi3+0xe9>
  803746:	b8 01 00 00 00       	mov    $0x1,%eax
  80374b:	31 d2                	xor    %edx,%edx
  80374d:	f7 f7                	div    %edi
  80374f:	89 c5                	mov    %eax,%ebp
  803751:	89 f0                	mov    %esi,%eax
  803753:	31 d2                	xor    %edx,%edx
  803755:	f7 f5                	div    %ebp
  803757:	89 c8                	mov    %ecx,%eax
  803759:	f7 f5                	div    %ebp
  80375b:	89 d0                	mov    %edx,%eax
  80375d:	e9 44 ff ff ff       	jmp    8036a6 <__umoddi3+0x3e>
  803762:	66 90                	xchg   %ax,%ax
  803764:	89 c8                	mov    %ecx,%eax
  803766:	89 f2                	mov    %esi,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	3b 04 24             	cmp    (%esp),%eax
  803773:	72 06                	jb     80377b <__umoddi3+0x113>
  803775:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803779:	77 0f                	ja     80378a <__umoddi3+0x122>
  80377b:	89 f2                	mov    %esi,%edx
  80377d:	29 f9                	sub    %edi,%ecx
  80377f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803783:	89 14 24             	mov    %edx,(%esp)
  803786:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80378a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80378e:	8b 14 24             	mov    (%esp),%edx
  803791:	83 c4 1c             	add    $0x1c,%esp
  803794:	5b                   	pop    %ebx
  803795:	5e                   	pop    %esi
  803796:	5f                   	pop    %edi
  803797:	5d                   	pop    %ebp
  803798:	c3                   	ret    
  803799:	8d 76 00             	lea    0x0(%esi),%esi
  80379c:	2b 04 24             	sub    (%esp),%eax
  80379f:	19 fa                	sbb    %edi,%edx
  8037a1:	89 d1                	mov    %edx,%ecx
  8037a3:	89 c6                	mov    %eax,%esi
  8037a5:	e9 71 ff ff ff       	jmp    80371b <__umoddi3+0xb3>
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037b0:	72 ea                	jb     80379c <__umoddi3+0x134>
  8037b2:	89 d9                	mov    %ebx,%ecx
  8037b4:	e9 62 ff ff ff       	jmp    80371b <__umoddi3+0xb3>
