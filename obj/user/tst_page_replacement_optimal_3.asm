
obj/user/tst_page_replacement_optimal_3:     file format elf32-i386


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
  800031:	e8 28 01 00 00       	call   80015e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x800000, 0x801000, 0x802000,		//Code
		0x803000,0x804000,0x805000,0x806000,0x807000,0x808000,0x809000, 	//Data
		0xeebfd000, 	//Stack
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  80003e:	6a 01                	push   $0x1
  800040:	68 00 00 80 00       	push   $0x800000
  800045:	6a 0b                	push   $0xb
  800047:	68 20 30 80 00       	push   $0x803020
  80004c:	e8 71 19 00 00       	call   8019c2 <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 00 1d 80 00       	push   $0x801d00
  800065:	6a 1c                	push   $0x1c
  800067:	68 74 1d 80 00       	push   $0x801d74
  80006c:	e8 9d 02 00 00       	call   80030e <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800071:	c6 05 df d0 80 00 61 	movb   $0x61,0x80d0df

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800078:	a0 df e0 80 00       	mov    0x80e0df,%al
  80007d:	88 45 eb             	mov    %al,-0x15(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800080:	a0 df f0 80 00       	mov    0x80f0df,%al
  800085:	88 45 ea             	mov    %al,-0x16(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800088:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80008f:	eb 26                	jmp    8000b7 <_main+0x7f>
	{
		__arr__[i] = -1 ;
  800091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800094:	05 e0 30 80 00       	add    $0x8030e0,%eax
  800099:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  80009c:	a1 00 30 80 00       	mov    0x803000,%eax
  8000a1:	8a 00                	mov    (%eax),%al
  8000a3:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *__ptr2__ ;
  8000a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ab:	8a 00                	mov    (%eax),%al
  8000ad:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000b0:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000b7:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000be:	7e d1                	jle    800091 <_main+0x59>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 9a 1d 80 00       	push   $0x801d9a
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 5a 05 00 00       	call   800629 <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 b3 1d 80 00       	push   $0x801db3
  8000e6:	6a 3b                	push   $0x3b
  8000e8:	68 74 1d 80 00       	push   $0x801d74
  8000ed:	e8 1c 02 00 00       	call   80030e <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 b3 1d 80 00       	push   $0x801db3
  800106:	6a 3c                	push   $0x3c
  800108:	68 74 1d 80 00       	push   $0x801d74
  80010d:	e8 fc 01 00 00       	call   80030e <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Faults... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 c0 1d 80 00       	push   $0x801dc0
  80011a:	6a 03                	push   $0x3
  80011c:	e8 08 05 00 00       	call   800629 <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 8;
  800124:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		if (sys_get_optimal_num_faults() != expectedNumOfFaults)
  80012b:	e8 ed 18 00 00       	call   801a1d <sys_get_optimal_num_faults>
  800130:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800133:	74 14                	je     800149 <_main+0x111>
			panic("OPTIMAL alg. failed.. unexpected number of faults");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 e4 1d 80 00       	push   $0x801de4
  80013d:	6a 42                	push   $0x42
  80013f:	68 74 1d 80 00       	push   $0x801d74
  800144:	e8 c5 01 00 00       	call   80030e <_panic>
	}
	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #3 [OPTIMAL Alg.] is completed successfully.\n");
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 18 1e 80 00       	push   $0x801e18
  800151:	6a 0a                	push   $0xa
  800153:	e8 d1 04 00 00       	call   800629 <cprintf_colored>
  800158:	83 c4 10             	add    $0x10,%esp
	return;
  80015b:	90                   	nop
}
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800167:	e8 5d 16 00 00       	call   8017c9 <sys_getenvindex>
  80016c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80016f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800172:	89 d0                	mov    %edx,%eax
  800174:	01 c0                	add    %eax,%eax
  800176:	01 d0                	add    %edx,%eax
  800178:	c1 e0 02             	shl    $0x2,%eax
  80017b:	01 d0                	add    %edx,%eax
  80017d:	c1 e0 02             	shl    $0x2,%eax
  800180:	01 d0                	add    %edx,%eax
  800182:	c1 e0 03             	shl    $0x3,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	c1 e0 02             	shl    $0x2,%eax
  80018a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80018f:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800194:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800199:	8a 40 20             	mov    0x20(%eax),%al
  80019c:	84 c0                	test   %al,%al
  80019e:	74 0d                	je     8001ad <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001a0:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a5:	83 c0 20             	add    $0x20,%eax
  8001a8:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001b1:	7e 0a                	jle    8001bd <libmain+0x5f>
		binaryname = argv[0];
  8001b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b6:	8b 00                	mov    (%eax),%eax
  8001b8:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	ff 75 08             	pushl  0x8(%ebp)
  8001c6:	e8 6d fe ff ff       	call   800038 <_main>
  8001cb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001ce:	a1 8c 30 80 00       	mov    0x80308c,%eax
  8001d3:	85 c0                	test   %eax,%eax
  8001d5:	0f 84 01 01 00 00    	je     8002dc <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001db:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e1:	bb 6c 1f 80 00       	mov    $0x801f6c,%ebx
  8001e6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001eb:	89 c7                	mov    %eax,%edi
  8001ed:	89 de                	mov    %ebx,%esi
  8001ef:	89 d1                	mov    %edx,%ecx
  8001f1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001f6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001fb:	b0 00                	mov    $0x0,%al
  8001fd:	89 d7                	mov    %edx,%edi
  8001ff:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800201:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800208:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	50                   	push   %eax
  80020f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	e8 e4 17 00 00       	call   8019ff <sys_utilities>
  80021b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80021e:	e8 2d 13 00 00       	call   801550 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 8c 1e 80 00       	push   $0x801e8c
  80022b:	e8 cc 03 00 00       	call   8005fc <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800233:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800236:	85 c0                	test   %eax,%eax
  800238:	74 18                	je     800252 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80023a:	e8 de 17 00 00       	call   801a1d <sys_get_optimal_num_faults>
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	50                   	push   %eax
  800243:	68 b4 1e 80 00       	push   $0x801eb4
  800248:	e8 af 03 00 00       	call   8005fc <cprintf>
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	eb 59                	jmp    8002ab <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800252:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800257:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80025d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800262:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800268:	83 ec 04             	sub    $0x4,%esp
  80026b:	52                   	push   %edx
  80026c:	50                   	push   %eax
  80026d:	68 d8 1e 80 00       	push   $0x801ed8
  800272:	e8 85 03 00 00       	call   8005fc <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80027a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80027f:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800285:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80028a:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800290:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800295:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80029b:	51                   	push   %ecx
  80029c:	52                   	push   %edx
  80029d:	50                   	push   %eax
  80029e:	68 00 1f 80 00       	push   $0x801f00
  8002a3:	e8 54 03 00 00       	call   8005fc <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002ab:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002b0:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	50                   	push   %eax
  8002ba:	68 58 1f 80 00       	push   $0x801f58
  8002bf:	e8 38 03 00 00       	call   8005fc <cprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	68 8c 1e 80 00       	push   $0x801e8c
  8002cf:	e8 28 03 00 00       	call   8005fc <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002d7:	e8 8e 12 00 00       	call   80156a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002dc:	e8 1f 00 00 00       	call   800300 <exit>
}
  8002e1:	90                   	nop
  8002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e5:	5b                   	pop    %ebx
  8002e6:	5e                   	pop    %esi
  8002e7:	5f                   	pop    %edi
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    

008002ea <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	6a 00                	push   $0x0
  8002f5:	e8 9b 14 00 00       	call   801795 <sys_destroy_env>
  8002fa:	83 c4 10             	add    $0x10,%esp
}
  8002fd:	90                   	nop
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <exit>:

void
exit(void)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800306:	e8 f0 14 00 00       	call   8017fb <sys_exit_env>
}
  80030b:	90                   	nop
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800314:	8d 45 10             	lea    0x10(%ebp),%eax
  800317:	83 c0 04             	add    $0x4,%eax
  80031a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80031d:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  800322:	85 c0                	test   %eax,%eax
  800324:	74 16                	je     80033c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800326:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	50                   	push   %eax
  80032f:	68 d0 1f 80 00       	push   $0x801fd0
  800334:	e8 c3 02 00 00       	call   8005fc <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80033c:	a1 90 30 80 00       	mov    0x803090,%eax
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 08             	pushl  0x8(%ebp)
  80034a:	50                   	push   %eax
  80034b:	68 d8 1f 80 00       	push   $0x801fd8
  800350:	6a 74                	push   $0x74
  800352:	e8 d2 02 00 00       	call   800629 <cprintf_colored>
  800357:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80035a:	8b 45 10             	mov    0x10(%ebp),%eax
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	ff 75 f4             	pushl  -0xc(%ebp)
  800363:	50                   	push   %eax
  800364:	e8 24 02 00 00       	call   80058d <vcprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	6a 00                	push   $0x0
  800371:	68 00 20 80 00       	push   $0x802000
  800376:	e8 12 02 00 00       	call   80058d <vcprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80037e:	e8 7d ff ff ff       	call   800300 <exit>

	// should not return here
	while (1) ;
  800383:	eb fe                	jmp    800383 <_panic+0x75>

00800385 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	53                   	push   %ebx
  800389:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038c:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800391:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039a:	39 c2                	cmp    %eax,%edx
  80039c:	74 14                	je     8003b2 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	68 04 20 80 00       	push   $0x802004
  8003a6:	6a 26                	push   $0x26
  8003a8:	68 50 20 80 00       	push   $0x802050
  8003ad:	e8 5c ff ff ff       	call   80030e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c0:	e9 d9 00 00 00       	jmp    80049e <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	75 08                	jne    8003e2 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003da:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003dd:	e9 b9 00 00 00       	jmp    80049b <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003f0:	eb 79                	jmp    80046b <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f2:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003f7:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800400:	89 d0                	mov    %edx,%eax
  800402:	01 c0                	add    %eax,%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80040d:	01 d8                	add    %ebx,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	01 c8                	add    %ecx,%eax
  800413:	8a 40 04             	mov    0x4(%eax),%al
  800416:	84 c0                	test   %al,%al
  800418:	75 4e                	jne    800468 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80041f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800425:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800428:	89 d0                	mov    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800435:	01 d8                	add    %ebx,%eax
  800437:	01 d0                	add    %edx,%eax
  800439:	01 c8                	add    %ecx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800448:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80044a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	01 c8                	add    %ecx,%eax
  800459:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	75 09                	jne    800468 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80045f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800466:	eb 19                	jmp    800481 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800468:	ff 45 e8             	incl   -0x18(%ebp)
  80046b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800470:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800479:	39 c2                	cmp    %eax,%edx
  80047b:	0f 87 71 ff ff ff    	ja     8003f2 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800481:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800485:	75 14                	jne    80049b <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 5c 20 80 00       	push   $0x80205c
  80048f:	6a 3a                	push   $0x3a
  800491:	68 50 20 80 00       	push   $0x802050
  800496:	e8 73 fe ff ff       	call   80030e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80049b:	ff 45 f0             	incl   -0x10(%ebp)
  80049e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a4:	0f 8c 1b ff ff ff    	jl     8003c5 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b8:	eb 2e                	jmp    8004e8 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004ba:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004bf:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c8:	89 d0                	mov    %edx,%eax
  8004ca:	01 c0                	add    %eax,%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004d5:	01 d8                	add    %ebx,%eax
  8004d7:	01 d0                	add    %edx,%eax
  8004d9:	01 c8                	add    %ecx,%eax
  8004db:	8a 40 04             	mov    0x4(%eax),%al
  8004de:	3c 01                	cmp    $0x1,%al
  8004e0:	75 03                	jne    8004e5 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004e2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e5:	ff 45 e0             	incl   -0x20(%ebp)
  8004e8:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f6:	39 c2                	cmp    %eax,%edx
  8004f8:	77 c0                	ja     8004ba <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800500:	74 14                	je     800516 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800502:	83 ec 04             	sub    $0x4,%esp
  800505:	68 b0 20 80 00       	push   $0x8020b0
  80050a:	6a 44                	push   $0x44
  80050c:	68 50 20 80 00       	push   $0x802050
  800511:	e8 f8 fd ff ff       	call   80030e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800516:	90                   	nop
  800517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    

0080051c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	53                   	push   %ebx
  800520:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800523:	8b 45 0c             	mov    0xc(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	8d 48 01             	lea    0x1(%eax),%ecx
  80052b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052e:	89 0a                	mov    %ecx,(%edx)
  800530:	8b 55 08             	mov    0x8(%ebp),%edx
  800533:	88 d1                	mov    %dl,%cl
  800535:	8b 55 0c             	mov    0xc(%ebp),%edx
  800538:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	3d ff 00 00 00       	cmp    $0xff,%eax
  800546:	75 30                	jne    800578 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800548:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  80054e:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800559:	8b 09                	mov    (%ecx),%ecx
  80055b:	89 cb                	mov    %ecx,%ebx
  80055d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800560:	83 c1 08             	add    $0x8,%ecx
  800563:	52                   	push   %edx
  800564:	50                   	push   %eax
  800565:	53                   	push   %ebx
  800566:	51                   	push   %ecx
  800567:	e8 a0 0f 00 00       	call   80150c <sys_cputs>
  80056c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80056f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800572:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057b:	8b 40 04             	mov    0x4(%eax),%eax
  80057e:	8d 50 01             	lea    0x1(%eax),%edx
  800581:	8b 45 0c             	mov    0xc(%ebp),%eax
  800584:	89 50 04             	mov    %edx,0x4(%eax)
}
  800587:	90                   	nop
  800588:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058b:	c9                   	leave  
  80058c:	c3                   	ret    

0080058d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80058d:	55                   	push   %ebp
  80058e:	89 e5                	mov    %esp,%ebp
  800590:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800596:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80059d:	00 00 00 
	b.cnt = 0;
  8005a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005a7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005aa:	ff 75 0c             	pushl  0xc(%ebp)
  8005ad:	ff 75 08             	pushl  0x8(%ebp)
  8005b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b6:	50                   	push   %eax
  8005b7:	68 1c 05 80 00       	push   $0x80051c
  8005bc:	e8 5a 02 00 00       	call   80081b <vprintfmt>
  8005c1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005c4:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005ca:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005cf:	0f b6 c0             	movzbl %al,%eax
  8005d2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005d8:	52                   	push   %edx
  8005d9:	50                   	push   %eax
  8005da:	51                   	push   %ecx
  8005db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e1:	83 c0 08             	add    $0x8,%eax
  8005e4:	50                   	push   %eax
  8005e5:	e8 22 0f 00 00       	call   80150c <sys_cputs>
  8005ea:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ed:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  8005f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005fa:	c9                   	leave  
  8005fb:	c3                   	ret    

008005fc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800602:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  800609:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	ff 75 f4             	pushl  -0xc(%ebp)
  800618:	50                   	push   %eax
  800619:	e8 6f ff ff ff       	call   80058d <vcprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800624:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80062f:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	c1 e0 08             	shl    $0x8,%eax
  80063c:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  800641:	8d 45 0c             	lea    0xc(%ebp),%eax
  800644:	83 c0 04             	add    $0x4,%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	ff 75 f4             	pushl  -0xc(%ebp)
  800653:	50                   	push   %eax
  800654:	e8 34 ff ff ff       	call   80058d <vcprintf>
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80065f:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  800666:	07 00 00 

	return cnt;
  800669:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066c:	c9                   	leave  
  80066d:	c3                   	ret    

0080066e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80066e:	55                   	push   %ebp
  80066f:	89 e5                	mov    %esp,%ebp
  800671:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800674:	e8 d7 0e 00 00       	call   801550 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800679:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	ff 75 f4             	pushl  -0xc(%ebp)
  800688:	50                   	push   %eax
  800689:	e8 ff fe ff ff       	call   80058d <vcprintf>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800694:	e8 d1 0e 00 00       	call   80156a <sys_unlock_cons>
	return cnt;
  800699:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069c:	c9                   	leave  
  80069d:	c3                   	ret    

0080069e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	53                   	push   %ebx
  8006a2:	83 ec 14             	sub    $0x14,%esp
  8006a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bc:	77 55                	ja     800713 <printnum+0x75>
  8006be:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c1:	72 05                	jb     8006c8 <printnum+0x2a>
  8006c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c6:	77 4b                	ja     800713 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006cb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d6:	52                   	push   %edx
  8006d7:	50                   	push   %eax
  8006d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006db:	ff 75 f0             	pushl  -0x10(%ebp)
  8006de:	e8 a9 13 00 00       	call   801a8c <__udivdi3>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	83 ec 04             	sub    $0x4,%esp
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	53                   	push   %ebx
  8006ed:	ff 75 18             	pushl  0x18(%ebp)
  8006f0:	52                   	push   %edx
  8006f1:	50                   	push   %eax
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	e8 a1 ff ff ff       	call   80069e <printnum>
  8006fd:	83 c4 20             	add    $0x20,%esp
  800700:	eb 1a                	jmp    80071c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 20             	pushl  0x20(%ebp)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800713:	ff 4d 1c             	decl   0x1c(%ebp)
  800716:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071a:	7f e6                	jg     800702 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80071f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072a:	53                   	push   %ebx
  80072b:	51                   	push   %ecx
  80072c:	52                   	push   %edx
  80072d:	50                   	push   %eax
  80072e:	e8 69 14 00 00       	call   801b9c <__umoddi3>
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	05 14 23 80 00       	add    $0x802314,%eax
  80073b:	8a 00                	mov    (%eax),%al
  80073d:	0f be c0             	movsbl %al,%eax
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	50                   	push   %eax
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	ff d0                	call   *%eax
  80074c:	83 c4 10             	add    $0x10,%esp
}
  80074f:	90                   	nop
  800750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800753:	c9                   	leave  
  800754:	c3                   	ret    

00800755 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 40                	jmp    8007ba <getuint+0x65>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1e                	je     80079e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	eb 1c                	jmp    8007ba <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	8d 50 04             	lea    0x4(%eax),%edx
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	89 10                	mov    %edx,(%eax)
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	83 e8 04             	sub    $0x4,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ba:	5d                   	pop    %ebp
  8007bb:	c3                   	ret    

008007bc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getint+0x25>
		return va_arg(*ap, long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 38                	jmp    800819 <getint+0x5d>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1a                	je     800801 <getint+0x45>
		return va_arg(*ap, long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	99                   	cltd   
  8007ff:	eb 18                	jmp    800819 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	8d 50 04             	lea    0x4(%eax),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	89 10                	mov    %edx,(%eax)
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	83 e8 04             	sub    $0x4,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	99                   	cltd   
}
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800823:	eb 17                	jmp    80083c <vprintfmt+0x21>
			if (ch == '\0')
  800825:	85 db                	test   %ebx,%ebx
  800827:	0f 84 c1 03 00 00    	je     800bee <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	53                   	push   %ebx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083c:	8b 45 10             	mov    0x10(%ebp),%eax
  80083f:	8d 50 01             	lea    0x1(%eax),%edx
  800842:	89 55 10             	mov    %edx,0x10(%ebp)
  800845:	8a 00                	mov    (%eax),%al
  800847:	0f b6 d8             	movzbl %al,%ebx
  80084a:	83 fb 25             	cmp    $0x25,%ebx
  80084d:	75 d6                	jne    800825 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80084f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800853:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800861:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800868:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086f:	8b 45 10             	mov    0x10(%ebp),%eax
  800872:	8d 50 01             	lea    0x1(%eax),%edx
  800875:	89 55 10             	mov    %edx,0x10(%ebp)
  800878:	8a 00                	mov    (%eax),%al
  80087a:	0f b6 d8             	movzbl %al,%ebx
  80087d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800880:	83 f8 5b             	cmp    $0x5b,%eax
  800883:	0f 87 3d 03 00 00    	ja     800bc6 <vprintfmt+0x3ab>
  800889:	8b 04 85 38 23 80 00 	mov    0x802338(,%eax,4),%eax
  800890:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800892:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800896:	eb d7                	jmp    80086f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800898:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089c:	eb d1                	jmp    80086f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a8:	89 d0                	mov    %edx,%eax
  8008aa:	c1 e0 02             	shl    $0x2,%eax
  8008ad:	01 d0                	add    %edx,%eax
  8008af:	01 c0                	add    %eax,%eax
  8008b1:	01 d8                	add    %ebx,%eax
  8008b3:	83 e8 30             	sub    $0x30,%eax
  8008b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bc:	8a 00                	mov    (%eax),%al
  8008be:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c4:	7e 3e                	jle    800904 <vprintfmt+0xe9>
  8008c6:	83 fb 39             	cmp    $0x39,%ebx
  8008c9:	7f 39                	jg     800904 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008cb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ce:	eb d5                	jmp    8008a5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e4:	eb 1f                	jmp    800905 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	79 83                	jns    80086f <vprintfmt+0x54>
				width = 0;
  8008ec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f3:	e9 77 ff ff ff       	jmp    80086f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008f8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ff:	e9 6b ff ff ff       	jmp    80086f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800904:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	0f 89 60 ff ff ff    	jns    80086f <vprintfmt+0x54>
				width = precision, precision = -1;
  80090f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800915:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091c:	e9 4e ff ff ff       	jmp    80086f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800921:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800924:	e9 46 ff ff ff       	jmp    80086f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	83 c0 04             	add    $0x4,%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	50                   	push   %eax
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
			break;
  800949:	e9 9b 02 00 00       	jmp    800be9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	83 c0 04             	add    $0x4,%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80095f:	85 db                	test   %ebx,%ebx
  800961:	79 02                	jns    800965 <vprintfmt+0x14a>
				err = -err;
  800963:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800965:	83 fb 64             	cmp    $0x64,%ebx
  800968:	7f 0b                	jg     800975 <vprintfmt+0x15a>
  80096a:	8b 34 9d 80 21 80 00 	mov    0x802180(,%ebx,4),%esi
  800971:	85 f6                	test   %esi,%esi
  800973:	75 19                	jne    80098e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800975:	53                   	push   %ebx
  800976:	68 25 23 80 00       	push   $0x802325
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	ff 75 08             	pushl  0x8(%ebp)
  800981:	e8 70 02 00 00       	call   800bf6 <printfmt>
  800986:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800989:	e9 5b 02 00 00       	jmp    800be9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098e:	56                   	push   %esi
  80098f:	68 2e 23 80 00       	push   $0x80232e
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	ff 75 08             	pushl  0x8(%ebp)
  80099a:	e8 57 02 00 00       	call   800bf6 <printfmt>
  80099f:	83 c4 10             	add    $0x10,%esp
			break;
  8009a2:	e9 42 02 00 00       	jmp    800be9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	83 c0 04             	add    $0x4,%eax
  8009ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 e8 04             	sub    $0x4,%eax
  8009b6:	8b 30                	mov    (%eax),%esi
  8009b8:	85 f6                	test   %esi,%esi
  8009ba:	75 05                	jne    8009c1 <vprintfmt+0x1a6>
				p = "(null)";
  8009bc:	be 31 23 80 00       	mov    $0x802331,%esi
			if (width > 0 && padc != '-')
  8009c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c5:	7e 6d                	jle    800a34 <vprintfmt+0x219>
  8009c7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009cb:	74 67                	je     800a34 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	50                   	push   %eax
  8009d4:	56                   	push   %esi
  8009d5:	e8 1e 03 00 00       	call   800cf8 <strnlen>
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e0:	eb 16                	jmp    8009f8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	50                   	push   %eax
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fc:	7f e4                	jg     8009e2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fe:	eb 34                	jmp    800a34 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a00:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a04:	74 1c                	je     800a22 <vprintfmt+0x207>
  800a06:	83 fb 1f             	cmp    $0x1f,%ebx
  800a09:	7e 05                	jle    800a10 <vprintfmt+0x1f5>
  800a0b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a0e:	7e 12                	jle    800a22 <vprintfmt+0x207>
					putch('?', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 3f                	push   $0x3f
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
  800a20:	eb 0f                	jmp    800a31 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	53                   	push   %ebx
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a31:	ff 4d e4             	decl   -0x1c(%ebp)
  800a34:	89 f0                	mov    %esi,%eax
  800a36:	8d 70 01             	lea    0x1(%eax),%esi
  800a39:	8a 00                	mov    (%eax),%al
  800a3b:	0f be d8             	movsbl %al,%ebx
  800a3e:	85 db                	test   %ebx,%ebx
  800a40:	74 24                	je     800a66 <vprintfmt+0x24b>
  800a42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a46:	78 b8                	js     800a00 <vprintfmt+0x1e5>
  800a48:	ff 4d e0             	decl   -0x20(%ebp)
  800a4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4f:	79 af                	jns    800a00 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a51:	eb 13                	jmp    800a66 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 20                	push   $0x20
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a63:	ff 4d e4             	decl   -0x1c(%ebp)
  800a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6a:	7f e7                	jg     800a53 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6c:	e9 78 01 00 00       	jmp    800be9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 e8             	pushl  -0x18(%ebp)
  800a77:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7a:	50                   	push   %eax
  800a7b:	e8 3c fd ff ff       	call   8007bc <getint>
  800a80:	83 c4 10             	add    $0x10,%esp
  800a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a86:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8f:	85 d2                	test   %edx,%edx
  800a91:	79 23                	jns    800ab6 <vprintfmt+0x29b>
				putch('-', putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	6a 2d                	push   $0x2d
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa9:	f7 d8                	neg    %eax
  800aab:	83 d2 00             	adc    $0x0,%edx
  800aae:	f7 da                	neg    %edx
  800ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abd:	e9 bc 00 00 00       	jmp    800b7e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac8:	8d 45 14             	lea    0x14(%ebp),%eax
  800acb:	50                   	push   %eax
  800acc:	e8 84 fc ff ff       	call   800755 <getuint>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ada:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae1:	e9 98 00 00 00       	jmp    800b7e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	6a 58                	push   $0x58
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			break;
  800b16:	e9 ce 00 00 00       	jmp    800be9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	6a 30                	push   $0x30
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	ff d0                	call   *%eax
  800b28:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 78                	push   $0x78
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3e:	83 c0 04             	add    $0x4,%eax
  800b41:	89 45 14             	mov    %eax,0x14(%ebp)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	83 e8 04             	sub    $0x4,%eax
  800b4a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b56:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b5d:	eb 1f                	jmp    800b7e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 e8             	pushl  -0x18(%ebp)
  800b65:	8d 45 14             	lea    0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	e8 e7 fb ff ff       	call   800755 <getuint>
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b74:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b77:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b7e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b85:	83 ec 04             	sub    $0x4,%esp
  800b88:	52                   	push   %edx
  800b89:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8c:	50                   	push   %eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	ff 75 f0             	pushl  -0x10(%ebp)
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 00 fb ff ff       	call   80069e <printnum>
  800b9e:	83 c4 20             	add    $0x20,%esp
			break;
  800ba1:	eb 46                	jmp    800be9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	53                   	push   %ebx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
			break;
  800bb2:	eb 35                	jmp    800be9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bb4:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800bbb:	eb 2c                	jmp    800be9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bbd:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800bc4:	eb 23                	jmp    800be9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	6a 25                	push   $0x25
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	ff d0                	call   *%eax
  800bd3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd6:	ff 4d 10             	decl   0x10(%ebp)
  800bd9:	eb 03                	jmp    800bde <vprintfmt+0x3c3>
  800bdb:	ff 4d 10             	decl   0x10(%ebp)
  800bde:	8b 45 10             	mov    0x10(%ebp),%eax
  800be1:	48                   	dec    %eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	3c 25                	cmp    $0x25,%al
  800be6:	75 f3                	jne    800bdb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800be8:	90                   	nop
		}
	}
  800be9:	e9 35 fc ff ff       	jmp    800823 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bee:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfc:	8d 45 10             	lea    0x10(%ebp),%eax
  800bff:	83 c0 04             	add    $0x4,%eax
  800c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c05:	8b 45 10             	mov    0x10(%ebp),%eax
  800c08:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0b:	50                   	push   %eax
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	ff 75 08             	pushl  0x8(%ebp)
  800c12:	e8 04 fc ff ff       	call   80081b <vprintfmt>
  800c17:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c1a:	90                   	nop
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 40 08             	mov    0x8(%eax),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 10                	mov    (%eax),%edx
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	8b 40 04             	mov    0x4(%eax),%eax
  800c3a:	39 c2                	cmp    %eax,%edx
  800c3c:	73 12                	jae    800c50 <sprintputch+0x33>
		*b->buf++ = ch;
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	8d 48 01             	lea    0x1(%eax),%ecx
  800c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c49:	89 0a                	mov    %ecx,(%edx)
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	88 10                	mov    %dl,(%eax)
}
  800c50:	90                   	nop
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	01 d0                	add    %edx,%eax
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c78:	74 06                	je     800c80 <vsnprintf+0x2d>
  800c7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7e:	7f 07                	jg     800c87 <vsnprintf+0x34>
		return -E_INVAL;
  800c80:	b8 03 00 00 00       	mov    $0x3,%eax
  800c85:	eb 20                	jmp    800ca7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c87:	ff 75 14             	pushl  0x14(%ebp)
  800c8a:	ff 75 10             	pushl  0x10(%ebp)
  800c8d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c90:	50                   	push   %eax
  800c91:	68 1d 0c 80 00       	push   $0x800c1d
  800c96:	e8 80 fb ff ff       	call   80081b <vprintfmt>
  800c9b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800caf:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb2:	83 c0 04             	add    $0x4,%eax
  800cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	50                   	push   %eax
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	ff 75 08             	pushl  0x8(%ebp)
  800cc5:	e8 89 ff ff ff       	call   800c53 <vsnprintf>
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd3:	c9                   	leave  
  800cd4:	c3                   	ret    

00800cd5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce2:	eb 06                	jmp    800cea <strlen+0x15>
		n++;
  800ce4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce7:	ff 45 08             	incl   0x8(%ebp)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	75 f1                	jne    800ce4 <strlen+0xf>
		n++;
	return n;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d05:	eb 09                	jmp    800d10 <strnlen+0x18>
		n++;
  800d07:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0a:	ff 45 08             	incl   0x8(%ebp)
  800d0d:	ff 4d 0c             	decl   0xc(%ebp)
  800d10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d14:	74 09                	je     800d1f <strnlen+0x27>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	84 c0                	test   %al,%al
  800d1d:	75 e8                	jne    800d07 <strnlen+0xf>
		n++;
	return n;
  800d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d30:	90                   	nop
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d43:	8a 12                	mov    (%edx),%dl
  800d45:	88 10                	mov    %dl,(%eax)
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	75 e4                	jne    800d31 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d65:	eb 1f                	jmp    800d86 <strncpy+0x34>
		*dst++ = *src;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8d 50 01             	lea    0x1(%eax),%edx
  800d6d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 03                	je     800d83 <strncpy+0x31>
			src++;
  800d80:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d83:	ff 45 fc             	incl   -0x4(%ebp)
  800d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d89:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8c:	72 d9                	jb     800d67 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 30                	je     800dd5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da5:	eb 16                	jmp    800dbd <strlcpy+0x2a>
			*dst++ = *src++;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8d 50 01             	lea    0x1(%eax),%edx
  800dad:	89 55 08             	mov    %edx,0x8(%ebp)
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db9:	8a 12                	mov    (%edx),%dl
  800dbb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbd:	ff 4d 10             	decl   0x10(%ebp)
  800dc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc4:	74 09                	je     800dcf <strlcpy+0x3c>
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	84 c0                	test   %al,%al
  800dcd:	75 d8                	jne    800da7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddb:	29 c2                	sub    %eax,%edx
  800ddd:	89 d0                	mov    %edx,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de4:	eb 06                	jmp    800dec <strcmp+0xb>
		p++, q++;
  800de6:	ff 45 08             	incl   0x8(%ebp)
  800de9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	84 c0                	test   %al,%al
  800df3:	74 0e                	je     800e03 <strcmp+0x22>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 10                	mov    (%eax),%dl
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	38 c2                	cmp    %al,%dl
  800e01:	74 e3                	je     800de6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f b6 d0             	movzbl %al,%edx
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f b6 c0             	movzbl %al,%eax
  800e13:	29 c2                	sub    %eax,%edx
  800e15:	89 d0                	mov    %edx,%eax
}
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1c:	eb 09                	jmp    800e27 <strncmp+0xe>
		n--, p++, q++;
  800e1e:	ff 4d 10             	decl   0x10(%ebp)
  800e21:	ff 45 08             	incl   0x8(%ebp)
  800e24:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2b:	74 17                	je     800e44 <strncmp+0x2b>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	74 0e                	je     800e44 <strncmp+0x2b>
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 10                	mov    (%eax),%dl
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	38 c2                	cmp    %al,%dl
  800e42:	74 da                	je     800e1e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e48:	75 07                	jne    800e51 <strncmp+0x38>
		return 0;
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4f:	eb 14                	jmp    800e65 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	0f b6 d0             	movzbl %al,%edx
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	0f b6 c0             	movzbl %al,%eax
  800e61:	29 c2                	sub    %eax,%edx
  800e63:	89 d0                	mov    %edx,%eax
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 04             	sub    $0x4,%esp
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e73:	eb 12                	jmp    800e87 <strchr+0x20>
		if (*s == c)
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7d:	75 05                	jne    800e84 <strchr+0x1d>
			return (char *) s;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	eb 11                	jmp    800e95 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 e5                	jne    800e75 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e95:	c9                   	leave  
  800e96:	c3                   	ret    

00800e97 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 0d                	jmp    800eb2 <strfind+0x1b>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	74 0e                	je     800ebd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eaf:	ff 45 08             	incl   0x8(%ebp)
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 ea                	jne    800ea5 <strfind+0xe>
  800ebb:	eb 01                	jmp    800ebe <strfind+0x27>
		if (*s == c)
			break;
  800ebd:	90                   	nop
	return (char *) s;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ecf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ed3:	76 63                	jbe    800f38 <memset+0x75>
		uint64 data_block = c;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	99                   	cltd   
  800ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ee9:	c1 e0 08             	shl    $0x8,%eax
  800eec:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eef:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800efc:	c1 e0 10             	shl    $0x10,%eax
  800eff:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f02:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0b:	89 c2                	mov    %eax,%edx
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f15:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f18:	eb 18                	jmp    800f32 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f1a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f1d:	8d 41 08             	lea    0x8(%ecx),%eax
  800f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	89 01                	mov    %eax,(%ecx)
  800f2b:	89 51 04             	mov    %edx,0x4(%ecx)
  800f2e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f32:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f36:	77 e2                	ja     800f1a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3c:	74 23                	je     800f61 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f44:	eb 0e                	jmp    800f54 <memset+0x91>
			*p8++ = (uint8)c;
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	8d 50 01             	lea    0x1(%eax),%edx
  800f4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f52:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	75 e5                	jne    800f46 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f78:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f7c:	76 24                	jbe    800fa2 <memcpy+0x3c>
		while(n >= 8){
  800f7e:	eb 1c                	jmp    800f9c <memcpy+0x36>
			*d64 = *s64;
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f83:	8b 50 04             	mov    0x4(%eax),%edx
  800f86:	8b 00                	mov    (%eax),%eax
  800f88:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f8b:	89 01                	mov    %eax,(%ecx)
  800f8d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f90:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f94:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f98:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f9c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fa0:	77 de                	ja     800f80 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa6:	74 31                	je     800fd9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fb4:	eb 16                	jmp    800fcc <memcpy+0x66>
			*d8++ = *s8++;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb9:	8d 50 01             	lea    0x1(%eax),%edx
  800fbc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fc8:	8a 12                	mov    (%edx),%dl
  800fca:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	75 dd                	jne    800fb6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdc:	c9                   	leave  
  800fdd:	c3                   	ret    

00800fde <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ff0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff6:	73 50                	jae    801048 <memmove+0x6a>
  800ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	01 d0                	add    %edx,%eax
  801000:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801003:	76 43                	jbe    801048 <memmove+0x6a>
		s += n;
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801011:	eb 10                	jmp    801023 <memmove+0x45>
			*--d = *--s;
  801013:	ff 4d f8             	decl   -0x8(%ebp)
  801016:	ff 4d fc             	decl   -0x4(%ebp)
  801019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101c:	8a 10                	mov    (%eax),%dl
  80101e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801021:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	8d 50 ff             	lea    -0x1(%eax),%edx
  801029:	89 55 10             	mov    %edx,0x10(%ebp)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	75 e3                	jne    801013 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801030:	eb 23                	jmp    801055 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8d 50 01             	lea    0x1(%eax),%edx
  801038:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801041:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801044:	8a 12                	mov    (%edx),%dl
  801046:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801048:	8b 45 10             	mov    0x10(%ebp),%eax
  80104b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104e:	89 55 10             	mov    %edx,0x10(%ebp)
  801051:	85 c0                	test   %eax,%eax
  801053:	75 dd                	jne    801032 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80106c:	eb 2a                	jmp    801098 <memcmp+0x3e>
		if (*s1 != *s2)
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801071:	8a 10                	mov    (%eax),%dl
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	38 c2                	cmp    %al,%dl
  80107a:	74 16                	je     801092 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80107c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f b6 d0             	movzbl %al,%edx
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f b6 c0             	movzbl %al,%eax
  80108c:	29 c2                	sub    %eax,%edx
  80108e:	89 d0                	mov    %edx,%eax
  801090:	eb 18                	jmp    8010aa <memcmp+0x50>
		s1++, s2++;
  801092:	ff 45 fc             	incl   -0x4(%ebp)
  801095:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109e:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	75 c9                	jne    80106e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	01 d0                	add    %edx,%eax
  8010ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010bd:	eb 15                	jmp    8010d4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 d0             	movzbl %al,%edx
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	0f b6 c0             	movzbl %al,%eax
  8010cd:	39 c2                	cmp    %eax,%edx
  8010cf:	74 0d                	je     8010de <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010d1:	ff 45 08             	incl   0x8(%ebp)
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010da:	72 e3                	jb     8010bf <memfind+0x13>
  8010dc:	eb 01                	jmp    8010df <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010de:	90                   	nop
	return (void *) s;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f8:	eb 03                	jmp    8010fd <strtol+0x19>
		s++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	3c 20                	cmp    $0x20,%al
  801104:	74 f4                	je     8010fa <strtol+0x16>
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	3c 09                	cmp    $0x9,%al
  80110d:	74 eb                	je     8010fa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	3c 2b                	cmp    $0x2b,%al
  801116:	75 05                	jne    80111d <strtol+0x39>
		s++;
  801118:	ff 45 08             	incl   0x8(%ebp)
  80111b:	eb 13                	jmp    801130 <strtol+0x4c>
	else if (*s == '-')
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 2d                	cmp    $0x2d,%al
  801124:	75 0a                	jne    801130 <strtol+0x4c>
		s++, neg = 1;
  801126:	ff 45 08             	incl   0x8(%ebp)
  801129:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801130:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801134:	74 06                	je     80113c <strtol+0x58>
  801136:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80113a:	75 20                	jne    80115c <strtol+0x78>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 30                	cmp    $0x30,%al
  801143:	75 17                	jne    80115c <strtol+0x78>
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	40                   	inc    %eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	3c 78                	cmp    $0x78,%al
  80114d:	75 0d                	jne    80115c <strtol+0x78>
		s += 2, base = 16;
  80114f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801153:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80115a:	eb 28                	jmp    801184 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80115c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801160:	75 15                	jne    801177 <strtol+0x93>
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	3c 30                	cmp    $0x30,%al
  801169:	75 0c                	jne    801177 <strtol+0x93>
		s++, base = 8;
  80116b:	ff 45 08             	incl   0x8(%ebp)
  80116e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801175:	eb 0d                	jmp    801184 <strtol+0xa0>
	else if (base == 0)
  801177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117b:	75 07                	jne    801184 <strtol+0xa0>
		base = 10;
  80117d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3c 2f                	cmp    $0x2f,%al
  80118b:	7e 19                	jle    8011a6 <strtol+0xc2>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 39                	cmp    $0x39,%al
  801194:	7f 10                	jg     8011a6 <strtol+0xc2>
			dig = *s - '0';
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	0f be c0             	movsbl %al,%eax
  80119e:	83 e8 30             	sub    $0x30,%eax
  8011a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a4:	eb 42                	jmp    8011e8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 60                	cmp    $0x60,%al
  8011ad:	7e 19                	jle    8011c8 <strtol+0xe4>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	3c 7a                	cmp    $0x7a,%al
  8011b6:	7f 10                	jg     8011c8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	0f be c0             	movsbl %al,%eax
  8011c0:	83 e8 57             	sub    $0x57,%eax
  8011c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c6:	eb 20                	jmp    8011e8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 40                	cmp    $0x40,%al
  8011cf:	7e 39                	jle    80120a <strtol+0x126>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3c 5a                	cmp    $0x5a,%al
  8011d8:	7f 30                	jg     80120a <strtol+0x126>
			dig = *s - 'A' + 10;
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	0f be c0             	movsbl %al,%eax
  8011e2:	83 e8 37             	sub    $0x37,%eax
  8011e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011eb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ee:	7d 19                	jge    801209 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011f0:	ff 45 08             	incl   0x8(%ebp)
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011fa:	89 c2                	mov    %eax,%edx
  8011fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801204:	e9 7b ff ff ff       	jmp    801184 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801209:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80120a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120e:	74 08                	je     801218 <strtol+0x134>
		*endptr = (char *) s;
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 07                	je     801225 <strtol+0x141>
  80121e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801221:	f7 d8                	neg    %eax
  801223:	eb 03                	jmp    801228 <strtol+0x144>
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <ltostr>:

void
ltostr(long value, char *str)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801237:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80123e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801242:	79 13                	jns    801257 <ltostr+0x2d>
	{
		neg = 1;
  801244:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801251:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801254:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80125f:	99                   	cltd   
  801260:	f7 f9                	idiv   %ecx
  801262:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801265:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801268:	8d 50 01             	lea    0x1(%eax),%edx
  80126b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80126e:	89 c2                	mov    %eax,%edx
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	01 d0                	add    %edx,%eax
  801275:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801278:	83 c2 30             	add    $0x30,%edx
  80127b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80127d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801280:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801285:	f7 e9                	imul   %ecx
  801287:	c1 fa 02             	sar    $0x2,%edx
  80128a:	89 c8                	mov    %ecx,%eax
  80128c:	c1 f8 1f             	sar    $0x1f,%eax
  80128f:	29 c2                	sub    %eax,%edx
  801291:	89 d0                	mov    %edx,%eax
  801293:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801296:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129a:	75 bb                	jne    801257 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80129c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a6:	48                   	dec    %eax
  8012a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ae:	74 3d                	je     8012ed <ltostr+0xc3>
		start = 1 ;
  8012b0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012b7:	eb 34                	jmp    8012ed <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 c2                	add    %eax,%edx
  8012ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	01 c8                	add    %ecx,%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012e5:	88 02                	mov    %al,(%edx)
		start++ ;
  8012e7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ea:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f3:	7c c4                	jl     8012b9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801309:	ff 75 08             	pushl  0x8(%ebp)
  80130c:	e8 c4 f9 ff ff       	call   800cd5 <strlen>
  801311:	83 c4 04             	add    $0x4,%esp
  801314:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 b6 f9 ff ff       	call   800cd5 <strlen>
  80131f:	83 c4 04             	add    $0x4,%esp
  801322:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801333:	eb 17                	jmp    80134c <strcconcat+0x49>
		final[s] = str1[s] ;
  801335:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	01 c2                	add    %eax,%edx
  80133d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	01 c8                	add    %ecx,%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801349:	ff 45 fc             	incl   -0x4(%ebp)
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801352:	7c e1                	jl     801335 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801354:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80135b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801362:	eb 1f                	jmp    801383 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80136d:	89 c2                	mov    %eax,%edx
  80136f:	8b 45 10             	mov    0x10(%ebp),%eax
  801372:	01 c2                	add    %eax,%edx
  801374:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	01 c8                	add    %ecx,%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801380:	ff 45 f8             	incl   -0x8(%ebp)
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801386:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801389:	7c d9                	jl     801364 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80138b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138e:	8b 45 10             	mov    0x10(%ebp),%eax
  801391:	01 d0                	add    %edx,%eax
  801393:	c6 00 00             	movb   $0x0,(%eax)
}
  801396:	90                   	nop
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80139c:	8b 45 14             	mov    0x14(%ebp),%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	01 d0                	add    %edx,%eax
  8013b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013bc:	eb 0c                	jmp    8013ca <strsplit+0x31>
			*string++ = 0;
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	84 c0                	test   %al,%al
  8013d1:	74 18                	je     8013eb <strsplit+0x52>
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	0f be c0             	movsbl %al,%eax
  8013db:	50                   	push   %eax
  8013dc:	ff 75 0c             	pushl  0xc(%ebp)
  8013df:	e8 83 fa ff ff       	call   800e67 <strchr>
  8013e4:	83 c4 08             	add    $0x8,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	75 d3                	jne    8013be <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	84 c0                	test   %al,%al
  8013f2:	74 5a                	je     80144e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f7:	8b 00                	mov    (%eax),%eax
  8013f9:	83 f8 0f             	cmp    $0xf,%eax
  8013fc:	75 07                	jne    801405 <strsplit+0x6c>
		{
			return 0;
  8013fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801403:	eb 66                	jmp    80146b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	8b 00                	mov    (%eax),%eax
  80140a:	8d 48 01             	lea    0x1(%eax),%ecx
  80140d:	8b 55 14             	mov    0x14(%ebp),%edx
  801410:	89 0a                	mov    %ecx,(%edx)
  801412:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	01 c2                	add    %eax,%edx
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801423:	eb 03                	jmp    801428 <strsplit+0x8f>
			string++;
  801425:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	74 8b                	je     8013bc <strsplit+0x23>
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	0f be c0             	movsbl %al,%eax
  801439:	50                   	push   %eax
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	e8 25 fa ff ff       	call   800e67 <strchr>
  801442:	83 c4 08             	add    $0x8,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	74 dc                	je     801425 <strsplit+0x8c>
			string++;
	}
  801449:	e9 6e ff ff ff       	jmp    8013bc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80144e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80144f:	8b 45 14             	mov    0x14(%ebp),%eax
  801452:	8b 00                	mov    (%eax),%eax
  801454:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80145b:	8b 45 10             	mov    0x10(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801466:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801480:	eb 4a                	jmp    8014cc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801482:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	01 c2                	add    %eax,%edx
  80148a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	01 c8                	add    %ecx,%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149c:	01 d0                	add    %edx,%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	3c 40                	cmp    $0x40,%al
  8014a2:	7e 25                	jle    8014c9 <str2lower+0x5c>
  8014a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014aa:	01 d0                	add    %edx,%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	3c 5a                	cmp    $0x5a,%al
  8014b0:	7f 17                	jg     8014c9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c0:	01 ca                	add    %ecx,%edx
  8014c2:	8a 12                	mov    (%edx),%dl
  8014c4:	83 c2 20             	add    $0x20,%edx
  8014c7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	e8 01 f8 ff ff       	call   800cd5 <strlen>
  8014d4:	83 c4 04             	add    $0x4,%esp
  8014d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014da:	7f a6                	jg     801482 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	57                   	push   %edi
  8014e5:	56                   	push   %esi
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014f6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014f9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014fc:	cd 30                	int    $0x30
  8014fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801501:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	5b                   	pop    %ebx
  801508:	5e                   	pop    %esi
  801509:	5f                   	pop    %edi
  80150a:	5d                   	pop    %ebp
  80150b:	c3                   	ret    

0080150c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801518:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80151b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	6a 00                	push   $0x0
  801524:	51                   	push   %ecx
  801525:	52                   	push   %edx
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	50                   	push   %eax
  80152a:	6a 00                	push   $0x0
  80152c:	e8 b0 ff ff ff       	call   8014e1 <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
}
  801534:	90                   	nop
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_cgetc>:

int
sys_cgetc(void)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 02                	push   $0x2
  801546:	e8 96 ff ff ff       	call   8014e1 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 03                	push   $0x3
  80155f:	e8 7d ff ff ff       	call   8014e1 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	90                   	nop
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 04                	push   $0x4
  801579:	e8 63 ff ff ff       	call   8014e1 <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	90                   	nop
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	52                   	push   %edx
  801594:	50                   	push   %eax
  801595:	6a 08                	push   $0x8
  801597:	e8 45 ff ff ff       	call   8014e1 <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	56                   	push   %esi
  8015a5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8015a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	56                   	push   %esi
  8015b6:	53                   	push   %ebx
  8015b7:	51                   	push   %ecx
  8015b8:	52                   	push   %edx
  8015b9:	50                   	push   %eax
  8015ba:	6a 09                	push   $0x9
  8015bc:	e8 20 ff ff ff       	call   8014e1 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c7:	5b                   	pop    %ebx
  8015c8:	5e                   	pop    %esi
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    

008015cb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	6a 0a                	push   $0xa
  8015db:	e8 01 ff ff ff       	call   8014e1 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	6a 0b                	push   $0xb
  8015f6:	e8 e6 fe ff ff       	call   8014e1 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 0c                	push   $0xc
  80160f:	e8 cd fe ff ff       	call   8014e1 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 0d                	push   $0xd
  801628:	e8 b4 fe ff ff       	call   8014e1 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 0e                	push   $0xe
  801641:	e8 9b fe ff ff       	call   8014e1 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 0f                	push   $0xf
  80165a:	e8 82 fe ff ff       	call   8014e1 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	6a 10                	push   $0x10
  801674:	e8 68 fe ff ff       	call   8014e1 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 11                	push   $0x11
  80168d:	e8 4f fe ff ff       	call   8014e1 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	90                   	nop
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_cputc>:

void
sys_cputc(const char c)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	50                   	push   %eax
  8016b1:	6a 01                	push   $0x1
  8016b3:	e8 29 fe ff ff       	call   8014e1 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	90                   	nop
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 14                	push   $0x14
  8016cd:	e8 0f fe ff ff       	call   8014e1 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	90                   	nop
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	6a 00                	push   $0x0
  8016f0:	51                   	push   %ecx
  8016f1:	52                   	push   %edx
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	50                   	push   %eax
  8016f6:	6a 15                	push   $0x15
  8016f8:	e8 e4 fd ff ff       	call   8014e1 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801705:	8b 55 0c             	mov    0xc(%ebp),%edx
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	52                   	push   %edx
  801712:	50                   	push   %eax
  801713:	6a 16                	push   $0x16
  801715:	e8 c7 fd ff ff       	call   8014e1 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801722:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	51                   	push   %ecx
  801730:	52                   	push   %edx
  801731:	50                   	push   %eax
  801732:	6a 17                	push   $0x17
  801734:	e8 a8 fd ff ff       	call   8014e1 <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801741:	8b 55 0c             	mov    0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	52                   	push   %edx
  80174e:	50                   	push   %eax
  80174f:	6a 18                	push   $0x18
  801751:	e8 8b fd ff ff       	call   8014e1 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	ff 75 14             	pushl  0x14(%ebp)
  801766:	ff 75 10             	pushl  0x10(%ebp)
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	50                   	push   %eax
  80176d:	6a 19                	push   $0x19
  80176f:	e8 6d fd ff ff       	call   8014e1 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	50                   	push   %eax
  801788:	6a 1a                	push   $0x1a
  80178a:	e8 52 fd ff ff       	call   8014e1 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	90                   	nop
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	50                   	push   %eax
  8017a4:	6a 1b                	push   $0x1b
  8017a6:	e8 36 fd ff ff       	call   8014e1 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 05                	push   $0x5
  8017bf:	e8 1d fd ff ff       	call   8014e1 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 06                	push   $0x6
  8017d8:	e8 04 fd ff ff       	call   8014e1 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 07                	push   $0x7
  8017f1:	e8 eb fc ff ff       	call   8014e1 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_exit_env>:


void sys_exit_env(void)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 1c                	push   $0x1c
  80180a:	e8 d2 fc ff ff       	call   8014e1 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	90                   	nop
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80181b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80181e:	8d 50 04             	lea    0x4(%eax),%edx
  801821:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	6a 1d                	push   $0x1d
  80182e:	e8 ae fc ff ff       	call   8014e1 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
	return result;
  801836:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801839:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183f:	89 01                	mov    %eax,(%ecx)
  801841:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	c9                   	leave  
  801848:	c2 04 00             	ret    $0x4

0080184b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 10             	pushl  0x10(%ebp)
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	ff 75 08             	pushl  0x8(%ebp)
  80185b:	6a 13                	push   $0x13
  80185d:	e8 7f fc ff ff       	call   8014e1 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
	return ;
  801865:	90                   	nop
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_rcr2>:
uint32 sys_rcr2()
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 1e                	push   $0x1e
  801877:	e8 65 fc ff ff       	call   8014e1 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80188d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	50                   	push   %eax
  80189a:	6a 1f                	push   $0x1f
  80189c:	e8 40 fc ff ff       	call   8014e1 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a4:	90                   	nop
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <rsttst>:
void rsttst()
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 21                	push   $0x21
  8018b6:	e8 26 fc ff ff       	call   8014e1 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018be:	90                   	nop
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8018d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d4:	52                   	push   %edx
  8018d5:	50                   	push   %eax
  8018d6:	ff 75 10             	pushl  0x10(%ebp)
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	6a 20                	push   $0x20
  8018e1:	e8 fb fb ff ff       	call   8014e1 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e9:	90                   	nop
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <chktst>:
void chktst(uint32 n)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 22                	push   $0x22
  8018fc:	e8 e0 fb ff ff       	call   8014e1 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
	return ;
  801904:	90                   	nop
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <inctst>:

void inctst()
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 23                	push   $0x23
  801916:	e8 c6 fb ff ff       	call   8014e1 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
	return ;
  80191e:	90                   	nop
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <gettst>:
uint32 gettst()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 24                	push   $0x24
  801930:	e8 ac fb ff ff       	call   8014e1 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 25                	push   $0x25
  801949:	e8 93 fb ff ff       	call   8014e1 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
  801951:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  801956:	a1 00 71 82 00       	mov    0x827100,%eax
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 26                	push   $0x26
  801975:	e8 67 fb ff ff       	call   8014e1 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801984:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801987:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	53                   	push   %ebx
  801993:	51                   	push   %ecx
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	6a 27                	push   $0x27
  801998:	e8 44 fb ff ff       	call   8014e1 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	52                   	push   %edx
  8019b5:	50                   	push   %eax
  8019b6:	6a 28                	push   $0x28
  8019b8:	e8 24 fb ff ff       	call   8014e1 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	51                   	push   %ecx
  8019d1:	ff 75 10             	pushl  0x10(%ebp)
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 29                	push   $0x29
  8019d8:	e8 04 fb ff ff       	call   8014e1 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	ff 75 08             	pushl  0x8(%ebp)
  8019f2:	6a 12                	push   $0x12
  8019f4:	e8 e8 fa ff ff       	call   8014e1 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fc:	90                   	nop
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	52                   	push   %edx
  801a0f:	50                   	push   %eax
  801a10:	6a 2a                	push   $0x2a
  801a12:	e8 ca fa ff ff       	call   8014e1 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return;
  801a1a:	90                   	nop
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 2b                	push   $0x2b
  801a2c:	e8 b0 fa ff ff       	call   8014e1 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	6a 2d                	push   $0x2d
  801a47:	e8 95 fa ff ff       	call   8014e1 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
	return;
  801a4f:	90                   	nop
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 2c                	push   $0x2c
  801a63:	e8 79 fa ff ff       	call   8014e1 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6b:	90                   	nop
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 2e                	push   $0x2e
  801a81:	e8 5b fa ff ff       	call   8014e1 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
	return ;
  801a89:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <__udivdi3>:
  801a8c:	55                   	push   %ebp
  801a8d:	57                   	push   %edi
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 1c             	sub    $0x1c,%esp
  801a93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aa3:	89 ca                	mov    %ecx,%edx
  801aa5:	89 f8                	mov    %edi,%eax
  801aa7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aab:	85 f6                	test   %esi,%esi
  801aad:	75 2d                	jne    801adc <__udivdi3+0x50>
  801aaf:	39 cf                	cmp    %ecx,%edi
  801ab1:	77 65                	ja     801b18 <__udivdi3+0x8c>
  801ab3:	89 fd                	mov    %edi,%ebp
  801ab5:	85 ff                	test   %edi,%edi
  801ab7:	75 0b                	jne    801ac4 <__udivdi3+0x38>
  801ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  801abe:	31 d2                	xor    %edx,%edx
  801ac0:	f7 f7                	div    %edi
  801ac2:	89 c5                	mov    %eax,%ebp
  801ac4:	31 d2                	xor    %edx,%edx
  801ac6:	89 c8                	mov    %ecx,%eax
  801ac8:	f7 f5                	div    %ebp
  801aca:	89 c1                	mov    %eax,%ecx
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	f7 f5                	div    %ebp
  801ad0:	89 cf                	mov    %ecx,%edi
  801ad2:	89 fa                	mov    %edi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	39 ce                	cmp    %ecx,%esi
  801ade:	77 28                	ja     801b08 <__udivdi3+0x7c>
  801ae0:	0f bd fe             	bsr    %esi,%edi
  801ae3:	83 f7 1f             	xor    $0x1f,%edi
  801ae6:	75 40                	jne    801b28 <__udivdi3+0x9c>
  801ae8:	39 ce                	cmp    %ecx,%esi
  801aea:	72 0a                	jb     801af6 <__udivdi3+0x6a>
  801aec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801af0:	0f 87 9e 00 00 00    	ja     801b94 <__udivdi3+0x108>
  801af6:	b8 01 00 00 00       	mov    $0x1,%eax
  801afb:	89 fa                	mov    %edi,%edx
  801afd:	83 c4 1c             	add    $0x1c,%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5f                   	pop    %edi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
  801b05:	8d 76 00             	lea    0x0(%esi),%esi
  801b08:	31 ff                	xor    %edi,%edi
  801b0a:	31 c0                	xor    %eax,%eax
  801b0c:	89 fa                	mov    %edi,%edx
  801b0e:	83 c4 1c             	add    $0x1c,%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	f7 f7                	div    %edi
  801b1c:	31 ff                	xor    %edi,%edi
  801b1e:	89 fa                	mov    %edi,%edx
  801b20:	83 c4 1c             	add    $0x1c,%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5e                   	pop    %esi
  801b25:	5f                   	pop    %edi
  801b26:	5d                   	pop    %ebp
  801b27:	c3                   	ret    
  801b28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b2d:	89 eb                	mov    %ebp,%ebx
  801b2f:	29 fb                	sub    %edi,%ebx
  801b31:	89 f9                	mov    %edi,%ecx
  801b33:	d3 e6                	shl    %cl,%esi
  801b35:	89 c5                	mov    %eax,%ebp
  801b37:	88 d9                	mov    %bl,%cl
  801b39:	d3 ed                	shr    %cl,%ebp
  801b3b:	89 e9                	mov    %ebp,%ecx
  801b3d:	09 f1                	or     %esi,%ecx
  801b3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b43:	89 f9                	mov    %edi,%ecx
  801b45:	d3 e0                	shl    %cl,%eax
  801b47:	89 c5                	mov    %eax,%ebp
  801b49:	89 d6                	mov    %edx,%esi
  801b4b:	88 d9                	mov    %bl,%cl
  801b4d:	d3 ee                	shr    %cl,%esi
  801b4f:	89 f9                	mov    %edi,%ecx
  801b51:	d3 e2                	shl    %cl,%edx
  801b53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b57:	88 d9                	mov    %bl,%cl
  801b59:	d3 e8                	shr    %cl,%eax
  801b5b:	09 c2                	or     %eax,%edx
  801b5d:	89 d0                	mov    %edx,%eax
  801b5f:	89 f2                	mov    %esi,%edx
  801b61:	f7 74 24 0c          	divl   0xc(%esp)
  801b65:	89 d6                	mov    %edx,%esi
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	f7 e5                	mul    %ebp
  801b6b:	39 d6                	cmp    %edx,%esi
  801b6d:	72 19                	jb     801b88 <__udivdi3+0xfc>
  801b6f:	74 0b                	je     801b7c <__udivdi3+0xf0>
  801b71:	89 d8                	mov    %ebx,%eax
  801b73:	31 ff                	xor    %edi,%edi
  801b75:	e9 58 ff ff ff       	jmp    801ad2 <__udivdi3+0x46>
  801b7a:	66 90                	xchg   %ax,%ax
  801b7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b80:	89 f9                	mov    %edi,%ecx
  801b82:	d3 e2                	shl    %cl,%edx
  801b84:	39 c2                	cmp    %eax,%edx
  801b86:	73 e9                	jae    801b71 <__udivdi3+0xe5>
  801b88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b8b:	31 ff                	xor    %edi,%edi
  801b8d:	e9 40 ff ff ff       	jmp    801ad2 <__udivdi3+0x46>
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	31 c0                	xor    %eax,%eax
  801b96:	e9 37 ff ff ff       	jmp    801ad2 <__udivdi3+0x46>
  801b9b:	90                   	nop

00801b9c <__umoddi3>:
  801b9c:	55                   	push   %ebp
  801b9d:	57                   	push   %edi
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 1c             	sub    $0x1c,%esp
  801ba3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ba7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801baf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bbb:	89 f3                	mov    %esi,%ebx
  801bbd:	89 fa                	mov    %edi,%edx
  801bbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc3:	89 34 24             	mov    %esi,(%esp)
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	75 1a                	jne    801be4 <__umoddi3+0x48>
  801bca:	39 f7                	cmp    %esi,%edi
  801bcc:	0f 86 a2 00 00 00    	jbe    801c74 <__umoddi3+0xd8>
  801bd2:	89 c8                	mov    %ecx,%eax
  801bd4:	89 f2                	mov    %esi,%edx
  801bd6:	f7 f7                	div    %edi
  801bd8:	89 d0                	mov    %edx,%eax
  801bda:	31 d2                	xor    %edx,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	39 f0                	cmp    %esi,%eax
  801be6:	0f 87 ac 00 00 00    	ja     801c98 <__umoddi3+0xfc>
  801bec:	0f bd e8             	bsr    %eax,%ebp
  801bef:	83 f5 1f             	xor    $0x1f,%ebp
  801bf2:	0f 84 ac 00 00 00    	je     801ca4 <__umoddi3+0x108>
  801bf8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bfd:	29 ef                	sub    %ebp,%edi
  801bff:	89 fe                	mov    %edi,%esi
  801c01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c05:	89 e9                	mov    %ebp,%ecx
  801c07:	d3 e0                	shl    %cl,%eax
  801c09:	89 d7                	mov    %edx,%edi
  801c0b:	89 f1                	mov    %esi,%ecx
  801c0d:	d3 ef                	shr    %cl,%edi
  801c0f:	09 c7                	or     %eax,%edi
  801c11:	89 e9                	mov    %ebp,%ecx
  801c13:	d3 e2                	shl    %cl,%edx
  801c15:	89 14 24             	mov    %edx,(%esp)
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	d3 e0                	shl    %cl,%eax
  801c1c:	89 c2                	mov    %eax,%edx
  801c1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c22:	d3 e0                	shl    %cl,%eax
  801c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2c:	89 f1                	mov    %esi,%ecx
  801c2e:	d3 e8                	shr    %cl,%eax
  801c30:	09 d0                	or     %edx,%eax
  801c32:	d3 eb                	shr    %cl,%ebx
  801c34:	89 da                	mov    %ebx,%edx
  801c36:	f7 f7                	div    %edi
  801c38:	89 d3                	mov    %edx,%ebx
  801c3a:	f7 24 24             	mull   (%esp)
  801c3d:	89 c6                	mov    %eax,%esi
  801c3f:	89 d1                	mov    %edx,%ecx
  801c41:	39 d3                	cmp    %edx,%ebx
  801c43:	0f 82 87 00 00 00    	jb     801cd0 <__umoddi3+0x134>
  801c49:	0f 84 91 00 00 00    	je     801ce0 <__umoddi3+0x144>
  801c4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c53:	29 f2                	sub    %esi,%edx
  801c55:	19 cb                	sbb    %ecx,%ebx
  801c57:	89 d8                	mov    %ebx,%eax
  801c59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c5d:	d3 e0                	shl    %cl,%eax
  801c5f:	89 e9                	mov    %ebp,%ecx
  801c61:	d3 ea                	shr    %cl,%edx
  801c63:	09 d0                	or     %edx,%eax
  801c65:	89 e9                	mov    %ebp,%ecx
  801c67:	d3 eb                	shr    %cl,%ebx
  801c69:	89 da                	mov    %ebx,%edx
  801c6b:	83 c4 1c             	add    $0x1c,%esp
  801c6e:	5b                   	pop    %ebx
  801c6f:	5e                   	pop    %esi
  801c70:	5f                   	pop    %edi
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    
  801c73:	90                   	nop
  801c74:	89 fd                	mov    %edi,%ebp
  801c76:	85 ff                	test   %edi,%edi
  801c78:	75 0b                	jne    801c85 <__umoddi3+0xe9>
  801c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7f:	31 d2                	xor    %edx,%edx
  801c81:	f7 f7                	div    %edi
  801c83:	89 c5                	mov    %eax,%ebp
  801c85:	89 f0                	mov    %esi,%eax
  801c87:	31 d2                	xor    %edx,%edx
  801c89:	f7 f5                	div    %ebp
  801c8b:	89 c8                	mov    %ecx,%eax
  801c8d:	f7 f5                	div    %ebp
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	e9 44 ff ff ff       	jmp    801bda <__umoddi3+0x3e>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	89 c8                	mov    %ecx,%eax
  801c9a:	89 f2                	mov    %esi,%edx
  801c9c:	83 c4 1c             	add    $0x1c,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
  801ca4:	3b 04 24             	cmp    (%esp),%eax
  801ca7:	72 06                	jb     801caf <__umoddi3+0x113>
  801ca9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cad:	77 0f                	ja     801cbe <__umoddi3+0x122>
  801caf:	89 f2                	mov    %esi,%edx
  801cb1:	29 f9                	sub    %edi,%ecx
  801cb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cb7:	89 14 24             	mov    %edx,(%esp)
  801cba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cc2:	8b 14 24             	mov    (%esp),%edx
  801cc5:	83 c4 1c             	add    $0x1c,%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
  801ccd:	8d 76 00             	lea    0x0(%esi),%esi
  801cd0:	2b 04 24             	sub    (%esp),%eax
  801cd3:	19 fa                	sbb    %edi,%edx
  801cd5:	89 d1                	mov    %edx,%ecx
  801cd7:	89 c6                	mov    %eax,%esi
  801cd9:	e9 71 ff ff ff       	jmp    801c4f <__umoddi3+0xb3>
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ce4:	72 ea                	jb     801cd0 <__umoddi3+0x134>
  801ce6:	89 d9                	mov    %ebx,%ecx
  801ce8:	e9 62 ff ff ff       	jmp    801c4f <__umoddi3+0xb3>
