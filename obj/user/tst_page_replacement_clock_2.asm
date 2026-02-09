
obj/user/tst_page_replacement_clock_2:     file format elf32-i386


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
  800031:	e8 2b 03 00 00       	call   800361 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000,
		0x803000, 0x809000, 0x80a000, 0x800000, 0x801000, 0x804000, 0x80b000,0x80c000,
		0x827000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 4c             	sub    $0x4c,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  800041:	6a 01                	push   $0x1
  800043:	68 00 00 80 00       	push   $0x800000
  800048:	6a 0b                	push   $0xb
  80004a:	68 20 30 80 00       	push   $0x803020
  80004f:	e8 71 1b 00 00       	call   801bc5 <sys_check_WS_list>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80005a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 00 1f 80 00       	push   $0x801f00
  800068:	6a 22                	push   $0x22
  80006a:	68 74 1f 80 00       	push   $0x801f74
  80006f:	e8 9d 04 00 00       	call   800511 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800074:	e8 8a 17 00 00       	call   801803 <sys_calculate_free_frames>
  800079:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007c:	e8 cd 17 00 00       	call   80184e <sys_pf_calculate_allocated_pages>
  800081:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	uint32 va;
	char invPageCmd[20] = "__InvPage__";
  800084:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800087:	bb 8b 22 80 00       	mov    $0x80228b,%ebx
  80008c:	ba 03 00 00 00       	mov    $0x3,%edx
  800091:	89 c7                	mov    %eax,%edi
  800093:	89 de                	mov    %ebx,%esi
  800095:	89 d1                	mov    %edx,%ecx
  800097:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800099:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8000a0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)

	//Remove some pages from the WS
	cprintf_colored(TEXT_cyan, "%~\nRemove some pages from the WS... \n");
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	68 98 1f 80 00       	push   $0x801f98
  8000af:	6a 03                	push   $0x3
  8000b1:	e8 76 07 00 00       	call   80082c <cprintf_colored>
  8000b6:	83 c4 10             	add    $0x10,%esp
	{
		va = 0x805000;
  8000b9:	c7 45 d0 00 50 80 00 	movl   $0x805000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8000c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	50                   	push   %eax
  8000c7:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000ca:	50                   	push   %eax
  8000cb:	e8 32 1b 00 00       	call   801c02 <sys_utilities>
  8000d0:	83 c4 10             	add    $0x10,%esp
		va = 0x807000;
  8000d3:	c7 45 d0 00 70 80 00 	movl   $0x807000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8000da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000dd:	83 ec 08             	sub    $0x8,%esp
  8000e0:	50                   	push   %eax
  8000e1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000e4:	50                   	push   %eax
  8000e5:	e8 18 1b 00 00       	call   801c02 <sys_utilities>
  8000ea:	83 c4 10             	add    $0x10,%esp
		va = 0x809000;
  8000ed:	c7 45 d0 00 90 80 00 	movl   $0x809000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	50                   	push   %eax
  8000fb:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000fe:	50                   	push   %eax
  8000ff:	e8 fe 1a 00 00       	call   801c02 <sys_utilities>
  800104:	83 c4 10             	add    $0x10,%esp
	}
	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800107:	c6 05 1f d1 80 00 61 	movb   $0x61,0x80d11f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  80010e:	a0 1f e1 80 00       	mov    0x80e11f,%al
  800113:	88 45 cf             	mov    %al,-0x31(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800116:	a0 1f f1 80 00       	mov    0x80f11f,%al
  80011b:	88 45 ce             	mov    %al,-0x32(%ebp)
	char garbage4,garbage5;

	//Checking the WS after the 3 faults
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE CLOCK algorithm after freeing some pages [PLACEMENT]... \n");
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	68 c0 1f 80 00       	push   $0x801fc0
  800126:	6a 03                	push   $0x3
  800128:	e8 ff 06 00 00       	call   80082c <cprintf_colored>
  80012d:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedVAs1, 11, 0x806000, 1);
  800130:	6a 01                	push   $0x1
  800132:	68 00 60 80 00       	push   $0x806000
  800137:	6a 0b                	push   $0xb
  800139:	68 60 30 80 00       	push   $0x803060
  80013e:	e8 82 1a 00 00       	call   801bc5 <sys_check_WS_list>
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (found != 1) panic("CLOCK alg. failed.. trace it by printing WS before and after page fault");
  800149:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80014d:	74 14                	je     800163 <_main+0x12b>
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	68 0c 20 80 00       	push   $0x80200c
  800157:	6a 44                	push   $0x44
  800159:	68 74 1f 80 00       	push   $0x801f74
  80015e:	e8 ae 03 00 00       	call   800511 <_panic>
	}

	//Remove some pages from the WS
	cprintf_colored(TEXT_cyan, "%~\nRemove some other pages from the WS including last WS element... \n");
  800163:	83 ec 08             	sub    $0x8,%esp
  800166:	68 54 20 80 00       	push   $0x802054
  80016b:	6a 03                	push   $0x3
  80016d:	e8 ba 06 00 00       	call   80082c <cprintf_colored>
  800172:	83 c4 10             	add    $0x10,%esp
	{
		va = 0x827000;
  800175:	c7 45 d0 00 70 82 00 	movl   $0x827000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  80017c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	50                   	push   %eax
  800183:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800186:	50                   	push   %eax
  800187:	e8 76 1a 00 00       	call   801c02 <sys_utilities>
  80018c:	83 c4 10             	add    $0x10,%esp
		va = 0x80F000;
  80018f:	c7 45 d0 00 f0 80 00 	movl   $0x80f000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  800196:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	50                   	push   %eax
  80019d:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	e8 5c 1a 00 00       	call   801c02 <sys_utilities>
  8001a6:	83 c4 10             	add    $0x10,%esp
		va = 0x806000;
  8001a9:	c7 45 d0 00 60 80 00 	movl   $0x806000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001ba:	50                   	push   %eax
  8001bb:	e8 42 1a 00 00       	call   801c02 <sys_utilities>
  8001c0:	83 c4 10             	add    $0x10,%esp
		va = 0x808000;
  8001c3:	c7 45 d0 00 80 80 00 	movl   $0x808000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	50                   	push   %eax
  8001d1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 28 1a 00 00       	call   801c02 <sys_utilities>
  8001da:	83 c4 10             	add    $0x10,%esp
		va = 0x800000;
  8001dd:	c7 45 d0 00 00 80 00 	movl   $0x800000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	50                   	push   %eax
  8001eb:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 0e 1a 00 00       	call   801c02 <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp
		va = 0x801000;
  8001f7:	c7 45 d0 00 10 80 00 	movl   $0x801000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	50                   	push   %eax
  800205:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	e8 f4 19 00 00       	call   801c02 <sys_utilities>
  80020e:	83 c4 10             	add    $0x10,%esp
	}
	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800211:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800218:	eb 26                	jmp    800240 <_main+0x208>
	{
		__arr__[i] = -1 ;
  80021a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021d:	05 20 31 80 00       	add    $0x803120,%eax
  800222:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  800225:	a1 00 30 80 00       	mov    0x803000,%eax
  80022a:	8a 00                	mov    (%eax),%al
  80022c:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *__ptr2__ ;
  80022f:	a1 04 30 80 00       	mov    0x803004,%eax
  800234:	8a 00                	mov    (%eax),%al
  800236:	88 45 e6             	mov    %al,-0x1a(%ebp)
		va = 0x801000;
		sys_utilities(invPageCmd, va);
	}
	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800239:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800240:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800247:	7e d1                	jle    80021a <_main+0x1e2>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	68 9a 20 80 00       	push   $0x80209a
  800251:	6a 03                	push   $0x3
  800253:	e8 d4 05 00 00       	call   80082c <cprintf_colored>
  800258:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  80025b:	a1 00 30 80 00       	mov    0x803000,%eax
  800260:	8a 00                	mov    (%eax),%al
  800262:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 b3 20 80 00       	push   $0x8020b3
  80026f:	6a 68                	push   $0x68
  800271:	68 74 1f 80 00       	push   $0x801f74
  800276:	e8 96 02 00 00       	call   800511 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  80027b:	a1 04 30 80 00       	mov    0x803004,%eax
  800280:	8a 00                	mov    (%eax),%al
  800282:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 b3 20 80 00       	push   $0x8020b3
  80028f:	6a 69                	push   $0x69
  800291:	68 74 1f 80 00       	push   $0x801f74
  800296:	e8 76 02 00 00       	call   800511 <_panic>
	}

	//Checking the WS after the 10 faults
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE CLOCK algorithm after freeing other set of pages [REPLACEMENT]... \n");
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	68 c0 20 80 00       	push   $0x8020c0
  8002a3:	6a 03                	push   $0x3
  8002a5:	e8 82 05 00 00       	call   80082c <cprintf_colored>
  8002aa:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedVAs2, 11, 0xeebfd000, 1);
  8002ad:	6a 01                	push   $0x1
  8002af:	68 00 d0 bf ee       	push   $0xeebfd000
  8002b4:	6a 0b                	push   $0xb
  8002b6:	68 a0 30 80 00       	push   $0x8030a0
  8002bb:	e8 05 19 00 00       	call   801bc5 <sys_check_WS_list>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (found != 1) panic("CLOCK alg. failed.. trace it by printing WS before and after page fault");
  8002c6:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8002ca:	74 14                	je     8002e0 <_main+0x2a8>
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	68 0c 20 80 00       	push   $0x80200c
  8002d4:	6a 70                	push   $0x70
  8002d6:	68 74 1f 80 00       	push   $0x801f74
  8002db:	e8 31 02 00 00       	call   800511 <_panic>
	}

	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	68 18 21 80 00       	push   $0x802118
  8002e8:	6a 03                	push   $0x3
  8002ea:	e8 3d 05 00 00       	call   80082c <cprintf_colored>
  8002ef:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8002f2:	e8 57 15 00 00       	call   80184e <sys_pf_calculate_allocated_pages>
  8002f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8002fa:	74 14                	je     800310 <_main+0x2d8>
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	68 48 21 80 00       	push   $0x802148
  800304:	6a 75                	push   $0x75
  800306:	68 74 1f 80 00       	push   $0x801f74
  80030b:	e8 01 02 00 00       	call   800511 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800310:	e8 ee 14 00 00       	call   801803 <sys_calculate_free_frames>
  800315:	89 c3                	mov    %eax,%ebx
  800317:	e8 00 15 00 00       	call   80181c <sys_calculate_modified_frames>
  80031c:	01 d8                	add    %ebx,%eax
  80031e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800327:	74 1d                	je     800346 <_main+0x30e>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  800329:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80032c:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 00                	push   $0x0
  800335:	68 b4 21 80 00       	push   $0x8021b4
  80033a:	6a 79                	push   $0x79
  80033c:	68 74 1f 80 00       	push   $0x801f74
  800341:	e8 cb 01 00 00       	call   800511 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [CLOCK Alg. #2] is completed successfully.\n");
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	68 34 22 80 00       	push   $0x802234
  80034e:	6a 0a                	push   $0xa
  800350:	e8 d7 04 00 00       	call   80082c <cprintf_colored>
  800355:	83 c4 10             	add    $0x10,%esp
	return;
  800358:	90                   	nop
}
  800359:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035c:	5b                   	pop    %ebx
  80035d:	5e                   	pop    %esi
  80035e:	5f                   	pop    %edi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
  800367:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80036a:	e8 5d 16 00 00       	call   8019cc <sys_getenvindex>
  80036f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 02             	shl    $0x2,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 02             	shl    $0x2,%eax
  800383:	01 d0                	add    %edx,%eax
  800385:	c1 e0 03             	shl    $0x3,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	c1 e0 02             	shl    $0x2,%eax
  80038d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800392:	a3 e0 30 80 00       	mov    %eax,0x8030e0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800397:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80039c:	8a 40 20             	mov    0x20(%eax),%al
  80039f:	84 c0                	test   %al,%al
  8003a1:	74 0d                	je     8003b0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8003a3:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003a8:	83 c0 20             	add    $0x20,%eax
  8003ab:	a3 d0 30 80 00       	mov    %eax,0x8030d0

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b4:	7e 0a                	jle    8003c0 <libmain+0x5f>
		binaryname = argv[0];
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	a3 d0 30 80 00       	mov    %eax,0x8030d0

	// call user main routine
	_main(argc, argv);
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	e8 6a fc ff ff       	call   800038 <_main>
  8003ce:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8003d1:	a1 cc 30 80 00       	mov    0x8030cc,%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	0f 84 01 01 00 00    	je     8004df <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8003de:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003e4:	bb 98 23 80 00       	mov    $0x802398,%ebx
  8003e9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003ee:	89 c7                	mov    %eax,%edi
  8003f0:	89 de                	mov    %ebx,%esi
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003f6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003f9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003fe:	b0 00                	mov    $0x0,%al
  800400:	89 d7                	mov    %edx,%edi
  800402:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800404:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80040b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	50                   	push   %eax
  800412:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	e8 e4 17 00 00       	call   801c02 <sys_utilities>
  80041e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800421:	e8 2d 13 00 00       	call   801753 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800426:	83 ec 0c             	sub    $0xc,%esp
  800429:	68 b8 22 80 00       	push   $0x8022b8
  80042e:	e8 cc 03 00 00       	call   8007ff <cprintf>
  800433:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	85 c0                	test   %eax,%eax
  80043b:	74 18                	je     800455 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80043d:	e8 de 17 00 00       	call   801c20 <sys_get_optimal_num_faults>
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	50                   	push   %eax
  800446:	68 e0 22 80 00       	push   $0x8022e0
  80044b:	e8 af 03 00 00       	call   8007ff <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	eb 59                	jmp    8004ae <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800455:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80045a:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800460:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800465:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80046b:	83 ec 04             	sub    $0x4,%esp
  80046e:	52                   	push   %edx
  80046f:	50                   	push   %eax
  800470:	68 04 23 80 00       	push   $0x802304
  800475:	e8 85 03 00 00       	call   8007ff <cprintf>
  80047a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80047d:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800482:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800488:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80048d:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800493:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800498:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80049e:	51                   	push   %ecx
  80049f:	52                   	push   %edx
  8004a0:	50                   	push   %eax
  8004a1:	68 2c 23 80 00       	push   $0x80232c
  8004a6:	e8 54 03 00 00       	call   8007ff <cprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ae:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8004b3:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	50                   	push   %eax
  8004bd:	68 84 23 80 00       	push   $0x802384
  8004c2:	e8 38 03 00 00       	call   8007ff <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	68 b8 22 80 00       	push   $0x8022b8
  8004d2:	e8 28 03 00 00       	call   8007ff <cprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004da:	e8 8e 12 00 00       	call   80176d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004df:	e8 1f 00 00 00       	call   800503 <exit>
}
  8004e4:	90                   	nop
  8004e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e8:	5b                   	pop    %ebx
  8004e9:	5e                   	pop    %esi
  8004ea:	5f                   	pop    %edi
  8004eb:	5d                   	pop    %ebp
  8004ec:	c3                   	ret    

008004ed <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	6a 00                	push   $0x0
  8004f8:	e8 9b 14 00 00       	call   801998 <sys_destroy_env>
  8004fd:	83 c4 10             	add    $0x10,%esp
}
  800500:	90                   	nop
  800501:	c9                   	leave  
  800502:	c3                   	ret    

00800503 <exit>:

void
exit(void)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
  800506:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800509:	e8 f0 14 00 00       	call   8019fe <sys_exit_env>
}
  80050e:	90                   	nop
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800517:	8d 45 10             	lea    0x10(%ebp),%eax
  80051a:	83 c0 04             	add    $0x4,%eax
  80051d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800520:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  800525:	85 c0                	test   %eax,%eax
  800527:	74 16                	je     80053f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800529:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	50                   	push   %eax
  800532:	68 fc 23 80 00       	push   $0x8023fc
  800537:	e8 c3 02 00 00       	call   8007ff <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80053f:	a1 d0 30 80 00       	mov    0x8030d0,%eax
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	ff 75 0c             	pushl  0xc(%ebp)
  80054a:	ff 75 08             	pushl  0x8(%ebp)
  80054d:	50                   	push   %eax
  80054e:	68 04 24 80 00       	push   $0x802404
  800553:	6a 74                	push   $0x74
  800555:	e8 d2 02 00 00       	call   80082c <cprintf_colored>
  80055a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80055d:	8b 45 10             	mov    0x10(%ebp),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 f4             	pushl  -0xc(%ebp)
  800566:	50                   	push   %eax
  800567:	e8 24 02 00 00       	call   800790 <vcprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	6a 00                	push   $0x0
  800574:	68 2c 24 80 00       	push   $0x80242c
  800579:	e8 12 02 00 00       	call   800790 <vcprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800581:	e8 7d ff ff ff       	call   800503 <exit>

	// should not return here
	while (1) ;
  800586:	eb fe                	jmp    800586 <_panic+0x75>

00800588 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80058f:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800594:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80059a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059d:	39 c2                	cmp    %eax,%edx
  80059f:	74 14                	je     8005b5 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 30 24 80 00       	push   $0x802430
  8005a9:	6a 26                	push   $0x26
  8005ab:	68 7c 24 80 00       	push   $0x80247c
  8005b0:	e8 5c ff ff ff       	call   800511 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c3:	e9 d9 00 00 00       	jmp    8006a1 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8005c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	01 d0                	add    %edx,%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	85 c0                	test   %eax,%eax
  8005db:	75 08                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8005dd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005e0:	e9 b9 00 00 00       	jmp    80069e <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8005e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005f3:	eb 79                	jmp    80066e <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005f5:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8005fa:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800600:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800603:	89 d0                	mov    %edx,%eax
  800605:	01 c0                	add    %eax,%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800610:	01 d8                	add    %ebx,%eax
  800612:	01 d0                	add    %edx,%eax
  800614:	01 c8                	add    %ecx,%eax
  800616:	8a 40 04             	mov    0x4(%eax),%al
  800619:	84 c0                	test   %al,%al
  80061b:	75 4e                	jne    80066b <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80061d:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800622:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800628:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80062b:	89 d0                	mov    %edx,%eax
  80062d:	01 c0                	add    %eax,%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800638:	01 d8                	add    %ebx,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800646:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80064b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	01 c8                	add    %ecx,%eax
  80065c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80065e:	39 c2                	cmp    %eax,%edx
  800660:	75 09                	jne    80066b <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800662:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800669:	eb 19                	jmp    800684 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066b:	ff 45 e8             	incl   -0x18(%ebp)
  80066e:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800673:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80067c:	39 c2                	cmp    %eax,%edx
  80067e:	0f 87 71 ff ff ff    	ja     8005f5 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800684:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800688:	75 14                	jne    80069e <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	68 88 24 80 00       	push   $0x802488
  800692:	6a 3a                	push   $0x3a
  800694:	68 7c 24 80 00       	push   $0x80247c
  800699:	e8 73 fe ff ff       	call   800511 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80069e:	ff 45 f0             	incl   -0x10(%ebp)
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a7:	0f 8c 1b ff ff ff    	jl     8005c8 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006bb:	eb 2e                	jmp    8006eb <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006bd:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8006c2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8006c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cb:	89 d0                	mov    %edx,%eax
  8006cd:	01 c0                	add    %eax,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8006d8:	01 d8                	add    %ebx,%eax
  8006da:	01 d0                	add    %edx,%eax
  8006dc:	01 c8                	add    %ecx,%eax
  8006de:	8a 40 04             	mov    0x4(%eax),%al
  8006e1:	3c 01                	cmp    $0x1,%al
  8006e3:	75 03                	jne    8006e8 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8006e5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e8:	ff 45 e0             	incl   -0x20(%ebp)
  8006eb:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8006f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f9:	39 c2                	cmp    %eax,%edx
  8006fb:	77 c0                	ja     8006bd <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800700:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800703:	74 14                	je     800719 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 dc 24 80 00       	push   $0x8024dc
  80070d:	6a 44                	push   $0x44
  80070f:	68 7c 24 80 00       	push   $0x80247c
  800714:	e8 f8 fd ff ff       	call   800511 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800719:	90                   	nop
  80071a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	53                   	push   %ebx
  800723:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800726:	8b 45 0c             	mov    0xc(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 48 01             	lea    0x1(%eax),%ecx
  80072e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800731:	89 0a                	mov    %ecx,(%edx)
  800733:	8b 55 08             	mov    0x8(%ebp),%edx
  800736:	88 d1                	mov    %dl,%cl
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80073f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	3d ff 00 00 00       	cmp    $0xff,%eax
  800749:	75 30                	jne    80077b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80074b:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  800751:	a0 04 31 80 00       	mov    0x803104,%al
  800756:	0f b6 c0             	movzbl %al,%eax
  800759:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80075c:	8b 09                	mov    (%ecx),%ecx
  80075e:	89 cb                	mov    %ecx,%ebx
  800760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800763:	83 c1 08             	add    $0x8,%ecx
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	53                   	push   %ebx
  800769:	51                   	push   %ecx
  80076a:	e8 a0 0f 00 00       	call   80170f <sys_cputs>
  80076f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800772:	8b 45 0c             	mov    0xc(%ebp),%eax
  800775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80077b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077e:	8b 40 04             	mov    0x4(%eax),%eax
  800781:	8d 50 01             	lea    0x1(%eax),%edx
  800784:	8b 45 0c             	mov    0xc(%ebp),%eax
  800787:	89 50 04             	mov    %edx,0x4(%eax)
}
  80078a:	90                   	nop
  80078b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800799:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a0:	00 00 00 
	b.cnt = 0;
  8007a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007aa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b9:	50                   	push   %eax
  8007ba:	68 1f 07 80 00       	push   $0x80071f
  8007bf:	e8 5a 02 00 00       	call   800a1e <vprintfmt>
  8007c4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8007c7:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  8007cd:	a0 04 31 80 00       	mov    0x803104,%al
  8007d2:	0f b6 c0             	movzbl %al,%eax
  8007d5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8007db:	52                   	push   %edx
  8007dc:	50                   	push   %eax
  8007dd:	51                   	push   %ecx
  8007de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e4:	83 c0 08             	add    $0x8,%eax
  8007e7:	50                   	push   %eax
  8007e8:	e8 22 0f 00 00       	call   80170f <sys_cputs>
  8007ed:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007f0:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
	return b.cnt;
  8007f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    

008007ff <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800805:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	va_start(ap, fmt);
  80080c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 f4             	pushl  -0xc(%ebp)
  80081b:	50                   	push   %eax
  80081c:	e8 6f ff ff ff       	call   800790 <vcprintf>
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800827:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800832:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	curTextClr = (textClr << 8) ; //set text color by the given value
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	c1 e0 08             	shl    $0x8,%eax
  80083f:	a3 fc 71 82 00       	mov    %eax,0x8271fc
	va_start(ap, fmt);
  800844:	8d 45 0c             	lea    0xc(%ebp),%eax
  800847:	83 c0 04             	add    $0x4,%eax
  80084a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80084d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 f4             	pushl  -0xc(%ebp)
  800856:	50                   	push   %eax
  800857:	e8 34 ff ff ff       	call   800790 <vcprintf>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800862:	c7 05 fc 71 82 00 00 	movl   $0x700,0x8271fc
  800869:	07 00 00 

	return cnt;
  80086c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80086f:	c9                   	leave  
  800870:	c3                   	ret    

00800871 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800877:	e8 d7 0e 00 00       	call   801753 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80087c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80087f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 f4             	pushl  -0xc(%ebp)
  80088b:	50                   	push   %eax
  80088c:	e8 ff fe ff ff       	call   800790 <vcprintf>
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800897:	e8 d1 0e 00 00       	call   80176d <sys_unlock_cons>
	return cnt;
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    

008008a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	83 ec 14             	sub    $0x14,%esp
  8008a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008bf:	77 55                	ja     800916 <printnum+0x75>
  8008c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008c4:	72 05                	jb     8008cb <printnum+0x2a>
  8008c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008c9:	77 4b                	ja     800916 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d9:	52                   	push   %edx
  8008da:	50                   	push   %eax
  8008db:	ff 75 f4             	pushl  -0xc(%ebp)
  8008de:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e1:	e8 aa 13 00 00       	call   801c90 <__udivdi3>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 ec 04             	sub    $0x4,%esp
  8008ec:	ff 75 20             	pushl  0x20(%ebp)
  8008ef:	53                   	push   %ebx
  8008f0:	ff 75 18             	pushl  0x18(%ebp)
  8008f3:	52                   	push   %edx
  8008f4:	50                   	push   %eax
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	ff 75 08             	pushl  0x8(%ebp)
  8008fb:	e8 a1 ff ff ff       	call   8008a1 <printnum>
  800900:	83 c4 20             	add    $0x20,%esp
  800903:	eb 1a                	jmp    80091f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800916:	ff 4d 1c             	decl   0x1c(%ebp)
  800919:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80091d:	7f e6                	jg     800905 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80091f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800922:	bb 00 00 00 00       	mov    $0x0,%ebx
  800927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80092d:	53                   	push   %ebx
  80092e:	51                   	push   %ecx
  80092f:	52                   	push   %edx
  800930:	50                   	push   %eax
  800931:	e8 6a 14 00 00       	call   801da0 <__umoddi3>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	05 54 27 80 00       	add    $0x802754,%eax
  80093e:	8a 00                	mov    (%eax),%al
  800940:	0f be c0             	movsbl %al,%eax
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	50                   	push   %eax
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	ff d0                	call   *%eax
  80094f:	83 c4 10             	add    $0x10,%esp
}
  800952:	90                   	nop
  800953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80095b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80095f:	7e 1c                	jle    80097d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	8d 50 08             	lea    0x8(%eax),%edx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 10                	mov    %edx,(%eax)
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	83 e8 08             	sub    $0x8,%eax
  800976:	8b 50 04             	mov    0x4(%eax),%edx
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	eb 40                	jmp    8009bd <getuint+0x65>
	else if (lflag)
  80097d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800981:	74 1e                	je     8009a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	8d 50 04             	lea    0x4(%eax),%edx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 10                	mov    %edx,(%eax)
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	83 e8 04             	sub    $0x4,%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	ba 00 00 00 00       	mov    $0x0,%edx
  80099f:	eb 1c                	jmp    8009bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	8d 50 04             	lea    0x4(%eax),%edx
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	89 10                	mov    %edx,(%eax)
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	83 e8 04             	sub    $0x4,%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009c6:	7e 1c                	jle    8009e4 <getint+0x25>
		return va_arg(*ap, long long);
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 00                	mov    (%eax),%eax
  8009cd:	8d 50 08             	lea    0x8(%eax),%edx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	89 10                	mov    %edx,(%eax)
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 00                	mov    (%eax),%eax
  8009da:	83 e8 08             	sub    $0x8,%eax
  8009dd:	8b 50 04             	mov    0x4(%eax),%edx
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	eb 38                	jmp    800a1c <getint+0x5d>
	else if (lflag)
  8009e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e8:	74 1a                	je     800a04 <getint+0x45>
		return va_arg(*ap, long);
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	8d 50 04             	lea    0x4(%eax),%edx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	89 10                	mov    %edx,(%eax)
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8b 00                	mov    (%eax),%eax
  8009fc:	83 e8 04             	sub    $0x4,%eax
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	99                   	cltd   
  800a02:	eb 18                	jmp    800a1c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	8d 50 04             	lea    0x4(%eax),%edx
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	89 10                	mov    %edx,(%eax)
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 00                	mov    (%eax),%eax
  800a16:	83 e8 04             	sub    $0x4,%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	99                   	cltd   
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a26:	eb 17                	jmp    800a3f <vprintfmt+0x21>
			if (ch == '\0')
  800a28:	85 db                	test   %ebx,%ebx
  800a2a:	0f 84 c1 03 00 00    	je     800df1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	53                   	push   %ebx
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a42:	8d 50 01             	lea    0x1(%eax),%edx
  800a45:	89 55 10             	mov    %edx,0x10(%ebp)
  800a48:	8a 00                	mov    (%eax),%al
  800a4a:	0f b6 d8             	movzbl %al,%ebx
  800a4d:	83 fb 25             	cmp    $0x25,%ebx
  800a50:	75 d6                	jne    800a28 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a52:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a56:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a5d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a6b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	8d 50 01             	lea    0x1(%eax),%edx
  800a78:	89 55 10             	mov    %edx,0x10(%ebp)
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f b6 d8             	movzbl %al,%ebx
  800a80:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a83:	83 f8 5b             	cmp    $0x5b,%eax
  800a86:	0f 87 3d 03 00 00    	ja     800dc9 <vprintfmt+0x3ab>
  800a8c:	8b 04 85 78 27 80 00 	mov    0x802778(,%eax,4),%eax
  800a93:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a95:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a99:	eb d7                	jmp    800a72 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a9b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a9f:	eb d1                	jmp    800a72 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800aa8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	c1 e0 02             	shl    $0x2,%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	01 c0                	add    %eax,%eax
  800ab4:	01 d8                	add    %ebx,%eax
  800ab6:	83 e8 30             	sub    $0x30,%eax
  800ab9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800abc:	8b 45 10             	mov    0x10(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ac7:	7e 3e                	jle    800b07 <vprintfmt+0xe9>
  800ac9:	83 fb 39             	cmp    $0x39,%ebx
  800acc:	7f 39                	jg     800b07 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ace:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad1:	eb d5                	jmp    800aa8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 14             	mov    %eax,0x14(%ebp)
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	83 e8 04             	sub    $0x4,%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ae7:	eb 1f                	jmp    800b08 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ae9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aed:	79 83                	jns    800a72 <vprintfmt+0x54>
				width = 0;
  800aef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800af6:	e9 77 ff ff ff       	jmp    800a72 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800afb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b02:	e9 6b ff ff ff       	jmp    800a72 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b07:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	0f 89 60 ff ff ff    	jns    800a72 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b18:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b1f:	e9 4e ff ff ff       	jmp    800a72 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b24:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b27:	e9 46 ff ff ff       	jmp    800a72 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	50                   	push   %eax
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			break;
  800b4c:	e9 9b 02 00 00       	jmp    800dec <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	83 c0 04             	add    $0x4,%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5d:	83 e8 04             	sub    $0x4,%eax
  800b60:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b62:	85 db                	test   %ebx,%ebx
  800b64:	79 02                	jns    800b68 <vprintfmt+0x14a>
				err = -err;
  800b66:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b68:	83 fb 64             	cmp    $0x64,%ebx
  800b6b:	7f 0b                	jg     800b78 <vprintfmt+0x15a>
  800b6d:	8b 34 9d c0 25 80 00 	mov    0x8025c0(,%ebx,4),%esi
  800b74:	85 f6                	test   %esi,%esi
  800b76:	75 19                	jne    800b91 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b78:	53                   	push   %ebx
  800b79:	68 65 27 80 00       	push   $0x802765
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	ff 75 08             	pushl  0x8(%ebp)
  800b84:	e8 70 02 00 00       	call   800df9 <printfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b8c:	e9 5b 02 00 00       	jmp    800dec <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b91:	56                   	push   %esi
  800b92:	68 6e 27 80 00       	push   $0x80276e
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 57 02 00 00       	call   800df9 <printfmt>
  800ba2:	83 c4 10             	add    $0x10,%esp
			break;
  800ba5:	e9 42 02 00 00       	jmp    800dec <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 30                	mov    (%eax),%esi
  800bbb:	85 f6                	test   %esi,%esi
  800bbd:	75 05                	jne    800bc4 <vprintfmt+0x1a6>
				p = "(null)";
  800bbf:	be 71 27 80 00       	mov    $0x802771,%esi
			if (width > 0 && padc != '-')
  800bc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc8:	7e 6d                	jle    800c37 <vprintfmt+0x219>
  800bca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bce:	74 67                	je     800c37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	50                   	push   %eax
  800bd7:	56                   	push   %esi
  800bd8:	e8 1e 03 00 00       	call   800efb <strnlen>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800be3:	eb 16                	jmp    800bfb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800be5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	50                   	push   %eax
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	ff d0                	call   *%eax
  800bf5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bff:	7f e4                	jg     800be5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c01:	eb 34                	jmp    800c37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c07:	74 1c                	je     800c25 <vprintfmt+0x207>
  800c09:	83 fb 1f             	cmp    $0x1f,%ebx
  800c0c:	7e 05                	jle    800c13 <vprintfmt+0x1f5>
  800c0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800c11:	7e 12                	jle    800c25 <vprintfmt+0x207>
					putch('?', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 3f                	push   $0x3f
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
  800c23:	eb 0f                	jmp    800c34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	53                   	push   %ebx
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c34:	ff 4d e4             	decl   -0x1c(%ebp)
  800c37:	89 f0                	mov    %esi,%eax
  800c39:	8d 70 01             	lea    0x1(%eax),%esi
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	0f be d8             	movsbl %al,%ebx
  800c41:	85 db                	test   %ebx,%ebx
  800c43:	74 24                	je     800c69 <vprintfmt+0x24b>
  800c45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c49:	78 b8                	js     800c03 <vprintfmt+0x1e5>
  800c4b:	ff 4d e0             	decl   -0x20(%ebp)
  800c4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c52:	79 af                	jns    800c03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c54:	eb 13                	jmp    800c69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	6a 20                	push   $0x20
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c66:	ff 4d e4             	decl   -0x1c(%ebp)
  800c69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c6d:	7f e7                	jg     800c56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c6f:	e9 78 01 00 00       	jmp    800dec <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7d:	50                   	push   %eax
  800c7e:	e8 3c fd ff ff       	call   8009bf <getint>
  800c83:	83 c4 10             	add    $0x10,%esp
  800c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c92:	85 d2                	test   %edx,%edx
  800c94:	79 23                	jns    800cb9 <vprintfmt+0x29b>
				putch('-', putdat);
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	ff 75 0c             	pushl  0xc(%ebp)
  800c9c:	6a 2d                	push   $0x2d
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	ff d0                	call   *%eax
  800ca3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cac:	f7 d8                	neg    %eax
  800cae:	83 d2 00             	adc    $0x0,%edx
  800cb1:	f7 da                	neg    %edx
  800cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cb9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc0:	e9 bc 00 00 00       	jmp    800d81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cc5:	83 ec 08             	sub    $0x8,%esp
  800cc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ccb:	8d 45 14             	lea    0x14(%ebp),%eax
  800cce:	50                   	push   %eax
  800ccf:	e8 84 fc ff ff       	call   800958 <getuint>
  800cd4:	83 c4 10             	add    $0x10,%esp
  800cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cdd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ce4:	e9 98 00 00 00       	jmp    800d81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	6a 58                	push   $0x58
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 58                	push   $0x58
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	6a 58                	push   $0x58
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	ff d0                	call   *%eax
  800d16:	83 c4 10             	add    $0x10,%esp
			break;
  800d19:	e9 ce 00 00 00       	jmp    800dec <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	6a 30                	push   $0x30
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	ff d0                	call   *%eax
  800d2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	6a 78                	push   $0x78
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	ff d0                	call   *%eax
  800d3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	83 c0 04             	add    $0x4,%eax
  800d44:	89 45 14             	mov    %eax,0x14(%ebp)
  800d47:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4a:	83 e8 04             	sub    $0x4,%eax
  800d4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d60:	eb 1f                	jmp    800d81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 e8             	pushl  -0x18(%ebp)
  800d68:	8d 45 14             	lea    0x14(%ebp),%eax
  800d6b:	50                   	push   %eax
  800d6c:	e8 e7 fb ff ff       	call   800958 <getuint>
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	52                   	push   %edx
  800d8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d8f:	50                   	push   %eax
  800d90:	ff 75 f4             	pushl  -0xc(%ebp)
  800d93:	ff 75 f0             	pushl  -0x10(%ebp)
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	ff 75 08             	pushl  0x8(%ebp)
  800d9c:	e8 00 fb ff ff       	call   8008a1 <printnum>
  800da1:	83 c4 20             	add    $0x20,%esp
			break;
  800da4:	eb 46                	jmp    800dec <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da6:	83 ec 08             	sub    $0x8,%esp
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	53                   	push   %ebx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	ff d0                	call   *%eax
  800db2:	83 c4 10             	add    $0x10,%esp
			break;
  800db5:	eb 35                	jmp    800dec <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800db7:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
			break;
  800dbe:	eb 2c                	jmp    800dec <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dc0:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
			break;
  800dc7:	eb 23                	jmp    800dec <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dc9:	83 ec 08             	sub    $0x8,%esp
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	6a 25                	push   $0x25
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	ff d0                	call   *%eax
  800dd6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd9:	ff 4d 10             	decl   0x10(%ebp)
  800ddc:	eb 03                	jmp    800de1 <vprintfmt+0x3c3>
  800dde:	ff 4d 10             	decl   0x10(%ebp)
  800de1:	8b 45 10             	mov    0x10(%ebp),%eax
  800de4:	48                   	dec    %eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	3c 25                	cmp    $0x25,%al
  800de9:	75 f3                	jne    800dde <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800deb:	90                   	nop
		}
	}
  800dec:	e9 35 fc ff ff       	jmp    800a26 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800df1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dff:	8d 45 10             	lea    0x10(%ebp),%eax
  800e02:	83 c0 04             	add    $0x4,%eax
  800e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0e:	50                   	push   %eax
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	ff 75 08             	pushl  0x8(%ebp)
  800e15:	e8 04 fc ff ff       	call   800a1e <vprintfmt>
  800e1a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e1d:	90                   	nop
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8b 40 08             	mov    0x8(%eax),%eax
  800e29:	8d 50 01             	lea    0x1(%eax),%edx
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	8b 10                	mov    (%eax),%edx
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	8b 40 04             	mov    0x4(%eax),%eax
  800e3d:	39 c2                	cmp    %eax,%edx
  800e3f:	73 12                	jae    800e53 <sprintputch+0x33>
		*b->buf++ = ch;
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	8b 00                	mov    (%eax),%eax
  800e46:	8d 48 01             	lea    0x1(%eax),%ecx
  800e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4c:	89 0a                	mov    %ecx,(%edx)
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	88 10                	mov    %dl,(%eax)
}
  800e53:	90                   	nop
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	01 d0                	add    %edx,%eax
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e7b:	74 06                	je     800e83 <vsnprintf+0x2d>
  800e7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e81:	7f 07                	jg     800e8a <vsnprintf+0x34>
		return -E_INVAL;
  800e83:	b8 03 00 00 00       	mov    $0x3,%eax
  800e88:	eb 20                	jmp    800eaa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e8a:	ff 75 14             	pushl  0x14(%ebp)
  800e8d:	ff 75 10             	pushl  0x10(%ebp)
  800e90:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e93:	50                   	push   %eax
  800e94:	68 20 0e 80 00       	push   $0x800e20
  800e99:	e8 80 fb ff ff       	call   800a1e <vprintfmt>
  800e9e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ea4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eb2:	8d 45 10             	lea    0x10(%ebp),%eax
  800eb5:	83 c0 04             	add    $0x4,%eax
  800eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec1:	50                   	push   %eax
  800ec2:	ff 75 0c             	pushl  0xc(%ebp)
  800ec5:	ff 75 08             	pushl  0x8(%ebp)
  800ec8:	e8 89 ff ff ff       	call   800e56 <vsnprintf>
  800ecd:	83 c4 10             	add    $0x10,%esp
  800ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee5:	eb 06                	jmp    800eed <strlen+0x15>
		n++;
  800ee7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eea:	ff 45 08             	incl   0x8(%ebp)
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	84 c0                	test   %al,%al
  800ef4:	75 f1                	jne    800ee7 <strlen+0xf>
		n++;
	return n;
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f08:	eb 09                	jmp    800f13 <strnlen+0x18>
		n++;
  800f0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	ff 4d 0c             	decl   0xc(%ebp)
  800f13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f17:	74 09                	je     800f22 <strnlen+0x27>
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 e8                	jne    800f0a <strnlen+0xf>
		n++;
	return n;
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f33:	90                   	nop
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f46:	8a 12                	mov    (%edx),%dl
  800f48:	88 10                	mov    %dl,(%eax)
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	75 e4                	jne    800f34 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f68:	eb 1f                	jmp    800f89 <strncpy+0x34>
		*dst++ = *src;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8d 50 01             	lea    0x1(%eax),%edx
  800f70:	89 55 08             	mov    %edx,0x8(%ebp)
  800f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	74 03                	je     800f86 <strncpy+0x31>
			src++;
  800f83:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f86:	ff 45 fc             	incl   -0x4(%ebp)
  800f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f8f:	72 d9                	jb     800f6a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa6:	74 30                	je     800fd8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fa8:	eb 16                	jmp    800fc0 <strlcpy+0x2a>
			*dst++ = *src++;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fbc:	8a 12                	mov    (%edx),%dl
  800fbe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fc0:	ff 4d 10             	decl   0x10(%ebp)
  800fc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc7:	74 09                	je     800fd2 <strlcpy+0x3c>
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	84 c0                	test   %al,%al
  800fd0:	75 d8                	jne    800faa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fde:	29 c2                	sub    %eax,%edx
  800fe0:	89 d0                	mov    %edx,%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fe7:	eb 06                	jmp    800fef <strcmp+0xb>
		p++, q++;
  800fe9:	ff 45 08             	incl   0x8(%ebp)
  800fec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	84 c0                	test   %al,%al
  800ff6:	74 0e                	je     801006 <strcmp+0x22>
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 10                	mov    (%eax),%dl
  800ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	38 c2                	cmp    %al,%dl
  801004:	74 e3                	je     800fe9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	0f b6 d0             	movzbl %al,%edx
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 c0             	movzbl %al,%eax
  801016:	29 c2                	sub    %eax,%edx
  801018:	89 d0                	mov    %edx,%eax
}
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80101f:	eb 09                	jmp    80102a <strncmp+0xe>
		n--, p++, q++;
  801021:	ff 4d 10             	decl   0x10(%ebp)
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80102a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102e:	74 17                	je     801047 <strncmp+0x2b>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	84 c0                	test   %al,%al
  801037:	74 0e                	je     801047 <strncmp+0x2b>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 10                	mov    (%eax),%dl
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	38 c2                	cmp    %al,%dl
  801045:	74 da                	je     801021 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801047:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104b:	75 07                	jne    801054 <strncmp+0x38>
		return 0;
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	eb 14                	jmp    801068 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	0f b6 d0             	movzbl %al,%edx
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	0f b6 c0             	movzbl %al,%eax
  801064:	29 c2                	sub    %eax,%edx
  801066:	89 d0                	mov    %edx,%eax
}
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 04             	sub    $0x4,%esp
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801076:	eb 12                	jmp    80108a <strchr+0x20>
		if (*s == c)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801080:	75 05                	jne    801087 <strchr+0x1d>
			return (char *) s;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	eb 11                	jmp    801098 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	84 c0                	test   %al,%al
  801091:	75 e5                	jne    801078 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010a6:	eb 0d                	jmp    8010b5 <strfind+0x1b>
		if (*s == c)
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010b0:	74 0e                	je     8010c0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b2:	ff 45 08             	incl   0x8(%ebp)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	84 c0                	test   %al,%al
  8010bc:	75 ea                	jne    8010a8 <strfind+0xe>
  8010be:	eb 01                	jmp    8010c1 <strfind+0x27>
		if (*s == c)
			break;
  8010c0:	90                   	nop
	return (char *) s;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8010d2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d6:	76 63                	jbe    80113b <memset+0x75>
		uint64 data_block = c;
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	99                   	cltd   
  8010dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010df:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8010e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8010ec:	c1 e0 08             	shl    $0x8,%eax
  8010ef:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010f2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8010f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fb:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8010ff:	c1 e0 10             	shl    $0x10,%eax
  801102:	09 45 f0             	or     %eax,-0x10(%ebp)
  801105:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110e:	89 c2                	mov    %eax,%edx
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
  801115:	09 45 f0             	or     %eax,-0x10(%ebp)
  801118:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80111b:	eb 18                	jmp    801135 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80111d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801120:	8d 41 08             	lea    0x8(%ecx),%eax
  801123:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112c:	89 01                	mov    %eax,(%ecx)
  80112e:	89 51 04             	mov    %edx,0x4(%ecx)
  801131:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801135:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801139:	77 e2                	ja     80111d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 23                	je     801164 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801144:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801147:	eb 0e                	jmp    801157 <memset+0x91>
			*p8++ = (uint8)c;
  801149:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114c:	8d 50 01             	lea    0x1(%eax),%edx
  80114f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801152:	8b 55 0c             	mov    0xc(%ebp),%edx
  801155:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115d:	89 55 10             	mov    %edx,0x10(%ebp)
  801160:	85 c0                	test   %eax,%eax
  801162:	75 e5                	jne    801149 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80117b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80117f:	76 24                	jbe    8011a5 <memcpy+0x3c>
		while(n >= 8){
  801181:	eb 1c                	jmp    80119f <memcpy+0x36>
			*d64 = *s64;
  801183:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801186:	8b 50 04             	mov    0x4(%eax),%edx
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80118e:	89 01                	mov    %eax,(%ecx)
  801190:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801193:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801197:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80119b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80119f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011a3:	77 de                	ja     801183 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a9:	74 31                	je     8011dc <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011b7:	eb 16                	jmp    8011cf <memcpy+0x66>
			*d8++ = *s8++;
  8011b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bc:	8d 50 01             	lea    0x1(%eax),%edx
  8011bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011cb:	8a 12                	mov    (%edx),%dl
  8011cd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	75 dd                	jne    8011b9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011f9:	73 50                	jae    80124b <memmove+0x6a>
  8011fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801206:	76 43                	jbe    80124b <memmove+0x6a>
		s += n;
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801214:	eb 10                	jmp    801226 <memmove+0x45>
			*--d = *--s;
  801216:	ff 4d f8             	decl   -0x8(%ebp)
  801219:	ff 4d fc             	decl   -0x4(%ebp)
  80121c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121f:	8a 10                	mov    (%eax),%dl
  801221:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801224:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122c:	89 55 10             	mov    %edx,0x10(%ebp)
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 e3                	jne    801216 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801233:	eb 23                	jmp    801258 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801235:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801238:	8d 50 01             	lea    0x1(%eax),%edx
  80123b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80123e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801241:	8d 4a 01             	lea    0x1(%edx),%ecx
  801244:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801247:	8a 12                	mov    (%edx),%dl
  801249:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801251:	89 55 10             	mov    %edx,0x10(%ebp)
  801254:	85 c0                	test   %eax,%eax
  801256:	75 dd                	jne    801235 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80126f:	eb 2a                	jmp    80129b <memcmp+0x3e>
		if (*s1 != *s2)
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	8a 10                	mov    (%eax),%dl
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	38 c2                	cmp    %al,%dl
  80127d:	74 16                	je     801295 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	0f b6 d0             	movzbl %al,%edx
  801287:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	0f b6 c0             	movzbl %al,%eax
  80128f:	29 c2                	sub    %eax,%edx
  801291:	89 d0                	mov    %edx,%eax
  801293:	eb 18                	jmp    8012ad <memcmp+0x50>
		s1++, s2++;
  801295:	ff 45 fc             	incl   -0x4(%ebp)
  801298:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	75 c9                	jne    801271 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 d0                	add    %edx,%eax
  8012bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012c0:	eb 15                	jmp    8012d7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	0f b6 d0             	movzbl %al,%edx
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	0f b6 c0             	movzbl %al,%eax
  8012d0:	39 c2                	cmp    %eax,%edx
  8012d2:	74 0d                	je     8012e1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012d4:	ff 45 08             	incl   0x8(%ebp)
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012dd:	72 e3                	jb     8012c2 <memfind+0x13>
  8012df:	eb 01                	jmp    8012e2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012e1:	90                   	nop
	return (void *) s;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012fb:	eb 03                	jmp    801300 <strtol+0x19>
		s++;
  8012fd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3c 20                	cmp    $0x20,%al
  801307:	74 f4                	je     8012fd <strtol+0x16>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	3c 09                	cmp    $0x9,%al
  801310:	74 eb                	je     8012fd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	3c 2b                	cmp    $0x2b,%al
  801319:	75 05                	jne    801320 <strtol+0x39>
		s++;
  80131b:	ff 45 08             	incl   0x8(%ebp)
  80131e:	eb 13                	jmp    801333 <strtol+0x4c>
	else if (*s == '-')
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	3c 2d                	cmp    $0x2d,%al
  801327:	75 0a                	jne    801333 <strtol+0x4c>
		s++, neg = 1;
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801337:	74 06                	je     80133f <strtol+0x58>
  801339:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80133d:	75 20                	jne    80135f <strtol+0x78>
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	3c 30                	cmp    $0x30,%al
  801346:	75 17                	jne    80135f <strtol+0x78>
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	40                   	inc    %eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	3c 78                	cmp    $0x78,%al
  801350:	75 0d                	jne    80135f <strtol+0x78>
		s += 2, base = 16;
  801352:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801356:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80135d:	eb 28                	jmp    801387 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80135f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801363:	75 15                	jne    80137a <strtol+0x93>
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	3c 30                	cmp    $0x30,%al
  80136c:	75 0c                	jne    80137a <strtol+0x93>
		s++, base = 8;
  80136e:	ff 45 08             	incl   0x8(%ebp)
  801371:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801378:	eb 0d                	jmp    801387 <strtol+0xa0>
	else if (base == 0)
  80137a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137e:	75 07                	jne    801387 <strtol+0xa0>
		base = 10;
  801380:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 2f                	cmp    $0x2f,%al
  80138e:	7e 19                	jle    8013a9 <strtol+0xc2>
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 39                	cmp    $0x39,%al
  801397:	7f 10                	jg     8013a9 <strtol+0xc2>
			dig = *s - '0';
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	0f be c0             	movsbl %al,%eax
  8013a1:	83 e8 30             	sub    $0x30,%eax
  8013a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a7:	eb 42                	jmp    8013eb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	3c 60                	cmp    $0x60,%al
  8013b0:	7e 19                	jle    8013cb <strtol+0xe4>
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	3c 7a                	cmp    $0x7a,%al
  8013b9:	7f 10                	jg     8013cb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	0f be c0             	movsbl %al,%eax
  8013c3:	83 e8 57             	sub    $0x57,%eax
  8013c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013c9:	eb 20                	jmp    8013eb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	3c 40                	cmp    $0x40,%al
  8013d2:	7e 39                	jle    80140d <strtol+0x126>
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	3c 5a                	cmp    $0x5a,%al
  8013db:	7f 30                	jg     80140d <strtol+0x126>
			dig = *s - 'A' + 10;
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	0f be c0             	movsbl %al,%eax
  8013e5:	83 e8 37             	sub    $0x37,%eax
  8013e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ee:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013f1:	7d 19                	jge    80140c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013f3:	ff 45 08             	incl   0x8(%ebp)
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013fd:	89 c2                	mov    %eax,%edx
  8013ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801402:	01 d0                	add    %edx,%eax
  801404:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801407:	e9 7b ff ff ff       	jmp    801387 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80140c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80140d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801411:	74 08                	je     80141b <strtol+0x134>
		*endptr = (char *) s;
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	8b 55 08             	mov    0x8(%ebp),%edx
  801419:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80141b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141f:	74 07                	je     801428 <strtol+0x141>
  801421:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801424:	f7 d8                	neg    %eax
  801426:	eb 03                	jmp    80142b <strtol+0x144>
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <ltostr>:

void
ltostr(long value, char *str)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80143a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801445:	79 13                	jns    80145a <ltostr+0x2d>
	{
		neg = 1;
  801447:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801454:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801457:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801462:	99                   	cltd   
  801463:	f7 f9                	idiv   %ecx
  801465:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801468:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146b:	8d 50 01             	lea    0x1(%eax),%edx
  80146e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801471:	89 c2                	mov    %eax,%edx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80147b:	83 c2 30             	add    $0x30,%edx
  80147e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801480:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801483:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801488:	f7 e9                	imul   %ecx
  80148a:	c1 fa 02             	sar    $0x2,%edx
  80148d:	89 c8                	mov    %ecx,%eax
  80148f:	c1 f8 1f             	sar    $0x1f,%eax
  801492:	29 c2                	sub    %eax,%edx
  801494:	89 d0                	mov    %edx,%eax
  801496:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149d:	75 bb                	jne    80145a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80149f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a9:	48                   	dec    %eax
  8014aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014b1:	74 3d                	je     8014f0 <ltostr+0xc3>
		start = 1 ;
  8014b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014ba:	eb 34                	jmp    8014f0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8014bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	01 d0                	add    %edx,%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	01 c2                	add    %eax,%edx
  8014d1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	01 c8                	add    %ecx,%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	01 c2                	add    %eax,%edx
  8014e5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014e8:	88 02                	mov    %al,(%edx)
		start++ ;
  8014ea:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014ed:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f6:	7c c4                	jl     8014bc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fe:	01 d0                	add    %edx,%eax
  801500:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 c4 f9 ff ff       	call   800ed8 <strlen>
  801514:	83 c4 04             	add    $0x4,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80151a:	ff 75 0c             	pushl  0xc(%ebp)
  80151d:	e8 b6 f9 ff ff       	call   800ed8 <strlen>
  801522:	83 c4 04             	add    $0x4,%esp
  801525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801528:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80152f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801536:	eb 17                	jmp    80154f <strcconcat+0x49>
		final[s] = str1[s] ;
  801538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	01 c2                	add    %eax,%edx
  801540:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	01 c8                	add    %ecx,%eax
  801548:	8a 00                	mov    (%eax),%al
  80154a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80154c:	ff 45 fc             	incl   -0x4(%ebp)
  80154f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801552:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801555:	7c e1                	jl     801538 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801557:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80155e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801565:	eb 1f                	jmp    801586 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	8d 50 01             	lea    0x1(%eax),%edx
  80156d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801570:	89 c2                	mov    %eax,%edx
  801572:	8b 45 10             	mov    0x10(%ebp),%eax
  801575:	01 c2                	add    %eax,%edx
  801577:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	01 c8                	add    %ecx,%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801583:	ff 45 f8             	incl   -0x8(%ebp)
  801586:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801589:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80158c:	7c d9                	jl     801567 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80158e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	c6 00 00             	movb   $0x0,(%eax)
}
  801599:	90                   	nop
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80159f:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015bf:	eb 0c                	jmp    8015cd <strsplit+0x31>
			*string++ = 0;
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	8d 50 01             	lea    0x1(%eax),%edx
  8015c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ca:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	84 c0                	test   %al,%al
  8015d4:	74 18                	je     8015ee <strsplit+0x52>
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8a 00                	mov    (%eax),%al
  8015db:	0f be c0             	movsbl %al,%eax
  8015de:	50                   	push   %eax
  8015df:	ff 75 0c             	pushl  0xc(%ebp)
  8015e2:	e8 83 fa ff ff       	call   80106a <strchr>
  8015e7:	83 c4 08             	add    $0x8,%esp
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 d3                	jne    8015c1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	84 c0                	test   %al,%al
  8015f5:	74 5a                	je     801651 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fa:	8b 00                	mov    (%eax),%eax
  8015fc:	83 f8 0f             	cmp    $0xf,%eax
  8015ff:	75 07                	jne    801608 <strsplit+0x6c>
		{
			return 0;
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	eb 66                	jmp    80166e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801608:	8b 45 14             	mov    0x14(%ebp),%eax
  80160b:	8b 00                	mov    (%eax),%eax
  80160d:	8d 48 01             	lea    0x1(%eax),%ecx
  801610:	8b 55 14             	mov    0x14(%ebp),%edx
  801613:	89 0a                	mov    %ecx,(%edx)
  801615:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
  80161f:	01 c2                	add    %eax,%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801626:	eb 03                	jmp    80162b <strsplit+0x8f>
			string++;
  801628:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	84 c0                	test   %al,%al
  801632:	74 8b                	je     8015bf <strsplit+0x23>
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8a 00                	mov    (%eax),%al
  801639:	0f be c0             	movsbl %al,%eax
  80163c:	50                   	push   %eax
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	e8 25 fa ff ff       	call   80106a <strchr>
  801645:	83 c4 08             	add    $0x8,%esp
  801648:	85 c0                	test   %eax,%eax
  80164a:	74 dc                	je     801628 <strsplit+0x8c>
			string++;
	}
  80164c:	e9 6e ff ff ff       	jmp    8015bf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801651:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801652:	8b 45 14             	mov    0x14(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 d0                	add    %edx,%eax
  801663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801669:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80167c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801683:	eb 4a                	jmp    8016cf <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801685:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	01 c2                	add    %eax,%edx
  80168d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801690:	8b 45 0c             	mov    0xc(%ebp),%eax
  801693:	01 c8                	add    %ecx,%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801699:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80169c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169f:	01 d0                	add    %edx,%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	3c 40                	cmp    $0x40,%al
  8016a5:	7e 25                	jle    8016cc <str2lower+0x5c>
  8016a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	01 d0                	add    %edx,%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	3c 5a                	cmp    $0x5a,%al
  8016b3:	7f 17                	jg     8016cc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c3:	01 ca                	add    %ecx,%edx
  8016c5:	8a 12                	mov    (%edx),%dl
  8016c7:	83 c2 20             	add    $0x20,%edx
  8016ca:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8016cc:	ff 45 fc             	incl   -0x4(%ebp)
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	e8 01 f8 ff ff       	call   800ed8 <strlen>
  8016d7:	83 c4 04             	add    $0x4,%esp
  8016da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016dd:	7f a6                	jg     801685 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8016df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	57                   	push   %edi
  8016e8:	56                   	push   %esi
  8016e9:	53                   	push   %ebx
  8016ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016ff:	cd 30                	int    $0x30
  801701:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5e                   	pop    %esi
  80170c:	5f                   	pop    %edi
  80170d:	5d                   	pop    %ebp
  80170e:	c3                   	ret    

0080170f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
  801718:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80171b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80171e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	6a 00                	push   $0x0
  801727:	51                   	push   %ecx
  801728:	52                   	push   %edx
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	50                   	push   %eax
  80172d:	6a 00                	push   $0x0
  80172f:	e8 b0 ff ff ff       	call   8016e4 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	90                   	nop
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_cgetc>:

int
sys_cgetc(void)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 02                	push   $0x2
  801749:	e8 96 ff ff ff       	call   8016e4 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 03                	push   $0x3
  801762:	e8 7d ff ff ff       	call   8016e4 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	90                   	nop
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 04                	push   $0x4
  80177c:	e8 63 ff ff ff       	call   8016e4 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	52                   	push   %edx
  801797:	50                   	push   %eax
  801798:	6a 08                	push   $0x8
  80179a:	e8 45 ff ff ff       	call   8016e4 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8017ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	56                   	push   %esi
  8017b9:	53                   	push   %ebx
  8017ba:	51                   	push   %ecx
  8017bb:	52                   	push   %edx
  8017bc:	50                   	push   %eax
  8017bd:	6a 09                	push   $0x9
  8017bf:	e8 20 ff ff ff       	call   8016e4 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ca:	5b                   	pop    %ebx
  8017cb:	5e                   	pop    %esi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 0a                	push   $0xa
  8017de:	e8 01 ff ff ff       	call   8016e4 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 0b                	push   $0xb
  8017f9:	e8 e6 fe ff ff       	call   8016e4 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 0c                	push   $0xc
  801812:	e8 cd fe ff ff       	call   8016e4 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 0d                	push   $0xd
  80182b:	e8 b4 fe ff ff       	call   8016e4 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 0e                	push   $0xe
  801844:	e8 9b fe ff ff       	call   8016e4 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 0f                	push   $0xf
  80185d:	e8 82 fe ff ff       	call   8016e4 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	6a 10                	push   $0x10
  801877:	e8 68 fe ff ff       	call   8016e4 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 11                	push   $0x11
  801890:	e8 4f fe ff ff       	call   8016e4 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	90                   	nop
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_cputc>:

void
sys_cputc(const char c)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	50                   	push   %eax
  8018b4:	6a 01                	push   $0x1
  8018b6:	e8 29 fe ff ff       	call   8016e4 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 14                	push   $0x14
  8018d0:	e8 0f fe ff ff       	call   8016e4 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	51                   	push   %ecx
  8018f4:	52                   	push   %edx
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	50                   	push   %eax
  8018f9:	6a 15                	push   $0x15
  8018fb:	e8 e4 fd ff ff       	call   8016e4 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 16                	push   $0x16
  801918:	e8 c7 fd ff ff       	call   8016e4 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801925:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	51                   	push   %ecx
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 17                	push   $0x17
  801937:	e8 a8 fd ff ff       	call   8016e4 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	52                   	push   %edx
  801951:	50                   	push   %eax
  801952:	6a 18                	push   $0x18
  801954:	e8 8b fd ff ff       	call   8016e4 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	ff 75 14             	pushl  0x14(%ebp)
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	6a 19                	push   $0x19
  801972:	e8 6d fd ff ff       	call   8016e4 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	50                   	push   %eax
  80198b:	6a 1a                	push   $0x1a
  80198d:	e8 52 fd ff ff       	call   8016e4 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	50                   	push   %eax
  8019a7:	6a 1b                	push   $0x1b
  8019a9:	e8 36 fd ff ff       	call   8016e4 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 05                	push   $0x5
  8019c2:	e8 1d fd ff ff       	call   8016e4 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 06                	push   $0x6
  8019db:	e8 04 fd ff ff       	call   8016e4 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 07                	push   $0x7
  8019f4:	e8 eb fc ff ff       	call   8016e4 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_exit_env>:


void sys_exit_env(void)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 1c                	push   $0x1c
  801a0d:	e8 d2 fc ff ff       	call   8016e4 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a21:	8d 50 04             	lea    0x4(%eax),%edx
  801a24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 1d                	push   $0x1d
  801a31:	e8 ae fc ff ff       	call   8016e4 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
	return result;
  801a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a42:	89 01                	mov    %eax,(%ecx)
  801a44:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	c9                   	leave  
  801a4b:	c2 04 00             	ret    $0x4

00801a4e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	ff 75 10             	pushl  0x10(%ebp)
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	6a 13                	push   $0x13
  801a60:	e8 7f fc ff ff       	call   8016e4 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
	return ;
  801a68:	90                   	nop
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_rcr2>:
uint32 sys_rcr2()
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 1e                	push   $0x1e
  801a7a:	e8 65 fc ff ff       	call   8016e4 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a90:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	50                   	push   %eax
  801a9d:	6a 1f                	push   $0x1f
  801a9f:	e8 40 fc ff ff       	call   8016e4 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa7:	90                   	nop
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <rsttst>:
void rsttst()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 21                	push   $0x21
  801ab9:	e8 26 fc ff ff       	call   8016e4 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	8b 45 14             	mov    0x14(%ebp),%eax
  801acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ad0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad7:	52                   	push   %edx
  801ad8:	50                   	push   %eax
  801ad9:	ff 75 10             	pushl  0x10(%ebp)
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	ff 75 08             	pushl  0x8(%ebp)
  801ae2:	6a 20                	push   $0x20
  801ae4:	e8 fb fb ff ff       	call   8016e4 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aec:	90                   	nop
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <chktst>:
void chktst(uint32 n)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	6a 22                	push   $0x22
  801aff:	e8 e0 fb ff ff       	call   8016e4 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return ;
  801b07:	90                   	nop
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <inctst>:

void inctst()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 23                	push   $0x23
  801b19:	e8 c6 fb ff ff       	call   8016e4 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b21:	90                   	nop
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <gettst>:
uint32 gettst()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 24                	push   $0x24
  801b33:	e8 ac fb ff ff       	call   8016e4 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 25                	push   $0x25
  801b4c:	e8 93 fb ff ff       	call   8016e4 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
  801b54:	a3 40 71 82 00       	mov    %eax,0x827140
	return uheapPlaceStrategy ;
  801b59:	a1 40 71 82 00       	mov    0x827140,%eax
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	a3 40 71 82 00       	mov    %eax,0x827140
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	6a 26                	push   $0x26
  801b78:	e8 67 fb ff ff       	call   8016e4 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	53                   	push   %ebx
  801b96:	51                   	push   %ecx
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 27                	push   $0x27
  801b9b:	e8 44 fb ff ff       	call   8016e4 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 28                	push   $0x28
  801bbb:	e8 24 fb ff ff       	call   8016e4 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bc8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	51                   	push   %ecx
  801bd4:	ff 75 10             	pushl  0x10(%ebp)
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 29                	push   $0x29
  801bdb:	e8 04 fb ff ff       	call   8016e4 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 10             	pushl  0x10(%ebp)
  801bef:	ff 75 0c             	pushl  0xc(%ebp)
  801bf2:	ff 75 08             	pushl  0x8(%ebp)
  801bf5:	6a 12                	push   $0x12
  801bf7:	e8 e8 fa ff ff       	call   8016e4 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bff:	90                   	nop
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 2a                	push   $0x2a
  801c15:	e8 ca fa ff ff       	call   8016e4 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
	return;
  801c1d:	90                   	nop
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 2b                	push   $0x2b
  801c2f:	e8 b0 fa ff ff       	call   8016e4 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	ff 75 08             	pushl  0x8(%ebp)
  801c48:	6a 2d                	push   $0x2d
  801c4a:	e8 95 fa ff ff       	call   8016e4 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
	return;
  801c52:	90                   	nop
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	ff 75 0c             	pushl  0xc(%ebp)
  801c61:	ff 75 08             	pushl  0x8(%ebp)
  801c64:	6a 2c                	push   $0x2c
  801c66:	e8 79 fa ff ff       	call   8016e4 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6e:	90                   	nop
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	52                   	push   %edx
  801c81:	50                   	push   %eax
  801c82:	6a 2e                	push   $0x2e
  801c84:	e8 5b fa ff ff       	call   8016e4 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    
  801c8f:	90                   	nop

00801c90 <__udivdi3>:
  801c90:	55                   	push   %ebp
  801c91:	57                   	push   %edi
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 1c             	sub    $0x1c,%esp
  801c97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ca3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ca7:	89 ca                	mov    %ecx,%edx
  801ca9:	89 f8                	mov    %edi,%eax
  801cab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801caf:	85 f6                	test   %esi,%esi
  801cb1:	75 2d                	jne    801ce0 <__udivdi3+0x50>
  801cb3:	39 cf                	cmp    %ecx,%edi
  801cb5:	77 65                	ja     801d1c <__udivdi3+0x8c>
  801cb7:	89 fd                	mov    %edi,%ebp
  801cb9:	85 ff                	test   %edi,%edi
  801cbb:	75 0b                	jne    801cc8 <__udivdi3+0x38>
  801cbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc2:	31 d2                	xor    %edx,%edx
  801cc4:	f7 f7                	div    %edi
  801cc6:	89 c5                	mov    %eax,%ebp
  801cc8:	31 d2                	xor    %edx,%edx
  801cca:	89 c8                	mov    %ecx,%eax
  801ccc:	f7 f5                	div    %ebp
  801cce:	89 c1                	mov    %eax,%ecx
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	f7 f5                	div    %ebp
  801cd4:	89 cf                	mov    %ecx,%edi
  801cd6:	89 fa                	mov    %edi,%edx
  801cd8:	83 c4 1c             	add    $0x1c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    
  801ce0:	39 ce                	cmp    %ecx,%esi
  801ce2:	77 28                	ja     801d0c <__udivdi3+0x7c>
  801ce4:	0f bd fe             	bsr    %esi,%edi
  801ce7:	83 f7 1f             	xor    $0x1f,%edi
  801cea:	75 40                	jne    801d2c <__udivdi3+0x9c>
  801cec:	39 ce                	cmp    %ecx,%esi
  801cee:	72 0a                	jb     801cfa <__udivdi3+0x6a>
  801cf0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cf4:	0f 87 9e 00 00 00    	ja     801d98 <__udivdi3+0x108>
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	89 fa                	mov    %edi,%edx
  801d01:	83 c4 1c             	add    $0x1c,%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5f                   	pop    %edi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    
  801d09:	8d 76 00             	lea    0x0(%esi),%esi
  801d0c:	31 ff                	xor    %edi,%edi
  801d0e:	31 c0                	xor    %eax,%eax
  801d10:	89 fa                	mov    %edi,%edx
  801d12:	83 c4 1c             	add    $0x1c,%esp
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5f                   	pop    %edi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
  801d1a:	66 90                	xchg   %ax,%ax
  801d1c:	89 d8                	mov    %ebx,%eax
  801d1e:	f7 f7                	div    %edi
  801d20:	31 ff                	xor    %edi,%edi
  801d22:	89 fa                	mov    %edi,%edx
  801d24:	83 c4 1c             	add    $0x1c,%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5f                   	pop    %edi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
  801d2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d31:	89 eb                	mov    %ebp,%ebx
  801d33:	29 fb                	sub    %edi,%ebx
  801d35:	89 f9                	mov    %edi,%ecx
  801d37:	d3 e6                	shl    %cl,%esi
  801d39:	89 c5                	mov    %eax,%ebp
  801d3b:	88 d9                	mov    %bl,%cl
  801d3d:	d3 ed                	shr    %cl,%ebp
  801d3f:	89 e9                	mov    %ebp,%ecx
  801d41:	09 f1                	or     %esi,%ecx
  801d43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d47:	89 f9                	mov    %edi,%ecx
  801d49:	d3 e0                	shl    %cl,%eax
  801d4b:	89 c5                	mov    %eax,%ebp
  801d4d:	89 d6                	mov    %edx,%esi
  801d4f:	88 d9                	mov    %bl,%cl
  801d51:	d3 ee                	shr    %cl,%esi
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	d3 e2                	shl    %cl,%edx
  801d57:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5b:	88 d9                	mov    %bl,%cl
  801d5d:	d3 e8                	shr    %cl,%eax
  801d5f:	09 c2                	or     %eax,%edx
  801d61:	89 d0                	mov    %edx,%eax
  801d63:	89 f2                	mov    %esi,%edx
  801d65:	f7 74 24 0c          	divl   0xc(%esp)
  801d69:	89 d6                	mov    %edx,%esi
  801d6b:	89 c3                	mov    %eax,%ebx
  801d6d:	f7 e5                	mul    %ebp
  801d6f:	39 d6                	cmp    %edx,%esi
  801d71:	72 19                	jb     801d8c <__udivdi3+0xfc>
  801d73:	74 0b                	je     801d80 <__udivdi3+0xf0>
  801d75:	89 d8                	mov    %ebx,%eax
  801d77:	31 ff                	xor    %edi,%edi
  801d79:	e9 58 ff ff ff       	jmp    801cd6 <__udivdi3+0x46>
  801d7e:	66 90                	xchg   %ax,%ax
  801d80:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d84:	89 f9                	mov    %edi,%ecx
  801d86:	d3 e2                	shl    %cl,%edx
  801d88:	39 c2                	cmp    %eax,%edx
  801d8a:	73 e9                	jae    801d75 <__udivdi3+0xe5>
  801d8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d8f:	31 ff                	xor    %edi,%edi
  801d91:	e9 40 ff ff ff       	jmp    801cd6 <__udivdi3+0x46>
  801d96:	66 90                	xchg   %ax,%ax
  801d98:	31 c0                	xor    %eax,%eax
  801d9a:	e9 37 ff ff ff       	jmp    801cd6 <__udivdi3+0x46>
  801d9f:	90                   	nop

00801da0 <__umoddi3>:
  801da0:	55                   	push   %ebp
  801da1:	57                   	push   %edi
  801da2:	56                   	push   %esi
  801da3:	53                   	push   %ebx
  801da4:	83 ec 1c             	sub    $0x1c,%esp
  801da7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dab:	8b 74 24 34          	mov    0x34(%esp),%esi
  801daf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801db3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801db7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dbf:	89 f3                	mov    %esi,%ebx
  801dc1:	89 fa                	mov    %edi,%edx
  801dc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dc7:	89 34 24             	mov    %esi,(%esp)
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	75 1a                	jne    801de8 <__umoddi3+0x48>
  801dce:	39 f7                	cmp    %esi,%edi
  801dd0:	0f 86 a2 00 00 00    	jbe    801e78 <__umoddi3+0xd8>
  801dd6:	89 c8                	mov    %ecx,%eax
  801dd8:	89 f2                	mov    %esi,%edx
  801dda:	f7 f7                	div    %edi
  801ddc:	89 d0                	mov    %edx,%eax
  801dde:	31 d2                	xor    %edx,%edx
  801de0:	83 c4 1c             	add    $0x1c,%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
  801de8:	39 f0                	cmp    %esi,%eax
  801dea:	0f 87 ac 00 00 00    	ja     801e9c <__umoddi3+0xfc>
  801df0:	0f bd e8             	bsr    %eax,%ebp
  801df3:	83 f5 1f             	xor    $0x1f,%ebp
  801df6:	0f 84 ac 00 00 00    	je     801ea8 <__umoddi3+0x108>
  801dfc:	bf 20 00 00 00       	mov    $0x20,%edi
  801e01:	29 ef                	sub    %ebp,%edi
  801e03:	89 fe                	mov    %edi,%esi
  801e05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e09:	89 e9                	mov    %ebp,%ecx
  801e0b:	d3 e0                	shl    %cl,%eax
  801e0d:	89 d7                	mov    %edx,%edi
  801e0f:	89 f1                	mov    %esi,%ecx
  801e11:	d3 ef                	shr    %cl,%edi
  801e13:	09 c7                	or     %eax,%edi
  801e15:	89 e9                	mov    %ebp,%ecx
  801e17:	d3 e2                	shl    %cl,%edx
  801e19:	89 14 24             	mov    %edx,(%esp)
  801e1c:	89 d8                	mov    %ebx,%eax
  801e1e:	d3 e0                	shl    %cl,%eax
  801e20:	89 c2                	mov    %eax,%edx
  801e22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e26:	d3 e0                	shl    %cl,%eax
  801e28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e30:	89 f1                	mov    %esi,%ecx
  801e32:	d3 e8                	shr    %cl,%eax
  801e34:	09 d0                	or     %edx,%eax
  801e36:	d3 eb                	shr    %cl,%ebx
  801e38:	89 da                	mov    %ebx,%edx
  801e3a:	f7 f7                	div    %edi
  801e3c:	89 d3                	mov    %edx,%ebx
  801e3e:	f7 24 24             	mull   (%esp)
  801e41:	89 c6                	mov    %eax,%esi
  801e43:	89 d1                	mov    %edx,%ecx
  801e45:	39 d3                	cmp    %edx,%ebx
  801e47:	0f 82 87 00 00 00    	jb     801ed4 <__umoddi3+0x134>
  801e4d:	0f 84 91 00 00 00    	je     801ee4 <__umoddi3+0x144>
  801e53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e57:	29 f2                	sub    %esi,%edx
  801e59:	19 cb                	sbb    %ecx,%ebx
  801e5b:	89 d8                	mov    %ebx,%eax
  801e5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e61:	d3 e0                	shl    %cl,%eax
  801e63:	89 e9                	mov    %ebp,%ecx
  801e65:	d3 ea                	shr    %cl,%edx
  801e67:	09 d0                	or     %edx,%eax
  801e69:	89 e9                	mov    %ebp,%ecx
  801e6b:	d3 eb                	shr    %cl,%ebx
  801e6d:	89 da                	mov    %ebx,%edx
  801e6f:	83 c4 1c             	add    $0x1c,%esp
  801e72:	5b                   	pop    %ebx
  801e73:	5e                   	pop    %esi
  801e74:	5f                   	pop    %edi
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    
  801e77:	90                   	nop
  801e78:	89 fd                	mov    %edi,%ebp
  801e7a:	85 ff                	test   %edi,%edi
  801e7c:	75 0b                	jne    801e89 <__umoddi3+0xe9>
  801e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e83:	31 d2                	xor    %edx,%edx
  801e85:	f7 f7                	div    %edi
  801e87:	89 c5                	mov    %eax,%ebp
  801e89:	89 f0                	mov    %esi,%eax
  801e8b:	31 d2                	xor    %edx,%edx
  801e8d:	f7 f5                	div    %ebp
  801e8f:	89 c8                	mov    %ecx,%eax
  801e91:	f7 f5                	div    %ebp
  801e93:	89 d0                	mov    %edx,%eax
  801e95:	e9 44 ff ff ff       	jmp    801dde <__umoddi3+0x3e>
  801e9a:	66 90                	xchg   %ax,%ax
  801e9c:	89 c8                	mov    %ecx,%eax
  801e9e:	89 f2                	mov    %esi,%edx
  801ea0:	83 c4 1c             	add    $0x1c,%esp
  801ea3:	5b                   	pop    %ebx
  801ea4:	5e                   	pop    %esi
  801ea5:	5f                   	pop    %edi
  801ea6:	5d                   	pop    %ebp
  801ea7:	c3                   	ret    
  801ea8:	3b 04 24             	cmp    (%esp),%eax
  801eab:	72 06                	jb     801eb3 <__umoddi3+0x113>
  801ead:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801eb1:	77 0f                	ja     801ec2 <__umoddi3+0x122>
  801eb3:	89 f2                	mov    %esi,%edx
  801eb5:	29 f9                	sub    %edi,%ecx
  801eb7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ebb:	89 14 24             	mov    %edx,(%esp)
  801ebe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ec6:	8b 14 24             	mov    (%esp),%edx
  801ec9:	83 c4 1c             	add    $0x1c,%esp
  801ecc:	5b                   	pop    %ebx
  801ecd:	5e                   	pop    %esi
  801ece:	5f                   	pop    %edi
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    
  801ed1:	8d 76 00             	lea    0x0(%esi),%esi
  801ed4:	2b 04 24             	sub    (%esp),%eax
  801ed7:	19 fa                	sbb    %edi,%edx
  801ed9:	89 d1                	mov    %edx,%ecx
  801edb:	89 c6                	mov    %eax,%esi
  801edd:	e9 71 ff ff ff       	jmp    801e53 <__umoddi3+0xb3>
  801ee2:	66 90                	xchg   %ax,%ax
  801ee4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ee8:	72 ea                	jb     801ed4 <__umoddi3+0x134>
  801eea:	89 d9                	mov    %ebx,%ecx
  801eec:	e9 62 ff ff ff       	jmp    801e53 <__umoddi3+0xb3>
