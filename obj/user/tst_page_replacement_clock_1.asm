
obj/user/tst_page_replacement_clock_1:     file format elf32-i386


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
  800031:	e8 a1 01 00 00       	call   8001d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedFinalVAs[11] = {
		0xeebfd000, 	//Stack
		0x800000, 0x809000, 0x80a000, 0x803000, 0x801000, 0x804000, 0x80b000, 0x80c000, 0x827000, 0x802000, 	//Code & Data
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
  80004c:	e8 ea 19 00 00       	call   801a3b <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 80 1d 80 00       	push   $0x801d80
  800065:	6a 1b                	push   $0x1b
  800067:	68 f4 1d 80 00       	push   $0x801df4
  80006c:	e8 16 03 00 00       	call   800387 <_panic>
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
		//*__ptr__ = *__ptr2__ ;
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
  8000c3:	68 18 1e 80 00       	push   $0x801e18
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 d3 05 00 00       	call   8006a2 <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 31 1e 80 00       	push   $0x801e31
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 f4 1d 80 00       	push   $0x801df4
  8000ed:	e8 95 02 00 00       	call   800387 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 31 1e 80 00       	push   $0x801e31
  800106:	6a 3b                	push   $0x3b
  800108:	68 f4 1d 80 00       	push   $0x801df4
  80010d:	e8 75 02 00 00       	call   800387 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE CLOCK algorithm... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 40 1e 80 00       	push   $0x801e40
  80011a:	6a 03                	push   $0x3
  80011c:	e8 81 05 00 00       	call   8006a2 <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0xeebfd000, 1);
  800124:	6a 01                	push   $0x1
  800126:	68 00 d0 bf ee       	push   $0xeebfd000
  80012b:	6a 0b                	push   $0xb
  80012d:	68 60 30 80 00       	push   $0x803060
  800132:	e8 04 19 00 00       	call   801a3b <sys_check_WS_list>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("CLOCK alg. failed.. trace it by printing WS before and after page fault");
  80013d:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 68 1e 80 00       	push   $0x801e68
  80014b:	6a 40                	push   $0x40
  80014d:	68 f4 1d 80 00       	push   $0x801df4
  800152:	e8 30 02 00 00       	call   800387 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Disk Access... \n");
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	68 b0 1e 80 00       	push   $0x801eb0
  80015f:	6a 03                	push   $0x3
  800161:	e8 3c 05 00 00       	call   8006a2 <cprintf_colored>
  800166:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 18;
  800169:	c7 45 e4 12 00 00 00 	movl   $0x12,-0x1c(%ebp)
		uint32 expectedNumOfWrites = 7;
  800170:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
		uint32 expectedNumOfReads = 18;
  800177:	c7 45 dc 12 00 00 00 	movl   $0x12,-0x24(%ebp)
		if (myEnv->nPageIn != expectedNumOfReads || myEnv->nPageOut != expectedNumOfWrites || myEnv->pageFaultsCounter != expectedNumOfFaults)
  80017e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800183:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800189:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80018c:	75 20                	jne    8001ae <_main+0x176>
  80018e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800193:	8b 80 98 06 00 00    	mov    0x698(%eax),%eax
  800199:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80019c:	75 10                	jne    8001ae <_main+0x176>
  80019e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a3:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8001a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
			panic("CLOCK alg. failed.. unexpected number of disk access");
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 d8 1e 80 00       	push   $0x801ed8
  8001b6:	6a 48                	push   $0x48
  8001b8:	68 f4 1d 80 00       	push   $0x801df4
  8001bd:	e8 c5 01 00 00       	call   800387 <_panic>
	}
	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [CLOCK Alg. #1] is completed successfully.\n");
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 10 1f 80 00       	push   $0x801f10
  8001ca:	6a 0a                	push   $0xa
  8001cc:	e8 d1 04 00 00       	call   8006a2 <cprintf_colored>
  8001d1:	83 c4 10             	add    $0x10,%esp
	return;
  8001d4:	90                   	nop
}
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001e0:	e8 5d 16 00 00       	call   801842 <sys_getenvindex>
  8001e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001eb:	89 d0                	mov    %edx,%eax
  8001ed:	01 c0                	add    %eax,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	c1 e0 02             	shl    $0x2,%eax
  8001f4:	01 d0                	add    %edx,%eax
  8001f6:	c1 e0 02             	shl    $0x2,%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	c1 e0 03             	shl    $0x3,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	c1 e0 02             	shl    $0x2,%eax
  800203:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800208:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800212:	8a 40 20             	mov    0x20(%eax),%al
  800215:	84 c0                	test   %al,%al
  800217:	74 0d                	je     800226 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800219:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80021e:	83 c0 20             	add    $0x20,%eax
  800221:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022a:	7e 0a                	jle    800236 <libmain+0x5f>
		binaryname = argv[0];
  80022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	ff 75 0c             	pushl  0xc(%ebp)
  80023c:	ff 75 08             	pushl  0x8(%ebp)
  80023f:	e8 f4 fd ff ff       	call   800038 <_main>
  800244:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800247:	a1 8c 30 80 00       	mov    0x80308c,%eax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	0f 84 01 01 00 00    	je     800355 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800254:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80025a:	bb 60 20 80 00       	mov    $0x802060,%ebx
  80025f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800264:	89 c7                	mov    %eax,%edi
  800266:	89 de                	mov    %ebx,%esi
  800268:	89 d1                	mov    %edx,%ecx
  80026a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80026c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80026f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800274:	b0 00                	mov    $0x0,%al
  800276:	89 d7                	mov    %edx,%edi
  800278:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80027a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800281:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	50                   	push   %eax
  800288:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	e8 e4 17 00 00       	call   801a78 <sys_utilities>
  800294:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800297:	e8 2d 13 00 00       	call   8015c9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 80 1f 80 00       	push   $0x801f80
  8002a4:	e8 cc 03 00 00       	call   800675 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	74 18                	je     8002cb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002b3:	e8 de 17 00 00       	call   801a96 <sys_get_optimal_num_faults>
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	50                   	push   %eax
  8002bc:	68 a8 1f 80 00       	push   $0x801fa8
  8002c1:	e8 af 03 00 00       	call   800675 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
  8002c9:	eb 59                	jmp    800324 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002cb:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002d0:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8002d6:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002db:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	52                   	push   %edx
  8002e5:	50                   	push   %eax
  8002e6:	68 cc 1f 80 00       	push   $0x801fcc
  8002eb:	e8 85 03 00 00       	call   800675 <cprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f3:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002f8:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8002fe:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800303:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800309:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80030e:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800314:	51                   	push   %ecx
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	68 f4 1f 80 00       	push   $0x801ff4
  80031c:	e8 54 03 00 00       	call   800675 <cprintf>
  800321:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800324:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800329:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	50                   	push   %eax
  800333:	68 4c 20 80 00       	push   $0x80204c
  800338:	e8 38 03 00 00       	call   800675 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 80 1f 80 00       	push   $0x801f80
  800348:	e8 28 03 00 00       	call   800675 <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800350:	e8 8e 12 00 00       	call   8015e3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800355:	e8 1f 00 00 00       	call   800379 <exit>
}
  80035a:	90                   	nop
  80035b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035e:	5b                   	pop    %ebx
  80035f:	5e                   	pop    %esi
  800360:	5f                   	pop    %edi
  800361:	5d                   	pop    %ebp
  800362:	c3                   	ret    

00800363 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	6a 00                	push   $0x0
  80036e:	e8 9b 14 00 00       	call   80180e <sys_destroy_env>
  800373:	83 c4 10             	add    $0x10,%esp
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <exit>:

void
exit(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037f:	e8 f0 14 00 00       	call   801874 <sys_exit_env>
}
  800384:	90                   	nop
  800385:	c9                   	leave  
  800386:	c3                   	ret    

00800387 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80038d:	8d 45 10             	lea    0x10(%ebp),%eax
  800390:	83 c0 04             	add    $0x4,%eax
  800393:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800396:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 16                	je     8003b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80039f:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	50                   	push   %eax
  8003a8:	68 c4 20 80 00       	push   $0x8020c4
  8003ad:	e8 c3 02 00 00       	call   800675 <cprintf>
  8003b2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003b5:	a1 90 30 80 00       	mov    0x803090,%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	ff 75 0c             	pushl  0xc(%ebp)
  8003c0:	ff 75 08             	pushl  0x8(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	68 cc 20 80 00       	push   $0x8020cc
  8003c9:	6a 74                	push   $0x74
  8003cb:	e8 d2 02 00 00       	call   8006a2 <cprintf_colored>
  8003d0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dc:	50                   	push   %eax
  8003dd:	e8 24 02 00 00       	call   800606 <vcprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	6a 00                	push   $0x0
  8003ea:	68 f4 20 80 00       	push   $0x8020f4
  8003ef:	e8 12 02 00 00       	call   800606 <vcprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f7:	e8 7d ff ff ff       	call   800379 <exit>

	// should not return here
	while (1) ;
  8003fc:	eb fe                	jmp    8003fc <_panic+0x75>

008003fe <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	53                   	push   %ebx
  800402:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800405:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80040a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 f8 20 80 00       	push   $0x8020f8
  80041f:	6a 26                	push   $0x26
  800421:	68 44 21 80 00       	push   $0x802144
  800426:	e8 5c ff ff ff       	call   800387 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 d9 00 00 00       	jmp    800517 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 b9 00 00 00       	jmp    800514 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 79                	jmp    8004e4 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800470:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800486:	01 d8                	add    %ebx,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	01 c8                	add    %ecx,%eax
  80048c:	8a 40 04             	mov    0x4(%eax),%al
  80048f:	84 c0                	test   %al,%al
  800491:	75 4e                	jne    8004e1 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800493:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800498:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80049e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a1:	89 d0                	mov    %edx,%eax
  8004a3:	01 c0                	add    %eax,%eax
  8004a5:	01 d0                	add    %edx,%eax
  8004a7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004ae:	01 d8                	add    %ebx,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	01 c8                	add    %ecx,%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	01 c8                	add    %ecx,%eax
  8004d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	75 09                	jne    8004e1 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8004d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004df:	eb 19                	jmp    8004fa <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e1:	ff 45 e8             	incl   -0x18(%ebp)
  8004e4:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004e9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	0f 87 71 ff ff ff    	ja     80046b <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004fe:	75 14                	jne    800514 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	68 50 21 80 00       	push   $0x802150
  800508:	6a 3a                	push   $0x3a
  80050a:	68 44 21 80 00       	push   $0x802144
  80050f:	e8 73 fe ff ff       	call   800387 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800514:	ff 45 f0             	incl   -0x10(%ebp)
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80051d:	0f 8c 1b ff ff ff    	jl     80043e <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800523:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800531:	eb 2e                	jmp    800561 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800533:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800538:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80053e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800541:	89 d0                	mov    %edx,%eax
  800543:	01 c0                	add    %eax,%eax
  800545:	01 d0                	add    %edx,%eax
  800547:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80054e:	01 d8                	add    %ebx,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	01 c8                	add    %ecx,%eax
  800554:	8a 40 04             	mov    0x4(%eax),%al
  800557:	3c 01                	cmp    $0x1,%al
  800559:	75 03                	jne    80055e <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80055b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055e:	ff 45 e0             	incl   -0x20(%ebp)
  800561:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800566:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80056c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056f:	39 c2                	cmp    %eax,%edx
  800571:	77 c0                	ja     800533 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800576:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800579:	74 14                	je     80058f <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 a4 21 80 00       	push   $0x8021a4
  800583:	6a 44                	push   $0x44
  800585:	68 44 21 80 00       	push   $0x802144
  80058a:	e8 f8 fd ff ff       	call   800387 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80058f:	90                   	nop
  800590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	53                   	push   %ebx
  800599:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a7:	89 0a                	mov    %ecx,(%edx)
  8005a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ac:	88 d1                	mov    %dl,%cl
  8005ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005bf:	75 30                	jne    8005f1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005c1:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005c7:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005cc:	0f b6 c0             	movzbl %al,%eax
  8005cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d2:	8b 09                	mov    (%ecx),%ecx
  8005d4:	89 cb                	mov    %ecx,%ebx
  8005d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d9:	83 c1 08             	add    $0x8,%ecx
  8005dc:	52                   	push   %edx
  8005dd:	50                   	push   %eax
  8005de:	53                   	push   %ebx
  8005df:	51                   	push   %ecx
  8005e0:	e8 a0 0f 00 00       	call   801585 <sys_cputs>
  8005e5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f4:	8b 40 04             	mov    0x4(%eax),%eax
  8005f7:	8d 50 01             	lea    0x1(%eax),%edx
  8005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800600:	90                   	nop
  800601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80060f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800616:	00 00 00 
	b.cnt = 0;
  800619:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800620:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	ff 75 08             	pushl  0x8(%ebp)
  800629:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80062f:	50                   	push   %eax
  800630:	68 95 05 80 00       	push   $0x800595
  800635:	e8 5a 02 00 00       	call   800894 <vprintfmt>
  80063a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80063d:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  800643:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800648:	0f b6 c0             	movzbl %al,%eax
  80064b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	51                   	push   %ecx
  800654:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065a:	83 c0 08             	add    $0x8,%eax
  80065d:	50                   	push   %eax
  80065e:	e8 22 0f 00 00       	call   801585 <sys_cputs>
  800663:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800666:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  80066d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80067b:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  800682:	8d 45 0c             	lea    0xc(%ebp),%eax
  800685:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 f4             	pushl  -0xc(%ebp)
  800691:	50                   	push   %eax
  800692:	e8 6f ff ff ff       	call   800606 <vcprintf>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a0:	c9                   	leave  
  8006a1:	c3                   	ret    

008006a2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
  8006a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006a8:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	c1 e0 08             	shl    $0x8,%eax
  8006b5:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  8006ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006bd:	83 c0 04             	add    $0x4,%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 34 ff ff ff       	call   800606 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006d8:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  8006df:	07 00 00 

	return cnt;
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ed:	e8 d7 0e 00 00       	call   8015c9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800701:	50                   	push   %eax
  800702:	e8 ff fe ff ff       	call   800606 <vcprintf>
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80070d:	e8 d1 0e 00 00       	call   8015e3 <sys_unlock_cons>
	return cnt;
  800712:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	53                   	push   %ebx
  80071b:	83 ec 14             	sub    $0x14,%esp
  80071e:	8b 45 10             	mov    0x10(%ebp),%eax
  800721:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072a:	8b 45 18             	mov    0x18(%ebp),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800735:	77 55                	ja     80078c <printnum+0x75>
  800737:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073a:	72 05                	jb     800741 <printnum+0x2a>
  80073c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80073f:	77 4b                	ja     80078c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800741:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800744:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800747:	8b 45 18             	mov    0x18(%ebp),%eax
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	52                   	push   %edx
  800750:	50                   	push   %eax
  800751:	ff 75 f4             	pushl  -0xc(%ebp)
  800754:	ff 75 f0             	pushl  -0x10(%ebp)
  800757:	e8 ac 13 00 00       	call   801b08 <__udivdi3>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	ff 75 20             	pushl  0x20(%ebp)
  800765:	53                   	push   %ebx
  800766:	ff 75 18             	pushl  0x18(%ebp)
  800769:	52                   	push   %edx
  80076a:	50                   	push   %eax
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	ff 75 08             	pushl  0x8(%ebp)
  800771:	e8 a1 ff ff ff       	call   800717 <printnum>
  800776:	83 c4 20             	add    $0x20,%esp
  800779:	eb 1a                	jmp    800795 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 20             	pushl  0x20(%ebp)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	ff d0                	call   *%eax
  800789:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078c:	ff 4d 1c             	decl   0x1c(%ebp)
  80078f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800793:	7f e6                	jg     80077b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800795:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800798:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a3:	53                   	push   %ebx
  8007a4:	51                   	push   %ecx
  8007a5:	52                   	push   %edx
  8007a6:	50                   	push   %eax
  8007a7:	e8 6c 14 00 00       	call   801c18 <__umoddi3>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	05 14 24 80 00       	add    $0x802414,%eax
  8007b4:	8a 00                	mov    (%eax),%al
  8007b6:	0f be c0             	movsbl %al,%eax
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	50                   	push   %eax
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	ff d0                	call   *%eax
  8007c5:	83 c4 10             	add    $0x10,%esp
}
  8007c8:	90                   	nop
  8007c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d5:	7e 1c                	jle    8007f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	8d 50 08             	lea    0x8(%eax),%edx
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	89 10                	mov    %edx,(%eax)
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	83 e8 08             	sub    $0x8,%eax
  8007ec:	8b 50 04             	mov    0x4(%eax),%edx
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	eb 40                	jmp    800833 <getuint+0x65>
	else if (lflag)
  8007f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f7:	74 1e                	je     800817 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	8d 50 04             	lea    0x4(%eax),%edx
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	89 10                	mov    %edx,(%eax)
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	83 e8 04             	sub    $0x4,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	ba 00 00 00 00       	mov    $0x0,%edx
  800815:	eb 1c                	jmp    800833 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	8d 50 04             	lea    0x4(%eax),%edx
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	89 10                	mov    %edx,(%eax)
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	83 e8 04             	sub    $0x4,%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800838:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083c:	7e 1c                	jle    80085a <getint+0x25>
		return va_arg(*ap, long long);
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	8d 50 08             	lea    0x8(%eax),%edx
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	89 10                	mov    %edx,(%eax)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	83 e8 08             	sub    $0x8,%eax
  800853:	8b 50 04             	mov    0x4(%eax),%edx
  800856:	8b 00                	mov    (%eax),%eax
  800858:	eb 38                	jmp    800892 <getint+0x5d>
	else if (lflag)
  80085a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085e:	74 1a                	je     80087a <getint+0x45>
		return va_arg(*ap, long);
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	8d 50 04             	lea    0x4(%eax),%edx
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	89 10                	mov    %edx,(%eax)
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	83 e8 04             	sub    $0x4,%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	99                   	cltd   
  800878:	eb 18                	jmp    800892 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	8d 50 04             	lea    0x4(%eax),%edx
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	89 10                	mov    %edx,(%eax)
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	83 e8 04             	sub    $0x4,%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	99                   	cltd   
}
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	56                   	push   %esi
  800898:	53                   	push   %ebx
  800899:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089c:	eb 17                	jmp    8008b5 <vprintfmt+0x21>
			if (ch == '\0')
  80089e:	85 db                	test   %ebx,%ebx
  8008a0:	0f 84 c1 03 00 00    	je     800c67 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	53                   	push   %ebx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b8:	8d 50 01             	lea    0x1(%eax),%edx
  8008bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8008be:	8a 00                	mov    (%eax),%al
  8008c0:	0f b6 d8             	movzbl %al,%ebx
  8008c3:	83 fb 25             	cmp    $0x25,%ebx
  8008c6:	75 d6                	jne    80089e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008eb:	8d 50 01             	lea    0x1(%eax),%edx
  8008ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f1:	8a 00                	mov    (%eax),%al
  8008f3:	0f b6 d8             	movzbl %al,%ebx
  8008f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008f9:	83 f8 5b             	cmp    $0x5b,%eax
  8008fc:	0f 87 3d 03 00 00    	ja     800c3f <vprintfmt+0x3ab>
  800902:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  800909:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80090f:	eb d7                	jmp    8008e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800911:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800915:	eb d1                	jmp    8008e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800917:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80091e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800921:	89 d0                	mov    %edx,%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	01 d0                	add    %edx,%eax
  800928:	01 c0                	add    %eax,%eax
  80092a:	01 d8                	add    %ebx,%eax
  80092c:	83 e8 30             	sub    $0x30,%eax
  80092f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800932:	8b 45 10             	mov    0x10(%ebp),%eax
  800935:	8a 00                	mov    (%eax),%al
  800937:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093a:	83 fb 2f             	cmp    $0x2f,%ebx
  80093d:	7e 3e                	jle    80097d <vprintfmt+0xe9>
  80093f:	83 fb 39             	cmp    $0x39,%ebx
  800942:	7f 39                	jg     80097d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800944:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800947:	eb d5                	jmp    80091e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 c0 04             	add    $0x4,%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	83 e8 04             	sub    $0x4,%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095d:	eb 1f                	jmp    80097e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80095f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800963:	79 83                	jns    8008e8 <vprintfmt+0x54>
				width = 0;
  800965:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80096c:	e9 77 ff ff ff       	jmp    8008e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800971:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800978:	e9 6b ff ff ff       	jmp    8008e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80097e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800982:	0f 89 60 ff ff ff    	jns    8008e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800988:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800995:	e9 4e ff ff ff       	jmp    8008e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099d:	e9 46 ff ff ff       	jmp    8008e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	83 c0 04             	add    $0x4,%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	83 e8 04             	sub    $0x4,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 0c             	pushl  0xc(%ebp)
  8009b9:	50                   	push   %eax
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	ff d0                	call   *%eax
  8009bf:	83 c4 10             	add    $0x10,%esp
			break;
  8009c2:	e9 9b 02 00 00       	jmp    800c62 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	83 c0 04             	add    $0x4,%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d3:	83 e8 04             	sub    $0x4,%eax
  8009d6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d8:	85 db                	test   %ebx,%ebx
  8009da:	79 02                	jns    8009de <vprintfmt+0x14a>
				err = -err;
  8009dc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009de:	83 fb 64             	cmp    $0x64,%ebx
  8009e1:	7f 0b                	jg     8009ee <vprintfmt+0x15a>
  8009e3:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  8009ea:	85 f6                	test   %esi,%esi
  8009ec:	75 19                	jne    800a07 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ee:	53                   	push   %ebx
  8009ef:	68 25 24 80 00       	push   $0x802425
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	ff 75 08             	pushl  0x8(%ebp)
  8009fa:	e8 70 02 00 00       	call   800c6f <printfmt>
  8009ff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a02:	e9 5b 02 00 00       	jmp    800c62 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a07:	56                   	push   %esi
  800a08:	68 2e 24 80 00       	push   $0x80242e
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	ff 75 08             	pushl  0x8(%ebp)
  800a13:	e8 57 02 00 00       	call   800c6f <printfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
			break;
  800a1b:	e9 42 02 00 00       	jmp    800c62 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 14             	mov    %eax,0x14(%ebp)
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 e8 04             	sub    $0x4,%eax
  800a2f:	8b 30                	mov    (%eax),%esi
  800a31:	85 f6                	test   %esi,%esi
  800a33:	75 05                	jne    800a3a <vprintfmt+0x1a6>
				p = "(null)";
  800a35:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7e 6d                	jle    800aad <vprintfmt+0x219>
  800a40:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a44:	74 67                	je     800aad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	50                   	push   %eax
  800a4d:	56                   	push   %esi
  800a4e:	e8 1e 03 00 00       	call   800d71 <strnlen>
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a59:	eb 16                	jmp    800a71 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	50                   	push   %eax
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a75:	7f e4                	jg     800a5b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a77:	eb 34                	jmp    800aad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7d:	74 1c                	je     800a9b <vprintfmt+0x207>
  800a7f:	83 fb 1f             	cmp    $0x1f,%ebx
  800a82:	7e 05                	jle    800a89 <vprintfmt+0x1f5>
  800a84:	83 fb 7e             	cmp    $0x7e,%ebx
  800a87:	7e 12                	jle    800a9b <vprintfmt+0x207>
					putch('?', putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	6a 3f                	push   $0x3f
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	ff d0                	call   *%eax
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	eb 0f                	jmp    800aaa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	53                   	push   %ebx
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aaa:	ff 4d e4             	decl   -0x1c(%ebp)
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	8d 70 01             	lea    0x1(%eax),%esi
  800ab2:	8a 00                	mov    (%eax),%al
  800ab4:	0f be d8             	movsbl %al,%ebx
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	74 24                	je     800adf <vprintfmt+0x24b>
  800abb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abf:	78 b8                	js     800a79 <vprintfmt+0x1e5>
  800ac1:	ff 4d e0             	decl   -0x20(%ebp)
  800ac4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac8:	79 af                	jns    800a79 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	eb 13                	jmp    800adf <vprintfmt+0x24b>
				putch(' ', putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	6a 20                	push   $0x20
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
  800ad9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800adc:	ff 4d e4             	decl   -0x1c(%ebp)
  800adf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae3:	7f e7                	jg     800acc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae5:	e9 78 01 00 00       	jmp    800c62 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 e8             	pushl  -0x18(%ebp)
  800af0:	8d 45 14             	lea    0x14(%ebp),%eax
  800af3:	50                   	push   %eax
  800af4:	e8 3c fd ff ff       	call   800835 <getint>
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b08:	85 d2                	test   %edx,%edx
  800b0a:	79 23                	jns    800b2f <vprintfmt+0x29b>
				putch('-', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 2d                	push   $0x2d
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b22:	f7 d8                	neg    %eax
  800b24:	83 d2 00             	adc    $0x0,%edx
  800b27:	f7 da                	neg    %edx
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b2f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b36:	e9 bc 00 00 00       	jmp    800bf7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b41:	8d 45 14             	lea    0x14(%ebp),%eax
  800b44:	50                   	push   %eax
  800b45:	e8 84 fc ff ff       	call   8007ce <getuint>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b53:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5a:	e9 98 00 00 00       	jmp    800bf7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 58                	push   $0x58
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	6a 58                	push   $0x58
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	ff d0                	call   *%eax
  800b7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 58                	push   $0x58
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	e9 ce 00 00 00       	jmp    800c62 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	6a 30                	push   $0x30
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	6a 78                	push   $0x78
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	ff d0                	call   *%eax
  800bb1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb7:	83 c0 04             	add    $0x4,%eax
  800bba:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc0:	83 e8 04             	sub    $0x4,%eax
  800bc3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bcf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd6:	eb 1f                	jmp    800bf7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	ff 75 e8             	pushl  -0x18(%ebp)
  800bde:	8d 45 14             	lea    0x14(%ebp),%eax
  800be1:	50                   	push   %eax
  800be2:	e8 e7 fb ff ff       	call   8007ce <getuint>
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bfe:	83 ec 04             	sub    $0x4,%esp
  800c01:	52                   	push   %edx
  800c02:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c05:	50                   	push   %eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	ff 75 f0             	pushl  -0x10(%ebp)
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	ff 75 08             	pushl  0x8(%ebp)
  800c12:	e8 00 fb ff ff       	call   800717 <printnum>
  800c17:	83 c4 20             	add    $0x20,%esp
			break;
  800c1a:	eb 46                	jmp    800c62 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1c:	83 ec 08             	sub    $0x8,%esp
  800c1f:	ff 75 0c             	pushl  0xc(%ebp)
  800c22:	53                   	push   %ebx
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			break;
  800c2b:	eb 35                	jmp    800c62 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c2d:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800c34:	eb 2c                	jmp    800c62 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c36:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800c3d:	eb 23                	jmp    800c62 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 25                	push   $0x25
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c4f:	ff 4d 10             	decl   0x10(%ebp)
  800c52:	eb 03                	jmp    800c57 <vprintfmt+0x3c3>
  800c54:	ff 4d 10             	decl   0x10(%ebp)
  800c57:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5a:	48                   	dec    %eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	3c 25                	cmp    $0x25,%al
  800c5f:	75 f3                	jne    800c54 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c61:	90                   	nop
		}
	}
  800c62:	e9 35 fc ff ff       	jmp    80089c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c67:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c75:	8d 45 10             	lea    0x10(%ebp),%eax
  800c78:	83 c0 04             	add    $0x4,%eax
  800c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	ff 75 f4             	pushl  -0xc(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	ff 75 08             	pushl  0x8(%ebp)
  800c8b:	e8 04 fc ff ff       	call   800894 <vprintfmt>
  800c90:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c93:	90                   	nop
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8b 40 08             	mov    0x8(%eax),%eax
  800c9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cab:	8b 10                	mov    (%eax),%edx
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8b 40 04             	mov    0x4(%eax),%eax
  800cb3:	39 c2                	cmp    %eax,%edx
  800cb5:	73 12                	jae    800cc9 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8b 00                	mov    (%eax),%eax
  800cbc:	8d 48 01             	lea    0x1(%eax),%ecx
  800cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc2:	89 0a                	mov    %ecx,(%edx)
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc7:	88 10                	mov    %dl,(%eax)
}
  800cc9:	90                   	nop
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	01 d0                	add    %edx,%eax
  800ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ced:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf1:	74 06                	je     800cf9 <vsnprintf+0x2d>
  800cf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf7:	7f 07                	jg     800d00 <vsnprintf+0x34>
		return -E_INVAL;
  800cf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfe:	eb 20                	jmp    800d20 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d00:	ff 75 14             	pushl  0x14(%ebp)
  800d03:	ff 75 10             	pushl  0x10(%ebp)
  800d06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d09:	50                   	push   %eax
  800d0a:	68 96 0c 80 00       	push   $0x800c96
  800d0f:	e8 80 fb ff ff       	call   800894 <vprintfmt>
  800d14:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d28:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2b:	83 c0 04             	add    $0x4,%eax
  800d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	ff 75 f4             	pushl  -0xc(%ebp)
  800d37:	50                   	push   %eax
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	ff 75 08             	pushl  0x8(%ebp)
  800d3e:	e8 89 ff ff ff       	call   800ccc <vsnprintf>
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5b:	eb 06                	jmp    800d63 <strlen+0x15>
		n++;
  800d5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 f1                	jne    800d5d <strlen+0xf>
		n++;
	return n;
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7e:	eb 09                	jmp    800d89 <strnlen+0x18>
		n++;
  800d80:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d83:	ff 45 08             	incl   0x8(%ebp)
  800d86:	ff 4d 0c             	decl   0xc(%ebp)
  800d89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8d:	74 09                	je     800d98 <strnlen+0x27>
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	75 e8                	jne    800d80 <strnlen+0xf>
		n++;
	return n;
  800d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da9:	90                   	nop
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8d 50 01             	lea    0x1(%eax),%edx
  800db0:	89 55 08             	mov    %edx,0x8(%ebp)
  800db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dbc:	8a 12                	mov    (%edx),%dl
  800dbe:	88 10                	mov    %dl,(%eax)
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	84 c0                	test   %al,%al
  800dc4:	75 e4                	jne    800daa <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dde:	eb 1f                	jmp    800dff <strncpy+0x34>
		*dst++ = *src;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8d 50 01             	lea    0x1(%eax),%edx
  800de6:	89 55 08             	mov    %edx,0x8(%ebp)
  800de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dec:	8a 12                	mov    (%edx),%dl
  800dee:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	84 c0                	test   %al,%al
  800df7:	74 03                	je     800dfc <strncpy+0x31>
			src++;
  800df9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dfc:	ff 45 fc             	incl   -0x4(%ebp)
  800dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e02:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e05:	72 d9                	jb     800de0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 30                	je     800e4e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e1e:	eb 16                	jmp    800e36 <strlcpy+0x2a>
			*dst++ = *src++;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8d 50 01             	lea    0x1(%eax),%edx
  800e26:	89 55 08             	mov    %edx,0x8(%ebp)
  800e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e32:	8a 12                	mov    (%edx),%dl
  800e34:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e36:	ff 4d 10             	decl   0x10(%ebp)
  800e39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3d:	74 09                	je     800e48 <strlcpy+0x3c>
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	84 c0                	test   %al,%al
  800e46:	75 d8                	jne    800e20 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e54:	29 c2                	sub    %eax,%edx
  800e56:	89 d0                	mov    %edx,%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e5d:	eb 06                	jmp    800e65 <strcmp+0xb>
		p++, q++;
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	84 c0                	test   %al,%al
  800e6c:	74 0e                	je     800e7c <strcmp+0x22>
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8a 10                	mov    (%eax),%dl
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	38 c2                	cmp    %al,%dl
  800e7a:	74 e3                	je     800e5f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	0f b6 d0             	movzbl %al,%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	0f b6 c0             	movzbl %al,%eax
  800e8c:	29 c2                	sub    %eax,%edx
  800e8e:	89 d0                	mov    %edx,%eax
}
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e95:	eb 09                	jmp    800ea0 <strncmp+0xe>
		n--, p++, q++;
  800e97:	ff 4d 10             	decl   0x10(%ebp)
  800e9a:	ff 45 08             	incl   0x8(%ebp)
  800e9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea4:	74 17                	je     800ebd <strncmp+0x2b>
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	84 c0                	test   %al,%al
  800ead:	74 0e                	je     800ebd <strncmp+0x2b>
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 10                	mov    (%eax),%dl
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	38 c2                	cmp    %al,%dl
  800ebb:	74 da                	je     800e97 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	75 07                	jne    800eca <strncmp+0x38>
		return 0;
  800ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec8:	eb 14                	jmp    800ede <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	0f b6 d0             	movzbl %al,%edx
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	29 c2                	sub    %eax,%edx
  800edc:	89 d0                	mov    %edx,%eax
}
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 04             	sub    $0x4,%esp
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eec:	eb 12                	jmp    800f00 <strchr+0x20>
		if (*s == c)
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef6:	75 05                	jne    800efd <strchr+0x1d>
			return (char *) s;
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	eb 11                	jmp    800f0e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800efd:	ff 45 08             	incl   0x8(%ebp)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	84 c0                	test   %al,%al
  800f07:	75 e5                	jne    800eee <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 04             	sub    $0x4,%esp
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f1c:	eb 0d                	jmp    800f2b <strfind+0x1b>
		if (*s == c)
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f26:	74 0e                	je     800f36 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f28:	ff 45 08             	incl   0x8(%ebp)
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	75 ea                	jne    800f1e <strfind+0xe>
  800f34:	eb 01                	jmp    800f37 <strfind+0x27>
		if (*s == c)
			break;
  800f36:	90                   	nop
	return (char *) s;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f48:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4c:	76 63                	jbe    800fb1 <memset+0x75>
		uint64 data_block = c;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	99                   	cltd   
  800f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f55:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f62:	c1 e0 08             	shl    $0x8,%eax
  800f65:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f68:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f71:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f75:	c1 e0 10             	shl    $0x10,%eax
  800f78:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f7b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f84:	89 c2                	mov    %eax,%edx
  800f86:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f8e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f91:	eb 18                	jmp    800fab <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f93:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f96:	8d 41 08             	lea    0x8(%ecx),%eax
  800f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa2:	89 01                	mov    %eax,(%ecx)
  800fa4:	89 51 04             	mov    %edx,0x4(%ecx)
  800fa7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800faf:	77 e2                	ja     800f93 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb5:	74 23                	je     800fda <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbd:	eb 0e                	jmp    800fcd <memset+0x91>
			*p8++ = (uint8)c;
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	75 e5                	jne    800fbf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ff1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff5:	76 24                	jbe    80101b <memcpy+0x3c>
		while(n >= 8){
  800ff7:	eb 1c                	jmp    801015 <memcpy+0x36>
			*d64 = *s64;
  800ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffc:	8b 50 04             	mov    0x4(%eax),%edx
  800fff:	8b 00                	mov    (%eax),%eax
  801001:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801004:	89 01                	mov    %eax,(%ecx)
  801006:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801009:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80100d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801011:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801015:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801019:	77 de                	ja     800ff9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80101b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101f:	74 31                	je     801052 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80102d:	eb 16                	jmp    801045 <memcpy+0x66>
			*d8++ = *s8++;
  80102f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801032:	8d 50 01             	lea    0x1(%eax),%edx
  801035:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801041:	8a 12                	mov    (%edx),%dl
  801043:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104b:	89 55 10             	mov    %edx,0x10(%ebp)
  80104e:	85 c0                	test   %eax,%eax
  801050:	75 dd                	jne    80102f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80106f:	73 50                	jae    8010c1 <memmove+0x6a>
  801071:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
  801079:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107c:	76 43                	jbe    8010c1 <memmove+0x6a>
		s += n;
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108a:	eb 10                	jmp    80109c <memmove+0x45>
			*--d = *--s;
  80108c:	ff 4d f8             	decl   -0x8(%ebp)
  80108f:	ff 4d fc             	decl   -0x4(%ebp)
  801092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801095:	8a 10                	mov    (%eax),%dl
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	75 e3                	jne    80108c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a9:	eb 23                	jmp    8010ce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bd:	8a 12                	mov    (%edx),%dl
  8010bf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	75 dd                	jne    8010ab <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e5:	eb 2a                	jmp    801111 <memcmp+0x3e>
		if (*s1 != *s2)
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8a 10                	mov    (%eax),%dl
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	38 c2                	cmp    %al,%dl
  8010f3:	74 16                	je     80110b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	0f b6 d0             	movzbl %al,%edx
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	0f b6 c0             	movzbl %al,%eax
  801105:	29 c2                	sub    %eax,%edx
  801107:	89 d0                	mov    %edx,%eax
  801109:	eb 18                	jmp    801123 <memcmp+0x50>
		s1++, s2++;
  80110b:	ff 45 fc             	incl   -0x4(%ebp)
  80110e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	8d 50 ff             	lea    -0x1(%eax),%edx
  801117:	89 55 10             	mov    %edx,0x10(%ebp)
  80111a:	85 c0                	test   %eax,%eax
  80111c:	75 c9                	jne    8010e7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80111e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 45 10             	mov    0x10(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801136:	eb 15                	jmp    80114d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	0f b6 d0             	movzbl %al,%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	0f b6 c0             	movzbl %al,%eax
  801146:	39 c2                	cmp    %eax,%edx
  801148:	74 0d                	je     801157 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80114a:	ff 45 08             	incl   0x8(%ebp)
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801153:	72 e3                	jb     801138 <memfind+0x13>
  801155:	eb 01                	jmp    801158 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801157:	90                   	nop
	return (void *) s;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80116a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801171:	eb 03                	jmp    801176 <strtol+0x19>
		s++;
  801173:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 20                	cmp    $0x20,%al
  80117d:	74 f4                	je     801173 <strtol+0x16>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 09                	cmp    $0x9,%al
  801186:	74 eb                	je     801173 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	3c 2b                	cmp    $0x2b,%al
  80118f:	75 05                	jne    801196 <strtol+0x39>
		s++;
  801191:	ff 45 08             	incl   0x8(%ebp)
  801194:	eb 13                	jmp    8011a9 <strtol+0x4c>
	else if (*s == '-')
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 2d                	cmp    $0x2d,%al
  80119d:	75 0a                	jne    8011a9 <strtol+0x4c>
		s++, neg = 1;
  80119f:	ff 45 08             	incl   0x8(%ebp)
  8011a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ad:	74 06                	je     8011b5 <strtol+0x58>
  8011af:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b3:	75 20                	jne    8011d5 <strtol+0x78>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 30                	cmp    $0x30,%al
  8011bc:	75 17                	jne    8011d5 <strtol+0x78>
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	40                   	inc    %eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 78                	cmp    $0x78,%al
  8011c6:	75 0d                	jne    8011d5 <strtol+0x78>
		s += 2, base = 16;
  8011c8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011cc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d3:	eb 28                	jmp    8011fd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d9:	75 15                	jne    8011f0 <strtol+0x93>
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 30                	cmp    $0x30,%al
  8011e2:	75 0c                	jne    8011f0 <strtol+0x93>
		s++, base = 8;
  8011e4:	ff 45 08             	incl   0x8(%ebp)
  8011e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ee:	eb 0d                	jmp    8011fd <strtol+0xa0>
	else if (base == 0)
  8011f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f4:	75 07                	jne    8011fd <strtol+0xa0>
		base = 10;
  8011f6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 2f                	cmp    $0x2f,%al
  801204:	7e 19                	jle    80121f <strtol+0xc2>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 39                	cmp    $0x39,%al
  80120d:	7f 10                	jg     80121f <strtol+0xc2>
			dig = *s - '0';
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	0f be c0             	movsbl %al,%eax
  801217:	83 e8 30             	sub    $0x30,%eax
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121d:	eb 42                	jmp    801261 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 60                	cmp    $0x60,%al
  801226:	7e 19                	jle    801241 <strtol+0xe4>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 7a                	cmp    $0x7a,%al
  80122f:	7f 10                	jg     801241 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	0f be c0             	movsbl %al,%eax
  801239:	83 e8 57             	sub    $0x57,%eax
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123f:	eb 20                	jmp    801261 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	3c 40                	cmp    $0x40,%al
  801248:	7e 39                	jle    801283 <strtol+0x126>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 5a                	cmp    $0x5a,%al
  801251:	7f 30                	jg     801283 <strtol+0x126>
			dig = *s - 'A' + 10;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f be c0             	movsbl %al,%eax
  80125b:	83 e8 37             	sub    $0x37,%eax
  80125e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801264:	3b 45 10             	cmp    0x10(%ebp),%eax
  801267:	7d 19                	jge    801282 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127d:	e9 7b ff ff ff       	jmp    8011fd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801282:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801283:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801287:	74 08                	je     801291 <strtol+0x134>
		*endptr = (char *) s;
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	8b 55 08             	mov    0x8(%ebp),%edx
  80128f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801291:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801295:	74 07                	je     80129e <strtol+0x141>
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	f7 d8                	neg    %eax
  80129c:	eb 03                	jmp    8012a1 <strtol+0x144>
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012bb:	79 13                	jns    8012d0 <ltostr+0x2d>
	{
		neg = 1;
  8012bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012ca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012cd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d8:	99                   	cltd   
  8012d9:	f7 f9                	idiv   %ecx
  8012db:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	8d 50 01             	lea    0x1(%eax),%edx
  8012e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e7:	89 c2                	mov    %eax,%edx
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f1:	83 c2 30             	add    $0x30,%edx
  8012f4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012fe:	f7 e9                	imul   %ecx
  801300:	c1 fa 02             	sar    $0x2,%edx
  801303:	89 c8                	mov    %ecx,%eax
  801305:	c1 f8 1f             	sar    $0x1f,%eax
  801308:	29 c2                	sub    %eax,%edx
  80130a:	89 d0                	mov    %edx,%eax
  80130c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80130f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801313:	75 bb                	jne    8012d0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131f:	48                   	dec    %eax
  801320:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801323:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801327:	74 3d                	je     801366 <ltostr+0xc3>
		start = 1 ;
  801329:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801330:	eb 34                	jmp    801366 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801332:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801335:	8b 45 0c             	mov    0xc(%ebp),%eax
  801338:	01 d0                	add    %edx,%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	01 c2                	add    %eax,%edx
  801347:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	01 c8                	add    %ecx,%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801353:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	01 c2                	add    %eax,%edx
  80135b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135e:	88 02                	mov    %al,(%edx)
		start++ ;
  801360:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801363:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801369:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136c:	7c c4                	jl     801332 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	01 d0                	add    %edx,%eax
  801376:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801379:	90                   	nop
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801382:	ff 75 08             	pushl  0x8(%ebp)
  801385:	e8 c4 f9 ff ff       	call   800d4e <strlen>
  80138a:	83 c4 04             	add    $0x4,%esp
  80138d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	e8 b6 f9 ff ff       	call   800d4e <strlen>
  801398:	83 c4 04             	add    $0x4,%esp
  80139b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ac:	eb 17                	jmp    8013c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	01 c2                	add    %eax,%edx
  8013b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c2:	ff 45 fc             	incl   -0x4(%ebp)
  8013c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013cb:	7c e1                	jl     8013ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013db:	eb 1f                	jmp    8013fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e0:	8d 50 01             	lea    0x1(%eax),%edx
  8013e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 c2                	add    %eax,%edx
  8013ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 c8                	add    %ecx,%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f9:	ff 45 f8             	incl   -0x8(%ebp)
  8013fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801402:	7c d9                	jl     8013dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801404:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801407:	8b 45 10             	mov    0x10(%ebp),%eax
  80140a:	01 d0                	add    %edx,%eax
  80140c:	c6 00 00             	movb   $0x0,(%eax)
}
  80140f:	90                   	nop
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801415:	8b 45 14             	mov    0x14(%ebp),%eax
  801418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141e:	8b 45 14             	mov    0x14(%ebp),%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	01 d0                	add    %edx,%eax
  80142f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801435:	eb 0c                	jmp    801443 <strsplit+0x31>
			*string++ = 0;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8d 50 01             	lea    0x1(%eax),%edx
  80143d:	89 55 08             	mov    %edx,0x8(%ebp)
  801440:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	84 c0                	test   %al,%al
  80144a:	74 18                	je     801464 <strsplit+0x52>
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	0f be c0             	movsbl %al,%eax
  801454:	50                   	push   %eax
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	e8 83 fa ff ff       	call   800ee0 <strchr>
  80145d:	83 c4 08             	add    $0x8,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	75 d3                	jne    801437 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	84 c0                	test   %al,%al
  80146b:	74 5a                	je     8014c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146d:	8b 45 14             	mov    0x14(%ebp),%eax
  801470:	8b 00                	mov    (%eax),%eax
  801472:	83 f8 0f             	cmp    $0xf,%eax
  801475:	75 07                	jne    80147e <strsplit+0x6c>
		{
			return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
  80147c:	eb 66                	jmp    8014e4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147e:	8b 45 14             	mov    0x14(%ebp),%eax
  801481:	8b 00                	mov    (%eax),%eax
  801483:	8d 48 01             	lea    0x1(%eax),%ecx
  801486:	8b 55 14             	mov    0x14(%ebp),%edx
  801489:	89 0a                	mov    %ecx,(%edx)
  80148b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	01 c2                	add    %eax,%edx
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149c:	eb 03                	jmp    8014a1 <strsplit+0x8f>
			string++;
  80149e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	84 c0                	test   %al,%al
  8014a8:	74 8b                	je     801435 <strsplit+0x23>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	50                   	push   %eax
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	e8 25 fa ff ff       	call   800ee0 <strchr>
  8014bb:	83 c4 08             	add    $0x8,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	74 dc                	je     80149e <strsplit+0x8c>
			string++;
	}
  8014c2:	e9 6e ff ff ff       	jmp    801435 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 d0                	add    %edx,%eax
  8014d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f9:	eb 4a                	jmp    801545 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	01 c2                	add    %eax,%edx
  801503:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	01 c8                	add    %ecx,%eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80150f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	01 d0                	add    %edx,%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 40                	cmp    $0x40,%al
  80151b:	7e 25                	jle    801542 <str2lower+0x5c>
  80151d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	01 d0                	add    %edx,%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	3c 5a                	cmp    $0x5a,%al
  801529:	7f 17                	jg     801542 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80152b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	01 d0                	add    %edx,%eax
  801533:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801536:	8b 55 08             	mov    0x8(%ebp),%edx
  801539:	01 ca                	add    %ecx,%edx
  80153b:	8a 12                	mov    (%edx),%dl
  80153d:	83 c2 20             	add    $0x20,%edx
  801540:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801542:	ff 45 fc             	incl   -0x4(%ebp)
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	e8 01 f8 ff ff       	call   800d4e <strlen>
  80154d:	83 c4 04             	add    $0x4,%esp
  801550:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801553:	7f a6                	jg     8014fb <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	57                   	push   %edi
  80155e:	56                   	push   %esi
  80155f:	53                   	push   %ebx
  801560:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8b 55 0c             	mov    0xc(%ebp),%edx
  801569:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80156f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801572:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801575:	cd 30                	int    $0x30
  801577:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	5b                   	pop    %ebx
  801581:	5e                   	pop    %esi
  801582:	5f                   	pop    %edi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	8b 45 10             	mov    0x10(%ebp),%eax
  80158e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801591:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801594:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	6a 00                	push   $0x0
  80159d:	51                   	push   %ecx
  80159e:	52                   	push   %edx
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	50                   	push   %eax
  8015a3:	6a 00                	push   $0x0
  8015a5:	e8 b0 ff ff ff       	call   80155a <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 02                	push   $0x2
  8015bf:	e8 96 ff ff ff       	call   80155a <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 03                	push   $0x3
  8015d8:	e8 7d ff ff ff       	call   80155a <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 04                	push   $0x4
  8015f2:	e8 63 ff ff ff       	call   80155a <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	90                   	nop
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	52                   	push   %edx
  80160d:	50                   	push   %eax
  80160e:	6a 08                	push   $0x8
  801610:	e8 45 ff ff ff       	call   80155a <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	56                   	push   %esi
  80161e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80161f:	8b 75 18             	mov    0x18(%ebp),%esi
  801622:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801625:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	56                   	push   %esi
  80162f:	53                   	push   %ebx
  801630:	51                   	push   %ecx
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	6a 09                	push   $0x9
  801635:	e8 20 ff ff ff       	call   80155a <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801640:	5b                   	pop    %ebx
  801641:	5e                   	pop    %esi
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    

00801644 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	ff 75 08             	pushl  0x8(%ebp)
  801652:	6a 0a                	push   $0xa
  801654:	e8 01 ff ff ff       	call   80155a <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	6a 0b                	push   $0xb
  80166f:	e8 e6 fe ff ff       	call   80155a <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 0c                	push   $0xc
  801688:	e8 cd fe ff ff       	call   80155a <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 0d                	push   $0xd
  8016a1:	e8 b4 fe ff ff       	call   80155a <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 0e                	push   $0xe
  8016ba:	e8 9b fe ff ff       	call   80155a <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 0f                	push   $0xf
  8016d3:	e8 82 fe ff ff       	call   80155a <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	6a 10                	push   $0x10
  8016ed:	e8 68 fe ff ff       	call   80155a <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 11                	push   $0x11
  801706:	e8 4f fe ff ff       	call   80155a <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_cputc>:

void
sys_cputc(const char c)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80171d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	50                   	push   %eax
  80172a:	6a 01                	push   $0x1
  80172c:	e8 29 fe ff ff       	call   80155a <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	90                   	nop
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 14                	push   $0x14
  801746:	e8 0f fe ff ff       	call   80155a <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	8b 45 10             	mov    0x10(%ebp),%eax
  80175a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80175d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801760:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	6a 00                	push   $0x0
  801769:	51                   	push   %ecx
  80176a:	52                   	push   %edx
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	50                   	push   %eax
  80176f:	6a 15                	push   $0x15
  801771:	e8 e4 fd ff ff       	call   80155a <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	52                   	push   %edx
  80178b:	50                   	push   %eax
  80178c:	6a 16                	push   $0x16
  80178e:	e8 c7 fd ff ff       	call   80155a <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80179b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	51                   	push   %ecx
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 17                	push   $0x17
  8017ad:	e8 a8 fd ff ff       	call   80155a <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	52                   	push   %edx
  8017c7:	50                   	push   %eax
  8017c8:	6a 18                	push   $0x18
  8017ca:	e8 8b fd ff ff       	call   80155a <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 14             	pushl  0x14(%ebp)
  8017df:	ff 75 10             	pushl  0x10(%ebp)
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	50                   	push   %eax
  8017e6:	6a 19                	push   $0x19
  8017e8:	e8 6d fd ff ff       	call   80155a <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	50                   	push   %eax
  801801:	6a 1a                	push   $0x1a
  801803:	e8 52 fd ff ff       	call   80155a <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	90                   	nop
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	50                   	push   %eax
  80181d:	6a 1b                	push   $0x1b
  80181f:	e8 36 fd ff ff       	call   80155a <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 05                	push   $0x5
  801838:	e8 1d fd ff ff       	call   80155a <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 06                	push   $0x6
  801851:	e8 04 fd ff ff       	call   80155a <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 07                	push   $0x7
  80186a:	e8 eb fc ff ff       	call   80155a <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_exit_env>:


void sys_exit_env(void)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 1c                	push   $0x1c
  801883:	e8 d2 fc ff ff       	call   80155a <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	90                   	nop
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801894:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801897:	8d 50 04             	lea    0x4(%eax),%edx
  80189a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 1d                	push   $0x1d
  8018a7:	e8 ae fc ff ff       	call   80155a <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
	return result;
  8018af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b8:	89 01                	mov    %eax,(%ecx)
  8018ba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	c9                   	leave  
  8018c1:	c2 04 00             	ret    $0x4

008018c4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 10             	pushl  0x10(%ebp)
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	6a 13                	push   $0x13
  8018d6:	e8 7f fc ff ff       	call   80155a <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
	return ;
  8018de:	90                   	nop
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 1e                	push   $0x1e
  8018f0:	e8 65 fc ff ff       	call   80155a <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 04             	sub    $0x4,%esp
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801906:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	50                   	push   %eax
  801913:	6a 1f                	push   $0x1f
  801915:	e8 40 fc ff ff       	call   80155a <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
	return ;
  80191d:	90                   	nop
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <rsttst>:
void rsttst()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 21                	push   $0x21
  80192f:	e8 26 fc ff ff       	call   80155a <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return ;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	8b 45 14             	mov    0x14(%ebp),%eax
  801943:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801946:	8b 55 18             	mov    0x18(%ebp),%edx
  801949:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	ff 75 10             	pushl  0x10(%ebp)
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	6a 20                	push   $0x20
  80195a:	e8 fb fb ff ff       	call   80155a <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
	return ;
  801962:	90                   	nop
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <chktst>:
void chktst(uint32 n)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 22                	push   $0x22
  801975:	e8 e0 fb ff ff       	call   80155a <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <inctst>:

void inctst()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 23                	push   $0x23
  80198f:	e8 c6 fb ff ff       	call   80155a <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return ;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <gettst>:
uint32 gettst()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 24                	push   $0x24
  8019a9:	e8 ac fb ff ff       	call   80155a <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 25                	push   $0x25
  8019c2:	e8 93 fb ff ff       	call   80155a <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
  8019ca:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  8019cf:	a1 00 71 82 00       	mov    0x827100,%eax
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	6a 26                	push   $0x26
  8019ee:	e8 67 fb ff ff       	call   80155a <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f6:	90                   	nop
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	53                   	push   %ebx
  801a0c:	51                   	push   %ecx
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 27                	push   $0x27
  801a11:	e8 44 fb ff ff       	call   80155a <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 28                	push   $0x28
  801a31:	e8 24 fb ff ff       	call   80155a <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	51                   	push   %ecx
  801a4a:	ff 75 10             	pushl  0x10(%ebp)
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 29                	push   $0x29
  801a51:	e8 04 fb ff ff       	call   80155a <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 10             	pushl  0x10(%ebp)
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	6a 12                	push   $0x12
  801a6d:	e8 e8 fa ff ff       	call   80155a <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
	return ;
  801a75:	90                   	nop
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 2a                	push   $0x2a
  801a8b:	e8 ca fa ff ff       	call   80155a <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return;
  801a93:	90                   	nop
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 2b                	push   $0x2b
  801aa5:	e8 b0 fa ff ff       	call   80155a <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 2d                	push   $0x2d
  801ac0:	e8 95 fa ff ff       	call   80155a <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	6a 2c                	push   $0x2c
  801adc:	e8 79 fa ff ff       	call   80155a <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	52                   	push   %edx
  801af7:	50                   	push   %eax
  801af8:	6a 2e                	push   $0x2e
  801afa:	e8 5b fa ff ff       	call   80155a <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
	return ;
  801b02:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    
  801b05:	66 90                	xchg   %ax,%ax
  801b07:	90                   	nop

00801b08 <__udivdi3>:
  801b08:	55                   	push   %ebp
  801b09:	57                   	push   %edi
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 1c             	sub    $0x1c,%esp
  801b0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1f:	89 ca                	mov    %ecx,%edx
  801b21:	89 f8                	mov    %edi,%eax
  801b23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b27:	85 f6                	test   %esi,%esi
  801b29:	75 2d                	jne    801b58 <__udivdi3+0x50>
  801b2b:	39 cf                	cmp    %ecx,%edi
  801b2d:	77 65                	ja     801b94 <__udivdi3+0x8c>
  801b2f:	89 fd                	mov    %edi,%ebp
  801b31:	85 ff                	test   %edi,%edi
  801b33:	75 0b                	jne    801b40 <__udivdi3+0x38>
  801b35:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3a:	31 d2                	xor    %edx,%edx
  801b3c:	f7 f7                	div    %edi
  801b3e:	89 c5                	mov    %eax,%ebp
  801b40:	31 d2                	xor    %edx,%edx
  801b42:	89 c8                	mov    %ecx,%eax
  801b44:	f7 f5                	div    %ebp
  801b46:	89 c1                	mov    %eax,%ecx
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	f7 f5                	div    %ebp
  801b4c:	89 cf                	mov    %ecx,%edi
  801b4e:	89 fa                	mov    %edi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	39 ce                	cmp    %ecx,%esi
  801b5a:	77 28                	ja     801b84 <__udivdi3+0x7c>
  801b5c:	0f bd fe             	bsr    %esi,%edi
  801b5f:	83 f7 1f             	xor    $0x1f,%edi
  801b62:	75 40                	jne    801ba4 <__udivdi3+0x9c>
  801b64:	39 ce                	cmp    %ecx,%esi
  801b66:	72 0a                	jb     801b72 <__udivdi3+0x6a>
  801b68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b6c:	0f 87 9e 00 00 00    	ja     801c10 <__udivdi3+0x108>
  801b72:	b8 01 00 00 00       	mov    $0x1,%eax
  801b77:	89 fa                	mov    %edi,%edx
  801b79:	83 c4 1c             	add    $0x1c,%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5f                   	pop    %edi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    
  801b81:	8d 76 00             	lea    0x0(%esi),%esi
  801b84:	31 ff                	xor    %edi,%edi
  801b86:	31 c0                	xor    %eax,%eax
  801b88:	89 fa                	mov    %edi,%edx
  801b8a:	83 c4 1c             	add    $0x1c,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5e                   	pop    %esi
  801b8f:	5f                   	pop    %edi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	f7 f7                	div    %edi
  801b98:	31 ff                	xor    %edi,%edi
  801b9a:	89 fa                	mov    %edi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ba9:	89 eb                	mov    %ebp,%ebx
  801bab:	29 fb                	sub    %edi,%ebx
  801bad:	89 f9                	mov    %edi,%ecx
  801baf:	d3 e6                	shl    %cl,%esi
  801bb1:	89 c5                	mov    %eax,%ebp
  801bb3:	88 d9                	mov    %bl,%cl
  801bb5:	d3 ed                	shr    %cl,%ebp
  801bb7:	89 e9                	mov    %ebp,%ecx
  801bb9:	09 f1                	or     %esi,%ecx
  801bbb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bbf:	89 f9                	mov    %edi,%ecx
  801bc1:	d3 e0                	shl    %cl,%eax
  801bc3:	89 c5                	mov    %eax,%ebp
  801bc5:	89 d6                	mov    %edx,%esi
  801bc7:	88 d9                	mov    %bl,%cl
  801bc9:	d3 ee                	shr    %cl,%esi
  801bcb:	89 f9                	mov    %edi,%ecx
  801bcd:	d3 e2                	shl    %cl,%edx
  801bcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd3:	88 d9                	mov    %bl,%cl
  801bd5:	d3 e8                	shr    %cl,%eax
  801bd7:	09 c2                	or     %eax,%edx
  801bd9:	89 d0                	mov    %edx,%eax
  801bdb:	89 f2                	mov    %esi,%edx
  801bdd:	f7 74 24 0c          	divl   0xc(%esp)
  801be1:	89 d6                	mov    %edx,%esi
  801be3:	89 c3                	mov    %eax,%ebx
  801be5:	f7 e5                	mul    %ebp
  801be7:	39 d6                	cmp    %edx,%esi
  801be9:	72 19                	jb     801c04 <__udivdi3+0xfc>
  801beb:	74 0b                	je     801bf8 <__udivdi3+0xf0>
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	31 ff                	xor    %edi,%edi
  801bf1:	e9 58 ff ff ff       	jmp    801b4e <__udivdi3+0x46>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bfc:	89 f9                	mov    %edi,%ecx
  801bfe:	d3 e2                	shl    %cl,%edx
  801c00:	39 c2                	cmp    %eax,%edx
  801c02:	73 e9                	jae    801bed <__udivdi3+0xe5>
  801c04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c07:	31 ff                	xor    %edi,%edi
  801c09:	e9 40 ff ff ff       	jmp    801b4e <__udivdi3+0x46>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	31 c0                	xor    %eax,%eax
  801c12:	e9 37 ff ff ff       	jmp    801b4e <__udivdi3+0x46>
  801c17:	90                   	nop

00801c18 <__umoddi3>:
  801c18:	55                   	push   %ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 1c             	sub    $0x1c,%esp
  801c1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c37:	89 f3                	mov    %esi,%ebx
  801c39:	89 fa                	mov    %edi,%edx
  801c3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3f:	89 34 24             	mov    %esi,(%esp)
  801c42:	85 c0                	test   %eax,%eax
  801c44:	75 1a                	jne    801c60 <__umoddi3+0x48>
  801c46:	39 f7                	cmp    %esi,%edi
  801c48:	0f 86 a2 00 00 00    	jbe    801cf0 <__umoddi3+0xd8>
  801c4e:	89 c8                	mov    %ecx,%eax
  801c50:	89 f2                	mov    %esi,%edx
  801c52:	f7 f7                	div    %edi
  801c54:	89 d0                	mov    %edx,%eax
  801c56:	31 d2                	xor    %edx,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	39 f0                	cmp    %esi,%eax
  801c62:	0f 87 ac 00 00 00    	ja     801d14 <__umoddi3+0xfc>
  801c68:	0f bd e8             	bsr    %eax,%ebp
  801c6b:	83 f5 1f             	xor    $0x1f,%ebp
  801c6e:	0f 84 ac 00 00 00    	je     801d20 <__umoddi3+0x108>
  801c74:	bf 20 00 00 00       	mov    $0x20,%edi
  801c79:	29 ef                	sub    %ebp,%edi
  801c7b:	89 fe                	mov    %edi,%esi
  801c7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c81:	89 e9                	mov    %ebp,%ecx
  801c83:	d3 e0                	shl    %cl,%eax
  801c85:	89 d7                	mov    %edx,%edi
  801c87:	89 f1                	mov    %esi,%ecx
  801c89:	d3 ef                	shr    %cl,%edi
  801c8b:	09 c7                	or     %eax,%edi
  801c8d:	89 e9                	mov    %ebp,%ecx
  801c8f:	d3 e2                	shl    %cl,%edx
  801c91:	89 14 24             	mov    %edx,(%esp)
  801c94:	89 d8                	mov    %ebx,%eax
  801c96:	d3 e0                	shl    %cl,%eax
  801c98:	89 c2                	mov    %eax,%edx
  801c9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9e:	d3 e0                	shl    %cl,%eax
  801ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca8:	89 f1                	mov    %esi,%ecx
  801caa:	d3 e8                	shr    %cl,%eax
  801cac:	09 d0                	or     %edx,%eax
  801cae:	d3 eb                	shr    %cl,%ebx
  801cb0:	89 da                	mov    %ebx,%edx
  801cb2:	f7 f7                	div    %edi
  801cb4:	89 d3                	mov    %edx,%ebx
  801cb6:	f7 24 24             	mull   (%esp)
  801cb9:	89 c6                	mov    %eax,%esi
  801cbb:	89 d1                	mov    %edx,%ecx
  801cbd:	39 d3                	cmp    %edx,%ebx
  801cbf:	0f 82 87 00 00 00    	jb     801d4c <__umoddi3+0x134>
  801cc5:	0f 84 91 00 00 00    	je     801d5c <__umoddi3+0x144>
  801ccb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ccf:	29 f2                	sub    %esi,%edx
  801cd1:	19 cb                	sbb    %ecx,%ebx
  801cd3:	89 d8                	mov    %ebx,%eax
  801cd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cd9:	d3 e0                	shl    %cl,%eax
  801cdb:	89 e9                	mov    %ebp,%ecx
  801cdd:	d3 ea                	shr    %cl,%edx
  801cdf:	09 d0                	or     %edx,%eax
  801ce1:	89 e9                	mov    %ebp,%ecx
  801ce3:	d3 eb                	shr    %cl,%ebx
  801ce5:	89 da                	mov    %ebx,%edx
  801ce7:	83 c4 1c             	add    $0x1c,%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    
  801cef:	90                   	nop
  801cf0:	89 fd                	mov    %edi,%ebp
  801cf2:	85 ff                	test   %edi,%edi
  801cf4:	75 0b                	jne    801d01 <__umoddi3+0xe9>
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	f7 f7                	div    %edi
  801cff:	89 c5                	mov    %eax,%ebp
  801d01:	89 f0                	mov    %esi,%eax
  801d03:	31 d2                	xor    %edx,%edx
  801d05:	f7 f5                	div    %ebp
  801d07:	89 c8                	mov    %ecx,%eax
  801d09:	f7 f5                	div    %ebp
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	e9 44 ff ff ff       	jmp    801c56 <__umoddi3+0x3e>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	89 c8                	mov    %ecx,%eax
  801d16:	89 f2                	mov    %esi,%edx
  801d18:	83 c4 1c             	add    $0x1c,%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    
  801d20:	3b 04 24             	cmp    (%esp),%eax
  801d23:	72 06                	jb     801d2b <__umoddi3+0x113>
  801d25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d29:	77 0f                	ja     801d3a <__umoddi3+0x122>
  801d2b:	89 f2                	mov    %esi,%edx
  801d2d:	29 f9                	sub    %edi,%ecx
  801d2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d33:	89 14 24             	mov    %edx,(%esp)
  801d36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d3e:	8b 14 24             	mov    (%esp),%edx
  801d41:	83 c4 1c             	add    $0x1c,%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5f                   	pop    %edi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    
  801d49:	8d 76 00             	lea    0x0(%esi),%esi
  801d4c:	2b 04 24             	sub    (%esp),%eax
  801d4f:	19 fa                	sbb    %edi,%edx
  801d51:	89 d1                	mov    %edx,%ecx
  801d53:	89 c6                	mov    %eax,%esi
  801d55:	e9 71 ff ff ff       	jmp    801ccb <__umoddi3+0xb3>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d60:	72 ea                	jb     801d4c <__umoddi3+0x134>
  801d62:	89 d9                	mov    %ebx,%ecx
  801d64:	e9 62 ff ff ff       	jmp    801ccb <__umoddi3+0xb3>
