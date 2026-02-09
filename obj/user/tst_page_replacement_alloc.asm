
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 3d 01 00 00       	call   800173 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 	//Stack
		} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  80003f:	6a 01                	push   $0x1
  800041:	68 00 00 80 00       	push   $0x800000
  800046:	6a 0b                	push   $0xb
  800048:	68 20 30 80 00       	push   $0x803020
  80004d:	e8 85 19 00 00       	call   8019d7 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800058:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 20 1d 80 00       	push   $0x801d20
  800066:	6a 1c                	push   $0x1c
  800068:	68 94 1d 80 00       	push   $0x801d94
  80006d:	e8 b1 02 00 00       	call   800323 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800072:	e8 9e 15 00 00       	call   801615 <sys_calculate_free_frames>
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007a:	e8 e1 15 00 00       	call   801660 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800082:	c6 05 9f d0 80 00 61 	movb   $0x61,0x80d09f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800089:	a0 9f e0 80 00       	mov    0x80e09f,%al
  80008e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800091:	a0 9f f0 80 00       	mov    0x80f09f,%al
  800096:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800099:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000a0:	eb 4a                	jmp    8000ec <_main+0xb4>
	{
		__arr__[i] = -1 ;
  8000a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a5:	05 a0 30 80 00       	add    $0x8030a0,%eax
  8000aa:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ + garbage5;
  8000ad:	a1 00 30 80 00       	mov    0x803000,%eax
  8000b2:	8a 00                	mov    (%eax),%al
  8000b4:	88 c2                	mov    %al,%dl
  8000b6:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *__ptr2__ + garbage4;
  8000be:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c3:	8a 00                	mov    (%eax),%al
  8000c5:	88 c2                	mov    %al,%dl
  8000c7:	8a 45 e1             	mov    -0x1f(%ebp),%al
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	88 45 f7             	mov    %al,-0x9(%ebp)
		__ptr__++ ; __ptr2__++ ;
  8000cf:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d4:	40                   	inc    %eax
  8000d5:	a3 00 30 80 00       	mov    %eax,0x803000
  8000da:	a1 04 30 80 00       	mov    0x803004,%eax
  8000df:	40                   	inc    %eax
  8000e0:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000e5:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000ec:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000f3:	7e ad                	jle    8000a2 <_main+0x6a>
		__ptr__++ ; __ptr2__++ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	68 b8 1d 80 00       	push   $0x801db8
  8000fd:	6a 03                	push   $0x3
  8000ff:	e8 3a 05 00 00       	call   80063e <cprintf_colored>
  800104:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800107:	e8 54 15 00 00       	call   801660 <sys_pf_calculate_allocated_pages>
  80010c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80010f:	74 14                	je     800125 <_main+0xed>
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	68 e8 1d 80 00       	push   $0x801de8
  800119:	6a 3f                	push   $0x3f
  80011b:	68 94 1d 80 00       	push   $0x801d94
  800120:	e8 fe 01 00 00       	call   800323 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800125:	e8 eb 14 00 00       	call   801615 <sys_calculate_free_frames>
  80012a:	89 c3                	mov    %eax,%ebx
  80012c:	e8 fd 14 00 00       	call   80162e <sys_calculate_modified_frames>
  800131:	01 d8                	add    %ebx,%eax
  800133:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800139:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80013c:	74 1d                	je     80015b <_main+0x123>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  80013e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800141:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 00                	push   $0x0
  80014a:	68 54 1e 80 00       	push   $0x801e54
  80014f:	6a 43                	push   $0x43
  800151:	68 94 1d 80 00       	push   $0x801d94
  800156:	e8 c8 01 00 00       	call   800323 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [ALLOCATION] is completed successfully\n");
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 d4 1e 80 00       	push   $0x801ed4
  800163:	6a 0a                	push   $0xa
  800165:	e8 d4 04 00 00       	call   80063e <cprintf_colored>
  80016a:	83 c4 10             	add    $0x10,%esp
	return;
  80016d:	90                   	nop
}
  80016e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80017c:	e8 5d 16 00 00       	call   8017de <sys_getenvindex>
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800187:	89 d0                	mov    %edx,%eax
  800189:	01 c0                	add    %eax,%eax
  80018b:	01 d0                	add    %edx,%eax
  80018d:	c1 e0 02             	shl    $0x2,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	c1 e0 02             	shl    $0x2,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	c1 e0 03             	shl    $0x3,%eax
  80019a:	01 d0                	add    %edx,%eax
  80019c:	c1 e0 02             	shl    $0x2,%eax
  80019f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a4:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a9:	a1 60 30 80 00       	mov    0x803060,%eax
  8001ae:	8a 40 20             	mov    0x20(%eax),%al
  8001b1:	84 c0                	test   %al,%al
  8001b3:	74 0d                	je     8001c2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001b5:	a1 60 30 80 00       	mov    0x803060,%eax
  8001ba:	83 c0 20             	add    $0x20,%eax
  8001bd:	a3 50 30 80 00       	mov    %eax,0x803050

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c6:	7e 0a                	jle    8001d2 <libmain+0x5f>
		binaryname = argv[0];
  8001c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cb:	8b 00                	mov    (%eax),%eax
  8001cd:	a3 50 30 80 00       	mov    %eax,0x803050

	// call user main routine
	_main(argc, argv);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	e8 58 fe ff ff       	call   800038 <_main>
  8001e0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e3:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	0f 84 01 01 00 00    	je     8002f1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f6:	bb 20 20 80 00       	mov    $0x802020,%ebx
  8001fb:	ba 0e 00 00 00       	mov    $0xe,%edx
  800200:	89 c7                	mov    %eax,%edi
  800202:	89 de                	mov    %ebx,%esi
  800204:	89 d1                	mov    %edx,%ecx
  800206:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800208:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80020b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800210:	b0 00                	mov    $0x0,%al
  800212:	89 d7                	mov    %edx,%edi
  800214:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800216:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80021d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	50                   	push   %eax
  800224:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80022a:	50                   	push   %eax
  80022b:	e8 e4 17 00 00       	call   801a14 <sys_utilities>
  800230:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800233:	e8 2d 13 00 00       	call   801565 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	68 40 1f 80 00       	push   $0x801f40
  800240:	e8 cc 03 00 00       	call   800611 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800248:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024b:	85 c0                	test   %eax,%eax
  80024d:	74 18                	je     800267 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80024f:	e8 de 17 00 00       	call   801a32 <sys_get_optimal_num_faults>
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	50                   	push   %eax
  800258:	68 68 1f 80 00       	push   $0x801f68
  80025d:	e8 af 03 00 00       	call   800611 <cprintf>
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	eb 59                	jmp    8002c0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800267:	a1 60 30 80 00       	mov    0x803060,%eax
  80026c:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800272:	a1 60 30 80 00       	mov    0x803060,%eax
  800277:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80027d:	83 ec 04             	sub    $0x4,%esp
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 8c 1f 80 00       	push   $0x801f8c
  800287:	e8 85 03 00 00       	call   800611 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80028f:	a1 60 30 80 00       	mov    0x803060,%eax
  800294:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80029a:	a1 60 30 80 00       	mov    0x803060,%eax
  80029f:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8002a5:	a1 60 30 80 00       	mov    0x803060,%eax
  8002aa:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8002b0:	51                   	push   %ecx
  8002b1:	52                   	push   %edx
  8002b2:	50                   	push   %eax
  8002b3:	68 b4 1f 80 00       	push   $0x801fb4
  8002b8:	e8 54 03 00 00       	call   800611 <cprintf>
  8002bd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c0:	a1 60 30 80 00       	mov    0x803060,%eax
  8002c5:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	50                   	push   %eax
  8002cf:	68 0c 20 80 00       	push   $0x80200c
  8002d4:	e8 38 03 00 00       	call   800611 <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	68 40 1f 80 00       	push   $0x801f40
  8002e4:	e8 28 03 00 00       	call   800611 <cprintf>
  8002e9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002ec:	e8 8e 12 00 00       	call   80157f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f1:	e8 1f 00 00 00       	call   800315 <exit>
}
  8002f6:	90                   	nop
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800305:	83 ec 0c             	sub    $0xc,%esp
  800308:	6a 00                	push   $0x0
  80030a:	e8 9b 14 00 00       	call   8017aa <sys_destroy_env>
  80030f:	83 c4 10             	add    $0x10,%esp
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <exit>:

void
exit(void)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031b:	e8 f0 14 00 00       	call   801810 <sys_exit_env>
}
  800320:	90                   	nop
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800329:	8d 45 10             	lea    0x10(%ebp),%eax
  80032c:	83 c0 04             	add    $0x4,%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800332:	a1 78 71 82 00       	mov    0x827178,%eax
  800337:	85 c0                	test   %eax,%eax
  800339:	74 16                	je     800351 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033b:	a1 78 71 82 00       	mov    0x827178,%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	68 84 20 80 00       	push   $0x802084
  800349:	e8 c3 02 00 00       	call   800611 <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800351:	a1 50 30 80 00       	mov    0x803050,%eax
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 8c 20 80 00       	push   $0x80208c
  800365:	6a 74                	push   $0x74
  800367:	e8 d2 02 00 00       	call   80063e <cprintf_colored>
  80036c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	ff 75 f4             	pushl  -0xc(%ebp)
  800378:	50                   	push   %eax
  800379:	e8 24 02 00 00       	call   8005a2 <vcprintf>
  80037e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	6a 00                	push   $0x0
  800386:	68 b4 20 80 00       	push   $0x8020b4
  80038b:	e8 12 02 00 00       	call   8005a2 <vcprintf>
  800390:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800393:	e8 7d ff ff ff       	call   800315 <exit>

	// should not return here
	while (1) ;
  800398:	eb fe                	jmp    800398 <_panic+0x75>

0080039a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	53                   	push   %ebx
  80039e:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a1:	a1 60 30 80 00       	mov    0x803060,%eax
  8003a6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	39 c2                	cmp    %eax,%edx
  8003b1:	74 14                	je     8003c7 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	68 b8 20 80 00       	push   $0x8020b8
  8003bb:	6a 26                	push   $0x26
  8003bd:	68 04 21 80 00       	push   $0x802104
  8003c2:	e8 5c ff ff ff       	call   800323 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d5:	e9 d9 00 00 00       	jmp    8004b3 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	75 08                	jne    8003f7 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003ef:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f2:	e9 b9 00 00 00       	jmp    8004b0 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800405:	eb 79                	jmp    800480 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800407:	a1 60 30 80 00       	mov    0x803060,%eax
  80040c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800412:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800415:	89 d0                	mov    %edx,%eax
  800417:	01 c0                	add    %eax,%eax
  800419:	01 d0                	add    %edx,%eax
  80041b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800422:	01 d8                	add    %ebx,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c8                	add    %ecx,%eax
  800428:	8a 40 04             	mov    0x4(%eax),%al
  80042b:	84 c0                	test   %al,%al
  80042d:	75 4e                	jne    80047d <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042f:	a1 60 30 80 00       	mov    0x803060,%eax
  800434:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80043a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	01 c0                	add    %eax,%eax
  800441:	01 d0                	add    %edx,%eax
  800443:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80044a:	01 d8                	add    %ebx,%eax
  80044c:	01 d0                	add    %edx,%eax
  80044e:	01 c8                	add    %ecx,%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800455:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80045d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	01 c8                	add    %ecx,%eax
  80046e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800470:	39 c2                	cmp    %eax,%edx
  800472:	75 09                	jne    80047d <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800474:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80047b:	eb 19                	jmp    800496 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e8             	incl   -0x18(%ebp)
  800480:	a1 60 30 80 00       	mov    0x803060,%eax
  800485:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80048b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	0f 87 71 ff ff ff    	ja     800407 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80049a:	75 14                	jne    8004b0 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	68 10 21 80 00       	push   $0x802110
  8004a4:	6a 3a                	push   $0x3a
  8004a6:	68 04 21 80 00       	push   $0x802104
  8004ab:	e8 73 fe ff ff       	call   800323 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004b0:	ff 45 f0             	incl   -0x10(%ebp)
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b9:	0f 8c 1b ff ff ff    	jl     8003da <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004cd:	eb 2e                	jmp    8004fd <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004cf:	a1 60 30 80 00       	mov    0x803060,%eax
  8004d4:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004ea:	01 d8                	add    %ebx,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	3c 01                	cmp    $0x1,%al
  8004f5:	75 03                	jne    8004fa <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004f7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004fa:	ff 45 e0             	incl   -0x20(%ebp)
  8004fd:	a1 60 30 80 00       	mov    0x803060,%eax
  800502:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800508:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80050b:	39 c2                	cmp    %eax,%edx
  80050d:	77 c0                	ja     8004cf <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80050f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800512:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800515:	74 14                	je     80052b <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	68 64 21 80 00       	push   $0x802164
  80051f:	6a 44                	push   $0x44
  800521:	68 04 21 80 00       	push   $0x802104
  800526:	e8 f8 fd ff ff       	call   800323 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80052b:	90                   	nop
  80052c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	53                   	push   %ebx
  800535:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	8d 48 01             	lea    0x1(%eax),%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	89 0a                	mov    %ecx,(%edx)
  800545:	8b 55 08             	mov    0x8(%ebp),%edx
  800548:	88 d1                	mov    %dl,%cl
  80054a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800551:	8b 45 0c             	mov    0xc(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055b:	75 30                	jne    80058d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80055d:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  800563:	a0 84 30 80 00       	mov    0x803084,%al
  800568:	0f b6 c0             	movzbl %al,%eax
  80056b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80056e:	8b 09                	mov    (%ecx),%ecx
  800570:	89 cb                	mov    %ecx,%ebx
  800572:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800575:	83 c1 08             	add    $0x8,%ecx
  800578:	52                   	push   %edx
  800579:	50                   	push   %eax
  80057a:	53                   	push   %ebx
  80057b:	51                   	push   %ecx
  80057c:	e8 a0 0f 00 00       	call   801521 <sys_cputs>
  800581:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800584:	8b 45 0c             	mov    0xc(%ebp),%eax
  800587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800590:	8b 40 04             	mov    0x4(%eax),%eax
  800593:	8d 50 01             	lea    0x1(%eax),%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	89 50 04             	mov    %edx,0x4(%eax)
}
  80059c:	90                   	nop
  80059d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005b2:	00 00 00 
	b.cnt = 0;
  8005b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005bf:	ff 75 0c             	pushl  0xc(%ebp)
  8005c2:	ff 75 08             	pushl  0x8(%ebp)
  8005c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	68 31 05 80 00       	push   $0x800531
  8005d1:	e8 5a 02 00 00       	call   800830 <vprintfmt>
  8005d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005d9:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  8005df:	a0 84 30 80 00       	mov    0x803084,%al
  8005e4:	0f b6 c0             	movzbl %al,%eax
  8005e7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005ed:	52                   	push   %edx
  8005ee:	50                   	push   %eax
  8005ef:	51                   	push   %ecx
  8005f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f6:	83 c0 08             	add    $0x8,%eax
  8005f9:	50                   	push   %eax
  8005fa:	e8 22 0f 00 00       	call   801521 <sys_cputs>
  8005ff:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800602:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  800609:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800617:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  80061e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800621:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 f4             	pushl  -0xc(%ebp)
  80062d:	50                   	push   %eax
  80062e:	e8 6f ff ff ff       	call   8005a2 <vcprintf>
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800639:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800644:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	c1 e0 08             	shl    $0x8,%eax
  800651:	a3 7c 71 82 00       	mov    %eax,0x82717c
	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	83 c0 04             	add    $0x4,%eax
  80065c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	ff 75 f4             	pushl  -0xc(%ebp)
  800668:	50                   	push   %eax
  800669:	e8 34 ff ff ff       	call   8005a2 <vcprintf>
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800674:	c7 05 7c 71 82 00 00 	movl   $0x700,0x82717c
  80067b:	07 00 00 

	return cnt;
  80067e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800689:	e8 d7 0e 00 00       	call   801565 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80068e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800691:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 f4             	pushl  -0xc(%ebp)
  80069d:	50                   	push   %eax
  80069e:	e8 ff fe ff ff       	call   8005a2 <vcprintf>
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006a9:	e8 d1 0e 00 00       	call   80157f <sys_unlock_cons>
	return cnt;
  8006ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	53                   	push   %ebx
  8006b7:	83 ec 14             	sub    $0x14,%esp
  8006ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	77 55                	ja     800728 <printnum+0x75>
  8006d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d6:	72 05                	jb     8006dd <printnum+0x2a>
  8006d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006db:	77 4b                	ja     800728 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006dd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006e0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006eb:	52                   	push   %edx
  8006ec:	50                   	push   %eax
  8006ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8006f3:	e8 ac 13 00 00       	call   801aa4 <__udivdi3>
  8006f8:	83 c4 10             	add    $0x10,%esp
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	ff 75 20             	pushl  0x20(%ebp)
  800701:	53                   	push   %ebx
  800702:	ff 75 18             	pushl  0x18(%ebp)
  800705:	52                   	push   %edx
  800706:	50                   	push   %eax
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	ff 75 08             	pushl  0x8(%ebp)
  80070d:	e8 a1 ff ff ff       	call   8006b3 <printnum>
  800712:	83 c4 20             	add    $0x20,%esp
  800715:	eb 1a                	jmp    800731 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	ff 75 20             	pushl  0x20(%ebp)
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	ff d0                	call   *%eax
  800725:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800728:	ff 4d 1c             	decl   0x1c(%ebp)
  80072b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072f:	7f e6                	jg     800717 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800731:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800734:	bb 00 00 00 00       	mov    $0x0,%ebx
  800739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073f:	53                   	push   %ebx
  800740:	51                   	push   %ecx
  800741:	52                   	push   %edx
  800742:	50                   	push   %eax
  800743:	e8 6c 14 00 00       	call   801bb4 <__umoddi3>
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	05 d4 23 80 00       	add    $0x8023d4,%eax
  800750:	8a 00                	mov    (%eax),%al
  800752:	0f be c0             	movsbl %al,%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
}
  800764:	90                   	nop
  800765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80076d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800771:	7e 1c                	jle    80078f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	8d 50 08             	lea    0x8(%eax),%edx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 10                	mov    %edx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	83 e8 08             	sub    $0x8,%eax
  800788:	8b 50 04             	mov    0x4(%eax),%edx
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	eb 40                	jmp    8007cf <getuint+0x65>
	else if (lflag)
  80078f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800793:	74 1e                	je     8007b3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	89 10                	mov    %edx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b1:	eb 1c                	jmp    8007cf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	8d 50 04             	lea    0x4(%eax),%edx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	89 10                	mov    %edx,(%eax)
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	83 e8 04             	sub    $0x4,%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d8:	7e 1c                	jle    8007f6 <getint+0x25>
		return va_arg(*ap, long long);
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	8d 50 08             	lea    0x8(%eax),%edx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	89 10                	mov    %edx,(%eax)
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	83 e8 08             	sub    $0x8,%eax
  8007ef:	8b 50 04             	mov    0x4(%eax),%edx
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	eb 38                	jmp    80082e <getint+0x5d>
	else if (lflag)
  8007f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fa:	74 1a                	je     800816 <getint+0x45>
		return va_arg(*ap, long);
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	89 10                	mov    %edx,(%eax)
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	83 e8 04             	sub    $0x4,%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	99                   	cltd   
  800814:	eb 18                	jmp    80082e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	8d 50 04             	lea    0x4(%eax),%edx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	89 10                	mov    %edx,(%eax)
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	99                   	cltd   
}
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	56                   	push   %esi
  800834:	53                   	push   %ebx
  800835:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800838:	eb 17                	jmp    800851 <vprintfmt+0x21>
			if (ch == '\0')
  80083a:	85 db                	test   %ebx,%ebx
  80083c:	0f 84 c1 03 00 00    	je     800c03 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	53                   	push   %ebx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800851:	8b 45 10             	mov    0x10(%ebp),%eax
  800854:	8d 50 01             	lea    0x1(%eax),%edx
  800857:	89 55 10             	mov    %edx,0x10(%ebp)
  80085a:	8a 00                	mov    (%eax),%al
  80085c:	0f b6 d8             	movzbl %al,%ebx
  80085f:	83 fb 25             	cmp    $0x25,%ebx
  800862:	75 d6                	jne    80083a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800864:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800868:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800876:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80087d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800884:	8b 45 10             	mov    0x10(%ebp),%eax
  800887:	8d 50 01             	lea    0x1(%eax),%edx
  80088a:	89 55 10             	mov    %edx,0x10(%ebp)
  80088d:	8a 00                	mov    (%eax),%al
  80088f:	0f b6 d8             	movzbl %al,%ebx
  800892:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800895:	83 f8 5b             	cmp    $0x5b,%eax
  800898:	0f 87 3d 03 00 00    	ja     800bdb <vprintfmt+0x3ab>
  80089e:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8008a5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ab:	eb d7                	jmp    800884 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008b1:	eb d1                	jmp    800884 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008bd:	89 d0                	mov    %edx,%eax
  8008bf:	c1 e0 02             	shl    $0x2,%eax
  8008c2:	01 d0                	add    %edx,%eax
  8008c4:	01 c0                	add    %eax,%eax
  8008c6:	01 d8                	add    %ebx,%eax
  8008c8:	83 e8 30             	sub    $0x30,%eax
  8008cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d1:	8a 00                	mov    (%eax),%al
  8008d3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d6:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d9:	7e 3e                	jle    800919 <vprintfmt+0xe9>
  8008db:	83 fb 39             	cmp    $0x39,%ebx
  8008de:	7f 39                	jg     800919 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e3:	eb d5                	jmp    8008ba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e8:	83 c0 04             	add    $0x4,%eax
  8008eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	83 e8 04             	sub    $0x4,%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f9:	eb 1f                	jmp    80091a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	79 83                	jns    800884 <vprintfmt+0x54>
				width = 0;
  800901:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800908:	e9 77 ff ff ff       	jmp    800884 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80090d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800914:	e9 6b ff ff ff       	jmp    800884 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800919:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80091a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091e:	0f 89 60 ff ff ff    	jns    800884 <vprintfmt+0x54>
				width = precision, precision = -1;
  800924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800931:	e9 4e ff ff ff       	jmp    800884 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800936:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800939:	e9 46 ff ff ff       	jmp    800884 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	83 c0 04             	add    $0x4,%eax
  800944:	89 45 14             	mov    %eax,0x14(%ebp)
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	83 e8 04             	sub    $0x4,%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	50                   	push   %eax
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	ff d0                	call   *%eax
  80095b:	83 c4 10             	add    $0x10,%esp
			break;
  80095e:	e9 9b 02 00 00       	jmp    800bfe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	83 c0 04             	add    $0x4,%eax
  800969:	89 45 14             	mov    %eax,0x14(%ebp)
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	83 e8 04             	sub    $0x4,%eax
  800972:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800974:	85 db                	test   %ebx,%ebx
  800976:	79 02                	jns    80097a <vprintfmt+0x14a>
				err = -err;
  800978:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80097a:	83 fb 64             	cmp    $0x64,%ebx
  80097d:	7f 0b                	jg     80098a <vprintfmt+0x15a>
  80097f:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  800986:	85 f6                	test   %esi,%esi
  800988:	75 19                	jne    8009a3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80098a:	53                   	push   %ebx
  80098b:	68 e5 23 80 00       	push   $0x8023e5
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	ff 75 08             	pushl  0x8(%ebp)
  800996:	e8 70 02 00 00       	call   800c0b <printfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80099e:	e9 5b 02 00 00       	jmp    800bfe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a3:	56                   	push   %esi
  8009a4:	68 ee 23 80 00       	push   $0x8023ee
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	e8 57 02 00 00       	call   800c0b <printfmt>
  8009b4:	83 c4 10             	add    $0x10,%esp
			break;
  8009b7:	e9 42 02 00 00       	jmp    800bfe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 c0 04             	add    $0x4,%eax
  8009c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	83 e8 04             	sub    $0x4,%eax
  8009cb:	8b 30                	mov    (%eax),%esi
  8009cd:	85 f6                	test   %esi,%esi
  8009cf:	75 05                	jne    8009d6 <vprintfmt+0x1a6>
				p = "(null)";
  8009d1:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  8009d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009da:	7e 6d                	jle    800a49 <vprintfmt+0x219>
  8009dc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009e0:	74 67                	je     800a49 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	50                   	push   %eax
  8009e9:	56                   	push   %esi
  8009ea:	e8 1e 03 00 00       	call   800d0d <strnlen>
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f5:	eb 16                	jmp    800a0d <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	50                   	push   %eax
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a11:	7f e4                	jg     8009f7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a13:	eb 34                	jmp    800a49 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a19:	74 1c                	je     800a37 <vprintfmt+0x207>
  800a1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a1e:	7e 05                	jle    800a25 <vprintfmt+0x1f5>
  800a20:	83 fb 7e             	cmp    $0x7e,%ebx
  800a23:	7e 12                	jle    800a37 <vprintfmt+0x207>
					putch('?', putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	6a 3f                	push   $0x3f
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	ff d0                	call   *%eax
  800a32:	83 c4 10             	add    $0x10,%esp
  800a35:	eb 0f                	jmp    800a46 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	53                   	push   %ebx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a46:	ff 4d e4             	decl   -0x1c(%ebp)
  800a49:	89 f0                	mov    %esi,%eax
  800a4b:	8d 70 01             	lea    0x1(%eax),%esi
  800a4e:	8a 00                	mov    (%eax),%al
  800a50:	0f be d8             	movsbl %al,%ebx
  800a53:	85 db                	test   %ebx,%ebx
  800a55:	74 24                	je     800a7b <vprintfmt+0x24b>
  800a57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5b:	78 b8                	js     800a15 <vprintfmt+0x1e5>
  800a5d:	ff 4d e0             	decl   -0x20(%ebp)
  800a60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a64:	79 af                	jns    800a15 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	eb 13                	jmp    800a7b <vprintfmt+0x24b>
				putch(' ', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 20                	push   $0x20
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a78:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7f:	7f e7                	jg     800a68 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a81:	e9 78 01 00 00       	jmp    800bfe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 3c fd ff ff       	call   8007d1 <getint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa4:	85 d2                	test   %edx,%edx
  800aa6:	79 23                	jns    800acb <vprintfmt+0x29b>
				putch('-', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	6a 2d                	push   $0x2d
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abe:	f7 d8                	neg    %eax
  800ac0:	83 d2 00             	adc    $0x0,%edx
  800ac3:	f7 da                	neg    %edx
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 bc 00 00 00       	jmp    800b93 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 e8             	pushl  -0x18(%ebp)
  800add:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 84 fc ff ff       	call   80076a <getuint>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af6:	e9 98 00 00 00       	jmp    800b93 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	6a 58                	push   $0x58
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	ff d0                	call   *%eax
  800b08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	6a 58                	push   $0x58
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	6a 58                	push   $0x58
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	ff d0                	call   *%eax
  800b28:	83 c4 10             	add    $0x10,%esp
			break;
  800b2b:	e9 ce 00 00 00       	jmp    800bfe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b30:	83 ec 08             	sub    $0x8,%esp
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	6a 30                	push   $0x30
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	6a 78                	push   $0x78
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b50:	8b 45 14             	mov    0x14(%ebp),%eax
  800b53:	83 c0 04             	add    $0x4,%eax
  800b56:	89 45 14             	mov    %eax,0x14(%ebp)
  800b59:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5c:	83 e8 04             	sub    $0x4,%eax
  800b5f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b72:	eb 1f                	jmp    800b93 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b7d:	50                   	push   %eax
  800b7e:	e8 e7 fb ff ff       	call   80076a <getuint>
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b93:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	52                   	push   %edx
  800b9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 00 fb ff ff       	call   8006b3 <printnum>
  800bb3:	83 c4 20             	add    $0x20,%esp
			break;
  800bb6:	eb 46                	jmp    800bfe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	53                   	push   %ebx
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			break;
  800bc7:	eb 35                	jmp    800bfe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bc9:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800bd0:	eb 2c                	jmp    800bfe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bd2:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800bd9:	eb 23                	jmp    800bfe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	6a 25                	push   $0x25
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	ff d0                	call   *%eax
  800be8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800beb:	ff 4d 10             	decl   0x10(%ebp)
  800bee:	eb 03                	jmp    800bf3 <vprintfmt+0x3c3>
  800bf0:	ff 4d 10             	decl   0x10(%ebp)
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	48                   	dec    %eax
  800bf7:	8a 00                	mov    (%eax),%al
  800bf9:	3c 25                	cmp    $0x25,%al
  800bfb:	75 f3                	jne    800bf0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bfd:	90                   	nop
		}
	}
  800bfe:	e9 35 fc ff ff       	jmp    800838 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c03:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c11:	8d 45 10             	lea    0x10(%ebp),%eax
  800c14:	83 c0 04             	add    $0x4,%eax
  800c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c20:	50                   	push   %eax
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 04 fc ff ff       	call   800830 <vprintfmt>
  800c2c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c2f:	90                   	nop
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8b 40 08             	mov    0x8(%eax),%eax
  800c3b:	8d 50 01             	lea    0x1(%eax),%edx
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	8b 10                	mov    (%eax),%edx
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8b 40 04             	mov    0x4(%eax),%eax
  800c4f:	39 c2                	cmp    %eax,%edx
  800c51:	73 12                	jae    800c65 <sprintputch+0x33>
		*b->buf++ = ch;
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	8d 48 01             	lea    0x1(%eax),%ecx
  800c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5e:	89 0a                	mov    %ecx,(%edx)
  800c60:	8b 55 08             	mov    0x8(%ebp),%edx
  800c63:	88 10                	mov    %dl,(%eax)
}
  800c65:	90                   	nop
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	01 d0                	add    %edx,%eax
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c8d:	74 06                	je     800c95 <vsnprintf+0x2d>
  800c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c93:	7f 07                	jg     800c9c <vsnprintf+0x34>
		return -E_INVAL;
  800c95:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9a:	eb 20                	jmp    800cbc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c9c:	ff 75 14             	pushl  0x14(%ebp)
  800c9f:	ff 75 10             	pushl  0x10(%ebp)
  800ca2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ca5:	50                   	push   %eax
  800ca6:	68 32 0c 80 00       	push   $0x800c32
  800cab:	e8 80 fb ff ff       	call   800830 <vprintfmt>
  800cb0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc4:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc7:	83 c0 04             	add    $0x4,%eax
  800cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	ff 75 08             	pushl  0x8(%ebp)
  800cda:	e8 89 ff ff ff       	call   800c68 <vsnprintf>
  800cdf:	83 c4 10             	add    $0x10,%esp
  800ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf7:	eb 06                	jmp    800cff <strlen+0x15>
		n++;
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cfc:	ff 45 08             	incl   0x8(%ebp)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	75 f1                	jne    800cf9 <strlen+0xf>
		n++;
	return n;
  800d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1a:	eb 09                	jmp    800d25 <strnlen+0x18>
		n++;
  800d1c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1f:	ff 45 08             	incl   0x8(%ebp)
  800d22:	ff 4d 0c             	decl   0xc(%ebp)
  800d25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d29:	74 09                	je     800d34 <strnlen+0x27>
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	75 e8                	jne    800d1c <strnlen+0xf>
		n++;
	return n;
  800d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d45:	90                   	nop
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d55:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d58:	8a 12                	mov    (%edx),%dl
  800d5a:	88 10                	mov    %dl,(%eax)
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e4                	jne    800d46 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7a:	eb 1f                	jmp    800d9b <strncpy+0x34>
		*dst++ = *src;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8d 50 01             	lea    0x1(%eax),%edx
  800d82:	89 55 08             	mov    %edx,0x8(%ebp)
  800d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	74 03                	je     800d98 <strncpy+0x31>
			src++;
  800d95:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d98:	ff 45 fc             	incl   -0x4(%ebp)
  800d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da1:	72 d9                	jb     800d7c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db8:	74 30                	je     800dea <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dba:	eb 16                	jmp    800dd2 <strlcpy+0x2a>
			*dst++ = *src++;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dcb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dce:	8a 12                	mov    (%edx),%dl
  800dd0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd2:	ff 4d 10             	decl   0x10(%ebp)
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	74 09                	je     800de4 <strlcpy+0x3c>
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	84 c0                	test   %al,%al
  800de2:	75 d8                	jne    800dbc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df0:	29 c2                	sub    %eax,%edx
  800df2:	89 d0                	mov    %edx,%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df9:	eb 06                	jmp    800e01 <strcmp+0xb>
		p++, q++;
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	84 c0                	test   %al,%al
  800e08:	74 0e                	je     800e18 <strcmp+0x22>
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 10                	mov    (%eax),%dl
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	38 c2                	cmp    %al,%dl
  800e16:	74 e3                	je     800dfb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	0f b6 d0             	movzbl %al,%edx
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 c0             	movzbl %al,%eax
  800e28:	29 c2                	sub    %eax,%edx
  800e2a:	89 d0                	mov    %edx,%eax
}
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e31:	eb 09                	jmp    800e3c <strncmp+0xe>
		n--, p++, q++;
  800e33:	ff 4d 10             	decl   0x10(%ebp)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e40:	74 17                	je     800e59 <strncmp+0x2b>
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	74 0e                	je     800e59 <strncmp+0x2b>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 10                	mov    (%eax),%dl
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	38 c2                	cmp    %al,%dl
  800e57:	74 da                	je     800e33 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5d:	75 07                	jne    800e66 <strncmp+0x38>
		return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e64:	eb 14                	jmp    800e7a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	0f b6 d0             	movzbl %al,%edx
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 c0             	movzbl %al,%eax
  800e76:	29 c2                	sub    %eax,%edx
  800e78:	89 d0                	mov    %edx,%eax
}
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 04             	sub    $0x4,%esp
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e88:	eb 12                	jmp    800e9c <strchr+0x20>
		if (*s == c)
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e92:	75 05                	jne    800e99 <strchr+0x1d>
			return (char *) s;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	eb 11                	jmp    800eaa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e99:	ff 45 08             	incl   0x8(%ebp)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	84 c0                	test   %al,%al
  800ea3:	75 e5                	jne    800e8a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 04             	sub    $0x4,%esp
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb8:	eb 0d                	jmp    800ec7 <strfind+0x1b>
		if (*s == c)
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec2:	74 0e                	je     800ed2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec4:	ff 45 08             	incl   0x8(%ebp)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	84 c0                	test   %al,%al
  800ece:	75 ea                	jne    800eba <strfind+0xe>
  800ed0:	eb 01                	jmp    800ed3 <strfind+0x27>
		if (*s == c)
			break;
  800ed2:	90                   	nop
	return (char *) s;
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ee4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee8:	76 63                	jbe    800f4d <memset+0x75>
		uint64 data_block = c;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	99                   	cltd   
  800eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efa:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800efe:	c1 e0 08             	shl    $0x8,%eax
  800f01:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f04:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f11:	c1 e0 10             	shl    $0x10,%eax
  800f14:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f17:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f20:	89 c2                	mov    %eax,%edx
  800f22:	b8 00 00 00 00       	mov    $0x0,%eax
  800f27:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f2a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f2d:	eb 18                	jmp    800f47 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f2f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f32:	8d 41 08             	lea    0x8(%ecx),%eax
  800f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3e:	89 01                	mov    %eax,(%ecx)
  800f40:	89 51 04             	mov    %edx,0x4(%ecx)
  800f43:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f47:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4b:	77 e2                	ja     800f2f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f51:	74 23                	je     800f76 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f56:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f59:	eb 0e                	jmp    800f69 <memset+0x91>
			*p8++ = (uint8)c;
  800f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5e:	8d 50 01             	lea    0x1(%eax),%edx
  800f61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f67:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	75 e5                	jne    800f5b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f8d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f91:	76 24                	jbe    800fb7 <memcpy+0x3c>
		while(n >= 8){
  800f93:	eb 1c                	jmp    800fb1 <memcpy+0x36>
			*d64 = *s64;
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	8b 50 04             	mov    0x4(%eax),%edx
  800f9b:	8b 00                	mov    (%eax),%eax
  800f9d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fa0:	89 01                	mov    %eax,(%ecx)
  800fa2:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fa5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fa9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fad:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fb1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb5:	77 de                	ja     800f95 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbb:	74 31                	je     800fee <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fc9:	eb 16                	jmp    800fe1 <memcpy+0x66>
			*d8++ = *s8++;
  800fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fce:	8d 50 01             	lea    0x1(%eax),%edx
  800fd1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fda:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fdd:	8a 12                	mov    (%edx),%dl
  800fdf:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fea:	85 c0                	test   %eax,%eax
  800fec:	75 dd                	jne    800fcb <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801008:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80100b:	73 50                	jae    80105d <memmove+0x6a>
  80100d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	01 d0                	add    %edx,%eax
  801015:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801018:	76 43                	jbe    80105d <memmove+0x6a>
		s += n;
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801026:	eb 10                	jmp    801038 <memmove+0x45>
			*--d = *--s;
  801028:	ff 4d f8             	decl   -0x8(%ebp)
  80102b:	ff 4d fc             	decl   -0x4(%ebp)
  80102e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801031:	8a 10                	mov    (%eax),%dl
  801033:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801036:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801038:	8b 45 10             	mov    0x10(%ebp),%eax
  80103b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103e:	89 55 10             	mov    %edx,0x10(%ebp)
  801041:	85 c0                	test   %eax,%eax
  801043:	75 e3                	jne    801028 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801045:	eb 23                	jmp    80106a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	8d 50 01             	lea    0x1(%eax),%edx
  80104d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801050:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801053:	8d 4a 01             	lea    0x1(%edx),%ecx
  801056:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801059:	8a 12                	mov    (%edx),%dl
  80105b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	8d 50 ff             	lea    -0x1(%eax),%edx
  801063:	89 55 10             	mov    %edx,0x10(%ebp)
  801066:	85 c0                	test   %eax,%eax
  801068:	75 dd                	jne    801047 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801081:	eb 2a                	jmp    8010ad <memcmp+0x3e>
		if (*s1 != *s2)
  801083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801086:	8a 10                	mov    (%eax),%dl
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	38 c2                	cmp    %al,%dl
  80108f:	74 16                	je     8010a7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f b6 d0             	movzbl %al,%edx
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 c0             	movzbl %al,%eax
  8010a1:	29 c2                	sub    %eax,%edx
  8010a3:	89 d0                	mov    %edx,%eax
  8010a5:	eb 18                	jmp    8010bf <memcmp+0x50>
		s1++, s2++;
  8010a7:	ff 45 fc             	incl   -0x4(%ebp)
  8010aa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	75 c9                	jne    801083 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d2:	eb 15                	jmp    8010e9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f b6 d0             	movzbl %al,%edx
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	0f b6 c0             	movzbl %al,%eax
  8010e2:	39 c2                	cmp    %eax,%edx
  8010e4:	74 0d                	je     8010f3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e6:	ff 45 08             	incl   0x8(%ebp)
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ef:	72 e3                	jb     8010d4 <memfind+0x13>
  8010f1:	eb 01                	jmp    8010f4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f3:	90                   	nop
	return (void *) s;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801106:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110d:	eb 03                	jmp    801112 <strtol+0x19>
		s++;
  80110f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	3c 20                	cmp    $0x20,%al
  801119:	74 f4                	je     80110f <strtol+0x16>
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	3c 09                	cmp    $0x9,%al
  801122:	74 eb                	je     80110f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	3c 2b                	cmp    $0x2b,%al
  80112b:	75 05                	jne    801132 <strtol+0x39>
		s++;
  80112d:	ff 45 08             	incl   0x8(%ebp)
  801130:	eb 13                	jmp    801145 <strtol+0x4c>
	else if (*s == '-')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2d                	cmp    $0x2d,%al
  801139:	75 0a                	jne    801145 <strtol+0x4c>
		s++, neg = 1;
  80113b:	ff 45 08             	incl   0x8(%ebp)
  80113e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801145:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801149:	74 06                	je     801151 <strtol+0x58>
  80114b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80114f:	75 20                	jne    801171 <strtol+0x78>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 30                	cmp    $0x30,%al
  801158:	75 17                	jne    801171 <strtol+0x78>
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	40                   	inc    %eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 78                	cmp    $0x78,%al
  801162:	75 0d                	jne    801171 <strtol+0x78>
		s += 2, base = 16;
  801164:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801168:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80116f:	eb 28                	jmp    801199 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801171:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801175:	75 15                	jne    80118c <strtol+0x93>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 0c                	jne    80118c <strtol+0x93>
		s++, base = 8;
  801180:	ff 45 08             	incl   0x8(%ebp)
  801183:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80118a:	eb 0d                	jmp    801199 <strtol+0xa0>
	else if (base == 0)
  80118c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801190:	75 07                	jne    801199 <strtol+0xa0>
		base = 10;
  801192:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	3c 2f                	cmp    $0x2f,%al
  8011a0:	7e 19                	jle    8011bb <strtol+0xc2>
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	3c 39                	cmp    $0x39,%al
  8011a9:	7f 10                	jg     8011bb <strtol+0xc2>
			dig = *s - '0';
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	0f be c0             	movsbl %al,%eax
  8011b3:	83 e8 30             	sub    $0x30,%eax
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b9:	eb 42                	jmp    8011fd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 60                	cmp    $0x60,%al
  8011c2:	7e 19                	jle    8011dd <strtol+0xe4>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 7a                	cmp    $0x7a,%al
  8011cb:	7f 10                	jg     8011dd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	0f be c0             	movsbl %al,%eax
  8011d5:	83 e8 57             	sub    $0x57,%eax
  8011d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011db:	eb 20                	jmp    8011fd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 40                	cmp    $0x40,%al
  8011e4:	7e 39                	jle    80121f <strtol+0x126>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 5a                	cmp    $0x5a,%al
  8011ed:	7f 30                	jg     80121f <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 37             	sub    $0x37,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801200:	3b 45 10             	cmp    0x10(%ebp),%eax
  801203:	7d 19                	jge    80121e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801205:	ff 45 08             	incl   0x8(%ebp)
  801208:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801219:	e9 7b ff ff ff       	jmp    801199 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80121e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80121f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801223:	74 08                	je     80122d <strtol+0x134>
		*endptr = (char *) s;
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
  80122b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80122d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801231:	74 07                	je     80123a <strtol+0x141>
  801233:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801236:	f7 d8                	neg    %eax
  801238:	eb 03                	jmp    80123d <strtol+0x144>
  80123a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <ltostr>:

void
ltostr(long value, char *str)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801257:	79 13                	jns    80126c <ltostr+0x2d>
	{
		neg = 1;
  801259:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801266:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801269:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801274:	99                   	cltd   
  801275:	f7 f9                	idiv   %ecx
  801277:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	8d 50 01             	lea    0x1(%eax),%edx
  801280:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801283:	89 c2                	mov    %eax,%edx
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80128d:	83 c2 30             	add    $0x30,%edx
  801290:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801292:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801295:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80129a:	f7 e9                	imul   %ecx
  80129c:	c1 fa 02             	sar    $0x2,%edx
  80129f:	89 c8                	mov    %ecx,%eax
  8012a1:	c1 f8 1f             	sar    $0x1f,%eax
  8012a4:	29 c2                	sub    %eax,%edx
  8012a6:	89 d0                	mov    %edx,%eax
  8012a8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	75 bb                	jne    80126c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bb:	48                   	dec    %eax
  8012bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c3:	74 3d                	je     801302 <ltostr+0xc3>
		start = 1 ;
  8012c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012cc:	eb 34                	jmp    801302 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	01 d0                	add    %edx,%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	01 c2                	add    %eax,%edx
  8012e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	01 c8                	add    %ecx,%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	01 c2                	add    %eax,%edx
  8012f7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012fa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012fc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801305:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801308:	7c c4                	jl     8012ce <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80130a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801315:	90                   	nop
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80131e:	ff 75 08             	pushl  0x8(%ebp)
  801321:	e8 c4 f9 ff ff       	call   800cea <strlen>
  801326:	83 c4 04             	add    $0x4,%esp
  801329:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80132c:	ff 75 0c             	pushl  0xc(%ebp)
  80132f:	e8 b6 f9 ff ff       	call   800cea <strlen>
  801334:	83 c4 04             	add    $0x4,%esp
  801337:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80133a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801348:	eb 17                	jmp    801361 <strcconcat+0x49>
		final[s] = str1[s] ;
  80134a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	01 c2                	add    %eax,%edx
  801352:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	01 c8                	add    %ecx,%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80135e:	ff 45 fc             	incl   -0x4(%ebp)
  801361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801364:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801367:	7c e1                	jl     80134a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801369:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801370:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801377:	eb 1f                	jmp    801398 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8d 50 01             	lea    0x1(%eax),%edx
  80137f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801382:	89 c2                	mov    %eax,%edx
  801384:	8b 45 10             	mov    0x10(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c8                	add    %ecx,%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801395:	ff 45 f8             	incl   -0x8(%ebp)
  801398:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139e:	7c d9                	jl     801379 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	01 d0                	add    %edx,%eax
  8013a8:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ab:	90                   	nop
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c9:	01 d0                	add    %edx,%eax
  8013cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013d1:	eb 0c                	jmp    8013df <strsplit+0x31>
			*string++ = 0;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8d 50 01             	lea    0x1(%eax),%edx
  8013d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013dc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	84 c0                	test   %al,%al
  8013e6:	74 18                	je     801400 <strsplit+0x52>
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	0f be c0             	movsbl %al,%eax
  8013f0:	50                   	push   %eax
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	e8 83 fa ff ff       	call   800e7c <strchr>
  8013f9:	83 c4 08             	add    $0x8,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	75 d3                	jne    8013d3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	74 5a                	je     801463 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	83 f8 0f             	cmp    $0xf,%eax
  801411:	75 07                	jne    80141a <strsplit+0x6c>
		{
			return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
  801418:	eb 66                	jmp    801480 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80141a:	8b 45 14             	mov    0x14(%ebp),%eax
  80141d:	8b 00                	mov    (%eax),%eax
  80141f:	8d 48 01             	lea    0x1(%eax),%ecx
  801422:	8b 55 14             	mov    0x14(%ebp),%edx
  801425:	89 0a                	mov    %ecx,(%edx)
  801427:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142e:	8b 45 10             	mov    0x10(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801438:	eb 03                	jmp    80143d <strsplit+0x8f>
			string++;
  80143a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	84 c0                	test   %al,%al
  801444:	74 8b                	je     8013d1 <strsplit+0x23>
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	0f be c0             	movsbl %al,%eax
  80144e:	50                   	push   %eax
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	e8 25 fa ff ff       	call   800e7c <strchr>
  801457:	83 c4 08             	add    $0x8,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	74 dc                	je     80143a <strsplit+0x8c>
			string++;
	}
  80145e:	e9 6e ff ff ff       	jmp    8013d1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801463:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801464:	8b 45 14             	mov    0x14(%ebp),%eax
  801467:	8b 00                	mov    (%eax),%eax
  801469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80147b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80148e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801495:	eb 4a                	jmp    8014e1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801497:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	01 c2                	add    %eax,%edx
  80149f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	01 c8                	add    %ecx,%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b1:	01 d0                	add    %edx,%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	3c 40                	cmp    $0x40,%al
  8014b7:	7e 25                	jle    8014de <str2lower+0x5c>
  8014b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	01 d0                	add    %edx,%eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	3c 5a                	cmp    $0x5a,%al
  8014c5:	7f 17                	jg     8014de <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	01 d0                	add    %edx,%eax
  8014cf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d5:	01 ca                	add    %ecx,%edx
  8014d7:	8a 12                	mov    (%edx),%dl
  8014d9:	83 c2 20             	add    $0x20,%edx
  8014dc:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014de:	ff 45 fc             	incl   -0x4(%ebp)
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 01 f8 ff ff       	call   800cea <strlen>
  8014e9:	83 c4 04             	add    $0x4,%esp
  8014ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ef:	7f a6                	jg     801497 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	57                   	push   %edi
  8014fa:	56                   	push   %esi
  8014fb:	53                   	push   %ebx
  8014fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801508:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80150b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80150e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801511:	cd 30                	int    $0x30
  801513:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5f                   	pop    %edi
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	8b 45 10             	mov    0x10(%ebp),%eax
  80152a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80152d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801530:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	6a 00                	push   $0x0
  801539:	51                   	push   %ecx
  80153a:	52                   	push   %edx
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	50                   	push   %eax
  80153f:	6a 00                	push   $0x0
  801541:	e8 b0 ff ff ff       	call   8014f6 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	90                   	nop
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_cgetc>:

int
sys_cgetc(void)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 02                	push   $0x2
  80155b:	e8 96 ff ff ff       	call   8014f6 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 03                	push   $0x3
  801574:	e8 7d ff ff ff       	call   8014f6 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	90                   	nop
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 04                	push   $0x4
  80158e:	e8 63 ff ff ff       	call   8014f6 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	90                   	nop
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80159c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	52                   	push   %edx
  8015a9:	50                   	push   %eax
  8015aa:	6a 08                	push   $0x8
  8015ac:	e8 45 ff ff ff       	call   8014f6 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8015be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	56                   	push   %esi
  8015cb:	53                   	push   %ebx
  8015cc:	51                   	push   %ecx
  8015cd:	52                   	push   %edx
  8015ce:	50                   	push   %eax
  8015cf:	6a 09                	push   $0x9
  8015d1:	e8 20 ff ff ff       	call   8014f6 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015dc:	5b                   	pop    %ebx
  8015dd:	5e                   	pop    %esi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	6a 0a                	push   $0xa
  8015f0:	e8 01 ff ff ff       	call   8014f6 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	ff 75 08             	pushl  0x8(%ebp)
  801609:	6a 0b                	push   $0xb
  80160b:	e8 e6 fe ff ff       	call   8014f6 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 0c                	push   $0xc
  801624:	e8 cd fe ff ff       	call   8014f6 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 0d                	push   $0xd
  80163d:	e8 b4 fe ff ff       	call   8014f6 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 0e                	push   $0xe
  801656:	e8 9b fe ff ff       	call   8014f6 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 0f                	push   $0xf
  80166f:	e8 82 fe ff ff       	call   8014f6 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	6a 10                	push   $0x10
  801689:	e8 68 fe ff ff       	call   8014f6 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 11                	push   $0x11
  8016a2:	e8 4f fe ff ff       	call   8014f6 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	90                   	nop
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_cputc>:

void
sys_cputc(const char c)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	50                   	push   %eax
  8016c6:	6a 01                	push   $0x1
  8016c8:	e8 29 fe ff ff       	call   8014f6 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 14                	push   $0x14
  8016e2:	e8 0f fe ff ff       	call   8014f6 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	51                   	push   %ecx
  801706:	52                   	push   %edx
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	50                   	push   %eax
  80170b:	6a 15                	push   $0x15
  80170d:	e8 e4 fd ff ff       	call   8014f6 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	6a 16                	push   $0x16
  80172a:	e8 c7 fd ff ff       	call   8014f6 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801737:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	51                   	push   %ecx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 17                	push   $0x17
  801749:	e8 a8 fd ff ff       	call   8014f6 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 18                	push   $0x18
  801766:	e8 8b fd ff ff       	call   8014f6 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	6a 00                	push   $0x0
  801778:	ff 75 14             	pushl  0x14(%ebp)
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	50                   	push   %eax
  801782:	6a 19                	push   $0x19
  801784:	e8 6d fd ff ff       	call   8014f6 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	50                   	push   %eax
  80179d:	6a 1a                	push   $0x1a
  80179f:	e8 52 fd ff ff       	call   8014f6 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	90                   	nop
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	50                   	push   %eax
  8017b9:	6a 1b                	push   $0x1b
  8017bb:	e8 36 fd ff ff       	call   8014f6 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 05                	push   $0x5
  8017d4:	e8 1d fd ff ff       	call   8014f6 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 06                	push   $0x6
  8017ed:	e8 04 fd ff ff       	call   8014f6 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 07                	push   $0x7
  801806:	e8 eb fc ff ff       	call   8014f6 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_exit_env>:


void sys_exit_env(void)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 1c                	push   $0x1c
  80181f:	e8 d2 fc ff ff       	call   8014f6 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	90                   	nop
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801830:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801833:	8d 50 04             	lea    0x4(%eax),%edx
  801836:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	52                   	push   %edx
  801840:	50                   	push   %eax
  801841:	6a 1d                	push   $0x1d
  801843:	e8 ae fc ff ff       	call   8014f6 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
	return result;
  80184b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80184e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801851:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801854:	89 01                	mov    %eax,(%ecx)
  801856:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	c9                   	leave  
  80185d:	c2 04 00             	ret    $0x4

00801860 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	ff 75 10             	pushl  0x10(%ebp)
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	6a 13                	push   $0x13
  801872:	e8 7f fc ff ff       	call   8014f6 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
	return ;
  80187a:	90                   	nop
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_rcr2>:
uint32 sys_rcr2()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 1e                	push   $0x1e
  80188c:	e8 65 fc ff ff       	call   8014f6 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018a2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	50                   	push   %eax
  8018af:	6a 1f                	push   $0x1f
  8018b1:	e8 40 fc ff ff       	call   8014f6 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <rsttst>:
void rsttst()
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 21                	push   $0x21
  8018cb:	e8 26 fc ff ff       	call   8014f6 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d3:	90                   	nop
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018e2:	8b 55 18             	mov    0x18(%ebp),%edx
  8018e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018e9:	52                   	push   %edx
  8018ea:	50                   	push   %eax
  8018eb:	ff 75 10             	pushl  0x10(%ebp)
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 20                	push   $0x20
  8018f6:	e8 fb fb ff ff       	call   8014f6 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fe:	90                   	nop
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <chktst>:
void chktst(uint32 n)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	6a 22                	push   $0x22
  801911:	e8 e0 fb ff ff       	call   8014f6 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
	return ;
  801919:	90                   	nop
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <inctst>:

void inctst()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 23                	push   $0x23
  80192b:	e8 c6 fb ff ff       	call   8014f6 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
	return ;
  801933:	90                   	nop
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <gettst>:
uint32 gettst()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 24                	push   $0x24
  801945:	e8 ac fb ff ff       	call   8014f6 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 25                	push   $0x25
  80195e:	e8 93 fb ff ff       	call   8014f6 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
  801966:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	return uheapPlaceStrategy ;
  80196b:	a1 c0 70 82 00       	mov    0x8270c0,%eax
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	6a 26                	push   $0x26
  80198a:	e8 67 fb ff ff       	call   8014f6 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
	return ;
  801992:	90                   	nop
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801999:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80199c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	53                   	push   %ebx
  8019a8:	51                   	push   %ecx
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	6a 27                	push   $0x27
  8019ad:	e8 44 fb ff ff       	call   8014f6 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	52                   	push   %edx
  8019ca:	50                   	push   %eax
  8019cb:	6a 28                	push   $0x28
  8019cd:	e8 24 fb ff ff       	call   8014f6 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	51                   	push   %ecx
  8019e6:	ff 75 10             	pushl  0x10(%ebp)
  8019e9:	52                   	push   %edx
  8019ea:	50                   	push   %eax
  8019eb:	6a 29                	push   $0x29
  8019ed:	e8 04 fb ff ff       	call   8014f6 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 10             	pushl  0x10(%ebp)
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	6a 12                	push   $0x12
  801a09:	e8 e8 fa ff ff       	call   8014f6 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a11:	90                   	nop
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 2a                	push   $0x2a
  801a27:	e8 ca fa ff ff       	call   8014f6 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 2b                	push   $0x2b
  801a41:	e8 b0 fa ff ff       	call   8014f6 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	6a 2d                	push   $0x2d
  801a5c:	e8 95 fa ff ff       	call   8014f6 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	ff 75 08             	pushl  0x8(%ebp)
  801a76:	6a 2c                	push   $0x2c
  801a78:	e8 79 fa ff ff       	call   8014f6 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a80:	90                   	nop
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 2e                	push   $0x2e
  801a96:	e8 5b fa ff ff       	call   8014f6 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9e:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    
  801aa1:	66 90                	xchg   %ax,%ax
  801aa3:	90                   	nop

00801aa4 <__udivdi3>:
  801aa4:	55                   	push   %ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 1c             	sub    $0x1c,%esp
  801aab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aaf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801abb:	89 ca                	mov    %ecx,%edx
  801abd:	89 f8                	mov    %edi,%eax
  801abf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ac3:	85 f6                	test   %esi,%esi
  801ac5:	75 2d                	jne    801af4 <__udivdi3+0x50>
  801ac7:	39 cf                	cmp    %ecx,%edi
  801ac9:	77 65                	ja     801b30 <__udivdi3+0x8c>
  801acb:	89 fd                	mov    %edi,%ebp
  801acd:	85 ff                	test   %edi,%edi
  801acf:	75 0b                	jne    801adc <__udivdi3+0x38>
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad6:	31 d2                	xor    %edx,%edx
  801ad8:	f7 f7                	div    %edi
  801ada:	89 c5                	mov    %eax,%ebp
  801adc:	31 d2                	xor    %edx,%edx
  801ade:	89 c8                	mov    %ecx,%eax
  801ae0:	f7 f5                	div    %ebp
  801ae2:	89 c1                	mov    %eax,%ecx
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	f7 f5                	div    %ebp
  801ae8:	89 cf                	mov    %ecx,%edi
  801aea:	89 fa                	mov    %edi,%edx
  801aec:	83 c4 1c             	add    $0x1c,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5f                   	pop    %edi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    
  801af4:	39 ce                	cmp    %ecx,%esi
  801af6:	77 28                	ja     801b20 <__udivdi3+0x7c>
  801af8:	0f bd fe             	bsr    %esi,%edi
  801afb:	83 f7 1f             	xor    $0x1f,%edi
  801afe:	75 40                	jne    801b40 <__udivdi3+0x9c>
  801b00:	39 ce                	cmp    %ecx,%esi
  801b02:	72 0a                	jb     801b0e <__udivdi3+0x6a>
  801b04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b08:	0f 87 9e 00 00 00    	ja     801bac <__udivdi3+0x108>
  801b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b13:	89 fa                	mov    %edi,%edx
  801b15:	83 c4 1c             	add    $0x1c,%esp
  801b18:	5b                   	pop    %ebx
  801b19:	5e                   	pop    %esi
  801b1a:	5f                   	pop    %edi
  801b1b:	5d                   	pop    %ebp
  801b1c:	c3                   	ret    
  801b1d:	8d 76 00             	lea    0x0(%esi),%esi
  801b20:	31 ff                	xor    %edi,%edi
  801b22:	31 c0                	xor    %eax,%eax
  801b24:	89 fa                	mov    %edi,%edx
  801b26:	83 c4 1c             	add    $0x1c,%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5e                   	pop    %esi
  801b2b:	5f                   	pop    %edi
  801b2c:	5d                   	pop    %ebp
  801b2d:	c3                   	ret    
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	f7 f7                	div    %edi
  801b34:	31 ff                	xor    %edi,%edi
  801b36:	89 fa                	mov    %edi,%edx
  801b38:	83 c4 1c             	add    $0x1c,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    
  801b40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b45:	89 eb                	mov    %ebp,%ebx
  801b47:	29 fb                	sub    %edi,%ebx
  801b49:	89 f9                	mov    %edi,%ecx
  801b4b:	d3 e6                	shl    %cl,%esi
  801b4d:	89 c5                	mov    %eax,%ebp
  801b4f:	88 d9                	mov    %bl,%cl
  801b51:	d3 ed                	shr    %cl,%ebp
  801b53:	89 e9                	mov    %ebp,%ecx
  801b55:	09 f1                	or     %esi,%ecx
  801b57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b5b:	89 f9                	mov    %edi,%ecx
  801b5d:	d3 e0                	shl    %cl,%eax
  801b5f:	89 c5                	mov    %eax,%ebp
  801b61:	89 d6                	mov    %edx,%esi
  801b63:	88 d9                	mov    %bl,%cl
  801b65:	d3 ee                	shr    %cl,%esi
  801b67:	89 f9                	mov    %edi,%ecx
  801b69:	d3 e2                	shl    %cl,%edx
  801b6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b6f:	88 d9                	mov    %bl,%cl
  801b71:	d3 e8                	shr    %cl,%eax
  801b73:	09 c2                	or     %eax,%edx
  801b75:	89 d0                	mov    %edx,%eax
  801b77:	89 f2                	mov    %esi,%edx
  801b79:	f7 74 24 0c          	divl   0xc(%esp)
  801b7d:	89 d6                	mov    %edx,%esi
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	f7 e5                	mul    %ebp
  801b83:	39 d6                	cmp    %edx,%esi
  801b85:	72 19                	jb     801ba0 <__udivdi3+0xfc>
  801b87:	74 0b                	je     801b94 <__udivdi3+0xf0>
  801b89:	89 d8                	mov    %ebx,%eax
  801b8b:	31 ff                	xor    %edi,%edi
  801b8d:	e9 58 ff ff ff       	jmp    801aea <__udivdi3+0x46>
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b98:	89 f9                	mov    %edi,%ecx
  801b9a:	d3 e2                	shl    %cl,%edx
  801b9c:	39 c2                	cmp    %eax,%edx
  801b9e:	73 e9                	jae    801b89 <__udivdi3+0xe5>
  801ba0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ba3:	31 ff                	xor    %edi,%edi
  801ba5:	e9 40 ff ff ff       	jmp    801aea <__udivdi3+0x46>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	31 c0                	xor    %eax,%eax
  801bae:	e9 37 ff ff ff       	jmp    801aea <__udivdi3+0x46>
  801bb3:	90                   	nop

00801bb4 <__umoddi3>:
  801bb4:	55                   	push   %ebp
  801bb5:	57                   	push   %edi
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 1c             	sub    $0x1c,%esp
  801bbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bd3:	89 f3                	mov    %esi,%ebx
  801bd5:	89 fa                	mov    %edi,%edx
  801bd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bdb:	89 34 24             	mov    %esi,(%esp)
  801bde:	85 c0                	test   %eax,%eax
  801be0:	75 1a                	jne    801bfc <__umoddi3+0x48>
  801be2:	39 f7                	cmp    %esi,%edi
  801be4:	0f 86 a2 00 00 00    	jbe    801c8c <__umoddi3+0xd8>
  801bea:	89 c8                	mov    %ecx,%eax
  801bec:	89 f2                	mov    %esi,%edx
  801bee:	f7 f7                	div    %edi
  801bf0:	89 d0                	mov    %edx,%eax
  801bf2:	31 d2                	xor    %edx,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	39 f0                	cmp    %esi,%eax
  801bfe:	0f 87 ac 00 00 00    	ja     801cb0 <__umoddi3+0xfc>
  801c04:	0f bd e8             	bsr    %eax,%ebp
  801c07:	83 f5 1f             	xor    $0x1f,%ebp
  801c0a:	0f 84 ac 00 00 00    	je     801cbc <__umoddi3+0x108>
  801c10:	bf 20 00 00 00       	mov    $0x20,%edi
  801c15:	29 ef                	sub    %ebp,%edi
  801c17:	89 fe                	mov    %edi,%esi
  801c19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c1d:	89 e9                	mov    %ebp,%ecx
  801c1f:	d3 e0                	shl    %cl,%eax
  801c21:	89 d7                	mov    %edx,%edi
  801c23:	89 f1                	mov    %esi,%ecx
  801c25:	d3 ef                	shr    %cl,%edi
  801c27:	09 c7                	or     %eax,%edi
  801c29:	89 e9                	mov    %ebp,%ecx
  801c2b:	d3 e2                	shl    %cl,%edx
  801c2d:	89 14 24             	mov    %edx,(%esp)
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	d3 e0                	shl    %cl,%eax
  801c34:	89 c2                	mov    %eax,%edx
  801c36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3a:	d3 e0                	shl    %cl,%eax
  801c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c44:	89 f1                	mov    %esi,%ecx
  801c46:	d3 e8                	shr    %cl,%eax
  801c48:	09 d0                	or     %edx,%eax
  801c4a:	d3 eb                	shr    %cl,%ebx
  801c4c:	89 da                	mov    %ebx,%edx
  801c4e:	f7 f7                	div    %edi
  801c50:	89 d3                	mov    %edx,%ebx
  801c52:	f7 24 24             	mull   (%esp)
  801c55:	89 c6                	mov    %eax,%esi
  801c57:	89 d1                	mov    %edx,%ecx
  801c59:	39 d3                	cmp    %edx,%ebx
  801c5b:	0f 82 87 00 00 00    	jb     801ce8 <__umoddi3+0x134>
  801c61:	0f 84 91 00 00 00    	je     801cf8 <__umoddi3+0x144>
  801c67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c6b:	29 f2                	sub    %esi,%edx
  801c6d:	19 cb                	sbb    %ecx,%ebx
  801c6f:	89 d8                	mov    %ebx,%eax
  801c71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c75:	d3 e0                	shl    %cl,%eax
  801c77:	89 e9                	mov    %ebp,%ecx
  801c79:	d3 ea                	shr    %cl,%edx
  801c7b:	09 d0                	or     %edx,%eax
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 eb                	shr    %cl,%ebx
  801c81:	89 da                	mov    %ebx,%edx
  801c83:	83 c4 1c             	add    $0x1c,%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5f                   	pop    %edi
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    
  801c8b:	90                   	nop
  801c8c:	89 fd                	mov    %edi,%ebp
  801c8e:	85 ff                	test   %edi,%edi
  801c90:	75 0b                	jne    801c9d <__umoddi3+0xe9>
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	31 d2                	xor    %edx,%edx
  801c99:	f7 f7                	div    %edi
  801c9b:	89 c5                	mov    %eax,%ebp
  801c9d:	89 f0                	mov    %esi,%eax
  801c9f:	31 d2                	xor    %edx,%edx
  801ca1:	f7 f5                	div    %ebp
  801ca3:	89 c8                	mov    %ecx,%eax
  801ca5:	f7 f5                	div    %ebp
  801ca7:	89 d0                	mov    %edx,%eax
  801ca9:	e9 44 ff ff ff       	jmp    801bf2 <__umoddi3+0x3e>
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	89 c8                	mov    %ecx,%eax
  801cb2:	89 f2                	mov    %esi,%edx
  801cb4:	83 c4 1c             	add    $0x1c,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5e                   	pop    %esi
  801cb9:	5f                   	pop    %edi
  801cba:	5d                   	pop    %ebp
  801cbb:	c3                   	ret    
  801cbc:	3b 04 24             	cmp    (%esp),%eax
  801cbf:	72 06                	jb     801cc7 <__umoddi3+0x113>
  801cc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cc5:	77 0f                	ja     801cd6 <__umoddi3+0x122>
  801cc7:	89 f2                	mov    %esi,%edx
  801cc9:	29 f9                	sub    %edi,%ecx
  801ccb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ccf:	89 14 24             	mov    %edx,(%esp)
  801cd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cda:	8b 14 24             	mov    (%esp),%edx
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    
  801ce5:	8d 76 00             	lea    0x0(%esi),%esi
  801ce8:	2b 04 24             	sub    (%esp),%eax
  801ceb:	19 fa                	sbb    %edi,%edx
  801ced:	89 d1                	mov    %edx,%ecx
  801cef:	89 c6                	mov    %eax,%esi
  801cf1:	e9 71 ff ff ff       	jmp    801c67 <__umoddi3+0xb3>
  801cf6:	66 90                	xchg   %ax,%ax
  801cf8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cfc:	72 ea                	jb     801ce8 <__umoddi3+0x134>
  801cfe:	89 d9                	mov    %ebx,%ecx
  801d00:	e9 62 ff ff ff       	jmp    801c67 <__umoddi3+0xb3>
