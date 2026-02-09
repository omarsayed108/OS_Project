
obj/user/tst_page_replacement_lru:     file format elf32-i386


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
  800031:	e8 9e 01 00 00       	call   8001d4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x809000, 0x800000, 0x80a000, 0x803000,0x801000,0x804000,0x80b000,0x80c000,0x827000,0x802000,	//Code & Data
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
  80004c:	e8 e7 19 00 00       	call   801a38 <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 80 1d 80 00       	push   $0x801d80
  800065:	6a 1d                	push   $0x1d
  800067:	68 f4 1d 80 00       	push   $0x801df4
  80006c:	e8 13 03 00 00       	call   800384 <_panic>
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
	}

	//===================


	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 14 1e 80 00       	push   $0x801e14
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 d0 05 00 00       	call   80069f <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 2d 1e 80 00       	push   $0x801e2d
  8000e6:	6a 3d                	push   $0x3d
  8000e8:	68 f4 1d 80 00       	push   $0x801df4
  8000ed:	e8 92 02 00 00       	call   800384 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 2d 1e 80 00       	push   $0x801e2d
  800106:	6a 3e                	push   $0x3e
  800108:	68 f4 1d 80 00       	push   $0x801df4
  80010d:	e8 72 02 00 00       	call   800384 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE LRU algorithm... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 3c 1e 80 00       	push   $0x801e3c
  80011a:	6a 03                	push   $0x3
  80011c:	e8 7e 05 00 00       	call   80069f <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0, 0); //order is not important in LRU
  800124:	6a 00                	push   $0x0
  800126:	6a 00                	push   $0x0
  800128:	6a 0b                	push   $0xb
  80012a:	68 60 30 80 00       	push   $0x803060
  80012f:	e8 04 19 00 00       	call   801a38 <sys_check_WS_list>
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("LRU alg. failed.. trace it by printing WS before and after page fault");
  80013a:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80013e:	74 14                	je     800154 <_main+0x11c>
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	68 60 1e 80 00       	push   $0x801e60
  800148:	6a 43                	push   $0x43
  80014a:	68 f4 1d 80 00       	push   $0x801df4
  80014f:	e8 30 02 00 00       	call   800384 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Disk Access... \n");
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	68 a8 1e 80 00       	push   $0x801ea8
  80015c:	6a 03                	push   $0x3
  80015e:	e8 3c 05 00 00       	call   80069f <cprintf_colored>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 17;
  800166:	c7 45 e4 11 00 00 00 	movl   $0x11,-0x1c(%ebp)
		uint32 expectedNumOfWrites = 6;
  80016d:	c7 45 e0 06 00 00 00 	movl   $0x6,-0x20(%ebp)
		uint32 expectedNumOfReads = 17;
  800174:	c7 45 dc 11 00 00 00 	movl   $0x11,-0x24(%ebp)
		if (myEnv->nPageIn != expectedNumOfReads || myEnv->nPageOut != expectedNumOfWrites || myEnv->pageFaultsCounter != expectedNumOfFaults)
  80017b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800180:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800186:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800189:	75 20                	jne    8001ab <_main+0x173>
  80018b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800190:	8b 80 98 06 00 00    	mov    0x698(%eax),%eax
  800196:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800199:	75 10                	jne    8001ab <_main+0x173>
  80019b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a0:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8001a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001a9:	74 14                	je     8001bf <_main+0x187>
			panic("LRU alg. failed.. unexpected number of disk access");
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 d0 1e 80 00       	push   $0x801ed0
  8001b3:	6a 4b                	push   $0x4b
  8001b5:	68 f4 1d 80 00       	push   $0x801df4
  8001ba:	e8 c5 01 00 00       	call   800384 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [LRU Alg.] is completed successfully.\n");
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	68 04 1f 80 00       	push   $0x801f04
  8001c7:	6a 0a                	push   $0xa
  8001c9:	e8 d1 04 00 00       	call   80069f <cprintf_colored>
  8001ce:	83 c4 10             	add    $0x10,%esp
	return;
  8001d1:	90                   	nop
}
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    

008001d4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	57                   	push   %edi
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001dd:	e8 5d 16 00 00       	call   80183f <sys_getenvindex>
  8001e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	01 c0                	add    %eax,%eax
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	c1 e0 02             	shl    $0x2,%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	c1 e0 02             	shl    $0x2,%eax
  8001f6:	01 d0                	add    %edx,%eax
  8001f8:	c1 e0 03             	shl    $0x3,%eax
  8001fb:	01 d0                	add    %edx,%eax
  8001fd:	c1 e0 02             	shl    $0x2,%eax
  800200:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800205:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80020f:	8a 40 20             	mov    0x20(%eax),%al
  800212:	84 c0                	test   %al,%al
  800214:	74 0d                	je     800223 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800216:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80021b:	83 c0 20             	add    $0x20,%eax
  80021e:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800227:	7e 0a                	jle    800233 <libmain+0x5f>
		binaryname = argv[0];
  800229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022c:	8b 00                	mov    (%eax),%eax
  80022e:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	e8 f7 fd ff ff       	call   800038 <_main>
  800241:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800244:	a1 8c 30 80 00       	mov    0x80308c,%eax
  800249:	85 c0                	test   %eax,%eax
  80024b:	0f 84 01 01 00 00    	je     800352 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800251:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800257:	bb 50 20 80 00       	mov    $0x802050,%ebx
  80025c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800261:	89 c7                	mov    %eax,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	89 d1                	mov    %edx,%ecx
  800267:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800269:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80026c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800271:	b0 00                	mov    $0x0,%al
  800273:	89 d7                	mov    %edx,%edi
  800275:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800277:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80027e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	50                   	push   %eax
  800285:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80028b:	50                   	push   %eax
  80028c:	e8 e4 17 00 00       	call   801a75 <sys_utilities>
  800291:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800294:	e8 2d 13 00 00       	call   8015c6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	68 70 1f 80 00       	push   $0x801f70
  8002a1:	e8 cc 03 00 00       	call   800672 <cprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	85 c0                	test   %eax,%eax
  8002ae:	74 18                	je     8002c8 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002b0:	e8 de 17 00 00       	call   801a93 <sys_get_optimal_num_faults>
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	50                   	push   %eax
  8002b9:	68 98 1f 80 00       	push   $0x801f98
  8002be:	e8 af 03 00 00       	call   800672 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb 59                	jmp    800321 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002cd:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8002d3:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002d8:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 bc 1f 80 00       	push   $0x801fbc
  8002e8:	e8 85 03 00 00       	call   800672 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002f5:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8002fb:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800300:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800306:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80030b:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 e4 1f 80 00       	push   $0x801fe4
  800319:	e8 54 03 00 00       	call   800672 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800326:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 3c 20 80 00       	push   $0x80203c
  800335:	e8 38 03 00 00       	call   800672 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 70 1f 80 00       	push   $0x801f70
  800345:	e8 28 03 00 00       	call   800672 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80034d:	e8 8e 12 00 00       	call   8015e0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800352:	e8 1f 00 00 00       	call   800376 <exit>
}
  800357:	90                   	nop
  800358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035b:	5b                   	pop    %ebx
  80035c:	5e                   	pop    %esi
  80035d:	5f                   	pop    %edi
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	6a 00                	push   $0x0
  80036b:	e8 9b 14 00 00       	call   80180b <sys_destroy_env>
  800370:	83 c4 10             	add    $0x10,%esp
}
  800373:	90                   	nop
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <exit>:

void
exit(void)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037c:	e8 f0 14 00 00       	call   801871 <sys_exit_env>
}
  800381:	90                   	nop
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80038a:	8d 45 10             	lea    0x10(%ebp),%eax
  80038d:	83 c0 04             	add    $0x4,%eax
  800390:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800393:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	74 16                	je     8003b2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80039c:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	50                   	push   %eax
  8003a5:	68 b4 20 80 00       	push   $0x8020b4
  8003aa:	e8 c3 02 00 00       	call   800672 <cprintf>
  8003af:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003b2:	a1 90 30 80 00       	mov    0x803090,%eax
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	50                   	push   %eax
  8003c1:	68 bc 20 80 00       	push   $0x8020bc
  8003c6:	6a 74                	push   $0x74
  8003c8:	e8 d2 02 00 00       	call   80069f <cprintf_colored>
  8003cd:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d9:	50                   	push   %eax
  8003da:	e8 24 02 00 00       	call   800603 <vcprintf>
  8003df:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	6a 00                	push   $0x0
  8003e7:	68 e4 20 80 00       	push   $0x8020e4
  8003ec:	e8 12 02 00 00       	call   800603 <vcprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f4:	e8 7d ff ff ff       	call   800376 <exit>

	// should not return here
	while (1) ;
  8003f9:	eb fe                	jmp    8003f9 <_panic+0x75>

008003fb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	53                   	push   %ebx
  8003ff:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800402:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800407:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800410:	39 c2                	cmp    %eax,%edx
  800412:	74 14                	je     800428 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800414:	83 ec 04             	sub    $0x4,%esp
  800417:	68 e8 20 80 00       	push   $0x8020e8
  80041c:	6a 26                	push   $0x26
  80041e:	68 34 21 80 00       	push   $0x802134
  800423:	e8 5c ff ff ff       	call   800384 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80042f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800436:	e9 d9 00 00 00       	jmp    800514 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80043b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	85 c0                	test   %eax,%eax
  80044e:	75 08                	jne    800458 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800450:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800453:	e9 b9 00 00 00       	jmp    800511 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800458:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800466:	eb 79                	jmp    8004e1 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800468:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80046d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800473:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800476:	89 d0                	mov    %edx,%eax
  800478:	01 c0                	add    %eax,%eax
  80047a:	01 d0                	add    %edx,%eax
  80047c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800483:	01 d8                	add    %ebx,%eax
  800485:	01 d0                	add    %edx,%eax
  800487:	01 c8                	add    %ecx,%eax
  800489:	8a 40 04             	mov    0x4(%eax),%al
  80048c:	84 c0                	test   %al,%al
  80048e:	75 4e                	jne    8004de <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800490:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800495:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80049b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80049e:	89 d0                	mov    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004ab:	01 d8                	add    %ebx,%eax
  8004ad:	01 d0                	add    %edx,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 19                	jmp    8004f7 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004e6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ef:	39 c2                	cmp    %eax,%edx
  8004f1:	0f 87 71 ff ff ff    	ja     800468 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004fb:	75 14                	jne    800511 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 40 21 80 00       	push   $0x802140
  800505:	6a 3a                	push   $0x3a
  800507:	68 34 21 80 00       	push   $0x802134
  80050c:	e8 73 fe ff ff       	call   800384 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800511:	ff 45 f0             	incl   -0x10(%ebp)
  800514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800517:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80051a:	0f 8c 1b ff ff ff    	jl     80043b <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800527:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80052e:	eb 2e                	jmp    80055e <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800530:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800535:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80053b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	01 c0                	add    %eax,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80054b:	01 d8                	add    %ebx,%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	01 c8                	add    %ecx,%eax
  800551:	8a 40 04             	mov    0x4(%eax),%al
  800554:	3c 01                	cmp    $0x1,%al
  800556:	75 03                	jne    80055b <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800558:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055b:	ff 45 e0             	incl   -0x20(%ebp)
  80055e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800563:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056c:	39 c2                	cmp    %eax,%edx
  80056e:	77 c0                	ja     800530 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800576:	74 14                	je     80058c <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800578:	83 ec 04             	sub    $0x4,%esp
  80057b:	68 94 21 80 00       	push   $0x802194
  800580:	6a 44                	push   $0x44
  800582:	68 34 21 80 00       	push   $0x802134
  800587:	e8 f8 fd ff ff       	call   800384 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80058c:	90                   	nop
  80058d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	53                   	push   %ebx
  800596:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a4:	89 0a                	mov    %ecx,(%edx)
  8005a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a9:	88 d1                	mov    %dl,%cl
  8005ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005bc:	75 30                	jne    8005ee <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005be:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005c4:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005c9:	0f b6 c0             	movzbl %al,%eax
  8005cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005cf:	8b 09                	mov    (%ecx),%ecx
  8005d1:	89 cb                	mov    %ecx,%ebx
  8005d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d6:	83 c1 08             	add    $0x8,%ecx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	53                   	push   %ebx
  8005dc:	51                   	push   %ecx
  8005dd:	e8 a0 0f 00 00       	call   801582 <sys_cputs>
  8005e2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f1:	8b 40 04             	mov    0x4(%eax),%eax
  8005f4:	8d 50 01             	lea    0x1(%eax),%edx
  8005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fa:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005fd:	90                   	nop
  8005fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80060c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800613:	00 00 00 
	b.cnt = 0;
  800616:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80061d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	ff 75 08             	pushl  0x8(%ebp)
  800626:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80062c:	50                   	push   %eax
  80062d:	68 92 05 80 00       	push   $0x800592
  800632:	e8 5a 02 00 00       	call   800891 <vprintfmt>
  800637:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80063a:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  800640:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800645:	0f b6 c0             	movzbl %al,%eax
  800648:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80064e:	52                   	push   %edx
  80064f:	50                   	push   %eax
  800650:	51                   	push   %ecx
  800651:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800657:	83 c0 08             	add    $0x8,%eax
  80065a:	50                   	push   %eax
  80065b:	e8 22 0f 00 00       	call   801582 <sys_cputs>
  800660:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800663:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  80066a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800678:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  80067f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800682:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 f4             	pushl  -0xc(%ebp)
  80068e:	50                   	push   %eax
  80068f:	e8 6f ff ff ff       	call   800603 <vcprintf>
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80069a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

0080069f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006a5:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	c1 e0 08             	shl    $0x8,%eax
  8006b2:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  8006b7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ba:	83 c0 04             	add    $0x4,%eax
  8006bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	e8 34 ff ff ff       	call   800603 <vcprintf>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006d5:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  8006dc:	07 00 00 

	return cnt;
  8006df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    

008006e4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ea:	e8 d7 0e 00 00       	call   8015c6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006ef:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fe:	50                   	push   %eax
  8006ff:	e8 ff fe ff ff       	call   800603 <vcprintf>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80070a:	e8 d1 0e 00 00       	call   8015e0 <sys_unlock_cons>
	return cnt;
  80070f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	53                   	push   %ebx
  800718:	83 ec 14             	sub    $0x14,%esp
  80071b:	8b 45 10             	mov    0x10(%ebp),%eax
  80071e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800727:	8b 45 18             	mov    0x18(%ebp),%eax
  80072a:	ba 00 00 00 00       	mov    $0x0,%edx
  80072f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800732:	77 55                	ja     800789 <printnum+0x75>
  800734:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800737:	72 05                	jb     80073e <printnum+0x2a>
  800739:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80073c:	77 4b                	ja     800789 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800741:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800744:	8b 45 18             	mov    0x18(%ebp),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	52                   	push   %edx
  80074d:	50                   	push   %eax
  80074e:	ff 75 f4             	pushl  -0xc(%ebp)
  800751:	ff 75 f0             	pushl  -0x10(%ebp)
  800754:	e8 ab 13 00 00       	call   801b04 <__udivdi3>
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	83 ec 04             	sub    $0x4,%esp
  80075f:	ff 75 20             	pushl  0x20(%ebp)
  800762:	53                   	push   %ebx
  800763:	ff 75 18             	pushl  0x18(%ebp)
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	ff 75 08             	pushl  0x8(%ebp)
  80076e:	e8 a1 ff ff ff       	call   800714 <printnum>
  800773:	83 c4 20             	add    $0x20,%esp
  800776:	eb 1a                	jmp    800792 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	ff 75 20             	pushl  0x20(%ebp)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	ff d0                	call   *%eax
  800786:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800789:	ff 4d 1c             	decl   0x1c(%ebp)
  80078c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800790:	7f e6                	jg     800778 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800792:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800795:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a0:	53                   	push   %ebx
  8007a1:	51                   	push   %ecx
  8007a2:	52                   	push   %edx
  8007a3:	50                   	push   %eax
  8007a4:	e8 6b 14 00 00       	call   801c14 <__umoddi3>
  8007a9:	83 c4 10             	add    $0x10,%esp
  8007ac:	05 f4 23 80 00       	add    $0x8023f4,%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be c0             	movsbl %al,%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
}
  8007c5:	90                   	nop
  8007c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ce:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d2:	7e 1c                	jle    8007f0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	8d 50 08             	lea    0x8(%eax),%edx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	89 10                	mov    %edx,(%eax)
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	83 e8 08             	sub    $0x8,%eax
  8007e9:	8b 50 04             	mov    0x4(%eax),%edx
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	eb 40                	jmp    800830 <getuint+0x65>
	else if (lflag)
  8007f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f4:	74 1e                	je     800814 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	8d 50 04             	lea    0x4(%eax),%edx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	89 10                	mov    %edx,(%eax)
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 e8 04             	sub    $0x4,%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	eb 1c                	jmp    800830 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	8d 50 04             	lea    0x4(%eax),%edx
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	89 10                	mov    %edx,(%eax)
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	83 e8 04             	sub    $0x4,%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800835:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800839:	7e 1c                	jle    800857 <getint+0x25>
		return va_arg(*ap, long long);
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	8d 50 08             	lea    0x8(%eax),%edx
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	89 10                	mov    %edx,(%eax)
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	8b 00                	mov    (%eax),%eax
  80084d:	83 e8 08             	sub    $0x8,%eax
  800850:	8b 50 04             	mov    0x4(%eax),%edx
  800853:	8b 00                	mov    (%eax),%eax
  800855:	eb 38                	jmp    80088f <getint+0x5d>
	else if (lflag)
  800857:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085b:	74 1a                	je     800877 <getint+0x45>
		return va_arg(*ap, long);
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	8d 50 04             	lea    0x4(%eax),%edx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	89 10                	mov    %edx,(%eax)
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	83 e8 04             	sub    $0x4,%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	99                   	cltd   
  800875:	eb 18                	jmp    80088f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 10                	mov    %edx,(%eax)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	83 e8 04             	sub    $0x4,%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	99                   	cltd   
}
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	56                   	push   %esi
  800895:	53                   	push   %ebx
  800896:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	eb 17                	jmp    8008b2 <vprintfmt+0x21>
			if (ch == '\0')
  80089b:	85 db                	test   %ebx,%ebx
  80089d:	0f 84 c1 03 00 00    	je     800c64 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b5:	8d 50 01             	lea    0x1(%eax),%edx
  8008b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008bb:	8a 00                	mov    (%eax),%al
  8008bd:	0f b6 d8             	movzbl %al,%ebx
  8008c0:	83 fb 25             	cmp    $0x25,%ebx
  8008c3:	75 d6                	jne    80089b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	8d 50 01             	lea    0x1(%eax),%edx
  8008eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ee:	8a 00                	mov    (%eax),%al
  8008f0:	0f b6 d8             	movzbl %al,%ebx
  8008f3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008f6:	83 f8 5b             	cmp    $0x5b,%eax
  8008f9:	0f 87 3d 03 00 00    	ja     800c3c <vprintfmt+0x3ab>
  8008ff:	8b 04 85 18 24 80 00 	mov    0x802418(,%eax,4),%eax
  800906:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800908:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80090c:	eb d7                	jmp    8008e5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80090e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800912:	eb d1                	jmp    8008e5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80091b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091e:	89 d0                	mov    %edx,%eax
  800920:	c1 e0 02             	shl    $0x2,%eax
  800923:	01 d0                	add    %edx,%eax
  800925:	01 c0                	add    %eax,%eax
  800927:	01 d8                	add    %ebx,%eax
  800929:	83 e8 30             	sub    $0x30,%eax
  80092c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80092f:	8b 45 10             	mov    0x10(%ebp),%eax
  800932:	8a 00                	mov    (%eax),%al
  800934:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800937:	83 fb 2f             	cmp    $0x2f,%ebx
  80093a:	7e 3e                	jle    80097a <vprintfmt+0xe9>
  80093c:	83 fb 39             	cmp    $0x39,%ebx
  80093f:	7f 39                	jg     80097a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800941:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800944:	eb d5                	jmp    80091b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 c0 04             	add    $0x4,%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095a:	eb 1f                	jmp    80097b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80095c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800960:	79 83                	jns    8008e5 <vprintfmt+0x54>
				width = 0;
  800962:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800969:	e9 77 ff ff ff       	jmp    8008e5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80096e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800975:	e9 6b ff ff ff       	jmp    8008e5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80097b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097f:	0f 89 60 ff ff ff    	jns    8008e5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800988:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800992:	e9 4e ff ff ff       	jmp    8008e5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800997:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099a:	e9 46 ff ff ff       	jmp    8008e5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 c0 04             	add    $0x4,%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	83 e8 04             	sub    $0x4,%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	50                   	push   %eax
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			break;
  8009bf:	e9 9b 02 00 00       	jmp    800c5f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	83 c0 04             	add    $0x4,%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d5:	85 db                	test   %ebx,%ebx
  8009d7:	79 02                	jns    8009db <vprintfmt+0x14a>
				err = -err;
  8009d9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009db:	83 fb 64             	cmp    $0x64,%ebx
  8009de:	7f 0b                	jg     8009eb <vprintfmt+0x15a>
  8009e0:	8b 34 9d 60 22 80 00 	mov    0x802260(,%ebx,4),%esi
  8009e7:	85 f6                	test   %esi,%esi
  8009e9:	75 19                	jne    800a04 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009eb:	53                   	push   %ebx
  8009ec:	68 05 24 80 00       	push   $0x802405
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 70 02 00 00       	call   800c6c <printfmt>
  8009fc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ff:	e9 5b 02 00 00       	jmp    800c5f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a04:	56                   	push   %esi
  800a05:	68 0e 24 80 00       	push   $0x80240e
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	ff 75 08             	pushl  0x8(%ebp)
  800a10:	e8 57 02 00 00       	call   800c6c <printfmt>
  800a15:	83 c4 10             	add    $0x10,%esp
			break;
  800a18:	e9 42 02 00 00       	jmp    800c5f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 c0 04             	add    $0x4,%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 e8 04             	sub    $0x4,%eax
  800a2c:	8b 30                	mov    (%eax),%esi
  800a2e:	85 f6                	test   %esi,%esi
  800a30:	75 05                	jne    800a37 <vprintfmt+0x1a6>
				p = "(null)";
  800a32:	be 11 24 80 00       	mov    $0x802411,%esi
			if (width > 0 && padc != '-')
  800a37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3b:	7e 6d                	jle    800aaa <vprintfmt+0x219>
  800a3d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a41:	74 67                	je     800aaa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	50                   	push   %eax
  800a4a:	56                   	push   %esi
  800a4b:	e8 1e 03 00 00       	call   800d6e <strnlen>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a56:	eb 16                	jmp    800a6e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a58:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	50                   	push   %eax
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a72:	7f e4                	jg     800a58 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a74:	eb 34                	jmp    800aaa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7a:	74 1c                	je     800a98 <vprintfmt+0x207>
  800a7c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a7f:	7e 05                	jle    800a86 <vprintfmt+0x1f5>
  800a81:	83 fb 7e             	cmp    $0x7e,%ebx
  800a84:	7e 12                	jle    800a98 <vprintfmt+0x207>
					putch('?', putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	6a 3f                	push   $0x3f
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	eb 0f                	jmp    800aa7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aaa:	89 f0                	mov    %esi,%eax
  800aac:	8d 70 01             	lea    0x1(%eax),%esi
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	0f be d8             	movsbl %al,%ebx
  800ab4:	85 db                	test   %ebx,%ebx
  800ab6:	74 24                	je     800adc <vprintfmt+0x24b>
  800ab8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abc:	78 b8                	js     800a76 <vprintfmt+0x1e5>
  800abe:	ff 4d e0             	decl   -0x20(%ebp)
  800ac1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac5:	79 af                	jns    800a76 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac7:	eb 13                	jmp    800adc <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	6a 20                	push   $0x20
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad9:	ff 4d e4             	decl   -0x1c(%ebp)
  800adc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae0:	7f e7                	jg     800ac9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae2:	e9 78 01 00 00       	jmp    800c5f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 3c fd ff ff       	call   800832 <getint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b05:	85 d2                	test   %edx,%edx
  800b07:	79 23                	jns    800b2c <vprintfmt+0x29b>
				putch('-', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 2d                	push   $0x2d
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1f:	f7 d8                	neg    %eax
  800b21:	83 d2 00             	adc    $0x0,%edx
  800b24:	f7 da                	neg    %edx
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b33:	e9 bc 00 00 00       	jmp    800bf4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b41:	50                   	push   %eax
  800b42:	e8 84 fc ff ff       	call   8007cb <getuint>
  800b47:	83 c4 10             	add    $0x10,%esp
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b50:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b57:	e9 98 00 00 00       	jmp    800bf4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 58                	push   $0x58
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 58                	push   $0x58
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	6a 58                	push   $0x58
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			break;
  800b8c:	e9 ce 00 00 00       	jmp    800c5f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 30                	push   $0x30
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	6a 78                	push   $0x78
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800bba:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbd:	83 e8 04             	sub    $0x4,%eax
  800bc0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bcc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd3:	eb 1f                	jmp    800bf4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 e7 fb ff ff       	call   8007cb <getuint>
  800be4:	83 c4 10             	add    $0x10,%esp
  800be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bed:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bfb:	83 ec 04             	sub    $0x4,%esp
  800bfe:	52                   	push   %edx
  800bff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c02:	50                   	push   %eax
  800c03:	ff 75 f4             	pushl  -0xc(%ebp)
  800c06:	ff 75 f0             	pushl  -0x10(%ebp)
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 00 fb ff ff       	call   800714 <printnum>
  800c14:	83 c4 20             	add    $0x20,%esp
			break;
  800c17:	eb 46                	jmp    800c5f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	53                   	push   %ebx
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	ff d0                	call   *%eax
  800c25:	83 c4 10             	add    $0x10,%esp
			break;
  800c28:	eb 35                	jmp    800c5f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c2a:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800c31:	eb 2c                	jmp    800c5f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c33:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800c3a:	eb 23                	jmp    800c5f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c3c:	83 ec 08             	sub    $0x8,%esp
  800c3f:	ff 75 0c             	pushl  0xc(%ebp)
  800c42:	6a 25                	push   $0x25
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	ff d0                	call   *%eax
  800c49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c4c:	ff 4d 10             	decl   0x10(%ebp)
  800c4f:	eb 03                	jmp    800c54 <vprintfmt+0x3c3>
  800c51:	ff 4d 10             	decl   0x10(%ebp)
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	48                   	dec    %eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	3c 25                	cmp    $0x25,%al
  800c5c:	75 f3                	jne    800c51 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c5e:	90                   	nop
		}
	}
  800c5f:	e9 35 fc ff ff       	jmp    800899 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c72:	8d 45 10             	lea    0x10(%ebp),%eax
  800c75:	83 c0 04             	add    $0x4,%eax
  800c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c81:	50                   	push   %eax
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	ff 75 08             	pushl  0x8(%ebp)
  800c88:	e8 04 fc ff ff       	call   800891 <vprintfmt>
  800c8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c90:	90                   	nop
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	8b 40 08             	mov    0x8(%eax),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca8:	8b 10                	mov    (%eax),%edx
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8b 40 04             	mov    0x4(%eax),%eax
  800cb0:	39 c2                	cmp    %eax,%edx
  800cb2:	73 12                	jae    800cc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbf:	89 0a                	mov    %ecx,(%edx)
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	88 10                	mov    %dl,(%eax)
}
  800cc6:	90                   	nop
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	01 d0                	add    %edx,%eax
  800ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cee:	74 06                	je     800cf6 <vsnprintf+0x2d>
  800cf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf4:	7f 07                	jg     800cfd <vsnprintf+0x34>
		return -E_INVAL;
  800cf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfb:	eb 20                	jmp    800d1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cfd:	ff 75 14             	pushl  0x14(%ebp)
  800d00:	ff 75 10             	pushl  0x10(%ebp)
  800d03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d06:	50                   	push   %eax
  800d07:	68 93 0c 80 00       	push   $0x800c93
  800d0c:	e8 80 fb ff ff       	call   800891 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d25:	8d 45 10             	lea    0x10(%ebp),%eax
  800d28:	83 c0 04             	add    $0x4,%eax
  800d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	ff 75 f4             	pushl  -0xc(%ebp)
  800d34:	50                   	push   %eax
  800d35:	ff 75 0c             	pushl  0xc(%ebp)
  800d38:	ff 75 08             	pushl  0x8(%ebp)
  800d3b:	e8 89 ff ff ff       	call   800cc9 <vsnprintf>
  800d40:	83 c4 10             	add    $0x10,%esp
  800d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d58:	eb 06                	jmp    800d60 <strlen+0x15>
		n++;
  800d5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d5d:	ff 45 08             	incl   0x8(%ebp)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	84 c0                	test   %al,%al
  800d67:	75 f1                	jne    800d5a <strlen+0xf>
		n++;
	return n;
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7b:	eb 09                	jmp    800d86 <strnlen+0x18>
		n++;
  800d7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	ff 4d 0c             	decl   0xc(%ebp)
  800d86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8a:	74 09                	je     800d95 <strnlen+0x27>
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	75 e8                	jne    800d7d <strnlen+0xf>
		n++;
	return n;
  800d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da6:	90                   	nop
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8d 50 01             	lea    0x1(%eax),%edx
  800dad:	89 55 08             	mov    %edx,0x8(%ebp)
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db9:	8a 12                	mov    (%edx),%dl
  800dbb:	88 10                	mov    %dl,(%eax)
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	84 c0                	test   %al,%al
  800dc1:	75 e4                	jne    800da7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddb:	eb 1f                	jmp    800dfc <strncpy+0x34>
		*dst++ = *src;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8d 50 01             	lea    0x1(%eax),%edx
  800de3:	89 55 08             	mov    %edx,0x8(%ebp)
  800de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	84 c0                	test   %al,%al
  800df4:	74 03                	je     800df9 <strncpy+0x31>
			src++;
  800df6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df9:	ff 45 fc             	incl   -0x4(%ebp)
  800dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e02:	72 d9                	jb     800ddd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 30                	je     800e4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e1b:	eb 16                	jmp    800e33 <strlcpy+0x2a>
			*dst++ = *src++;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 08             	mov    %edx,0x8(%ebp)
  800e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2f:	8a 12                	mov    (%edx),%dl
  800e31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e33:	ff 4d 10             	decl   0x10(%ebp)
  800e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3a:	74 09                	je     800e45 <strlcpy+0x3c>
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	84 c0                	test   %al,%al
  800e43:	75 d8                	jne    800e1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e51:	29 c2                	sub    %eax,%edx
  800e53:	89 d0                	mov    %edx,%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e5a:	eb 06                	jmp    800e62 <strcmp+0xb>
		p++, q++;
  800e5c:	ff 45 08             	incl   0x8(%ebp)
  800e5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	84 c0                	test   %al,%al
  800e69:	74 0e                	je     800e79 <strcmp+0x22>
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 10                	mov    (%eax),%dl
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	38 c2                	cmp    %al,%dl
  800e77:	74 e3                	je     800e5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	0f b6 d0             	movzbl %al,%edx
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 c0             	movzbl %al,%eax
  800e89:	29 c2                	sub    %eax,%edx
  800e8b:	89 d0                	mov    %edx,%eax
}
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    

00800e8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e92:	eb 09                	jmp    800e9d <strncmp+0xe>
		n--, p++, q++;
  800e94:	ff 4d 10             	decl   0x10(%ebp)
  800e97:	ff 45 08             	incl   0x8(%ebp)
  800e9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea1:	74 17                	je     800eba <strncmp+0x2b>
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	74 0e                	je     800eba <strncmp+0x2b>
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 10                	mov    (%eax),%dl
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	38 c2                	cmp    %al,%dl
  800eb8:	74 da                	je     800e94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	75 07                	jne    800ec7 <strncmp+0x38>
		return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec5:	eb 14                	jmp    800edb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	0f b6 d0             	movzbl %al,%edx
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 c0             	movzbl %al,%eax
  800ed7:	29 c2                	sub    %eax,%edx
  800ed9:	89 d0                	mov    %edx,%eax
}
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 04             	sub    $0x4,%esp
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee9:	eb 12                	jmp    800efd <strchr+0x20>
		if (*s == c)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef3:	75 05                	jne    800efa <strchr+0x1d>
			return (char *) s;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	eb 11                	jmp    800f0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 e5                	jne    800eeb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 04             	sub    $0x4,%esp
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f19:	eb 0d                	jmp    800f28 <strfind+0x1b>
		if (*s == c)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f23:	74 0e                	je     800f33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	84 c0                	test   %al,%al
  800f2f:	75 ea                	jne    800f1b <strfind+0xe>
  800f31:	eb 01                	jmp    800f34 <strfind+0x27>
		if (*s == c)
			break;
  800f33:	90                   	nop
	return (char *) s;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f45:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f49:	76 63                	jbe    800fae <memset+0x75>
		uint64 data_block = c;
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	99                   	cltd   
  800f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f52:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f5f:	c1 e0 08             	shl    $0x8,%eax
  800f62:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f65:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f72:	c1 e0 10             	shl    $0x10,%eax
  800f75:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f78:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
  800f88:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f8b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f8e:	eb 18                	jmp    800fa8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f90:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f93:	8d 41 08             	lea    0x8(%ecx),%eax
  800f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	89 01                	mov    %eax,(%ecx)
  800fa1:	89 51 04             	mov    %edx,0x4(%ecx)
  800fa4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fa8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fac:	77 e2                	ja     800f90 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb2:	74 23                	je     800fd7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fba:	eb 0e                	jmp    800fca <memset+0x91>
			*p8++ = (uint8)c;
  800fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbf:	8d 50 01             	lea    0x1(%eax),%edx
  800fc2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	75 e5                	jne    800fbc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fee:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff2:	76 24                	jbe    801018 <memcpy+0x3c>
		while(n >= 8){
  800ff4:	eb 1c                	jmp    801012 <memcpy+0x36>
			*d64 = *s64;
  800ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff9:	8b 50 04             	mov    0x4(%eax),%edx
  800ffc:	8b 00                	mov    (%eax),%eax
  800ffe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801001:	89 01                	mov    %eax,(%ecx)
  801003:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801006:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80100a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80100e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801012:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801016:	77 de                	ja     800ff6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101c:	74 31                	je     80104f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80101e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80102a:	eb 16                	jmp    801042 <memcpy+0x66>
			*d8++ = *s8++;
  80102c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801038:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80103e:	8a 12                	mov    (%edx),%dl
  801040:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801042:	8b 45 10             	mov    0x10(%ebp),%eax
  801045:	8d 50 ff             	lea    -0x1(%eax),%edx
  801048:	89 55 10             	mov    %edx,0x10(%ebp)
  80104b:	85 c0                	test   %eax,%eax
  80104d:	75 dd                	jne    80102c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801066:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801069:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80106c:	73 50                	jae    8010be <memmove+0x6a>
  80106e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801079:	76 43                	jbe    8010be <memmove+0x6a>
		s += n;
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801087:	eb 10                	jmp    801099 <memmove+0x45>
			*--d = *--s;
  801089:	ff 4d f8             	decl   -0x8(%ebp)
  80108c:	ff 4d fc             	decl   -0x4(%ebp)
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	8a 10                	mov    (%eax),%dl
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801097:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109f:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 e3                	jne    801089 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a6:	eb 23                	jmp    8010cb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ab:	8d 50 01             	lea    0x1(%eax),%edx
  8010ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ba:	8a 12                	mov    (%edx),%dl
  8010bc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 dd                	jne    8010a8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e2:	eb 2a                	jmp    80110e <memcmp+0x3e>
		if (*s1 != *s2)
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	8a 10                	mov    (%eax),%dl
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	38 c2                	cmp    %al,%dl
  8010f0:	74 16                	je     801108 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	0f b6 d0             	movzbl %al,%edx
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 c0             	movzbl %al,%eax
  801102:	29 c2                	sub    %eax,%edx
  801104:	89 d0                	mov    %edx,%eax
  801106:	eb 18                	jmp    801120 <memcmp+0x50>
		s1++, s2++;
  801108:	ff 45 fc             	incl   -0x4(%ebp)
  80110b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	8d 50 ff             	lea    -0x1(%eax),%edx
  801114:	89 55 10             	mov    %edx,0x10(%ebp)
  801117:	85 c0                	test   %eax,%eax
  801119:	75 c9                	jne    8010e4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801120:	c9                   	leave  
  801121:	c3                   	ret    

00801122 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801128:	8b 55 08             	mov    0x8(%ebp),%edx
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	01 d0                	add    %edx,%eax
  801130:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801133:	eb 15                	jmp    80114a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	0f b6 d0             	movzbl %al,%edx
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	39 c2                	cmp    %eax,%edx
  801145:	74 0d                	je     801154 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801147:	ff 45 08             	incl   0x8(%ebp)
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801150:	72 e3                	jb     801135 <memfind+0x13>
  801152:	eb 01                	jmp    801155 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801154:	90                   	nop
	return (void *) s;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116e:	eb 03                	jmp    801173 <strtol+0x19>
		s++;
  801170:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 20                	cmp    $0x20,%al
  80117a:	74 f4                	je     801170 <strtol+0x16>
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 09                	cmp    $0x9,%al
  801183:	74 eb                	je     801170 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 2b                	cmp    $0x2b,%al
  80118c:	75 05                	jne    801193 <strtol+0x39>
		s++;
  80118e:	ff 45 08             	incl   0x8(%ebp)
  801191:	eb 13                	jmp    8011a6 <strtol+0x4c>
	else if (*s == '-')
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	3c 2d                	cmp    $0x2d,%al
  80119a:	75 0a                	jne    8011a6 <strtol+0x4c>
		s++, neg = 1;
  80119c:	ff 45 08             	incl   0x8(%ebp)
  80119f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 06                	je     8011b2 <strtol+0x58>
  8011ac:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b0:	75 20                	jne    8011d2 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	3c 30                	cmp    $0x30,%al
  8011b9:	75 17                	jne    8011d2 <strtol+0x78>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	40                   	inc    %eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	3c 78                	cmp    $0x78,%al
  8011c3:	75 0d                	jne    8011d2 <strtol+0x78>
		s += 2, base = 16;
  8011c5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d0:	eb 28                	jmp    8011fa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d6:	75 15                	jne    8011ed <strtol+0x93>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 30                	cmp    $0x30,%al
  8011df:	75 0c                	jne    8011ed <strtol+0x93>
		s++, base = 8;
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011eb:	eb 0d                	jmp    8011fa <strtol+0xa0>
	else if (base == 0)
  8011ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f1:	75 07                	jne    8011fa <strtol+0xa0>
		base = 10;
  8011f3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 2f                	cmp    $0x2f,%al
  801201:	7e 19                	jle    80121c <strtol+0xc2>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 39                	cmp    $0x39,%al
  80120a:	7f 10                	jg     80121c <strtol+0xc2>
			dig = *s - '0';
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	0f be c0             	movsbl %al,%eax
  801214:	83 e8 30             	sub    $0x30,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121a:	eb 42                	jmp    80125e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 60                	cmp    $0x60,%al
  801223:	7e 19                	jle    80123e <strtol+0xe4>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 7a                	cmp    $0x7a,%al
  80122c:	7f 10                	jg     80123e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	0f be c0             	movsbl %al,%eax
  801236:	83 e8 57             	sub    $0x57,%eax
  801239:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123c:	eb 20                	jmp    80125e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 40                	cmp    $0x40,%al
  801245:	7e 39                	jle    801280 <strtol+0x126>
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 5a                	cmp    $0x5a,%al
  80124e:	7f 30                	jg     801280 <strtol+0x126>
			dig = *s - 'A' + 10;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	0f be c0             	movsbl %al,%eax
  801258:	83 e8 37             	sub    $0x37,%eax
  80125b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	3b 45 10             	cmp    0x10(%ebp),%eax
  801264:	7d 19                	jge    80127f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801266:	ff 45 08             	incl   0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127a:	e9 7b ff ff ff       	jmp    8011fa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80127f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801280:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801284:	74 08                	je     80128e <strtol+0x134>
		*endptr = (char *) s;
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80128e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801292:	74 07                	je     80129b <strtol+0x141>
  801294:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801297:	f7 d8                	neg    %eax
  801299:	eb 03                	jmp    80129e <strtol+0x144>
  80129b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b8:	79 13                	jns    8012cd <ltostr+0x2d>
	{
		neg = 1;
  8012ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012c7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ca:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d5:	99                   	cltd   
  8012d6:	f7 f9                	idiv   %ecx
  8012d8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012de:	8d 50 01             	lea    0x1(%eax),%edx
  8012e1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	01 d0                	add    %edx,%eax
  8012eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ee:	83 c2 30             	add    $0x30,%edx
  8012f1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012fb:	f7 e9                	imul   %ecx
  8012fd:	c1 fa 02             	sar    $0x2,%edx
  801300:	89 c8                	mov    %ecx,%eax
  801302:	c1 f8 1f             	sar    $0x1f,%eax
  801305:	29 c2                	sub    %eax,%edx
  801307:	89 d0                	mov    %edx,%eax
  801309:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80130c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801310:	75 bb                	jne    8012cd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131c:	48                   	dec    %eax
  80131d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801320:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801324:	74 3d                	je     801363 <ltostr+0xc3>
		start = 1 ;
  801326:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132d:	eb 34                	jmp    801363 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80132f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	01 c2                	add    %eax,%edx
  801344:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c8                	add    %ecx,%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801350:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	01 c2                	add    %eax,%edx
  801358:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135b:	88 02                	mov    %al,(%edx)
		start++ ;
  80135d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801360:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801366:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801369:	7c c4                	jl     80132f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80136e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801376:	90                   	nop
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 c4 f9 ff ff       	call   800d4b <strlen>
  801387:	83 c4 04             	add    $0x4,%esp
  80138a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138d:	ff 75 0c             	pushl  0xc(%ebp)
  801390:	e8 b6 f9 ff ff       	call   800d4b <strlen>
  801395:	83 c4 04             	add    $0x4,%esp
  801398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a9:	eb 17                	jmp    8013c2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b1:	01 c2                	add    %eax,%edx
  8013b3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	01 c8                	add    %ecx,%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013bf:	ff 45 fc             	incl   -0x4(%ebp)
  8013c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013c8:	7c e1                	jl     8013ab <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013d8:	eb 1f                	jmp    8013f9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013dd:	8d 50 01             	lea    0x1(%eax),%edx
  8013e0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	01 c2                	add    %eax,%edx
  8013ea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	01 c8                	add    %ecx,%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f6:	ff 45 f8             	incl   -0x8(%ebp)
  8013f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ff:	7c d9                	jl     8013da <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	01 d0                	add    %edx,%eax
  801409:	c6 00 00             	movb   $0x0,(%eax)
}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801412:	8b 45 14             	mov    0x14(%ebp),%eax
  801415:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141b:	8b 45 14             	mov    0x14(%ebp),%eax
  80141e:	8b 00                	mov    (%eax),%eax
  801420:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801432:	eb 0c                	jmp    801440 <strsplit+0x31>
			*string++ = 0;
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8d 50 01             	lea    0x1(%eax),%edx
  80143a:	89 55 08             	mov    %edx,0x8(%ebp)
  80143d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	74 18                	je     801461 <strsplit+0x52>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f be c0             	movsbl %al,%eax
  801451:	50                   	push   %eax
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	e8 83 fa ff ff       	call   800edd <strchr>
  80145a:	83 c4 08             	add    $0x8,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	75 d3                	jne    801434 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	84 c0                	test   %al,%al
  801468:	74 5a                	je     8014c4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146a:	8b 45 14             	mov    0x14(%ebp),%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 f8 0f             	cmp    $0xf,%eax
  801472:	75 07                	jne    80147b <strsplit+0x6c>
		{
			return 0;
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
  801479:	eb 66                	jmp    8014e1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147b:	8b 45 14             	mov    0x14(%ebp),%eax
  80147e:	8b 00                	mov    (%eax),%eax
  801480:	8d 48 01             	lea    0x1(%eax),%ecx
  801483:	8b 55 14             	mov    0x14(%ebp),%edx
  801486:	89 0a                	mov    %ecx,(%edx)
  801488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148f:	8b 45 10             	mov    0x10(%ebp),%eax
  801492:	01 c2                	add    %eax,%edx
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801499:	eb 03                	jmp    80149e <strsplit+0x8f>
			string++;
  80149b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	84 c0                	test   %al,%al
  8014a5:	74 8b                	je     801432 <strsplit+0x23>
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	0f be c0             	movsbl %al,%eax
  8014af:	50                   	push   %eax
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	e8 25 fa ff ff       	call   800edd <strchr>
  8014b8:	83 c4 08             	add    $0x8,%esp
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	74 dc                	je     80149b <strsplit+0x8c>
			string++;
	}
  8014bf:	e9 6e ff ff ff       	jmp    801432 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c8:	8b 00                	mov    (%eax),%eax
  8014ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f6:	eb 4a                	jmp    801542 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	01 c2                	add    %eax,%edx
  801500:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 c8                	add    %ecx,%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80150c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	01 d0                	add    %edx,%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	3c 40                	cmp    $0x40,%al
  801518:	7e 25                	jle    80153f <str2lower+0x5c>
  80151a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	3c 5a                	cmp    $0x5a,%al
  801526:	7f 17                	jg     80153f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801528:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	01 ca                	add    %ecx,%edx
  801538:	8a 12                	mov    (%edx),%dl
  80153a:	83 c2 20             	add    $0x20,%edx
  80153d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80153f:	ff 45 fc             	incl   -0x4(%ebp)
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	e8 01 f8 ff ff       	call   800d4b <strlen>
  80154a:	83 c4 04             	add    $0x4,%esp
  80154d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801550:	7f a6                	jg     8014f8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801552:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	57                   	push   %edi
  80155b:	56                   	push   %esi
  80155c:	53                   	push   %ebx
  80155d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801569:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80156c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80156f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801572:	cd 30                	int    $0x30
  801574:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801577:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5e                   	pop    %esi
  80157f:	5f                   	pop    %edi
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80158e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801591:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	6a 00                	push   $0x0
  80159a:	51                   	push   %ecx
  80159b:	52                   	push   %edx
  80159c:	ff 75 0c             	pushl  0xc(%ebp)
  80159f:	50                   	push   %eax
  8015a0:	6a 00                	push   $0x0
  8015a2:	e8 b0 ff ff ff       	call   801557 <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
}
  8015aa:	90                   	nop
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 02                	push   $0x2
  8015bc:	e8 96 ff ff ff       	call   801557 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 03                	push   $0x3
  8015d5:	e8 7d ff ff ff       	call   801557 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	90                   	nop
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 04                	push   $0x4
  8015ef:	e8 63 ff ff ff       	call   801557 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	90                   	nop
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	52                   	push   %edx
  80160a:	50                   	push   %eax
  80160b:	6a 08                	push   $0x8
  80160d:	e8 45 ff ff ff       	call   801557 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80161c:	8b 75 18             	mov    0x18(%ebp),%esi
  80161f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801622:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
  80162d:	51                   	push   %ecx
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 09                	push   $0x9
  801632:	e8 20 ff ff ff       	call   801557 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	ff 75 08             	pushl  0x8(%ebp)
  80164f:	6a 0a                	push   $0xa
  801651:	e8 01 ff ff ff       	call   801557 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	ff 75 0c             	pushl  0xc(%ebp)
  801667:	ff 75 08             	pushl  0x8(%ebp)
  80166a:	6a 0b                	push   $0xb
  80166c:	e8 e6 fe ff ff       	call   801557 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 0c                	push   $0xc
  801685:	e8 cd fe ff ff       	call   801557 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 0d                	push   $0xd
  80169e:	e8 b4 fe ff ff       	call   801557 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 0e                	push   $0xe
  8016b7:	e8 9b fe ff ff       	call   801557 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 0f                	push   $0xf
  8016d0:	e8 82 fe ff ff       	call   801557 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	6a 10                	push   $0x10
  8016ea:	e8 68 fe ff ff       	call   801557 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 11                	push   $0x11
  801703:	e8 4f fe ff ff       	call   801557 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	90                   	nop
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_cputc>:

void
sys_cputc(const char c)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80171a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	50                   	push   %eax
  801727:	6a 01                	push   $0x1
  801729:	e8 29 fe ff ff       	call   801557 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	90                   	nop
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 14                	push   $0x14
  801743:	e8 0f fe ff ff       	call   801557 <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	90                   	nop
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80175a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80175d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	51                   	push   %ecx
  801767:	52                   	push   %edx
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	50                   	push   %eax
  80176c:	6a 15                	push   $0x15
  80176e:	e8 e4 fd ff ff       	call   801557 <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80177b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	6a 16                	push   $0x16
  80178b:	e8 c7 fd ff ff       	call   801557 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801798:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	51                   	push   %ecx
  8017a6:	52                   	push   %edx
  8017a7:	50                   	push   %eax
  8017a8:	6a 17                	push   $0x17
  8017aa:	e8 a8 fd ff ff       	call   801557 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 18                	push   $0x18
  8017c7:	e8 8b fd ff ff       	call   801557 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	ff 75 14             	pushl  0x14(%ebp)
  8017dc:	ff 75 10             	pushl  0x10(%ebp)
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	6a 19                	push   $0x19
  8017e5:	e8 6d fd ff ff       	call   801557 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	50                   	push   %eax
  8017fe:	6a 1a                	push   $0x1a
  801800:	e8 52 fd ff ff       	call   801557 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	90                   	nop
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	50                   	push   %eax
  80181a:	6a 1b                	push   $0x1b
  80181c:	e8 36 fd ff ff       	call   801557 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 05                	push   $0x5
  801835:	e8 1d fd ff ff       	call   801557 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 06                	push   $0x6
  80184e:	e8 04 fd ff ff       	call   801557 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 07                	push   $0x7
  801867:	e8 eb fc ff ff       	call   801557 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_exit_env>:


void sys_exit_env(void)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 1c                	push   $0x1c
  801880:	e8 d2 fc ff ff       	call   801557 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801891:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801894:	8d 50 04             	lea    0x4(%eax),%edx
  801897:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 1d                	push   $0x1d
  8018a4:	e8 ae fc ff ff       	call   801557 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b5:	89 01                	mov    %eax,(%ecx)
  8018b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	c9                   	leave  
  8018be:	c2 04 00             	ret    $0x4

008018c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 10             	pushl  0x10(%ebp)
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	6a 13                	push   $0x13
  8018d3:	e8 7f fc ff ff       	call   801557 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018db:	90                   	nop
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_rcr2>:
uint32 sys_rcr2()
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 1e                	push   $0x1e
  8018ed:	e8 65 fc ff ff       	call   801557 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801903:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	50                   	push   %eax
  801910:	6a 1f                	push   $0x1f
  801912:	e8 40 fc ff ff       	call   801557 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
	return ;
  80191a:	90                   	nop
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <rsttst>:
void rsttst()
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 21                	push   $0x21
  80192c:	e8 26 fc ff ff       	call   801557 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
	return ;
  801934:	90                   	nop
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	8b 45 14             	mov    0x14(%ebp),%eax
  801940:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801943:	8b 55 18             	mov    0x18(%ebp),%edx
  801946:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	ff 75 10             	pushl  0x10(%ebp)
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	ff 75 08             	pushl  0x8(%ebp)
  801955:	6a 20                	push   $0x20
  801957:	e8 fb fb ff ff       	call   801557 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <chktst>:
void chktst(uint32 n)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	6a 22                	push   $0x22
  801972:	e8 e0 fb ff ff       	call   801557 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
	return ;
  80197a:	90                   	nop
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <inctst>:

void inctst()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 23                	push   $0x23
  80198c:	e8 c6 fb ff ff       	call   801557 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <gettst>:
uint32 gettst()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 24                	push   $0x24
  8019a6:	e8 ac fb ff ff       	call   801557 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 25                	push   $0x25
  8019bf:	e8 93 fb ff ff       	call   801557 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
  8019c7:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  8019cc:	a1 00 71 82 00       	mov    0x827100,%eax
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	6a 26                	push   $0x26
  8019eb:	e8 67 fb ff ff       	call   801557 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f3:	90                   	nop
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	53                   	push   %ebx
  801a09:	51                   	push   %ecx
  801a0a:	52                   	push   %edx
  801a0b:	50                   	push   %eax
  801a0c:	6a 27                	push   $0x27
  801a0e:	e8 44 fb ff ff       	call   801557 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 28                	push   $0x28
  801a2e:	e8 24 fb ff ff       	call   801557 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a3b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	51                   	push   %ecx
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	52                   	push   %edx
  801a4b:	50                   	push   %eax
  801a4c:	6a 29                	push   $0x29
  801a4e:	e8 04 fb ff ff       	call   801557 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	ff 75 10             	pushl  0x10(%ebp)
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	6a 12                	push   $0x12
  801a6a:	e8 e8 fa ff ff       	call   801557 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a72:	90                   	nop
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 2a                	push   $0x2a
  801a88:	e8 ca fa ff ff       	call   801557 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 2b                	push   $0x2b
  801aa2:	e8 b0 fa ff ff       	call   801557 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	6a 2d                	push   $0x2d
  801abd:	e8 95 fa ff ff       	call   801557 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
	return;
  801ac5:	90                   	nop
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	ff 75 08             	pushl  0x8(%ebp)
  801ad7:	6a 2c                	push   $0x2c
  801ad9:	e8 79 fa ff ff       	call   801557 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae1:	90                   	nop
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	50                   	push   %eax
  801af5:	6a 2e                	push   $0x2e
  801af7:	e8 5b fa ff ff       	call   801557 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
	return ;
  801aff:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    
  801b02:	66 90                	xchg   %ax,%ax

00801b04 <__udivdi3>:
  801b04:	55                   	push   %ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1b:	89 ca                	mov    %ecx,%edx
  801b1d:	89 f8                	mov    %edi,%eax
  801b1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b23:	85 f6                	test   %esi,%esi
  801b25:	75 2d                	jne    801b54 <__udivdi3+0x50>
  801b27:	39 cf                	cmp    %ecx,%edi
  801b29:	77 65                	ja     801b90 <__udivdi3+0x8c>
  801b2b:	89 fd                	mov    %edi,%ebp
  801b2d:	85 ff                	test   %edi,%edi
  801b2f:	75 0b                	jne    801b3c <__udivdi3+0x38>
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	31 d2                	xor    %edx,%edx
  801b38:	f7 f7                	div    %edi
  801b3a:	89 c5                	mov    %eax,%ebp
  801b3c:	31 d2                	xor    %edx,%edx
  801b3e:	89 c8                	mov    %ecx,%eax
  801b40:	f7 f5                	div    %ebp
  801b42:	89 c1                	mov    %eax,%ecx
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	f7 f5                	div    %ebp
  801b48:	89 cf                	mov    %ecx,%edi
  801b4a:	89 fa                	mov    %edi,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	39 ce                	cmp    %ecx,%esi
  801b56:	77 28                	ja     801b80 <__udivdi3+0x7c>
  801b58:	0f bd fe             	bsr    %esi,%edi
  801b5b:	83 f7 1f             	xor    $0x1f,%edi
  801b5e:	75 40                	jne    801ba0 <__udivdi3+0x9c>
  801b60:	39 ce                	cmp    %ecx,%esi
  801b62:	72 0a                	jb     801b6e <__udivdi3+0x6a>
  801b64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b68:	0f 87 9e 00 00 00    	ja     801c0c <__udivdi3+0x108>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	89 fa                	mov    %edi,%edx
  801b75:	83 c4 1c             	add    $0x1c,%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5f                   	pop    %edi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    
  801b7d:	8d 76 00             	lea    0x0(%esi),%esi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	31 c0                	xor    %eax,%eax
  801b84:	89 fa                	mov    %edi,%edx
  801b86:	83 c4 1c             	add    $0x1c,%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	f7 f7                	div    %edi
  801b94:	31 ff                	xor    %edi,%edi
  801b96:	89 fa                	mov    %edi,%edx
  801b98:	83 c4 1c             	add    $0x1c,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
  801ba0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ba5:	89 eb                	mov    %ebp,%ebx
  801ba7:	29 fb                	sub    %edi,%ebx
  801ba9:	89 f9                	mov    %edi,%ecx
  801bab:	d3 e6                	shl    %cl,%esi
  801bad:	89 c5                	mov    %eax,%ebp
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 ed                	shr    %cl,%ebp
  801bb3:	89 e9                	mov    %ebp,%ecx
  801bb5:	09 f1                	or     %esi,%ecx
  801bb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e0                	shl    %cl,%eax
  801bbf:	89 c5                	mov    %eax,%ebp
  801bc1:	89 d6                	mov    %edx,%esi
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 ee                	shr    %cl,%esi
  801bc7:	89 f9                	mov    %edi,%ecx
  801bc9:	d3 e2                	shl    %cl,%edx
  801bcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bcf:	88 d9                	mov    %bl,%cl
  801bd1:	d3 e8                	shr    %cl,%eax
  801bd3:	09 c2                	or     %eax,%edx
  801bd5:	89 d0                	mov    %edx,%eax
  801bd7:	89 f2                	mov    %esi,%edx
  801bd9:	f7 74 24 0c          	divl   0xc(%esp)
  801bdd:	89 d6                	mov    %edx,%esi
  801bdf:	89 c3                	mov    %eax,%ebx
  801be1:	f7 e5                	mul    %ebp
  801be3:	39 d6                	cmp    %edx,%esi
  801be5:	72 19                	jb     801c00 <__udivdi3+0xfc>
  801be7:	74 0b                	je     801bf4 <__udivdi3+0xf0>
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	31 ff                	xor    %edi,%edi
  801bed:	e9 58 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801bf2:	66 90                	xchg   %ax,%ax
  801bf4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bf8:	89 f9                	mov    %edi,%ecx
  801bfa:	d3 e2                	shl    %cl,%edx
  801bfc:	39 c2                	cmp    %eax,%edx
  801bfe:	73 e9                	jae    801be9 <__udivdi3+0xe5>
  801c00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c03:	31 ff                	xor    %edi,%edi
  801c05:	e9 40 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	31 c0                	xor    %eax,%eax
  801c0e:	e9 37 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801c13:	90                   	nop

00801c14 <__umoddi3>:
  801c14:	55                   	push   %ebp
  801c15:	57                   	push   %edi
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	83 ec 1c             	sub    $0x1c,%esp
  801c1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c33:	89 f3                	mov    %esi,%ebx
  801c35:	89 fa                	mov    %edi,%edx
  801c37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3b:	89 34 24             	mov    %esi,(%esp)
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	75 1a                	jne    801c5c <__umoddi3+0x48>
  801c42:	39 f7                	cmp    %esi,%edi
  801c44:	0f 86 a2 00 00 00    	jbe    801cec <__umoddi3+0xd8>
  801c4a:	89 c8                	mov    %ecx,%eax
  801c4c:	89 f2                	mov    %esi,%edx
  801c4e:	f7 f7                	div    %edi
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	31 d2                	xor    %edx,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	39 f0                	cmp    %esi,%eax
  801c5e:	0f 87 ac 00 00 00    	ja     801d10 <__umoddi3+0xfc>
  801c64:	0f bd e8             	bsr    %eax,%ebp
  801c67:	83 f5 1f             	xor    $0x1f,%ebp
  801c6a:	0f 84 ac 00 00 00    	je     801d1c <__umoddi3+0x108>
  801c70:	bf 20 00 00 00       	mov    $0x20,%edi
  801c75:	29 ef                	sub    %ebp,%edi
  801c77:	89 fe                	mov    %edi,%esi
  801c79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 e0                	shl    %cl,%eax
  801c81:	89 d7                	mov    %edx,%edi
  801c83:	89 f1                	mov    %esi,%ecx
  801c85:	d3 ef                	shr    %cl,%edi
  801c87:	09 c7                	or     %eax,%edi
  801c89:	89 e9                	mov    %ebp,%ecx
  801c8b:	d3 e2                	shl    %cl,%edx
  801c8d:	89 14 24             	mov    %edx,(%esp)
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	d3 e0                	shl    %cl,%eax
  801c94:	89 c2                	mov    %eax,%edx
  801c96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9a:	d3 e0                	shl    %cl,%eax
  801c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca4:	89 f1                	mov    %esi,%ecx
  801ca6:	d3 e8                	shr    %cl,%eax
  801ca8:	09 d0                	or     %edx,%eax
  801caa:	d3 eb                	shr    %cl,%ebx
  801cac:	89 da                	mov    %ebx,%edx
  801cae:	f7 f7                	div    %edi
  801cb0:	89 d3                	mov    %edx,%ebx
  801cb2:	f7 24 24             	mull   (%esp)
  801cb5:	89 c6                	mov    %eax,%esi
  801cb7:	89 d1                	mov    %edx,%ecx
  801cb9:	39 d3                	cmp    %edx,%ebx
  801cbb:	0f 82 87 00 00 00    	jb     801d48 <__umoddi3+0x134>
  801cc1:	0f 84 91 00 00 00    	je     801d58 <__umoddi3+0x144>
  801cc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ccb:	29 f2                	sub    %esi,%edx
  801ccd:	19 cb                	sbb    %ecx,%ebx
  801ccf:	89 d8                	mov    %ebx,%eax
  801cd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cd5:	d3 e0                	shl    %cl,%eax
  801cd7:	89 e9                	mov    %ebp,%ecx
  801cd9:	d3 ea                	shr    %cl,%edx
  801cdb:	09 d0                	or     %edx,%eax
  801cdd:	89 e9                	mov    %ebp,%ecx
  801cdf:	d3 eb                	shr    %cl,%ebx
  801ce1:	89 da                	mov    %ebx,%edx
  801ce3:	83 c4 1c             	add    $0x1c,%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    
  801ceb:	90                   	nop
  801cec:	89 fd                	mov    %edi,%ebp
  801cee:	85 ff                	test   %edi,%edi
  801cf0:	75 0b                	jne    801cfd <__umoddi3+0xe9>
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	31 d2                	xor    %edx,%edx
  801cf9:	f7 f7                	div    %edi
  801cfb:	89 c5                	mov    %eax,%ebp
  801cfd:	89 f0                	mov    %esi,%eax
  801cff:	31 d2                	xor    %edx,%edx
  801d01:	f7 f5                	div    %ebp
  801d03:	89 c8                	mov    %ecx,%eax
  801d05:	f7 f5                	div    %ebp
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	e9 44 ff ff ff       	jmp    801c52 <__umoddi3+0x3e>
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	89 c8                	mov    %ecx,%eax
  801d12:	89 f2                	mov    %esi,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	3b 04 24             	cmp    (%esp),%eax
  801d1f:	72 06                	jb     801d27 <__umoddi3+0x113>
  801d21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d25:	77 0f                	ja     801d36 <__umoddi3+0x122>
  801d27:	89 f2                	mov    %esi,%edx
  801d29:	29 f9                	sub    %edi,%ecx
  801d2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d2f:	89 14 24             	mov    %edx,(%esp)
  801d32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d3a:	8b 14 24             	mov    (%esp),%edx
  801d3d:	83 c4 1c             	add    $0x1c,%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
  801d45:	8d 76 00             	lea    0x0(%esi),%esi
  801d48:	2b 04 24             	sub    (%esp),%eax
  801d4b:	19 fa                	sbb    %edi,%edx
  801d4d:	89 d1                	mov    %edx,%ecx
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	e9 71 ff ff ff       	jmp    801cc7 <__umoddi3+0xb3>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d5c:	72 ea                	jb     801d48 <__umoddi3+0x134>
  801d5e:	89 d9                	mov    %ebx,%ecx
  801d60:	e9 62 ff ff ff       	jmp    801cc7 <__umoddi3+0xb3>
