
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 dc 00 00 00       	call   800112 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  800065:	68 e0 36 80 00       	push   $0x8036e0
  80006a:	6a 0e                	push   $0xe
  80006c:	68 fc 36 80 00       	push   $0x8036fc
  800071:	e8 4c 02 00 00       	call   8002c2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;
sys_lock_cons();
  80007d:	e8 8a 21 00 00       	call   80220c <sys_lock_cons>
	x = sget(sys_getparentenvid(),"x");
  800082:	e8 17 24 00 00       	call   80249e <sys_getparentenvid>
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 1a 37 80 00       	push   $0x80371a
  80008f:	50                   	push   %eax
  800090:	e8 66 1f 00 00       	call   801ffb <sget>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80009b:	e8 1c 22 00 00       	call   8022bc <sys_calculate_free_frames>
  8000a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 1c 37 80 00       	push   $0x80371c
  8000ab:	e8 00 05 00 00       	call   8005b0 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b9:	e8 c2 20 00 00       	call   802180 <sfree>
  8000be:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 40 37 80 00       	push   $0x803740
  8000c9:	e8 e2 04 00 00       	call   8005b0 <cprintf>
  8000ce:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000d1:	e8 e6 21 00 00       	call   8022bc <sys_calculate_free_frames>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000db:	29 c2                	sub    %eax,%edx
  8000dd:	89 d0                	mov    %edx,%eax
  8000df:	89 45 e8             	mov    %eax,-0x18(%ebp)
sys_unlock_cons();
  8000e2:	e8 3f 21 00 00       	call   802226 <sys_unlock_cons>
	expected = 1;
  8000e7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f4:	74 14                	je     80010a <_main+0xd2>
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	68 58 37 80 00       	push   $0x803758
  8000fe:	6a 25                	push   $0x25
  800100:	68 fc 36 80 00       	push   $0x8036fc
  800105:	e8 b8 01 00 00       	call   8002c2 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80010a:	e8 b4 24 00 00       	call   8025c3 <inctst>

	return;
  80010f:	90                   	nop
}
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	57                   	push   %edi
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80011b:	e8 65 23 00 00       	call   802485 <sys_getenvindex>
  800120:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800123:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800126:	89 d0                	mov    %edx,%eax
  800128:	01 c0                	add    %eax,%eax
  80012a:	01 d0                	add    %edx,%eax
  80012c:	c1 e0 02             	shl    $0x2,%eax
  80012f:	01 d0                	add    %edx,%eax
  800131:	c1 e0 02             	shl    $0x2,%eax
  800134:	01 d0                	add    %edx,%eax
  800136:	c1 e0 03             	shl    $0x3,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 02             	shl    $0x2,%eax
  80013e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800143:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800148:	a1 20 50 80 00       	mov    0x805020,%eax
  80014d:	8a 40 20             	mov    0x20(%eax),%al
  800150:	84 c0                	test   %al,%al
  800152:	74 0d                	je     800161 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800154:	a1 20 50 80 00       	mov    0x805020,%eax
  800159:	83 c0 20             	add    $0x20,%eax
  80015c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800165:	7e 0a                	jle    800171 <libmain+0x5f>
		binaryname = argv[0];
  800167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016a:	8b 00                	mov    (%eax),%eax
  80016c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	ff 75 0c             	pushl  0xc(%ebp)
  800177:	ff 75 08             	pushl  0x8(%ebp)
  80017a:	e8 b9 fe ff ff       	call   800038 <_main>
  80017f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800182:	a1 00 50 80 00       	mov    0x805000,%eax
  800187:	85 c0                	test   %eax,%eax
  800189:	0f 84 01 01 00 00    	je     800290 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80018f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800195:	bb dc 38 80 00       	mov    $0x8038dc,%ebx
  80019a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80019f:	89 c7                	mov    %eax,%edi
  8001a1:	89 de                	mov    %ebx,%esi
  8001a3:	89 d1                	mov    %edx,%ecx
  8001a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001af:	b0 00                	mov    $0x0,%al
  8001b1:	89 d7                	mov    %edx,%edi
  8001b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 ec 24 00 00       	call   8026bb <sys_utilities>
  8001cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d2:	e8 35 20 00 00       	call   80220c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 fc 37 80 00       	push   $0x8037fc
  8001df:	e8 cc 03 00 00       	call   8005b0 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	74 18                	je     800206 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001ee:	e8 e6 24 00 00       	call   8026d9 <sys_get_optimal_num_faults>
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	50                   	push   %eax
  8001f7:	68 24 38 80 00       	push   $0x803824
  8001fc:	e8 af 03 00 00       	call   8005b0 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	eb 59                	jmp    80025f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 50 80 00       	mov    0x805020,%eax
  80020b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800211:	a1 20 50 80 00       	mov    0x805020,%eax
  800216:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 48 38 80 00       	push   $0x803848
  800226:	e8 85 03 00 00       	call   8005b0 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022e:	a1 20 50 80 00       	mov    0x805020,%eax
  800233:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800239:	a1 20 50 80 00       	mov    0x805020,%eax
  80023e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80024f:	51                   	push   %ecx
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	68 70 38 80 00       	push   $0x803870
  800257:	e8 54 03 00 00       	call   8005b0 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 c8 38 80 00       	push   $0x8038c8
  800273:	e8 38 03 00 00       	call   8005b0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 fc 37 80 00       	push   $0x8037fc
  800283:	e8 28 03 00 00       	call   8005b0 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80028b:	e8 96 1f 00 00       	call   802226 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800290:	e8 1f 00 00 00       	call   8002b4 <exit>
}
  800295:	90                   	nop
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	6a 00                	push   $0x0
  8002a9:	e8 a3 21 00 00       	call   802451 <sys_destroy_env>
  8002ae:	83 c4 10             	add    $0x10,%esp
}
  8002b1:	90                   	nop
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <exit>:

void
exit(void)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ba:	e8 f8 21 00 00       	call   8024b7 <sys_exit_env>
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002cb:	83 c0 04             	add    $0x4,%eax
  8002ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d1:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8002d6:	85 c0                	test   %eax,%eax
  8002d8:	74 16                	je     8002f0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002da:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	50                   	push   %eax
  8002e3:	68 40 39 80 00       	push   $0x803940
  8002e8:	e8 c3 02 00 00       	call   8005b0 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	50                   	push   %eax
  8002ff:	68 48 39 80 00       	push   $0x803948
  800304:	6a 74                	push   $0x74
  800306:	e8 d2 02 00 00       	call   8005dd <cprintf_colored>
  80030b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80030e:	8b 45 10             	mov    0x10(%ebp),%eax
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 f4             	pushl  -0xc(%ebp)
  800317:	50                   	push   %eax
  800318:	e8 24 02 00 00       	call   800541 <vcprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	6a 00                	push   $0x0
  800325:	68 70 39 80 00       	push   $0x803970
  80032a:	e8 12 02 00 00       	call   800541 <vcprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800332:	e8 7d ff ff ff       	call   8002b4 <exit>

	// should not return here
	while (1) ;
  800337:	eb fe                	jmp    800337 <_panic+0x75>

00800339 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	53                   	push   %ebx
  80033d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80034b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034e:	39 c2                	cmp    %eax,%edx
  800350:	74 14                	je     800366 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	68 74 39 80 00       	push   $0x803974
  80035a:	6a 26                	push   $0x26
  80035c:	68 c0 39 80 00       	push   $0x8039c0
  800361:	e8 5c ff ff ff       	call   8002c2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800366:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	e9 d9 00 00 00       	jmp    800452 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 d0                	add    %edx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	75 08                	jne    800396 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80038e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800391:	e9 b9 00 00 00       	jmp    80044f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800396:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a4:	eb 79                	jmp    80041f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ab:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b4:	89 d0                	mov    %edx,%eax
  8003b6:	01 c0                	add    %eax,%eax
  8003b8:	01 d0                	add    %edx,%eax
  8003ba:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003c1:	01 d8                	add    %ebx,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8a 40 04             	mov    0x4(%eax),%al
  8003ca:	84 c0                	test   %al,%al
  8003cc:	75 4e                	jne    80041c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003dc:	89 d0                	mov    %edx,%eax
  8003de:	01 c0                	add    %eax,%eax
  8003e0:	01 d0                	add    %edx,%eax
  8003e2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003e9:	01 d8                	add    %ebx,%eax
  8003eb:	01 d0                	add    %edx,%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003fc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800401:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	01 c8                	add    %ecx,%eax
  80040d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80040f:	39 c2                	cmp    %eax,%edx
  800411:	75 09                	jne    80041c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800413:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80041a:	eb 19                	jmp    800435 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041c:	ff 45 e8             	incl   -0x18(%ebp)
  80041f:	a1 20 50 80 00       	mov    0x805020,%eax
  800424:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80042a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042d:	39 c2                	cmp    %eax,%edx
  80042f:	0f 87 71 ff ff ff    	ja     8003a6 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800435:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800439:	75 14                	jne    80044f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	68 cc 39 80 00       	push   $0x8039cc
  800443:	6a 3a                	push   $0x3a
  800445:	68 c0 39 80 00       	push   $0x8039c0
  80044a:	e8 73 fe ff ff       	call   8002c2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80044f:	ff 45 f0             	incl   -0x10(%ebp)
  800452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800455:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800458:	0f 8c 1b ff ff ff    	jl     800379 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80045e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80046c:	eb 2e                	jmp    80049c <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80046e:	a1 20 50 80 00       	mov    0x805020,%eax
  800473:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800479:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047c:	89 d0                	mov    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	01 d0                	add    %edx,%eax
  800482:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800489:	01 d8                	add    %ebx,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	01 c8                	add    %ecx,%eax
  80048f:	8a 40 04             	mov    0x4(%eax),%al
  800492:	3c 01                	cmp    $0x1,%al
  800494:	75 03                	jne    800499 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800496:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800499:	ff 45 e0             	incl   -0x20(%ebp)
  80049c:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004aa:	39 c2                	cmp    %eax,%edx
  8004ac:	77 c0                	ja     80046e <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b4:	74 14                	je     8004ca <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 20 3a 80 00       	push   $0x803a20
  8004be:	6a 44                	push   $0x44
  8004c0:	68 c0 39 80 00       	push   $0x8039c0
  8004c5:	e8 f8 fd ff ff       	call   8002c2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ca:	90                   	nop
  8004cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e2:	89 0a                	mov    %ecx,(%edx)
  8004e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e7:	88 d1                	mov    %dl,%cl
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004fa:	75 30                	jne    80052c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004fc:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800502:	a0 44 50 80 00       	mov    0x805044,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050d:	8b 09                	mov    (%ecx),%ecx
  80050f:	89 cb                	mov    %ecx,%ebx
  800511:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800514:	83 c1 08             	add    $0x8,%ecx
  800517:	52                   	push   %edx
  800518:	50                   	push   %eax
  800519:	53                   	push   %ebx
  80051a:	51                   	push   %ecx
  80051b:	e8 a8 1c 00 00       	call   8021c8 <sys_cputs>
  800520:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800523:	8b 45 0c             	mov    0xc(%ebp),%eax
  800526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052f:	8b 40 04             	mov    0x4(%eax),%eax
  800532:	8d 50 01             	lea    0x1(%eax),%edx
  800535:	8b 45 0c             	mov    0xc(%ebp),%eax
  800538:	89 50 04             	mov    %edx,0x4(%eax)
}
  80053b:	90                   	nop
  80053c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053f:	c9                   	leave  
  800540:	c3                   	ret    

00800541 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800541:	55                   	push   %ebp
  800542:	89 e5                	mov    %esp,%ebp
  800544:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80054a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800551:	00 00 00 
	b.cnt = 0;
  800554:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80055b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80055e:	ff 75 0c             	pushl  0xc(%ebp)
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	50                   	push   %eax
  80056b:	68 d0 04 80 00       	push   $0x8004d0
  800570:	e8 5a 02 00 00       	call   8007cf <vprintfmt>
  800575:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800578:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80057e:	a0 44 50 80 00       	mov    0x805044,%al
  800583:	0f b6 c0             	movzbl %al,%eax
  800586:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80058c:	52                   	push   %edx
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800595:	83 c0 08             	add    $0x8,%eax
  800598:	50                   	push   %eax
  800599:	e8 2a 1c 00 00       	call   8021c8 <sys_cputs>
  80059e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a1:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ae:	c9                   	leave  
  8005af:	c3                   	ret    

008005b0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b6:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 6f ff ff ff       	call   800541 <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005db:	c9                   	leave  
  8005dc:	c3                   	ret    

008005dd <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e3:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	c1 e0 08             	shl    $0x8,%eax
  8005f0:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8005f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f8:	83 c0 04             	add    $0x4,%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	ff 75 f4             	pushl  -0xc(%ebp)
  800607:	50                   	push   %eax
  800608:	e8 34 ff ff ff       	call   800541 <vcprintf>
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800613:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  80061a:	07 00 00 

	return cnt;
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800628:	e8 df 1b 00 00       	call   80220c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80062d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800630:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	ff 75 f4             	pushl  -0xc(%ebp)
  80063c:	50                   	push   %eax
  80063d:	e8 ff fe ff ff       	call   800541 <vcprintf>
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800648:	e8 d9 1b 00 00       	call   802226 <sys_unlock_cons>
	return cnt;
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800650:	c9                   	leave  
  800651:	c3                   	ret    

00800652 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	53                   	push   %ebx
  800656:	83 ec 14             	sub    $0x14,%esp
  800659:	8b 45 10             	mov    0x10(%ebp),%eax
  80065c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800665:	8b 45 18             	mov    0x18(%ebp),%eax
  800668:	ba 00 00 00 00       	mov    $0x0,%edx
  80066d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800670:	77 55                	ja     8006c7 <printnum+0x75>
  800672:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800675:	72 05                	jb     80067c <printnum+0x2a>
  800677:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80067a:	77 4b                	ja     8006c7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80067c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80067f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800682:	8b 45 18             	mov    0x18(%ebp),%eax
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	52                   	push   %edx
  80068b:	50                   	push   %eax
  80068c:	ff 75 f4             	pushl  -0xc(%ebp)
  80068f:	ff 75 f0             	pushl  -0x10(%ebp)
  800692:	e8 d5 2d 00 00       	call   80346c <__udivdi3>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	83 ec 04             	sub    $0x4,%esp
  80069d:	ff 75 20             	pushl  0x20(%ebp)
  8006a0:	53                   	push   %ebx
  8006a1:	ff 75 18             	pushl  0x18(%ebp)
  8006a4:	52                   	push   %edx
  8006a5:	50                   	push   %eax
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	ff 75 08             	pushl  0x8(%ebp)
  8006ac:	e8 a1 ff ff ff       	call   800652 <printnum>
  8006b1:	83 c4 20             	add    $0x20,%esp
  8006b4:	eb 1a                	jmp    8006d0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 20             	pushl  0x20(%ebp)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	ff d0                	call   *%eax
  8006c4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006ca:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ce:	7f e6                	jg     8006b6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006de:	53                   	push   %ebx
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	50                   	push   %eax
  8006e2:	e8 95 2e 00 00       	call   80357c <__umoddi3>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	05 94 3c 80 00       	add    $0x803c94,%eax
  8006ef:	8a 00                	mov    (%eax),%al
  8006f1:	0f be c0             	movsbl %al,%eax
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
}
  800703:	90                   	nop
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800710:	7e 1c                	jle    80072e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	8d 50 08             	lea    0x8(%eax),%edx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 10                	mov    %edx,(%eax)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	83 e8 08             	sub    $0x8,%eax
  800727:	8b 50 04             	mov    0x4(%eax),%edx
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	eb 40                	jmp    80076e <getuint+0x65>
	else if (lflag)
  80072e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800732:	74 1e                	je     800752 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	8d 50 04             	lea    0x4(%eax),%edx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	89 10                	mov    %edx,(%eax)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	ba 00 00 00 00       	mov    $0x0,%edx
  800750:	eb 1c                	jmp    80076e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 50 04             	lea    0x4(%eax),%edx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 10                	mov    %edx,(%eax)
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 e8 04             	sub    $0x4,%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800773:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800777:	7e 1c                	jle    800795 <getint+0x25>
		return va_arg(*ap, long long);
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	8d 50 08             	lea    0x8(%eax),%edx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	89 10                	mov    %edx,(%eax)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	83 e8 08             	sub    $0x8,%eax
  80078e:	8b 50 04             	mov    0x4(%eax),%edx
  800791:	8b 00                	mov    (%eax),%eax
  800793:	eb 38                	jmp    8007cd <getint+0x5d>
	else if (lflag)
  800795:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800799:	74 1a                	je     8007b5 <getint+0x45>
		return va_arg(*ap, long);
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	8d 50 04             	lea    0x4(%eax),%edx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	89 10                	mov    %edx,(%eax)
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	83 e8 04             	sub    $0x4,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	99                   	cltd   
  8007b3:	eb 18                	jmp    8007cd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	8d 50 04             	lea    0x4(%eax),%edx
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	89 10                	mov    %edx,(%eax)
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	83 e8 04             	sub    $0x4,%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	99                   	cltd   
}
  8007cd:	5d                   	pop    %ebp
  8007ce:	c3                   	ret    

008007cf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	56                   	push   %esi
  8007d3:	53                   	push   %ebx
  8007d4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d7:	eb 17                	jmp    8007f0 <vprintfmt+0x21>
			if (ch == '\0')
  8007d9:	85 db                	test   %ebx,%ebx
  8007db:	0f 84 c1 03 00 00    	je     800ba2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	53                   	push   %ebx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f3:	8d 50 01             	lea    0x1(%eax),%edx
  8007f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f9:	8a 00                	mov    (%eax),%al
  8007fb:	0f b6 d8             	movzbl %al,%ebx
  8007fe:	83 fb 25             	cmp    $0x25,%ebx
  800801:	75 d6                	jne    8007d9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800803:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800807:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80080e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800815:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80081c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800823:	8b 45 10             	mov    0x10(%ebp),%eax
  800826:	8d 50 01             	lea    0x1(%eax),%edx
  800829:	89 55 10             	mov    %edx,0x10(%ebp)
  80082c:	8a 00                	mov    (%eax),%al
  80082e:	0f b6 d8             	movzbl %al,%ebx
  800831:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800834:	83 f8 5b             	cmp    $0x5b,%eax
  800837:	0f 87 3d 03 00 00    	ja     800b7a <vprintfmt+0x3ab>
  80083d:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
  800844:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800846:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80084a:	eb d7                	jmp    800823 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800850:	eb d1                	jmp    800823 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800859:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085c:	89 d0                	mov    %edx,%eax
  80085e:	c1 e0 02             	shl    $0x2,%eax
  800861:	01 d0                	add    %edx,%eax
  800863:	01 c0                	add    %eax,%eax
  800865:	01 d8                	add    %ebx,%eax
  800867:	83 e8 30             	sub    $0x30,%eax
  80086a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	8a 00                	mov    (%eax),%al
  800872:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800875:	83 fb 2f             	cmp    $0x2f,%ebx
  800878:	7e 3e                	jle    8008b8 <vprintfmt+0xe9>
  80087a:	83 fb 39             	cmp    $0x39,%ebx
  80087d:	7f 39                	jg     8008b8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800882:	eb d5                	jmp    800859 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80089a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089e:	79 83                	jns    800823 <vprintfmt+0x54>
				width = 0;
  8008a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a7:	e9 77 ff ff ff       	jmp    800823 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ac:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b3:	e9 6b ff ff ff       	jmp    800823 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bd:	0f 89 60 ff ff ff    	jns    800823 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d0:	e9 4e ff ff ff       	jmp    800823 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d8:	e9 46 ff ff ff       	jmp    800823 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	83 e8 04             	sub    $0x4,%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	50                   	push   %eax
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
			break;
  8008fd:	e9 9b 02 00 00       	jmp    800b9d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	83 c0 04             	add    $0x4,%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	83 e8 04             	sub    $0x4,%eax
  800911:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800913:	85 db                	test   %ebx,%ebx
  800915:	79 02                	jns    800919 <vprintfmt+0x14a>
				err = -err;
  800917:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800919:	83 fb 64             	cmp    $0x64,%ebx
  80091c:	7f 0b                	jg     800929 <vprintfmt+0x15a>
  80091e:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  800925:	85 f6                	test   %esi,%esi
  800927:	75 19                	jne    800942 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800929:	53                   	push   %ebx
  80092a:	68 a5 3c 80 00       	push   $0x803ca5
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	ff 75 08             	pushl  0x8(%ebp)
  800935:	e8 70 02 00 00       	call   800baa <printfmt>
  80093a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80093d:	e9 5b 02 00 00       	jmp    800b9d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800942:	56                   	push   %esi
  800943:	68 ae 3c 80 00       	push   $0x803cae
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	ff 75 08             	pushl  0x8(%ebp)
  80094e:	e8 57 02 00 00       	call   800baa <printfmt>
  800953:	83 c4 10             	add    $0x10,%esp
			break;
  800956:	e9 42 02 00 00       	jmp    800b9d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	83 c0 04             	add    $0x4,%eax
  800961:	89 45 14             	mov    %eax,0x14(%ebp)
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 30                	mov    (%eax),%esi
  80096c:	85 f6                	test   %esi,%esi
  80096e:	75 05                	jne    800975 <vprintfmt+0x1a6>
				p = "(null)";
  800970:	be b1 3c 80 00       	mov    $0x803cb1,%esi
			if (width > 0 && padc != '-')
  800975:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800979:	7e 6d                	jle    8009e8 <vprintfmt+0x219>
  80097b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80097f:	74 67                	je     8009e8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	50                   	push   %eax
  800988:	56                   	push   %esi
  800989:	e8 1e 03 00 00       	call   800cac <strnlen>
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800994:	eb 16                	jmp    8009ac <vprintfmt+0x1dd>
					putch(padc, putdat);
  800996:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 0c             	pushl  0xc(%ebp)
  8009a0:	50                   	push   %eax
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	ff d0                	call   *%eax
  8009a6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b0:	7f e4                	jg     800996 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b2:	eb 34                	jmp    8009e8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b8:	74 1c                	je     8009d6 <vprintfmt+0x207>
  8009ba:	83 fb 1f             	cmp    $0x1f,%ebx
  8009bd:	7e 05                	jle    8009c4 <vprintfmt+0x1f5>
  8009bf:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c2:	7e 12                	jle    8009d6 <vprintfmt+0x207>
					putch('?', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 3f                	push   $0x3f
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	eb 0f                	jmp    8009e5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	53                   	push   %ebx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	ff d0                	call   *%eax
  8009e2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e8:	89 f0                	mov    %esi,%eax
  8009ea:	8d 70 01             	lea    0x1(%eax),%esi
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	0f be d8             	movsbl %al,%ebx
  8009f2:	85 db                	test   %ebx,%ebx
  8009f4:	74 24                	je     800a1a <vprintfmt+0x24b>
  8009f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009fa:	78 b8                	js     8009b4 <vprintfmt+0x1e5>
  8009fc:	ff 4d e0             	decl   -0x20(%ebp)
  8009ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a03:	79 af                	jns    8009b4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a05:	eb 13                	jmp    800a1a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	6a 20                	push   $0x20
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a17:	ff 4d e4             	decl   -0x1c(%ebp)
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	7f e7                	jg     800a07 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a20:	e9 78 01 00 00       	jmp    800b9d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	e8 3c fd ff ff       	call   800770 <getint>
  800a34:	83 c4 10             	add    $0x10,%esp
  800a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a43:	85 d2                	test   %edx,%edx
  800a45:	79 23                	jns    800a6a <vprintfmt+0x29b>
				putch('-', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 2d                	push   $0x2d
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5d:	f7 d8                	neg    %eax
  800a5f:	83 d2 00             	adc    $0x0,%edx
  800a62:	f7 da                	neg    %edx
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a71:	e9 bc 00 00 00       	jmp    800b32 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7f:	50                   	push   %eax
  800a80:	e8 84 fc ff ff       	call   800709 <getuint>
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a8e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a95:	e9 98 00 00 00       	jmp    800b32 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 58                	push   $0x58
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 0c             	pushl  0xc(%ebp)
  800ab0:	6a 58                	push   $0x58
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	ff d0                	call   *%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 58                	push   $0x58
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			break;
  800aca:	e9 ce 00 00 00       	jmp    800b9d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	6a 30                	push   $0x30
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	6a 78                	push   $0x78
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	ff d0                	call   *%eax
  800aec:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 c0 04             	add    $0x4,%eax
  800af5:	89 45 14             	mov    %eax,0x14(%ebp)
  800af8:	8b 45 14             	mov    0x14(%ebp),%eax
  800afb:	83 e8 04             	sub    $0x4,%eax
  800afe:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b0a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b11:	eb 1f                	jmp    800b32 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	ff 75 e8             	pushl  -0x18(%ebp)
  800b19:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1c:	50                   	push   %eax
  800b1d:	e8 e7 fb ff ff       	call   800709 <getuint>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b32:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b39:	83 ec 04             	sub    $0x4,%esp
  800b3c:	52                   	push   %edx
  800b3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b40:	50                   	push   %eax
  800b41:	ff 75 f4             	pushl  -0xc(%ebp)
  800b44:	ff 75 f0             	pushl  -0x10(%ebp)
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	ff 75 08             	pushl  0x8(%ebp)
  800b4d:	e8 00 fb ff ff       	call   800652 <printnum>
  800b52:	83 c4 20             	add    $0x20,%esp
			break;
  800b55:	eb 46                	jmp    800b9d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	53                   	push   %ebx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	ff d0                	call   *%eax
  800b63:	83 c4 10             	add    $0x10,%esp
			break;
  800b66:	eb 35                	jmp    800b9d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b68:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b6f:	eb 2c                	jmp    800b9d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b71:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800b78:	eb 23                	jmp    800b9d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	6a 25                	push   $0x25
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b8a:	ff 4d 10             	decl   0x10(%ebp)
  800b8d:	eb 03                	jmp    800b92 <vprintfmt+0x3c3>
  800b8f:	ff 4d 10             	decl   0x10(%ebp)
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	48                   	dec    %eax
  800b96:	8a 00                	mov    (%eax),%al
  800b98:	3c 25                	cmp    $0x25,%al
  800b9a:	75 f3                	jne    800b8f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b9c:	90                   	nop
		}
	}
  800b9d:	e9 35 fc ff ff       	jmp    8007d7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb3:	83 c0 04             	add    $0x4,%eax
  800bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbf:	50                   	push   %eax
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	ff 75 08             	pushl  0x8(%ebp)
  800bc6:	e8 04 fc ff ff       	call   8007cf <vprintfmt>
  800bcb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bce:	90                   	nop
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 40 08             	mov    0x8(%eax),%eax
  800bda:	8d 50 01             	lea    0x1(%eax),%edx
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	8b 10                	mov    (%eax),%edx
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	8b 40 04             	mov    0x4(%eax),%eax
  800bee:	39 c2                	cmp    %eax,%edx
  800bf0:	73 12                	jae    800c04 <sprintputch+0x33>
		*b->buf++ = ch;
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	8b 00                	mov    (%eax),%eax
  800bf7:	8d 48 01             	lea    0x1(%eax),%ecx
  800bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfd:	89 0a                	mov    %ecx,(%edx)
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	88 10                	mov    %dl,(%eax)
}
  800c04:	90                   	nop
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	01 d0                	add    %edx,%eax
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2c:	74 06                	je     800c34 <vsnprintf+0x2d>
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	7f 07                	jg     800c3b <vsnprintf+0x34>
		return -E_INVAL;
  800c34:	b8 03 00 00 00       	mov    $0x3,%eax
  800c39:	eb 20                	jmp    800c5b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c3b:	ff 75 14             	pushl  0x14(%ebp)
  800c3e:	ff 75 10             	pushl  0x10(%ebp)
  800c41:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c44:	50                   	push   %eax
  800c45:	68 d1 0b 80 00       	push   $0x800bd1
  800c4a:	e8 80 fb ff ff       	call   8007cf <vprintfmt>
  800c4f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c55:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c5b:	c9                   	leave  
  800c5c:	c3                   	ret    

00800c5d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c63:	8d 45 10             	lea    0x10(%ebp),%eax
  800c66:	83 c0 04             	add    $0x4,%eax
  800c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	ff 75 08             	pushl  0x8(%ebp)
  800c79:	e8 89 ff ff ff       	call   800c07 <vsnprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c96:	eb 06                	jmp    800c9e <strlen+0x15>
		n++;
  800c98:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9b:	ff 45 08             	incl   0x8(%ebp)
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 f1                	jne    800c98 <strlen+0xf>
		n++;
	return n;
  800ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    

00800cac <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb9:	eb 09                	jmp    800cc4 <strnlen+0x18>
		n++;
  800cbb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 4d 0c             	decl   0xc(%ebp)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 09                	je     800cd3 <strnlen+0x27>
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	84 c0                	test   %al,%al
  800cd1:	75 e8                	jne    800cbb <strnlen+0xf>
		n++;
	return n;
  800cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ce4:	90                   	nop
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8d 50 01             	lea    0x1(%eax),%edx
  800ceb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf7:	8a 12                	mov    (%edx),%dl
  800cf9:	88 10                	mov    %dl,(%eax)
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 e4                	jne    800ce5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d19:	eb 1f                	jmp    800d3a <strncpy+0x34>
		*dst++ = *src;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8d 50 01             	lea    0x1(%eax),%edx
  800d21:	89 55 08             	mov    %edx,0x8(%ebp)
  800d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d27:	8a 12                	mov    (%edx),%dl
  800d29:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	74 03                	je     800d37 <strncpy+0x31>
			src++;
  800d34:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
  800d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d40:	72 d9                	jb     800d1b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d42:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d57:	74 30                	je     800d89 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d59:	eb 16                	jmp    800d71 <strlcpy+0x2a>
			*dst++ = *src++;
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8d 50 01             	lea    0x1(%eax),%edx
  800d61:	89 55 08             	mov    %edx,0x8(%ebp)
  800d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d6d:	8a 12                	mov    (%edx),%dl
  800d6f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d71:	ff 4d 10             	decl   0x10(%ebp)
  800d74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d78:	74 09                	je     800d83 <strlcpy+0x3c>
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	84 c0                	test   %al,%al
  800d81:	75 d8                	jne    800d5b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8f:	29 c2                	sub    %eax,%edx
  800d91:	89 d0                	mov    %edx,%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d98:	eb 06                	jmp    800da0 <strcmp+0xb>
		p++, q++;
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	84 c0                	test   %al,%al
  800da7:	74 0e                	je     800db7 <strcmp+0x22>
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 10                	mov    (%eax),%dl
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	38 c2                	cmp    %al,%dl
  800db5:	74 e3                	je     800d9a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	0f b6 d0             	movzbl %al,%edx
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 c0             	movzbl %al,%eax
  800dc7:	29 c2                	sub    %eax,%edx
  800dc9:	89 d0                	mov    %edx,%eax
}
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd0:	eb 09                	jmp    800ddb <strncmp+0xe>
		n--, p++, q++;
  800dd2:	ff 4d 10             	decl   0x10(%ebp)
  800dd5:	ff 45 08             	incl   0x8(%ebp)
  800dd8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ddb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddf:	74 17                	je     800df8 <strncmp+0x2b>
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	74 0e                	je     800df8 <strncmp+0x2b>
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 10                	mov    (%eax),%dl
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	38 c2                	cmp    %al,%dl
  800df6:	74 da                	je     800dd2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800df8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfc:	75 07                	jne    800e05 <strncmp+0x38>
		return 0;
  800dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800e03:	eb 14                	jmp    800e19 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	0f b6 d0             	movzbl %al,%edx
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	0f b6 c0             	movzbl %al,%eax
  800e15:	29 c2                	sub    %eax,%edx
  800e17:	89 d0                	mov    %edx,%eax
}
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 04             	sub    $0x4,%esp
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e27:	eb 12                	jmp    800e3b <strchr+0x20>
		if (*s == c)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e31:	75 05                	jne    800e38 <strchr+0x1d>
			return (char *) s;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	eb 11                	jmp    800e49 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e38:	ff 45 08             	incl   0x8(%ebp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 e5                	jne    800e29 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e57:	eb 0d                	jmp    800e66 <strfind+0x1b>
		if (*s == c)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e61:	74 0e                	je     800e71 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 ea                	jne    800e59 <strfind+0xe>
  800e6f:	eb 01                	jmp    800e72 <strfind+0x27>
		if (*s == c)
			break;
  800e71:	90                   	nop
	return (char *) s;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e87:	76 63                	jbe    800eec <memset+0x75>
		uint64 data_block = c;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	99                   	cltd   
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e90:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e99:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e9d:	c1 e0 08             	shl    $0x8,%eax
  800ea0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eac:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb0:	c1 e0 10             	shl    $0x10,%eax
  800eb3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebf:	89 c2                	mov    %eax,%edx
  800ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ecc:	eb 18                	jmp    800ee6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ece:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed1:	8d 41 08             	lea    0x8(%ecx),%eax
  800ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edd:	89 01                	mov    %eax,(%ecx)
  800edf:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ee6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eea:	77 e2                	ja     800ece <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef0:	74 23                	je     800f15 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 0e                	jmp    800f08 <memset+0x91>
			*p8++ = (uint8)c;
  800efa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	75 e5                	jne    800efa <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f2c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f30:	76 24                	jbe    800f56 <memcpy+0x3c>
		while(n >= 8){
  800f32:	eb 1c                	jmp    800f50 <memcpy+0x36>
			*d64 = *s64;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8b 50 04             	mov    0x4(%eax),%edx
  800f3a:	8b 00                	mov    (%eax),%eax
  800f3c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f3f:	89 01                	mov    %eax,(%ecx)
  800f41:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f44:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f48:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f4c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f50:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f54:	77 de                	ja     800f34 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5a:	74 31                	je     800f8d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f68:	eb 16                	jmp    800f80 <memcpy+0x66>
			*d8++ = *s8++;
  800f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6d:	8d 50 01             	lea    0x1(%eax),%edx
  800f70:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f79:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f7c:	8a 12                	mov    (%edx),%dl
  800f7e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f80:	8b 45 10             	mov    0x10(%ebp),%eax
  800f83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f86:	89 55 10             	mov    %edx,0x10(%ebp)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	75 dd                	jne    800f6a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800faa:	73 50                	jae    800ffc <memmove+0x6a>
  800fac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	01 d0                	add    %edx,%eax
  800fb4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb7:	76 43                	jbe    800ffc <memmove+0x6a>
		s += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc5:	eb 10                	jmp    800fd7 <memmove+0x45>
			*--d = *--s;
  800fc7:	ff 4d f8             	decl   -0x8(%ebp)
  800fca:	ff 4d fc             	decl   -0x4(%ebp)
  800fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd0:	8a 10                	mov    (%eax),%dl
  800fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	75 e3                	jne    800fc7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe4:	eb 23                	jmp    801009 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	8d 50 01             	lea    0x1(%eax),%edx
  800fec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff8:	8a 12                	mov    (%edx),%dl
  800ffa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801002:	89 55 10             	mov    %edx,0x10(%ebp)
  801005:	85 c0                	test   %eax,%eax
  801007:	75 dd                	jne    800fe6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80101a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801020:	eb 2a                	jmp    80104c <memcmp+0x3e>
		if (*s1 != *s2)
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 10                	mov    (%eax),%dl
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	38 c2                	cmp    %al,%dl
  80102e:	74 16                	je     801046 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801030:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f b6 d0             	movzbl %al,%edx
  801038:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f b6 c0             	movzbl %al,%eax
  801040:	29 c2                	sub    %eax,%edx
  801042:	89 d0                	mov    %edx,%eax
  801044:	eb 18                	jmp    80105e <memcmp+0x50>
		s1++, s2++;
  801046:	ff 45 fc             	incl   -0x4(%ebp)
  801049:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801052:	89 55 10             	mov    %edx,0x10(%ebp)
  801055:	85 c0                	test   %eax,%eax
  801057:	75 c9                	jne    801022 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    

00801060 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	01 d0                	add    %edx,%eax
  80106e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801071:	eb 15                	jmp    801088 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f b6 d0             	movzbl %al,%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	0f b6 c0             	movzbl %al,%eax
  801081:	39 c2                	cmp    %eax,%edx
  801083:	74 0d                	je     801092 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801085:	ff 45 08             	incl   0x8(%ebp)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80108e:	72 e3                	jb     801073 <memfind+0x13>
  801090:	eb 01                	jmp    801093 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801092:	90                   	nop
	return (void *) s;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ac:	eb 03                	jmp    8010b1 <strtol+0x19>
		s++;
  8010ae:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 20                	cmp    $0x20,%al
  8010b8:	74 f4                	je     8010ae <strtol+0x16>
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 09                	cmp    $0x9,%al
  8010c1:	74 eb                	je     8010ae <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2b                	cmp    $0x2b,%al
  8010ca:	75 05                	jne    8010d1 <strtol+0x39>
		s++;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	eb 13                	jmp    8010e4 <strtol+0x4c>
	else if (*s == '-')
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	3c 2d                	cmp    $0x2d,%al
  8010d8:	75 0a                	jne    8010e4 <strtol+0x4c>
		s++, neg = 1;
  8010da:	ff 45 08             	incl   0x8(%ebp)
  8010dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e8:	74 06                	je     8010f0 <strtol+0x58>
  8010ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ee:	75 20                	jne    801110 <strtol+0x78>
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	3c 30                	cmp    $0x30,%al
  8010f7:	75 17                	jne    801110 <strtol+0x78>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	40                   	inc    %eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	3c 78                	cmp    $0x78,%al
  801101:	75 0d                	jne    801110 <strtol+0x78>
		s += 2, base = 16;
  801103:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801107:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80110e:	eb 28                	jmp    801138 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	75 15                	jne    80112b <strtol+0x93>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	3c 30                	cmp    $0x30,%al
  80111d:	75 0c                	jne    80112b <strtol+0x93>
		s++, base = 8;
  80111f:	ff 45 08             	incl   0x8(%ebp)
  801122:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801129:	eb 0d                	jmp    801138 <strtol+0xa0>
	else if (base == 0)
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	75 07                	jne    801138 <strtol+0xa0>
		base = 10;
  801131:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 2f                	cmp    $0x2f,%al
  80113f:	7e 19                	jle    80115a <strtol+0xc2>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 39                	cmp    $0x39,%al
  801148:	7f 10                	jg     80115a <strtol+0xc2>
			dig = *s - '0';
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	83 e8 30             	sub    $0x30,%eax
  801155:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801158:	eb 42                	jmp    80119c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 60                	cmp    $0x60,%al
  801161:	7e 19                	jle    80117c <strtol+0xe4>
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	3c 7a                	cmp    $0x7a,%al
  80116a:	7f 10                	jg     80117c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	0f be c0             	movsbl %al,%eax
  801174:	83 e8 57             	sub    $0x57,%eax
  801177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117a:	eb 20                	jmp    80119c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 40                	cmp    $0x40,%al
  801183:	7e 39                	jle    8011be <strtol+0x126>
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 5a                	cmp    $0x5a,%al
  80118c:	7f 30                	jg     8011be <strtol+0x126>
			dig = *s - 'A' + 10;
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	0f be c0             	movsbl %al,%eax
  801196:	83 e8 37             	sub    $0x37,%eax
  801199:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a2:	7d 19                	jge    8011bd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a4:	ff 45 08             	incl   0x8(%ebp)
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b8:	e9 7b ff ff ff       	jmp    801138 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011bd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c2:	74 08                	je     8011cc <strtol+0x134>
		*endptr = (char *) s;
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ca:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d0:	74 07                	je     8011d9 <strtol+0x141>
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d5:	f7 d8                	neg    %eax
  8011d7:	eb 03                	jmp    8011dc <strtol+0x144>
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <ltostr>:

void
ltostr(long value, char *str)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f6:	79 13                	jns    80120b <ltostr+0x2d>
	{
		neg = 1;
  8011f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801205:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801208:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801213:	99                   	cltd   
  801214:	f7 f9                	idiv   %ecx
  801216:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801219:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801222:	89 c2                	mov    %eax,%edx
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122c:	83 c2 30             	add    $0x30,%edx
  80122f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801234:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801239:	f7 e9                	imul   %ecx
  80123b:	c1 fa 02             	sar    $0x2,%edx
  80123e:	89 c8                	mov    %ecx,%eax
  801240:	c1 f8 1f             	sar    $0x1f,%eax
  801243:	29 c2                	sub    %eax,%edx
  801245:	89 d0                	mov    %edx,%eax
  801247:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80124a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80124e:	75 bb                	jne    80120b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801257:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125a:	48                   	dec    %eax
  80125b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80125e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801262:	74 3d                	je     8012a1 <ltostr+0xc3>
		start = 1 ;
  801264:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80126b:	eb 34                	jmp    8012a1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	01 d0                	add    %edx,%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80127a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	01 c8                	add    %ecx,%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80128e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	01 c2                	add    %eax,%edx
  801296:	8a 45 eb             	mov    -0x15(%ebp),%al
  801299:	88 02                	mov    %al,(%edx)
		start++ ;
  80129b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80129e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a7:	7c c4                	jl     80126d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 d0                	add    %edx,%eax
  8012b1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b4:	90                   	nop
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	e8 c4 f9 ff ff       	call   800c89 <strlen>
  8012c5:	83 c4 04             	add    $0x4,%esp
  8012c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012cb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ce:	e8 b6 f9 ff ff       	call   800c89 <strlen>
  8012d3:	83 c4 04             	add    $0x4,%esp
  8012d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e7:	eb 17                	jmp    801300 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 c2                	add    %eax,%edx
  8012f1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	01 c8                	add    %ecx,%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012fd:	ff 45 fc             	incl   -0x4(%ebp)
  801300:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801303:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801306:	7c e1                	jl     8012e9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801308:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80130f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801316:	eb 1f                	jmp    801337 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801318:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801321:	89 c2                	mov    %eax,%edx
  801323:	8b 45 10             	mov    0x10(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801334:	ff 45 f8             	incl   -0x8(%ebp)
  801337:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133d:	7c d9                	jl     801318 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80133f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801342:	8b 45 10             	mov    0x10(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	c6 00 00             	movb   $0x0,(%eax)
}
  80134a:	90                   	nop
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801350:	8b 45 14             	mov    0x14(%ebp),%eax
  801353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801365:	8b 45 10             	mov    0x10(%ebp),%eax
  801368:	01 d0                	add    %edx,%eax
  80136a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801370:	eb 0c                	jmp    80137e <strsplit+0x31>
			*string++ = 0;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8d 50 01             	lea    0x1(%eax),%edx
  801378:	89 55 08             	mov    %edx,0x8(%ebp)
  80137b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	84 c0                	test   %al,%al
  801385:	74 18                	je     80139f <strsplit+0x52>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f be c0             	movsbl %al,%eax
  80138f:	50                   	push   %eax
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	e8 83 fa ff ff       	call   800e1b <strchr>
  801398:	83 c4 08             	add    $0x8,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	75 d3                	jne    801372 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	84 c0                	test   %al,%al
  8013a6:	74 5a                	je     801402 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ab:	8b 00                	mov    (%eax),%eax
  8013ad:	83 f8 0f             	cmp    $0xf,%eax
  8013b0:	75 07                	jne    8013b9 <strsplit+0x6c>
		{
			return 0;
  8013b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b7:	eb 66                	jmp    80141f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c4:	89 0a                	mov    %ecx,(%edx)
  8013c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	01 c2                	add    %eax,%edx
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d7:	eb 03                	jmp    8013dc <strsplit+0x8f>
			string++;
  8013d9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	84 c0                	test   %al,%al
  8013e3:	74 8b                	je     801370 <strsplit+0x23>
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	0f be c0             	movsbl %al,%eax
  8013ed:	50                   	push   %eax
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	e8 25 fa ff ff       	call   800e1b <strchr>
  8013f6:	83 c4 08             	add    $0x8,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	74 dc                	je     8013d9 <strsplit+0x8c>
			string++;
	}
  8013fd:	e9 6e ff ff ff       	jmp    801370 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801402:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801403:	8b 45 14             	mov    0x14(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140f:	8b 45 10             	mov    0x10(%ebp),%eax
  801412:	01 d0                	add    %edx,%eax
  801414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80141a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80142d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801434:	eb 4a                	jmp    801480 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801436:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	01 c2                	add    %eax,%edx
  80143e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 c8                	add    %ecx,%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 40                	cmp    $0x40,%al
  801456:	7e 25                	jle    80147d <str2lower+0x5c>
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 5a                	cmp    $0x5a,%al
  801464:	7f 17                	jg     80147d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801466:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801471:	8b 55 08             	mov    0x8(%ebp),%edx
  801474:	01 ca                	add    %ecx,%edx
  801476:	8a 12                	mov    (%edx),%dl
  801478:	83 c2 20             	add    $0x20,%edx
  80147b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80147d:	ff 45 fc             	incl   -0x4(%ebp)
  801480:	ff 75 0c             	pushl  0xc(%ebp)
  801483:	e8 01 f8 ff ff       	call   800c89 <strlen>
  801488:	83 c4 04             	add    $0x4,%esp
  80148b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80148e:	7f a6                	jg     801436 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80149b:	83 ec 0c             	sub    $0xc,%esp
  80149e:	6a 10                	push   $0x10
  8014a0:	e8 b2 15 00 00       	call   802a57 <alloc_block>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8014ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014af:	75 14                	jne    8014c5 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	68 28 3e 80 00       	push   $0x803e28
  8014b9:	6a 14                	push   $0x14
  8014bb:	68 51 3e 80 00       	push   $0x803e51
  8014c0:	e8 fd ed ff ff       	call   8002c2 <_panic>

	node->start = start;
  8014c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cb:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8014cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8014d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8014dd:	a1 24 50 80 00       	mov    0x805024,%eax
  8014e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e5:	eb 18                	jmp    8014ff <insert_page_alloc+0x6a>
		if (start < it->start)
  8014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014ef:	77 37                	ja     801528 <insert_page_alloc+0x93>
			break;
		prev = it;
  8014f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8014f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8014fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801503:	74 08                	je     80150d <insert_page_alloc+0x78>
  801505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801508:	8b 40 08             	mov    0x8(%eax),%eax
  80150b:	eb 05                	jmp    801512 <insert_page_alloc+0x7d>
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
  801512:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801517:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80151c:	85 c0                	test   %eax,%eax
  80151e:	75 c7                	jne    8014e7 <insert_page_alloc+0x52>
  801520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801524:	75 c1                	jne    8014e7 <insert_page_alloc+0x52>
  801526:	eb 01                	jmp    801529 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801528:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801529:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80152d:	75 64                	jne    801593 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80152f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801533:	75 14                	jne    801549 <insert_page_alloc+0xb4>
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	68 60 3e 80 00       	push   $0x803e60
  80153d:	6a 21                	push   $0x21
  80153f:	68 51 3e 80 00       	push   $0x803e51
  801544:	e8 79 ed ff ff       	call   8002c2 <_panic>
  801549:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80154f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801552:	89 50 08             	mov    %edx,0x8(%eax)
  801555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801558:	8b 40 08             	mov    0x8(%eax),%eax
  80155b:	85 c0                	test   %eax,%eax
  80155d:	74 0d                	je     80156c <insert_page_alloc+0xd7>
  80155f:	a1 24 50 80 00       	mov    0x805024,%eax
  801564:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801567:	89 50 0c             	mov    %edx,0xc(%eax)
  80156a:	eb 08                	jmp    801574 <insert_page_alloc+0xdf>
  80156c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156f:	a3 28 50 80 00       	mov    %eax,0x805028
  801574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801577:	a3 24 50 80 00       	mov    %eax,0x805024
  80157c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801586:	a1 30 50 80 00       	mov    0x805030,%eax
  80158b:	40                   	inc    %eax
  80158c:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801591:	eb 71                	jmp    801604 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801593:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801597:	74 06                	je     80159f <insert_page_alloc+0x10a>
  801599:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80159d:	75 14                	jne    8015b3 <insert_page_alloc+0x11e>
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	68 84 3e 80 00       	push   $0x803e84
  8015a7:	6a 23                	push   $0x23
  8015a9:	68 51 3e 80 00       	push   $0x803e51
  8015ae:	e8 0f ed ff ff       	call   8002c2 <_panic>
  8015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b6:	8b 50 08             	mov    0x8(%eax),%edx
  8015b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bc:	89 50 08             	mov    %edx,0x8(%eax)
  8015bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c2:	8b 40 08             	mov    0x8(%eax),%eax
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 0c                	je     8015d5 <insert_page_alloc+0x140>
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	8b 40 08             	mov    0x8(%eax),%eax
  8015cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015d2:	89 50 0c             	mov    %edx,0xc(%eax)
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015db:	89 50 08             	mov    %edx,0x8(%eax)
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e4:	89 50 0c             	mov    %edx,0xc(%eax)
  8015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ea:	8b 40 08             	mov    0x8(%eax),%eax
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	75 08                	jne    8015f9 <insert_page_alloc+0x164>
  8015f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f4:	a3 28 50 80 00       	mov    %eax,0x805028
  8015f9:	a1 30 50 80 00       	mov    0x805030,%eax
  8015fe:	40                   	inc    %eax
  8015ff:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801604:	90                   	nop
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80160d:	a1 24 50 80 00       	mov    0x805024,%eax
  801612:	85 c0                	test   %eax,%eax
  801614:	75 0c                	jne    801622 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801616:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80161b:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801620:	eb 67                	jmp    801689 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801622:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801627:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80162a:	a1 24 50 80 00       	mov    0x805024,%eax
  80162f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801632:	eb 26                	jmp    80165a <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801634:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801637:	8b 10                	mov    (%eax),%edx
  801639:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163c:	8b 40 04             	mov    0x4(%eax),%eax
  80163f:	01 d0                	add    %edx,%eax
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80164a:	76 06                	jbe    801652 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801652:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801657:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80165a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80165e:	74 08                	je     801668 <recompute_page_alloc_break+0x61>
  801660:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801663:	8b 40 08             	mov    0x8(%eax),%eax
  801666:	eb 05                	jmp    80166d <recompute_page_alloc_break+0x66>
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
  80166d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801672:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801677:	85 c0                	test   %eax,%eax
  801679:	75 b9                	jne    801634 <recompute_page_alloc_break+0x2d>
  80167b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80167f:	75 b3                	jne    801634 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801684:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801691:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801698:	8b 55 08             	mov    0x8(%ebp),%edx
  80169b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	48                   	dec    %eax
  8016a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	f7 75 d8             	divl   -0x28(%ebp)
  8016af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016b2:	29 d0                	sub    %edx,%eax
  8016b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8016b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8016bb:	75 0a                	jne    8016c7 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8016bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c2:	e9 7e 01 00 00       	jmp    801845 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8016c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8016ce:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  8016d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  8016d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8016e0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8016e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8016e8:	a1 24 50 80 00       	mov    0x805024,%eax
  8016ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016f0:	eb 69                	jmp    80175b <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8016f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8016fa:	76 47                	jbe    801743 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8016fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801705:	8b 00                	mov    (%eax),%eax
  801707:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80170a:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80170d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801710:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801713:	72 2e                	jb     801743 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801715:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801719:	75 14                	jne    80172f <alloc_pages_custom_fit+0xa4>
  80171b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80171e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801721:	75 0c                	jne    80172f <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801723:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801726:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801729:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80172d:	eb 14                	jmp    801743 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80172f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801732:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801735:	76 0c                	jbe    801743 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801737:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80173a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80173d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801740:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801746:	8b 10                	mov    (%eax),%edx
  801748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174b:	8b 40 04             	mov    0x4(%eax),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801753:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801758:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80175b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80175f:	74 08                	je     801769 <alloc_pages_custom_fit+0xde>
  801761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801764:	8b 40 08             	mov    0x8(%eax),%eax
  801767:	eb 05                	jmp    80176e <alloc_pages_custom_fit+0xe3>
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801773:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801778:	85 c0                	test   %eax,%eax
  80177a:	0f 85 72 ff ff ff    	jne    8016f2 <alloc_pages_custom_fit+0x67>
  801780:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801784:	0f 85 68 ff ff ff    	jne    8016f2 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80178a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80178f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801792:	76 47                	jbe    8017db <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801797:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80179a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80179f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8017a2:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8017a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017a8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017ab:	72 2e                	jb     8017db <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8017ad:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017b1:	75 14                	jne    8017c7 <alloc_pages_custom_fit+0x13c>
  8017b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017b6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017b9:	75 0c                	jne    8017c7 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8017bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8017c1:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8017c5:	eb 14                	jmp    8017db <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8017c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017cd:	76 0c                	jbe    8017db <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8017cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  8017d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  8017db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8017e2:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017e6:	74 08                	je     8017f0 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017ee:	eb 40                	jmp    801830 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  8017f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f4:	74 08                	je     8017fe <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8017f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017fc:	eb 32                	jmp    801830 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8017fe:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801803:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801806:	89 c2                	mov    %eax,%edx
  801808:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80180d:	39 c2                	cmp    %eax,%edx
  80180f:	73 07                	jae    801818 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801811:	b8 00 00 00 00       	mov    $0x0,%eax
  801816:	eb 2d                	jmp    801845 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801818:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80181d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801820:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801826:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801829:	01 d0                	add    %edx,%eax
  80182b:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801830:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	ff 75 d0             	pushl  -0x30(%ebp)
  801839:	50                   	push   %eax
  80183a:	e8 56 fc ff ff       	call   801495 <insert_page_alloc>
  80183f:	83 c4 10             	add    $0x10,%esp

	return result;
  801842:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801853:	a1 24 50 80 00       	mov    0x805024,%eax
  801858:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80185b:	eb 1a                	jmp    801877 <find_allocated_size+0x30>
		if (it->start == va)
  80185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801865:	75 08                	jne    80186f <find_allocated_size+0x28>
			return it->size;
  801867:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80186a:	8b 40 04             	mov    0x4(%eax),%eax
  80186d:	eb 34                	jmp    8018a3 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80186f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801874:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801877:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80187b:	74 08                	je     801885 <find_allocated_size+0x3e>
  80187d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801880:	8b 40 08             	mov    0x8(%eax),%eax
  801883:	eb 05                	jmp    80188a <find_allocated_size+0x43>
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
  80188a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80188f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801894:	85 c0                	test   %eax,%eax
  801896:	75 c5                	jne    80185d <find_allocated_size+0x16>
  801898:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80189c:	75 bf                	jne    80185d <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018b1:	a1 24 50 80 00       	mov    0x805024,%eax
  8018b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018b9:	e9 e1 01 00 00       	jmp    801a9f <free_pages+0x1fa>
		if (it->start == va) {
  8018be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c1:	8b 00                	mov    (%eax),%eax
  8018c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8018c6:	0f 85 cb 01 00 00    	jne    801a97 <free_pages+0x1f2>

			uint32 start = it->start;
  8018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cf:	8b 00                	mov    (%eax),%eax
  8018d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	8b 40 04             	mov    0x4(%eax),%eax
  8018da:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  8018dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e0:	f7 d0                	not    %eax
  8018e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018e5:	73 1d                	jae    801904 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8018f0:	68 b8 3e 80 00       	push   $0x803eb8
  8018f5:	68 a5 00 00 00       	push   $0xa5
  8018fa:	68 51 3e 80 00       	push   $0x803e51
  8018ff:	e8 be e9 ff ff       	call   8002c2 <_panic>
			}

			uint32 start_end = start + size;
  801904:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190a:	01 d0                	add    %edx,%eax
  80190c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80190f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801912:	85 c0                	test   %eax,%eax
  801914:	79 19                	jns    80192f <free_pages+0x8a>
  801916:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80191d:	77 10                	ja     80192f <free_pages+0x8a>
  80191f:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801926:	77 07                	ja     80192f <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 2c                	js     80195b <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80192f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	68 00 00 00 a0       	push   $0xa0000000
  80193a:	ff 75 e0             	pushl  -0x20(%ebp)
  80193d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801940:	ff 75 e8             	pushl  -0x18(%ebp)
  801943:	ff 75 e4             	pushl  -0x1c(%ebp)
  801946:	50                   	push   %eax
  801947:	68 fc 3e 80 00       	push   $0x803efc
  80194c:	68 ad 00 00 00       	push   $0xad
  801951:	68 51 3e 80 00       	push   $0x803e51
  801956:	e8 67 e9 ff ff       	call   8002c2 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80195b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801961:	e9 88 00 00 00       	jmp    8019ee <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801966:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  80196d:	76 17                	jbe    801986 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  80196f:	ff 75 f0             	pushl  -0x10(%ebp)
  801972:	68 60 3f 80 00       	push   $0x803f60
  801977:	68 b4 00 00 00       	push   $0xb4
  80197c:	68 51 3e 80 00       	push   $0x803e51
  801981:	e8 3c e9 ff ff       	call   8002c2 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801989:	05 00 10 00 00       	add    $0x1000,%eax
  80198e:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801994:	85 c0                	test   %eax,%eax
  801996:	79 2e                	jns    8019c6 <free_pages+0x121>
  801998:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80199f:	77 25                	ja     8019c6 <free_pages+0x121>
  8019a1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8019a8:	77 1c                	ja     8019c6 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	68 00 10 00 00       	push   $0x1000
  8019b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b5:	e8 38 0d 00 00       	call   8026f2 <sys_free_user_mem>
  8019ba:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019bd:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8019c4:	eb 28                	jmp    8019ee <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8019c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c9:	68 00 00 00 a0       	push   $0xa0000000
  8019ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8019d1:	68 00 10 00 00       	push   $0x1000
  8019d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d9:	50                   	push   %eax
  8019da:	68 a0 3f 80 00       	push   $0x803fa0
  8019df:	68 bd 00 00 00       	push   $0xbd
  8019e4:	68 51 3e 80 00       	push   $0x803e51
  8019e9:	e8 d4 e8 ff ff       	call   8002c2 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019f4:	0f 82 6c ff ff ff    	jb     801966 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8019fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019fe:	75 17                	jne    801a17 <free_pages+0x172>
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 02 40 80 00       	push   $0x804002
  801a08:	68 c1 00 00 00       	push   $0xc1
  801a0d:	68 51 3e 80 00       	push   $0x803e51
  801a12:	e8 ab e8 ff ff       	call   8002c2 <_panic>
  801a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1a:	8b 40 08             	mov    0x8(%eax),%eax
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	74 11                	je     801a32 <free_pages+0x18d>
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	8b 40 08             	mov    0x8(%eax),%eax
  801a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a2d:	89 50 0c             	mov    %edx,0xc(%eax)
  801a30:	eb 0b                	jmp    801a3d <free_pages+0x198>
  801a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a35:	8b 40 0c             	mov    0xc(%eax),%eax
  801a38:	a3 28 50 80 00       	mov    %eax,0x805028
  801a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a40:	8b 40 0c             	mov    0xc(%eax),%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	74 11                	je     801a58 <free_pages+0x1b3>
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a50:	8b 52 08             	mov    0x8(%edx),%edx
  801a53:	89 50 08             	mov    %edx,0x8(%eax)
  801a56:	eb 0b                	jmp    801a63 <free_pages+0x1be>
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	8b 40 08             	mov    0x8(%eax),%eax
  801a5e:	a3 24 50 80 00       	mov    %eax,0x805024
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a77:	a1 30 50 80 00       	mov    0x805030,%eax
  801a7c:	48                   	dec    %eax
  801a7d:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	ff 75 f4             	pushl  -0xc(%ebp)
  801a88:	e8 24 15 00 00       	call   802fb1 <free_block>
  801a8d:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801a90:	e8 72 fb ff ff       	call   801607 <recompute_page_alloc_break>

			return;
  801a95:	eb 37                	jmp    801ace <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a97:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aa3:	74 08                	je     801aad <free_pages+0x208>
  801aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa8:	8b 40 08             	mov    0x8(%eax),%eax
  801aab:	eb 05                	jmp    801ab2 <free_pages+0x20d>
  801aad:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ab7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801abc:	85 c0                	test   %eax,%eax
  801abe:	0f 85 fa fd ff ff    	jne    8018be <free_pages+0x19>
  801ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac8:	0f 85 f0 fd ff ff    	jne    8018be <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad8:	5d                   	pop    %ebp
  801ad9:	c3                   	ret    

00801ada <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ae0:	a1 08 50 80 00       	mov    0x805008,%eax
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	74 60                	je     801b49 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	68 00 00 00 82       	push   $0x82000000
  801af1:	68 00 00 00 80       	push   $0x80000000
  801af6:	e8 0d 0d 00 00       	call   802808 <initialize_dynamic_allocator>
  801afb:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801afe:	e8 f3 0a 00 00       	call   8025f6 <sys_get_uheap_strategy>
  801b03:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b08:	a1 40 50 80 00       	mov    0x805040,%eax
  801b0d:	05 00 10 00 00       	add    $0x1000,%eax
  801b12:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b17:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b1c:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801b21:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801b28:	00 00 00 
  801b2b:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801b32:	00 00 00 
  801b35:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801b3c:	00 00 00 

		__firstTimeFlag = 0;
  801b3f:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b60:	83 ec 08             	sub    $0x8,%esp
  801b63:	68 06 04 00 00       	push   $0x406
  801b68:	50                   	push   %eax
  801b69:	e8 d2 06 00 00       	call   802240 <__sys_allocate_page>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b78:	79 17                	jns    801b91 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	68 20 40 80 00       	push   $0x804020
  801b82:	68 ea 00 00 00       	push   $0xea
  801b87:	68 51 3e 80 00       	push   $0x803e51
  801b8c:	e8 31 e7 ff ff       	call   8002c2 <_panic>
	return 0;
  801b91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	50                   	push   %eax
  801bb0:	e8 d2 06 00 00       	call   802287 <__sys_unmap_frame>
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bbf:	79 17                	jns    801bd8 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	68 5c 40 80 00       	push   $0x80405c
  801bc9:	68 f5 00 00 00       	push   $0xf5
  801bce:	68 51 3e 80 00       	push   $0x803e51
  801bd3:	e8 ea e6 ff ff       	call   8002c2 <_panic>
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801be1:	e8 f4 fe ff ff       	call   801ada <uheap_init>
	if (size == 0) return NULL ;
  801be6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bea:	75 0a                	jne    801bf6 <malloc+0x1b>
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf1:	e9 67 01 00 00       	jmp    801d5d <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801bfd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c04:	77 16                	ja     801c1c <malloc+0x41>
		result = alloc_block(size);
  801c06:	83 ec 0c             	sub    $0xc,%esp
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	e8 46 0e 00 00       	call   802a57 <alloc_block>
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c17:	e9 3e 01 00 00       	jmp    801d5a <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801c1c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c23:	8b 55 08             	mov    0x8(%ebp),%edx
  801c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c29:	01 d0                	add    %edx,%eax
  801c2b:	48                   	dec    %eax
  801c2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c32:	ba 00 00 00 00       	mov    $0x0,%edx
  801c37:	f7 75 f0             	divl   -0x10(%ebp)
  801c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3d:	29 d0                	sub    %edx,%eax
  801c3f:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801c42:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c47:	85 c0                	test   %eax,%eax
  801c49:	75 0a                	jne    801c55 <malloc+0x7a>
			return NULL;
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	e9 08 01 00 00       	jmp    801d5d <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801c55:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 0f                	je     801c6d <malloc+0x92>
  801c5e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801c64:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c69:	39 c2                	cmp    %eax,%edx
  801c6b:	73 0a                	jae    801c77 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801c6d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c72:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801c77:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801c7c:	83 f8 05             	cmp    $0x5,%eax
  801c7f:	75 11                	jne    801c92 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 e8             	pushl  -0x18(%ebp)
  801c87:	e8 ff f9 ff ff       	call   80168b <alloc_pages_custom_fit>
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c96:	0f 84 be 00 00 00    	je     801d5a <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca8:	e8 9a fb ff ff       	call   801847 <find_allocated_size>
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801cb3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cb7:	75 17                	jne    801cd0 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbc:	68 9c 40 80 00       	push   $0x80409c
  801cc1:	68 24 01 00 00       	push   $0x124
  801cc6:	68 51 3e 80 00       	push   $0x803e51
  801ccb:	e8 f2 e5 ff ff       	call   8002c2 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801cd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd3:	f7 d0                	not    %eax
  801cd5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cd8:	73 1d                	jae    801cf7 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	ff 75 e0             	pushl  -0x20(%ebp)
  801ce0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ce3:	68 e4 40 80 00       	push   $0x8040e4
  801ce8:	68 29 01 00 00       	push   $0x129
  801ced:	68 51 3e 80 00       	push   $0x803e51
  801cf2:	e8 cb e5 ff ff       	call   8002c2 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801cf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d05:	85 c0                	test   %eax,%eax
  801d07:	79 2c                	jns    801d35 <malloc+0x15a>
  801d09:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d10:	77 23                	ja     801d35 <malloc+0x15a>
  801d12:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d19:	77 1a                	ja     801d35 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	79 13                	jns    801d35 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801d22:	83 ec 08             	sub    $0x8,%esp
  801d25:	ff 75 e0             	pushl  -0x20(%ebp)
  801d28:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d2b:	e8 de 09 00 00       	call   80270e <sys_allocate_user_mem>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	eb 25                	jmp    801d5a <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801d35:	68 00 00 00 a0       	push   $0xa0000000
  801d3a:	ff 75 dc             	pushl  -0x24(%ebp)
  801d3d:	ff 75 e0             	pushl  -0x20(%ebp)
  801d40:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d43:	ff 75 f4             	pushl  -0xc(%ebp)
  801d46:	68 20 41 80 00       	push   $0x804120
  801d4b:	68 33 01 00 00       	push   $0x133
  801d50:	68 51 3e 80 00       	push   $0x803e51
  801d55:	e8 68 e5 ff ff       	call   8002c2 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801d65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d69:	0f 84 26 01 00 00    	je     801e95 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	79 1c                	jns    801d98 <free+0x39>
  801d7c:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801d83:	77 13                	ja     801d98 <free+0x39>
		free_block(virtual_address);
  801d85:	83 ec 0c             	sub    $0xc,%esp
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	e8 21 12 00 00       	call   802fb1 <free_block>
  801d90:	83 c4 10             	add    $0x10,%esp
		return;
  801d93:	e9 01 01 00 00       	jmp    801e99 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801d98:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d9d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801da0:	0f 82 d8 00 00 00    	jb     801e7e <free+0x11f>
  801da6:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801dad:	0f 87 cb 00 00 00    	ja     801e7e <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	25 ff 0f 00 00       	and    $0xfff,%eax
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	74 17                	je     801dd6 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	68 90 41 80 00       	push   $0x804190
  801dc7:	68 57 01 00 00       	push   $0x157
  801dcc:	68 51 3e 80 00       	push   $0x803e51
  801dd1:	e8 ec e4 ff ff       	call   8002c2 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	e8 66 fa ff ff       	call   801847 <find_allocated_size>
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801deb:	0f 84 a7 00 00 00    	je     801e98 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df4:	f7 d0                	not    %eax
  801df6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801df9:	73 1d                	jae    801e18 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801dfb:	83 ec 0c             	sub    $0xc,%esp
  801dfe:	ff 75 f0             	pushl  -0x10(%ebp)
  801e01:	ff 75 f4             	pushl  -0xc(%ebp)
  801e04:	68 b8 41 80 00       	push   $0x8041b8
  801e09:	68 61 01 00 00       	push   $0x161
  801e0e:	68 51 3e 80 00       	push   $0x803e51
  801e13:	e8 aa e4 ff ff       	call   8002c2 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1e:	01 d0                	add    %edx,%eax
  801e20:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	85 c0                	test   %eax,%eax
  801e28:	79 19                	jns    801e43 <free+0xe4>
  801e2a:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801e31:	77 10                	ja     801e43 <free+0xe4>
  801e33:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801e3a:	77 07                	ja     801e43 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	78 2b                	js     801e6e <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	68 00 00 00 a0       	push   $0xa0000000
  801e4b:	ff 75 ec             	pushl  -0x14(%ebp)
  801e4e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e51:	ff 75 f4             	pushl  -0xc(%ebp)
  801e54:	ff 75 f0             	pushl  -0x10(%ebp)
  801e57:	ff 75 08             	pushl  0x8(%ebp)
  801e5a:	68 f4 41 80 00       	push   $0x8041f4
  801e5f:	68 69 01 00 00       	push   $0x169
  801e64:	68 51 3e 80 00       	push   $0x803e51
  801e69:	e8 54 e4 ff ff       	call   8002c2 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	ff 75 08             	pushl  0x8(%ebp)
  801e74:	e8 2c fa ff ff       	call   8018a5 <free_pages>
  801e79:	83 c4 10             	add    $0x10,%esp
		return;
  801e7c:	eb 1b                	jmp    801e99 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	68 50 42 80 00       	push   $0x804250
  801e86:	68 70 01 00 00       	push   $0x170
  801e8b:	68 51 3e 80 00       	push   $0x803e51
  801e90:	e8 2d e4 ff ff       	call   8002c2 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801e95:	90                   	nop
  801e96:	eb 01                	jmp    801e99 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801e98:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 38             	sub    $0x38,%esp
  801ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ea7:	e8 2e fc ff ff       	call   801ada <uheap_init>
	if (size == 0) return NULL ;
  801eac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb0:	75 0a                	jne    801ebc <smalloc+0x21>
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb7:	e9 3d 01 00 00       	jmp    801ff9 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	25 ff 0f 00 00       	and    $0xfff,%eax
  801eca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801ecd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ed1:	74 0e                	je     801ee1 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801ed9:	05 00 10 00 00       	add    $0x1000,%eax
  801ede:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	c1 e8 0c             	shr    $0xc,%eax
  801ee7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801eea:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	75 0a                	jne    801efd <smalloc+0x62>
		return NULL;
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	e9 fc 00 00 00       	jmp    801ff9 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801efd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f02:	85 c0                	test   %eax,%eax
  801f04:	74 0f                	je     801f15 <smalloc+0x7a>
  801f06:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f0c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f11:	39 c2                	cmp    %eax,%edx
  801f13:	73 0a                	jae    801f1f <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f15:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f1a:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801f1f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f24:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f29:	29 c2                	sub    %eax,%edx
  801f2b:	89 d0                	mov    %edx,%eax
  801f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801f30:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f36:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f3b:	29 c2                	sub    %eax,%edx
  801f3d:	89 d0                	mov    %edx,%eax
  801f3f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f48:	77 13                	ja     801f5d <smalloc+0xc2>
  801f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f4d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f50:	77 0b                	ja     801f5d <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f55:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f58:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f5b:	73 0a                	jae    801f67 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	e9 92 00 00 00       	jmp    801ff9 <smalloc+0x15e>
	}

	void *va = NULL;
  801f67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801f6e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801f73:	83 f8 05             	cmp    $0x5,%eax
  801f76:	75 11                	jne    801f89 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801f78:	83 ec 0c             	sub    $0xc,%esp
  801f7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7e:	e8 08 f7 ff ff       	call   80168b <alloc_pages_custom_fit>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801f89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8d:	75 27                	jne    801fb6 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801f8f:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801f96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f99:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801f9c:	89 c2                	mov    %eax,%edx
  801f9e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fa3:	39 c2                	cmp    %eax,%edx
  801fa5:	73 07                	jae    801fae <smalloc+0x113>
			return NULL;}
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	eb 4b                	jmp    801ff9 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801fae:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801fb6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fba:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbd:	50                   	push   %eax
  801fbe:	ff 75 0c             	pushl  0xc(%ebp)
  801fc1:	ff 75 08             	pushl  0x8(%ebp)
  801fc4:	e8 cb 03 00 00       	call   802394 <sys_create_shared_object>
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801fcf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fd3:	79 07                	jns    801fdc <smalloc+0x141>
		return NULL;
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fda:	eb 1d                	jmp    801ff9 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  801fdc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fe1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  801fe4:	75 10                	jne    801ff6 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  801fe6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  801ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802001:	e8 d4 fa ff ff       	call   801ada <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802006:	83 ec 08             	sub    $0x8,%esp
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	e8 aa 03 00 00       	call   8023be <sys_size_of_shared_object>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80201a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80201e:	7f 0a                	jg     80202a <sget+0x2f>
		return NULL;
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	e9 32 01 00 00       	jmp    80215c <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80202a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802033:	25 ff 0f 00 00       	and    $0xfff,%eax
  802038:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80203b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80203f:	74 0e                	je     80204f <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802047:	05 00 10 00 00       	add    $0x1000,%eax
  80204c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80204f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802054:	85 c0                	test   %eax,%eax
  802056:	75 0a                	jne    802062 <sget+0x67>
		return NULL;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
  80205d:	e9 fa 00 00 00       	jmp    80215c <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802062:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	74 0f                	je     80207a <sget+0x7f>
  80206b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802071:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802076:	39 c2                	cmp    %eax,%edx
  802078:	73 0a                	jae    802084 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80207a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80207f:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802084:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802089:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80208e:	29 c2                	sub    %eax,%edx
  802090:	89 d0                	mov    %edx,%eax
  802092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802095:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80209b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020a0:	29 c2                	sub    %eax,%edx
  8020a2:	89 d0                	mov    %edx,%eax
  8020a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020ad:	77 13                	ja     8020c2 <sget+0xc7>
  8020af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020b5:	77 0b                	ja     8020c2 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8020b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ba:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020bd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020c0:	73 0a                	jae    8020cc <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c7:	e9 90 00 00 00       	jmp    80215c <sget+0x161>

	void *va = NULL;
  8020cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8020d3:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8020d8:	83 f8 05             	cmp    $0x5,%eax
  8020db:	75 11                	jne    8020ee <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e3:	e8 a3 f5 ff ff       	call   80168b <alloc_pages_custom_fit>
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8020ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f2:	75 27                	jne    80211b <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8020f4:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8020fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802101:	89 c2                	mov    %eax,%edx
  802103:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802108:	39 c2                	cmp    %eax,%edx
  80210a:	73 07                	jae    802113 <sget+0x118>
			return NULL;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	eb 49                	jmp    80215c <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802113:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802118:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	ff 75 f0             	pushl  -0x10(%ebp)
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	ff 75 08             	pushl  0x8(%ebp)
  802127:	e8 af 02 00 00       	call   8023db <sys_get_shared_object>
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802132:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802136:	79 07                	jns    80213f <sget+0x144>
		return NULL;
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
  80213d:	eb 1d                	jmp    80215c <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80213f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802144:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802147:	75 10                	jne    802159 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802149:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	01 d0                	add    %edx,%eax
  802154:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802159:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802164:	e8 71 f9 ff ff       	call   801ada <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 74 42 80 00       	push   $0x804274
  802171:	68 19 02 00 00       	push   $0x219
  802176:	68 51 3e 80 00       	push   $0x803e51
  80217b:	e8 42 e1 ff ff       	call   8002c2 <_panic>

00802180 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	68 9c 42 80 00       	push   $0x80429c
  80218e:	68 2b 02 00 00       	push   $0x22b
  802193:	68 51 3e 80 00       	push   $0x803e51
  802198:	e8 25 e1 ff ff       	call   8002c2 <_panic>

0080219d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	57                   	push   %edi
  8021a1:	56                   	push   %esi
  8021a2:	53                   	push   %ebx
  8021a3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021b2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021b5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021b8:	cd 30                	int    $0x30
  8021ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8021bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021c0:	83 c4 10             	add    $0x10,%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5f                   	pop    %edi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    

008021c8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8021d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	51                   	push   %ecx
  8021e1:	52                   	push   %edx
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	50                   	push   %eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	e8 b0 ff ff ff       	call   80219d <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	90                   	nop
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 02                	push   $0x2
  802202:	e8 96 ff ff ff       	call   80219d <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 03                	push   $0x3
  80221b:	e8 7d ff ff ff       	call   80219d <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	90                   	nop
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 04                	push   $0x4
  802235:	e8 63 ff ff ff       	call   80219d <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	90                   	nop
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	52                   	push   %edx
  802250:	50                   	push   %eax
  802251:	6a 08                	push   $0x8
  802253:	e8 45 ff ff ff       	call   80219d <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	56                   	push   %esi
  802261:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802262:	8b 75 18             	mov    0x18(%ebp),%esi
  802265:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	56                   	push   %esi
  802272:	53                   	push   %ebx
  802273:	51                   	push   %ecx
  802274:	52                   	push   %edx
  802275:	50                   	push   %eax
  802276:	6a 09                	push   $0x9
  802278:	e8 20 ff ff ff       	call   80219d <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802283:	5b                   	pop    %ebx
  802284:	5e                   	pop    %esi
  802285:	5d                   	pop    %ebp
  802286:	c3                   	ret    

00802287 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	6a 0a                	push   $0xa
  802297:	e8 01 ff ff ff       	call   80219d <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	ff 75 0c             	pushl  0xc(%ebp)
  8022ad:	ff 75 08             	pushl  0x8(%ebp)
  8022b0:	6a 0b                	push   $0xb
  8022b2:	e8 e6 fe ff ff       	call   80219d <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 0c                	push   $0xc
  8022cb:	e8 cd fe ff ff       	call   80219d <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 0d                	push   $0xd
  8022e4:	e8 b4 fe ff ff       	call   80219d <syscall>
  8022e9:	83 c4 18             	add    $0x18,%esp
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 0e                	push   $0xe
  8022fd:	e8 9b fe ff ff       	call   80219d <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 0f                	push   $0xf
  802316:	e8 82 fe ff ff       	call   80219d <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	ff 75 08             	pushl  0x8(%ebp)
  80232e:	6a 10                	push   $0x10
  802330:	e8 68 fe ff ff       	call   80219d <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 11                	push   $0x11
  802349:	e8 4f fe ff ff       	call   80219d <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	90                   	nop
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_cputc>:

void
sys_cputc(const char c)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802360:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	50                   	push   %eax
  80236d:	6a 01                	push   $0x1
  80236f:	e8 29 fe ff ff       	call   80219d <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	90                   	nop
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 14                	push   $0x14
  802389:	e8 0f fe ff ff       	call   80219d <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	90                   	nop
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	8b 45 10             	mov    0x10(%ebp),%eax
  80239d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	6a 00                	push   $0x0
  8023ac:	51                   	push   %ecx
  8023ad:	52                   	push   %edx
  8023ae:	ff 75 0c             	pushl  0xc(%ebp)
  8023b1:	50                   	push   %eax
  8023b2:	6a 15                	push   $0x15
  8023b4:	e8 e4 fd ff ff       	call   80219d <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
}
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	52                   	push   %edx
  8023ce:	50                   	push   %eax
  8023cf:	6a 16                	push   $0x16
  8023d1:	e8 c7 fd ff ff       	call   80219d <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	51                   	push   %ecx
  8023ec:	52                   	push   %edx
  8023ed:	50                   	push   %eax
  8023ee:	6a 17                	push   $0x17
  8023f0:	e8 a8 fd ff ff       	call   80219d <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	52                   	push   %edx
  80240a:	50                   	push   %eax
  80240b:	6a 18                	push   $0x18
  80240d:	e8 8b fd ff ff       	call   80219d <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	6a 00                	push   $0x0
  80241f:	ff 75 14             	pushl  0x14(%ebp)
  802422:	ff 75 10             	pushl  0x10(%ebp)
  802425:	ff 75 0c             	pushl  0xc(%ebp)
  802428:	50                   	push   %eax
  802429:	6a 19                	push   $0x19
  80242b:	e8 6d fd ff ff       	call   80219d <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	50                   	push   %eax
  802444:	6a 1a                	push   $0x1a
  802446:	e8 52 fd ff ff       	call   80219d <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	90                   	nop
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	50                   	push   %eax
  802460:	6a 1b                	push   $0x1b
  802462:	e8 36 fd ff ff       	call   80219d <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 05                	push   $0x5
  80247b:	e8 1d fd ff ff       	call   80219d <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 06                	push   $0x6
  802494:	e8 04 fd ff ff       	call   80219d <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 07                	push   $0x7
  8024ad:	e8 eb fc ff ff       	call   80219d <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_exit_env>:


void sys_exit_env(void)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 1c                	push   $0x1c
  8024c6:	e8 d2 fc ff ff       	call   80219d <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	90                   	nop
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024da:	8d 50 04             	lea    0x4(%eax),%edx
  8024dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	52                   	push   %edx
  8024e7:	50                   	push   %eax
  8024e8:	6a 1d                	push   $0x1d
  8024ea:	e8 ae fc ff ff       	call   80219d <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
	return result;
  8024f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024fb:	89 01                	mov    %eax,(%ecx)
  8024fd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	c9                   	leave  
  802504:	c2 04 00             	ret    $0x4

00802507 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 10             	pushl  0x10(%ebp)
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	6a 13                	push   $0x13
  802519:	e8 7f fc ff ff       	call   80219d <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
	return ;
  802521:	90                   	nop
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_rcr2>:
uint32 sys_rcr2()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 1e                	push   $0x1e
  802533:	e8 65 fc ff ff       	call   80219d <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 04             	sub    $0x4,%esp
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802549:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	50                   	push   %eax
  802556:	6a 1f                	push   $0x1f
  802558:	e8 40 fc ff ff       	call   80219d <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
	return ;
  802560:	90                   	nop
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <rsttst>:
void rsttst()
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 21                	push   $0x21
  802572:	e8 26 fc ff ff       	call   80219d <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
	return ;
  80257a:	90                   	nop
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	8b 45 14             	mov    0x14(%ebp),%eax
  802586:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802589:	8b 55 18             	mov    0x18(%ebp),%edx
  80258c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802590:	52                   	push   %edx
  802591:	50                   	push   %eax
  802592:	ff 75 10             	pushl  0x10(%ebp)
  802595:	ff 75 0c             	pushl  0xc(%ebp)
  802598:	ff 75 08             	pushl  0x8(%ebp)
  80259b:	6a 20                	push   $0x20
  80259d:	e8 fb fb ff ff       	call   80219d <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a5:	90                   	nop
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <chktst>:
void chktst(uint32 n)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	ff 75 08             	pushl  0x8(%ebp)
  8025b6:	6a 22                	push   $0x22
  8025b8:	e8 e0 fb ff ff       	call   80219d <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c0:	90                   	nop
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <inctst>:

void inctst()
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 23                	push   $0x23
  8025d2:	e8 c6 fb ff ff       	call   80219d <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025da:	90                   	nop
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <gettst>:
uint32 gettst()
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 24                	push   $0x24
  8025ec:	e8 ac fb ff ff       	call   80219d <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 25                	push   $0x25
  802605:	e8 93 fb ff ff       	call   80219d <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
  80260d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802612:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	ff 75 08             	pushl  0x8(%ebp)
  80262f:	6a 26                	push   $0x26
  802631:	e8 67 fb ff ff       	call   80219d <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
	return ;
  802639:	90                   	nop
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802640:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802643:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802646:	8b 55 0c             	mov    0xc(%ebp),%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	53                   	push   %ebx
  80264f:	51                   	push   %ecx
  802650:	52                   	push   %edx
  802651:	50                   	push   %eax
  802652:	6a 27                	push   $0x27
  802654:	e8 44 fb ff ff       	call   80219d <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
}
  80265c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802664:	8b 55 0c             	mov    0xc(%ebp),%edx
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	52                   	push   %edx
  802671:	50                   	push   %eax
  802672:	6a 28                	push   $0x28
  802674:	e8 24 fb ff ff       	call   80219d <syscall>
  802679:	83 c4 18             	add    $0x18,%esp
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802681:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802684:	8b 55 0c             	mov    0xc(%ebp),%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	6a 00                	push   $0x0
  80268c:	51                   	push   %ecx
  80268d:	ff 75 10             	pushl  0x10(%ebp)
  802690:	52                   	push   %edx
  802691:	50                   	push   %eax
  802692:	6a 29                	push   $0x29
  802694:	e8 04 fb ff ff       	call   80219d <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	ff 75 10             	pushl  0x10(%ebp)
  8026a8:	ff 75 0c             	pushl  0xc(%ebp)
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	6a 12                	push   $0x12
  8026b0:	e8 e8 fa ff ff       	call   80219d <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	52                   	push   %edx
  8026cb:	50                   	push   %eax
  8026cc:	6a 2a                	push   $0x2a
  8026ce:	e8 ca fa ff ff       	call   80219d <syscall>
  8026d3:	83 c4 18             	add    $0x18,%esp
	return;
  8026d6:	90                   	nop
}
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 2b                	push   $0x2b
  8026e8:	e8 b0 fa ff ff       	call   80219d <syscall>
  8026ed:	83 c4 18             	add    $0x18,%esp
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	ff 75 0c             	pushl  0xc(%ebp)
  8026fe:	ff 75 08             	pushl  0x8(%ebp)
  802701:	6a 2d                	push   $0x2d
  802703:	e8 95 fa ff ff       	call   80219d <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
	return;
  80270b:	90                   	nop
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	ff 75 0c             	pushl  0xc(%ebp)
  80271a:	ff 75 08             	pushl  0x8(%ebp)
  80271d:	6a 2c                	push   $0x2c
  80271f:	e8 79 fa ff ff       	call   80219d <syscall>
  802724:	83 c4 18             	add    $0x18,%esp
	return ;
  802727:	90                   	nop
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80272d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	52                   	push   %edx
  80273a:	50                   	push   %eax
  80273b:	6a 2e                	push   $0x2e
  80273d:	e8 5b fa ff ff       	call   80219d <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
	return ;
  802745:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80274e:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802755:	72 09                	jb     802760 <to_page_va+0x18>
  802757:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  80275e:	72 14                	jb     802774 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	68 c0 42 80 00       	push   $0x8042c0
  802768:	6a 15                	push   $0x15
  80276a:	68 eb 42 80 00       	push   $0x8042eb
  80276f:	e8 4e db ff ff       	call   8002c2 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	ba 60 50 80 00       	mov    $0x805060,%edx
  80277c:	29 d0                	sub    %edx,%eax
  80277e:	c1 f8 02             	sar    $0x2,%eax
  802781:	89 c2                	mov    %eax,%edx
  802783:	89 d0                	mov    %edx,%eax
  802785:	c1 e0 02             	shl    $0x2,%eax
  802788:	01 d0                	add    %edx,%eax
  80278a:	c1 e0 02             	shl    $0x2,%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	c1 e0 02             	shl    $0x2,%eax
  802792:	01 d0                	add    %edx,%eax
  802794:	89 c1                	mov    %eax,%ecx
  802796:	c1 e1 08             	shl    $0x8,%ecx
  802799:	01 c8                	add    %ecx,%eax
  80279b:	89 c1                	mov    %eax,%ecx
  80279d:	c1 e1 10             	shl    $0x10,%ecx
  8027a0:	01 c8                	add    %ecx,%eax
  8027a2:	01 c0                	add    %eax,%eax
  8027a4:	01 d0                	add    %edx,%eax
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	c1 e0 0c             	shl    $0xc,%eax
  8027af:	89 c2                	mov    %eax,%edx
  8027b1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027b6:	01 d0                	add    %edx,%eax
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8027c0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c8:	29 c2                	sub    %eax,%edx
  8027ca:	89 d0                	mov    %edx,%eax
  8027cc:	c1 e8 0c             	shr    $0xc,%eax
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	78 09                	js     8027e1 <to_page_info+0x27>
  8027d8:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8027df:	7e 14                	jle    8027f5 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 04 43 80 00       	push   $0x804304
  8027e9:	6a 22                	push   $0x22
  8027eb:	68 eb 42 80 00       	push   $0x8042eb
  8027f0:	e8 cd da ff ff       	call   8002c2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8027f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f8:	89 d0                	mov    %edx,%eax
  8027fa:	01 c0                	add    %eax,%eax
  8027fc:	01 d0                	add    %edx,%eax
  8027fe:	c1 e0 02             	shl    $0x2,%eax
  802801:	05 60 50 80 00       	add    $0x805060,%eax
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	05 00 00 00 02       	add    $0x2000000,%eax
  802816:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802819:	73 16                	jae    802831 <initialize_dynamic_allocator+0x29>
  80281b:	68 28 43 80 00       	push   $0x804328
  802820:	68 4e 43 80 00       	push   $0x80434e
  802825:	6a 34                	push   $0x34
  802827:	68 eb 42 80 00       	push   $0x8042eb
  80282c:	e8 91 da ff ff       	call   8002c2 <_panic>
		is_initialized = 1;
  802831:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802838:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802843:	8b 45 0c             	mov    0xc(%ebp),%eax
  802846:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  80284b:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802852:	00 00 00 
  802855:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80285c:	00 00 00 
  80285f:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802866:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802869:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802877:	eb 36                	jmp    8028af <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	c1 e0 04             	shl    $0x4,%eax
  80287f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802884:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c1 e0 04             	shl    $0x4,%eax
  802890:	05 84 d0 81 00       	add    $0x81d084,%eax
  802895:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	c1 e0 04             	shl    $0x4,%eax
  8028a1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8028a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8028ac:	ff 45 f4             	incl   -0xc(%ebp)
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028b5:	72 c2                	jb     802879 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8028b7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028bd:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028c2:	29 c2                	sub    %eax,%edx
  8028c4:	89 d0                	mov    %edx,%eax
  8028c6:	c1 e8 0c             	shr    $0xc,%eax
  8028c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8028cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028d3:	e9 c8 00 00 00       	jmp    8029a0 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8028d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028db:	89 d0                	mov    %edx,%eax
  8028dd:	01 c0                	add    %eax,%eax
  8028df:	01 d0                	add    %edx,%eax
  8028e1:	c1 e0 02             	shl    $0x2,%eax
  8028e4:	05 68 50 80 00       	add    $0x805068,%eax
  8028e9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8028ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f1:	89 d0                	mov    %edx,%eax
  8028f3:	01 c0                	add    %eax,%eax
  8028f5:	01 d0                	add    %edx,%eax
  8028f7:	c1 e0 02             	shl    $0x2,%eax
  8028fa:	05 6a 50 80 00       	add    $0x80506a,%eax
  8028ff:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802904:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80290a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80290d:	89 c8                	mov    %ecx,%eax
  80290f:	01 c0                	add    %eax,%eax
  802911:	01 c8                	add    %ecx,%eax
  802913:	c1 e0 02             	shl    $0x2,%eax
  802916:	05 64 50 80 00       	add    $0x805064,%eax
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802920:	89 d0                	mov    %edx,%eax
  802922:	01 c0                	add    %eax,%eax
  802924:	01 d0                	add    %edx,%eax
  802926:	c1 e0 02             	shl    $0x2,%eax
  802929:	05 64 50 80 00       	add    $0x805064,%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 1b                	je     80294f <initialize_dynamic_allocator+0x147>
  802934:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80293a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80293d:	89 c8                	mov    %ecx,%eax
  80293f:	01 c0                	add    %eax,%eax
  802941:	01 c8                	add    %ecx,%eax
  802943:	c1 e0 02             	shl    $0x2,%eax
  802946:	05 60 50 80 00       	add    $0x805060,%eax
  80294b:	89 02                	mov    %eax,(%edx)
  80294d:	eb 16                	jmp    802965 <initialize_dynamic_allocator+0x15d>
  80294f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802952:	89 d0                	mov    %edx,%eax
  802954:	01 c0                	add    %eax,%eax
  802956:	01 d0                	add    %edx,%eax
  802958:	c1 e0 02             	shl    $0x2,%eax
  80295b:	05 60 50 80 00       	add    $0x805060,%eax
  802960:	a3 48 50 80 00       	mov    %eax,0x805048
  802965:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802968:	89 d0                	mov    %edx,%eax
  80296a:	01 c0                	add    %eax,%eax
  80296c:	01 d0                	add    %edx,%eax
  80296e:	c1 e0 02             	shl    $0x2,%eax
  802971:	05 60 50 80 00       	add    $0x805060,%eax
  802976:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80297b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297e:	89 d0                	mov    %edx,%eax
  802980:	01 c0                	add    %eax,%eax
  802982:	01 d0                	add    %edx,%eax
  802984:	c1 e0 02             	shl    $0x2,%eax
  802987:	05 60 50 80 00       	add    $0x805060,%eax
  80298c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802992:	a1 54 50 80 00       	mov    0x805054,%eax
  802997:	40                   	inc    %eax
  802998:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  80299d:	ff 45 f0             	incl   -0x10(%ebp)
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029a6:	0f 82 2c ff ff ff    	jb     8028d8 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029b2:	eb 2f                	jmp    8029e3 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8029b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b7:	89 d0                	mov    %edx,%eax
  8029b9:	01 c0                	add    %eax,%eax
  8029bb:	01 d0                	add    %edx,%eax
  8029bd:	c1 e0 02             	shl    $0x2,%eax
  8029c0:	05 68 50 80 00       	add    $0x805068,%eax
  8029c5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8029ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029cd:	89 d0                	mov    %edx,%eax
  8029cf:	01 c0                	add    %eax,%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	c1 e0 02             	shl    $0x2,%eax
  8029d6:	05 6a 50 80 00       	add    $0x80506a,%eax
  8029db:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8029e0:	ff 45 ec             	incl   -0x14(%ebp)
  8029e3:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8029ea:	76 c8                	jbe    8029b4 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8029ec:	90                   	nop
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    

008029ef <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
  8029f2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8029f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8029fd:	29 c2                	sub    %eax,%edx
  8029ff:	89 d0                	mov    %edx,%eax
  802a01:	c1 e8 0c             	shr    $0xc,%eax
  802a04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802a07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a0a:	89 d0                	mov    %edx,%eax
  802a0c:	01 c0                	add    %eax,%eax
  802a0e:	01 d0                	add    %edx,%eax
  802a10:	c1 e0 02             	shl    $0x2,%eax
  802a13:	05 68 50 80 00       	add    $0x805068,%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802a1d:	c9                   	leave  
  802a1e:	c3                   	ret    

00802a1f <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802a1f:	55                   	push   %ebp
  802a20:	89 e5                	mov    %esp,%ebp
  802a22:	83 ec 14             	sub    $0x14,%esp
  802a25:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802a28:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802a2c:	77 07                	ja     802a35 <nearest_pow2_ceil.1513+0x16>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	eb 20                	jmp    802a55 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802a35:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802a3c:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802a3f:	eb 08                	jmp    802a49 <nearest_pow2_ceil.1513+0x2a>
  802a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a44:	01 c0                	add    %eax,%eax
  802a46:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a49:	d1 6d 08             	shrl   0x8(%ebp)
  802a4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a50:	75 ef                	jne    802a41 <nearest_pow2_ceil.1513+0x22>
        return power;
  802a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802a55:	c9                   	leave  
  802a56:	c3                   	ret    

00802a57 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802a5d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802a64:	76 16                	jbe    802a7c <alloc_block+0x25>
  802a66:	68 64 43 80 00       	push   $0x804364
  802a6b:	68 4e 43 80 00       	push   $0x80434e
  802a70:	6a 72                	push   $0x72
  802a72:	68 eb 42 80 00       	push   $0x8042eb
  802a77:	e8 46 d8 ff ff       	call   8002c2 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a80:	75 0a                	jne    802a8c <alloc_block+0x35>
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
  802a87:	e9 bd 04 00 00       	jmp    802f49 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802a8c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a99:	73 06                	jae    802aa1 <alloc_block+0x4a>
        size = min_block_size;
  802a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9e:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802aa1:	83 ec 0c             	sub    $0xc,%esp
  802aa4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802aa7:	ff 75 08             	pushl  0x8(%ebp)
  802aaa:	89 c1                	mov    %eax,%ecx
  802aac:	e8 6e ff ff ff       	call   802a1f <nearest_pow2_ceil.1513>
  802ab1:	83 c4 10             	add    $0x10,%esp
  802ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802ab7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aba:	83 ec 0c             	sub    $0xc,%esp
  802abd:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802ac0:	52                   	push   %edx
  802ac1:	89 c1                	mov    %eax,%ecx
  802ac3:	e8 83 04 00 00       	call   802f4b <log2_ceil.1520>
  802ac8:	83 c4 10             	add    $0x10,%esp
  802acb:	83 e8 03             	sub    $0x3,%eax
  802ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad4:	c1 e0 04             	shl    $0x4,%eax
  802ad7:	05 80 d0 81 00       	add    $0x81d080,%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	0f 84 d8 00 00 00    	je     802bbe <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae9:	c1 e0 04             	shl    $0x4,%eax
  802aec:	05 80 d0 81 00       	add    $0x81d080,%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802af6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802afa:	75 17                	jne    802b13 <alloc_block+0xbc>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 85 43 80 00       	push   $0x804385
  802b04:	68 98 00 00 00       	push   $0x98
  802b09:	68 eb 42 80 00       	push   $0x8042eb
  802b0e:	e8 af d7 ff ff       	call   8002c2 <_panic>
  802b13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 10                	je     802b2c <alloc_block+0xd5>
  802b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b24:	8b 52 04             	mov    0x4(%edx),%edx
  802b27:	89 50 04             	mov    %edx,0x4(%eax)
  802b2a:	eb 14                	jmp    802b40 <alloc_block+0xe9>
  802b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b35:	c1 e2 04             	shl    $0x4,%edx
  802b38:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802b3e:	89 02                	mov    %eax,(%edx)
  802b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0f                	je     802b59 <alloc_block+0x102>
  802b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b53:	8b 12                	mov    (%edx),%edx
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	eb 13                	jmp    802b6c <alloc_block+0x115>
  802b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b61:	c1 e2 04             	shl    $0x4,%edx
  802b64:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802b6a:	89 02                	mov    %eax,(%edx)
  802b6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b82:	c1 e0 04             	shl    $0x4,%eax
  802b85:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b92:	c1 e0 04             	shl    $0x4,%eax
  802b95:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b9a:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9f:	83 ec 0c             	sub    $0xc,%esp
  802ba2:	50                   	push   %eax
  802ba3:	e8 12 fc ff ff       	call   8027ba <to_page_info>
  802ba8:	83 c4 10             	add    $0x10,%esp
  802bab:	89 c2                	mov    %eax,%edx
  802bad:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802bb1:	48                   	dec    %eax
  802bb2:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802bb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb9:	e9 8b 03 00 00       	jmp    802f49 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802bbe:	a1 48 50 80 00       	mov    0x805048,%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	0f 84 64 02 00 00    	je     802e2f <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802bcb:	a1 48 50 80 00       	mov    0x805048,%eax
  802bd0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802bd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bd7:	75 17                	jne    802bf0 <alloc_block+0x199>
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	68 85 43 80 00       	push   $0x804385
  802be1:	68 a0 00 00 00       	push   $0xa0
  802be6:	68 eb 42 80 00       	push   $0x8042eb
  802beb:	e8 d2 d6 ff ff       	call   8002c2 <_panic>
  802bf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 10                	je     802c09 <alloc_block+0x1b2>
  802bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c01:	8b 52 04             	mov    0x4(%edx),%edx
  802c04:	89 50 04             	mov    %edx,0x4(%eax)
  802c07:	eb 0b                	jmp    802c14 <alloc_block+0x1bd>
  802c09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c0c:	8b 40 04             	mov    0x4(%eax),%eax
  802c0f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 0f                	je     802c2d <alloc_block+0x1d6>
  802c1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c27:	8b 12                	mov    (%edx),%edx
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	eb 0a                	jmp    802c37 <alloc_block+0x1e0>
  802c2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	a3 48 50 80 00       	mov    %eax,0x805048
  802c37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4a:	a1 54 50 80 00       	mov    0x805054,%eax
  802c4f:	48                   	dec    %eax
  802c50:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c58:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c5b:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802c5f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c64:	99                   	cltd   
  802c65:	f7 7d e8             	idivl  -0x18(%ebp)
  802c68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c6b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802c6f:	83 ec 0c             	sub    $0xc,%esp
  802c72:	ff 75 dc             	pushl  -0x24(%ebp)
  802c75:	e8 ce fa ff ff       	call   802748 <to_page_va>
  802c7a:	83 c4 10             	add    $0x10,%esp
  802c7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c83:	83 ec 0c             	sub    $0xc,%esp
  802c86:	50                   	push   %eax
  802c87:	e8 c0 ee ff ff       	call   801b4c <get_page>
  802c8c:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c96:	e9 aa 00 00 00       	jmp    802d45 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802ca2:	89 c2                	mov    %eax,%edx
  802ca4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ca7:	01 d0                	add    %edx,%eax
  802ca9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802cac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802cb0:	75 17                	jne    802cc9 <alloc_block+0x272>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 a4 43 80 00       	push   $0x8043a4
  802cba:	68 aa 00 00 00       	push   $0xaa
  802cbf:	68 eb 42 80 00       	push   $0x8042eb
  802cc4:	e8 f9 d5 ff ff       	call   8002c2 <_panic>
  802cc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccc:	c1 e0 04             	shl    $0x4,%eax
  802ccf:	05 84 d0 81 00       	add    $0x81d084,%eax
  802cd4:	8b 10                	mov    (%eax),%edx
  802cd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 14                	je     802cfa <alloc_block+0x2a3>
  802ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce9:	c1 e0 04             	shl    $0x4,%eax
  802cec:	05 84 d0 81 00       	add    $0x81d084,%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802cf6:	89 10                	mov    %edx,(%eax)
  802cf8:	eb 11                	jmp    802d0b <alloc_block+0x2b4>
  802cfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfd:	c1 e0 04             	shl    $0x4,%eax
  802d00:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d09:	89 02                	mov    %eax,(%edx)
  802d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0e:	c1 e0 04             	shl    $0x4,%eax
  802d11:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d1a:	89 02                	mov    %eax,(%edx)
  802d1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d28:	c1 e0 04             	shl    $0x4,%eax
  802d2b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	8d 50 01             	lea    0x1(%eax),%edx
  802d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d38:	c1 e0 04             	shl    $0x4,%eax
  802d3b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d40:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d42:	ff 45 f4             	incl   -0xc(%ebp)
  802d45:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d4a:	99                   	cltd   
  802d4b:	f7 7d e8             	idivl  -0x18(%ebp)
  802d4e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d51:	0f 8f 44 ff ff ff    	jg     802c9b <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5a:	c1 e0 04             	shl    $0x4,%eax
  802d5d:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802d67:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802d6b:	75 17                	jne    802d84 <alloc_block+0x32d>
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	68 85 43 80 00       	push   $0x804385
  802d75:	68 ae 00 00 00       	push   $0xae
  802d7a:	68 eb 42 80 00       	push   $0x8042eb
  802d7f:	e8 3e d5 ff ff       	call   8002c2 <_panic>
  802d84:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 10                	je     802d9d <alloc_block+0x346>
  802d8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d95:	8b 52 04             	mov    0x4(%edx),%edx
  802d98:	89 50 04             	mov    %edx,0x4(%eax)
  802d9b:	eb 14                	jmp    802db1 <alloc_block+0x35a>
  802d9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802da6:	c1 e2 04             	shl    $0x4,%edx
  802da9:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802daf:	89 02                	mov    %eax,(%edx)
  802db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	85 c0                	test   %eax,%eax
  802db9:	74 0f                	je     802dca <alloc_block+0x373>
  802dbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dc4:	8b 12                	mov    (%edx),%edx
  802dc6:	89 10                	mov    %edx,(%eax)
  802dc8:	eb 13                	jmp    802ddd <alloc_block+0x386>
  802dca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd2:	c1 e2 04             	shl    $0x4,%edx
  802dd5:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ddb:	89 02                	mov    %eax,(%edx)
  802ddd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df3:	c1 e0 04             	shl    $0x4,%eax
  802df6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e03:	c1 e0 04             	shl    $0x4,%eax
  802e06:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e0b:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e10:	83 ec 0c             	sub    $0xc,%esp
  802e13:	50                   	push   %eax
  802e14:	e8 a1 f9 ff ff       	call   8027ba <to_page_info>
  802e19:	83 c4 10             	add    $0x10,%esp
  802e1c:	89 c2                	mov    %eax,%edx
  802e1e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e22:	48                   	dec    %eax
  802e23:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802e27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e2a:	e9 1a 01 00 00       	jmp    802f49 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e32:	40                   	inc    %eax
  802e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e36:	e9 ed 00 00 00       	jmp    802f28 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	c1 e0 04             	shl    $0x4,%eax
  802e41:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	0f 84 d5 00 00 00    	je     802f25 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	c1 e0 04             	shl    $0x4,%eax
  802e56:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802e60:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e64:	75 17                	jne    802e7d <alloc_block+0x426>
  802e66:	83 ec 04             	sub    $0x4,%esp
  802e69:	68 85 43 80 00       	push   $0x804385
  802e6e:	68 b8 00 00 00       	push   $0xb8
  802e73:	68 eb 42 80 00       	push   $0x8042eb
  802e78:	e8 45 d4 ff ff       	call   8002c2 <_panic>
  802e7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 10                	je     802e96 <alloc_block+0x43f>
  802e86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e8e:	8b 52 04             	mov    0x4(%edx),%edx
  802e91:	89 50 04             	mov    %edx,0x4(%eax)
  802e94:	eb 14                	jmp    802eaa <alloc_block+0x453>
  802e96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9f:	c1 e2 04             	shl    $0x4,%edx
  802ea2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ea8:	89 02                	mov    %eax,(%edx)
  802eaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 0f                	je     802ec3 <alloc_block+0x46c>
  802eb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ebd:	8b 12                	mov    (%edx),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 13                	jmp    802ed6 <alloc_block+0x47f>
  802ec3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecb:	c1 e2 04             	shl    $0x4,%edx
  802ece:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ed4:	89 02                	mov    %eax,(%edx)
  802ed6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	c1 e0 04             	shl    $0x4,%eax
  802eef:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8d 50 ff             	lea    -0x1(%eax),%edx
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	c1 e0 04             	shl    $0x4,%eax
  802eff:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f04:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802f06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f09:	83 ec 0c             	sub    $0xc,%esp
  802f0c:	50                   	push   %eax
  802f0d:	e8 a8 f8 ff ff       	call   8027ba <to_page_info>
  802f12:	83 c4 10             	add    $0x10,%esp
  802f15:	89 c2                	mov    %eax,%edx
  802f17:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f1b:	48                   	dec    %eax
  802f1c:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802f20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f23:	eb 24                	jmp    802f49 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f25:	ff 45 f0             	incl   -0x10(%ebp)
  802f28:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802f2c:	0f 8e 09 ff ff ff    	jle    802e3b <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	68 c7 43 80 00       	push   $0x8043c7
  802f3a:	68 bf 00 00 00       	push   $0xbf
  802f3f:	68 eb 42 80 00       	push   $0x8042eb
  802f44:	e8 79 d3 ff ff       	call   8002c2 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802f49:	c9                   	leave  
  802f4a:	c3                   	ret    

00802f4b <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802f4b:	55                   	push   %ebp
  802f4c:	89 e5                	mov    %esp,%ebp
  802f4e:	83 ec 14             	sub    $0x14,%esp
  802f51:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f58:	75 07                	jne    802f61 <log2_ceil.1520+0x16>
  802f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5f:	eb 1b                	jmp    802f7c <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802f61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802f68:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802f6b:	eb 06                	jmp    802f73 <log2_ceil.1520+0x28>
            x >>= 1;
  802f6d:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802f70:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802f73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f77:	75 f4                	jne    802f6d <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802f7c:	c9                   	leave  
  802f7d:	c3                   	ret    

00802f7e <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802f7e:	55                   	push   %ebp
  802f7f:	89 e5                	mov    %esp,%ebp
  802f81:	83 ec 14             	sub    $0x14,%esp
  802f84:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802f87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8b:	75 07                	jne    802f94 <log2_ceil.1547+0x16>
  802f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f92:	eb 1b                	jmp    802faf <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802f94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802f9b:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802f9e:	eb 06                	jmp    802fa6 <log2_ceil.1547+0x28>
			x >>= 1;
  802fa0:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802fa3:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802fa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802faa:	75 f4                	jne    802fa0 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802faf:	c9                   	leave  
  802fb0:	c3                   	ret    

00802fb1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802fb1:	55                   	push   %ebp
  802fb2:	89 e5                	mov    %esp,%ebp
  802fb4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fba:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fbf:	39 c2                	cmp    %eax,%edx
  802fc1:	72 0c                	jb     802fcf <free_block+0x1e>
  802fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc6:	a1 40 50 80 00       	mov    0x805040,%eax
  802fcb:	39 c2                	cmp    %eax,%edx
  802fcd:	72 19                	jb     802fe8 <free_block+0x37>
  802fcf:	68 cc 43 80 00       	push   $0x8043cc
  802fd4:	68 4e 43 80 00       	push   $0x80434e
  802fd9:	68 d0 00 00 00       	push   $0xd0
  802fde:	68 eb 42 80 00       	push   $0x8042eb
  802fe3:	e8 da d2 ff ff       	call   8002c2 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  802fe8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fec:	0f 84 42 03 00 00    	je     803334 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  802ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802ffa:	39 c2                	cmp    %eax,%edx
  802ffc:	72 0c                	jb     80300a <free_block+0x59>
  802ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  803001:	a1 40 50 80 00       	mov    0x805040,%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	72 17                	jb     803021 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 04 44 80 00       	push   $0x804404
  803012:	68 e6 00 00 00       	push   $0xe6
  803017:	68 eb 42 80 00       	push   $0x8042eb
  80301c:	e8 a1 d2 ff ff       	call   8002c2 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803021:	8b 55 08             	mov    0x8(%ebp),%edx
  803024:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803029:	29 c2                	sub    %eax,%edx
  80302b:	89 d0                	mov    %edx,%eax
  80302d:	83 e0 07             	and    $0x7,%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 17                	je     80304b <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	68 38 44 80 00       	push   $0x804438
  80303c:	68 ea 00 00 00       	push   $0xea
  803041:	68 eb 42 80 00       	push   $0x8042eb
  803046:	e8 77 d2 ff ff       	call   8002c2 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	83 ec 0c             	sub    $0xc,%esp
  803051:	50                   	push   %eax
  803052:	e8 63 f7 ff ff       	call   8027ba <to_page_info>
  803057:	83 c4 10             	add    $0x10,%esp
  80305a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80305d:	83 ec 0c             	sub    $0xc,%esp
  803060:	ff 75 08             	pushl  0x8(%ebp)
  803063:	e8 87 f9 ff ff       	call   8029ef <get_block_size>
  803068:	83 c4 10             	add    $0x10,%esp
  80306b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80306e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803072:	75 17                	jne    80308b <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	68 64 44 80 00       	push   $0x804464
  80307c:	68 f1 00 00 00       	push   $0xf1
  803081:	68 eb 42 80 00       	push   $0x8042eb
  803086:	e8 37 d2 ff ff       	call   8002c2 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80308b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308e:	83 ec 0c             	sub    $0xc,%esp
  803091:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803094:	52                   	push   %edx
  803095:	89 c1                	mov    %eax,%ecx
  803097:	e8 e2 fe ff ff       	call   802f7e <log2_ceil.1547>
  80309c:	83 c4 10             	add    $0x10,%esp
  80309f:	83 e8 03             	sub    $0x3,%eax
  8030a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8030ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030af:	75 17                	jne    8030c8 <free_block+0x117>
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	68 b0 44 80 00       	push   $0x8044b0
  8030b9:	68 f6 00 00 00       	push   $0xf6
  8030be:	68 eb 42 80 00       	push   $0x8042eb
  8030c3:	e8 fa d1 ff ff       	call   8002c2 <_panic>
  8030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cb:	c1 e0 04             	shl    $0x4,%eax
  8030ce:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030d3:	8b 10                	mov    (%eax),%edx
  8030d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d8:	89 10                	mov    %edx,(%eax)
  8030da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030dd:	8b 00                	mov    (%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	74 15                	je     8030f8 <free_block+0x147>
  8030e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e6:	c1 e0 04             	shl    $0x4,%eax
  8030e9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	eb 11                	jmp    803109 <free_block+0x158>
  8030f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fb:	c1 e0 04             	shl    $0x4,%eax
  8030fe:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803107:	89 02                	mov    %eax,(%edx)
  803109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310c:	c1 e0 04             	shl    $0x4,%eax
  80310f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803118:	89 02                	mov    %eax,(%edx)
  80311a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803127:	c1 e0 04             	shl    $0x4,%eax
  80312a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	8d 50 01             	lea    0x1(%eax),%edx
  803134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803137:	c1 e0 04             	shl    $0x4,%eax
  80313a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80313f:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803144:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803148:	40                   	inc    %eax
  803149:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80314c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803150:	8b 55 08             	mov    0x8(%ebp),%edx
  803153:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803158:	29 c2                	sub    %eax,%edx
  80315a:	89 d0                	mov    %edx,%eax
  80315c:	c1 e8 0c             	shr    $0xc,%eax
  80315f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803165:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803169:	0f b7 c8             	movzwl %ax,%ecx
  80316c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803171:	99                   	cltd   
  803172:	f7 7d e8             	idivl  -0x18(%ebp)
  803175:	39 c1                	cmp    %eax,%ecx
  803177:	0f 85 b8 01 00 00    	jne    803335 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80317d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803187:	c1 e0 04             	shl    $0x4,%eax
  80318a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803194:	e9 d5 00 00 00       	jmp    80326e <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8031a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031a9:	29 c2                	sub    %eax,%edx
  8031ab:	89 d0                	mov    %edx,%eax
  8031ad:	c1 e8 0c             	shr    $0xc,%eax
  8031b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8031b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8031b9:	0f 85 a9 00 00 00    	jne    803268 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8031bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c3:	75 17                	jne    8031dc <free_block+0x22b>
  8031c5:	83 ec 04             	sub    $0x4,%esp
  8031c8:	68 85 43 80 00       	push   $0x804385
  8031cd:	68 04 01 00 00       	push   $0x104
  8031d2:	68 eb 42 80 00       	push   $0x8042eb
  8031d7:	e8 e6 d0 ff ff       	call   8002c2 <_panic>
  8031dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 10                	je     8031f5 <free_block+0x244>
  8031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e8:	8b 00                	mov    (%eax),%eax
  8031ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ed:	8b 52 04             	mov    0x4(%edx),%edx
  8031f0:	89 50 04             	mov    %edx,0x4(%eax)
  8031f3:	eb 14                	jmp    803209 <free_block+0x258>
  8031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f8:	8b 40 04             	mov    0x4(%eax),%eax
  8031fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031fe:	c1 e2 04             	shl    $0x4,%edx
  803201:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803207:	89 02                	mov    %eax,(%edx)
  803209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320c:	8b 40 04             	mov    0x4(%eax),%eax
  80320f:	85 c0                	test   %eax,%eax
  803211:	74 0f                	je     803222 <free_block+0x271>
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	8b 40 04             	mov    0x4(%eax),%eax
  803219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321c:	8b 12                	mov    (%edx),%edx
  80321e:	89 10                	mov    %edx,(%eax)
  803220:	eb 13                	jmp    803235 <free_block+0x284>
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80322a:	c1 e2 04             	shl    $0x4,%edx
  80322d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803233:	89 02                	mov    %eax,(%edx)
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803241:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324b:	c1 e0 04             	shl    $0x4,%eax
  80324e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803253:	8b 00                	mov    (%eax),%eax
  803255:	8d 50 ff             	lea    -0x1(%eax),%edx
  803258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325b:	c1 e0 04             	shl    $0x4,%eax
  80325e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803263:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803265:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803268:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80326b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80326e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803272:	0f 85 21 ff ff ff    	jne    803199 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803278:	b8 00 10 00 00       	mov    $0x1000,%eax
  80327d:	99                   	cltd   
  80327e:	f7 7d e8             	idivl  -0x18(%ebp)
  803281:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803284:	74 17                	je     80329d <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 d4 44 80 00       	push   $0x8044d4
  80328e:	68 0c 01 00 00       	push   $0x10c
  803293:	68 eb 42 80 00       	push   $0x8042eb
  803298:	e8 25 d0 ff ff       	call   8002c2 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80329d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8032a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8032af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032b3:	75 17                	jne    8032cc <free_block+0x31b>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 a4 43 80 00       	push   $0x8043a4
  8032bd:	68 11 01 00 00       	push   $0x111
  8032c2:	68 eb 42 80 00       	push   $0x8042eb
  8032c7:	e8 f6 cf ff ff       	call   8002c2 <_panic>
  8032cc:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0c                	je     8032ee <free_block+0x33d>
  8032e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ea:	89 10                	mov    %edx,(%eax)
  8032ec:	eb 08                	jmp    8032f6 <free_block+0x345>
  8032ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f1:	a3 48 50 80 00       	mov    %eax,0x805048
  8032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803307:	a1 54 50 80 00       	mov    0x805054,%eax
  80330c:	40                   	inc    %eax
  80330d:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803312:	83 ec 0c             	sub    $0xc,%esp
  803315:	ff 75 ec             	pushl  -0x14(%ebp)
  803318:	e8 2b f4 ff ff       	call   802748 <to_page_va>
  80331d:	83 c4 10             	add    $0x10,%esp
  803320:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803323:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803326:	83 ec 0c             	sub    $0xc,%esp
  803329:	50                   	push   %eax
  80332a:	e8 69 e8 ff ff       	call   801b98 <return_page>
  80332f:	83 c4 10             	add    $0x10,%esp
  803332:	eb 01                	jmp    803335 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803334:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803335:	c9                   	leave  
  803336:	c3                   	ret    

00803337 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803337:	55                   	push   %ebp
  803338:	89 e5                	mov    %esp,%ebp
  80333a:	83 ec 14             	sub    $0x14,%esp
  80333d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803340:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803344:	77 07                	ja     80334d <nearest_pow2_ceil.1572+0x16>
      return 1;
  803346:	b8 01 00 00 00       	mov    $0x1,%eax
  80334b:	eb 20                	jmp    80336d <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80334d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803354:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803357:	eb 08                	jmp    803361 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80335c:	01 c0                	add    %eax,%eax
  80335e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803361:	d1 6d 08             	shrl   0x8(%ebp)
  803364:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803368:	75 ef                	jne    803359 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80336a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80336d:	c9                   	leave  
  80336e:	c3                   	ret    

0080336f <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803379:	75 13                	jne    80338e <realloc_block+0x1f>
    return alloc_block(new_size);
  80337b:	83 ec 0c             	sub    $0xc,%esp
  80337e:	ff 75 0c             	pushl  0xc(%ebp)
  803381:	e8 d1 f6 ff ff       	call   802a57 <alloc_block>
  803386:	83 c4 10             	add    $0x10,%esp
  803389:	e9 d9 00 00 00       	jmp    803467 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80338e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803392:	75 18                	jne    8033ac <realloc_block+0x3d>
    free_block(va);
  803394:	83 ec 0c             	sub    $0xc,%esp
  803397:	ff 75 08             	pushl  0x8(%ebp)
  80339a:	e8 12 fc ff ff       	call   802fb1 <free_block>
  80339f:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8033a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a7:	e9 bb 00 00 00       	jmp    803467 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8033ac:	83 ec 0c             	sub    $0xc,%esp
  8033af:	ff 75 08             	pushl  0x8(%ebp)
  8033b2:	e8 38 f6 ff ff       	call   8029ef <get_block_size>
  8033b7:	83 c4 10             	add    $0x10,%esp
  8033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8033bd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8033c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8033ca:	73 06                	jae    8033d2 <realloc_block+0x63>
    new_size = min_block_size;
  8033cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033cf:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8033d2:	83 ec 0c             	sub    $0xc,%esp
  8033d5:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8033d8:	ff 75 0c             	pushl  0xc(%ebp)
  8033db:	89 c1                	mov    %eax,%ecx
  8033dd:	e8 55 ff ff ff       	call   803337 <nearest_pow2_ceil.1572>
  8033e2:	83 c4 10             	add    $0x10,%esp
  8033e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033ee:	75 05                	jne    8033f5 <realloc_block+0x86>
    return va;
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	eb 72                	jmp    803467 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8033f5:	83 ec 0c             	sub    $0xc,%esp
  8033f8:	ff 75 0c             	pushl  0xc(%ebp)
  8033fb:	e8 57 f6 ff ff       	call   802a57 <alloc_block>
  803400:	83 c4 10             	add    $0x10,%esp
  803403:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803406:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80340a:	75 07                	jne    803413 <realloc_block+0xa4>
    return NULL;
  80340c:	b8 00 00 00 00       	mov    $0x0,%eax
  803411:	eb 54                	jmp    803467 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803416:	8b 45 0c             	mov    0xc(%ebp),%eax
  803419:	39 d0                	cmp    %edx,%eax
  80341b:	76 02                	jbe    80341f <realloc_block+0xb0>
  80341d:	89 d0                	mov    %edx,%eax
  80341f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80342e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803435:	eb 17                	jmp    80344e <realloc_block+0xdf>
    dst[i] = src[i];
  803437:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	01 c2                	add    %eax,%edx
  80343f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803445:	01 c8                	add    %ecx,%eax
  803447:	8a 00                	mov    (%eax),%al
  803449:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80344b:	ff 45 f4             	incl   -0xc(%ebp)
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803454:	72 e1                	jb     803437 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	ff 75 08             	pushl  0x8(%ebp)
  80345c:	e8 50 fb ff ff       	call   802fb1 <free_block>
  803461:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803467:	c9                   	leave  
  803468:	c3                   	ret    
  803469:	66 90                	xchg   %ax,%ax
  80346b:	90                   	nop

0080346c <__udivdi3>:
  80346c:	55                   	push   %ebp
  80346d:	57                   	push   %edi
  80346e:	56                   	push   %esi
  80346f:	53                   	push   %ebx
  803470:	83 ec 1c             	sub    $0x1c,%esp
  803473:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803477:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80347b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80347f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803483:	89 ca                	mov    %ecx,%edx
  803485:	89 f8                	mov    %edi,%eax
  803487:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80348b:	85 f6                	test   %esi,%esi
  80348d:	75 2d                	jne    8034bc <__udivdi3+0x50>
  80348f:	39 cf                	cmp    %ecx,%edi
  803491:	77 65                	ja     8034f8 <__udivdi3+0x8c>
  803493:	89 fd                	mov    %edi,%ebp
  803495:	85 ff                	test   %edi,%edi
  803497:	75 0b                	jne    8034a4 <__udivdi3+0x38>
  803499:	b8 01 00 00 00       	mov    $0x1,%eax
  80349e:	31 d2                	xor    %edx,%edx
  8034a0:	f7 f7                	div    %edi
  8034a2:	89 c5                	mov    %eax,%ebp
  8034a4:	31 d2                	xor    %edx,%edx
  8034a6:	89 c8                	mov    %ecx,%eax
  8034a8:	f7 f5                	div    %ebp
  8034aa:	89 c1                	mov    %eax,%ecx
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	f7 f5                	div    %ebp
  8034b0:	89 cf                	mov    %ecx,%edi
  8034b2:	89 fa                	mov    %edi,%edx
  8034b4:	83 c4 1c             	add    $0x1c,%esp
  8034b7:	5b                   	pop    %ebx
  8034b8:	5e                   	pop    %esi
  8034b9:	5f                   	pop    %edi
  8034ba:	5d                   	pop    %ebp
  8034bb:	c3                   	ret    
  8034bc:	39 ce                	cmp    %ecx,%esi
  8034be:	77 28                	ja     8034e8 <__udivdi3+0x7c>
  8034c0:	0f bd fe             	bsr    %esi,%edi
  8034c3:	83 f7 1f             	xor    $0x1f,%edi
  8034c6:	75 40                	jne    803508 <__udivdi3+0x9c>
  8034c8:	39 ce                	cmp    %ecx,%esi
  8034ca:	72 0a                	jb     8034d6 <__udivdi3+0x6a>
  8034cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034d0:	0f 87 9e 00 00 00    	ja     803574 <__udivdi3+0x108>
  8034d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034db:	89 fa                	mov    %edi,%edx
  8034dd:	83 c4 1c             	add    $0x1c,%esp
  8034e0:	5b                   	pop    %ebx
  8034e1:	5e                   	pop    %esi
  8034e2:	5f                   	pop    %edi
  8034e3:	5d                   	pop    %ebp
  8034e4:	c3                   	ret    
  8034e5:	8d 76 00             	lea    0x0(%esi),%esi
  8034e8:	31 ff                	xor    %edi,%edi
  8034ea:	31 c0                	xor    %eax,%eax
  8034ec:	89 fa                	mov    %edi,%edx
  8034ee:	83 c4 1c             	add    $0x1c,%esp
  8034f1:	5b                   	pop    %ebx
  8034f2:	5e                   	pop    %esi
  8034f3:	5f                   	pop    %edi
  8034f4:	5d                   	pop    %ebp
  8034f5:	c3                   	ret    
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	f7 f7                	div    %edi
  8034fc:	31 ff                	xor    %edi,%edi
  8034fe:	89 fa                	mov    %edi,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	bd 20 00 00 00       	mov    $0x20,%ebp
  80350d:	89 eb                	mov    %ebp,%ebx
  80350f:	29 fb                	sub    %edi,%ebx
  803511:	89 f9                	mov    %edi,%ecx
  803513:	d3 e6                	shl    %cl,%esi
  803515:	89 c5                	mov    %eax,%ebp
  803517:	88 d9                	mov    %bl,%cl
  803519:	d3 ed                	shr    %cl,%ebp
  80351b:	89 e9                	mov    %ebp,%ecx
  80351d:	09 f1                	or     %esi,%ecx
  80351f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803523:	89 f9                	mov    %edi,%ecx
  803525:	d3 e0                	shl    %cl,%eax
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 d6                	mov    %edx,%esi
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 ee                	shr    %cl,%esi
  80352f:	89 f9                	mov    %edi,%ecx
  803531:	d3 e2                	shl    %cl,%edx
  803533:	8b 44 24 08          	mov    0x8(%esp),%eax
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 e8                	shr    %cl,%eax
  80353b:	09 c2                	or     %eax,%edx
  80353d:	89 d0                	mov    %edx,%eax
  80353f:	89 f2                	mov    %esi,%edx
  803541:	f7 74 24 0c          	divl   0xc(%esp)
  803545:	89 d6                	mov    %edx,%esi
  803547:	89 c3                	mov    %eax,%ebx
  803549:	f7 e5                	mul    %ebp
  80354b:	39 d6                	cmp    %edx,%esi
  80354d:	72 19                	jb     803568 <__udivdi3+0xfc>
  80354f:	74 0b                	je     80355c <__udivdi3+0xf0>
  803551:	89 d8                	mov    %ebx,%eax
  803553:	31 ff                	xor    %edi,%edi
  803555:	e9 58 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803560:	89 f9                	mov    %edi,%ecx
  803562:	d3 e2                	shl    %cl,%edx
  803564:	39 c2                	cmp    %eax,%edx
  803566:	73 e9                	jae    803551 <__udivdi3+0xe5>
  803568:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80356b:	31 ff                	xor    %edi,%edi
  80356d:	e9 40 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  803572:	66 90                	xchg   %ax,%ax
  803574:	31 c0                	xor    %eax,%eax
  803576:	e9 37 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80357b:	90                   	nop

0080357c <__umoddi3>:
  80357c:	55                   	push   %ebp
  80357d:	57                   	push   %edi
  80357e:	56                   	push   %esi
  80357f:	53                   	push   %ebx
  803580:	83 ec 1c             	sub    $0x1c,%esp
  803583:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803587:	8b 74 24 34          	mov    0x34(%esp),%esi
  80358b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80359b:	89 f3                	mov    %esi,%ebx
  80359d:	89 fa                	mov    %edi,%edx
  80359f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a3:	89 34 24             	mov    %esi,(%esp)
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	75 1a                	jne    8035c4 <__umoddi3+0x48>
  8035aa:	39 f7                	cmp    %esi,%edi
  8035ac:	0f 86 a2 00 00 00    	jbe    803654 <__umoddi3+0xd8>
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	89 f2                	mov    %esi,%edx
  8035b6:	f7 f7                	div    %edi
  8035b8:	89 d0                	mov    %edx,%eax
  8035ba:	31 d2                	xor    %edx,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	39 f0                	cmp    %esi,%eax
  8035c6:	0f 87 ac 00 00 00    	ja     803678 <__umoddi3+0xfc>
  8035cc:	0f bd e8             	bsr    %eax,%ebp
  8035cf:	83 f5 1f             	xor    $0x1f,%ebp
  8035d2:	0f 84 ac 00 00 00    	je     803684 <__umoddi3+0x108>
  8035d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035dd:	29 ef                	sub    %ebp,%edi
  8035df:	89 fe                	mov    %edi,%esi
  8035e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 e0                	shl    %cl,%eax
  8035e9:	89 d7                	mov    %edx,%edi
  8035eb:	89 f1                	mov    %esi,%ecx
  8035ed:	d3 ef                	shr    %cl,%edi
  8035ef:	09 c7                	or     %eax,%edi
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 e2                	shl    %cl,%edx
  8035f5:	89 14 24             	mov    %edx,(%esp)
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	d3 e0                	shl    %cl,%eax
  8035fc:	89 c2                	mov    %eax,%edx
  8035fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803602:	d3 e0                	shl    %cl,%eax
  803604:	89 44 24 04          	mov    %eax,0x4(%esp)
  803608:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360c:	89 f1                	mov    %esi,%ecx
  80360e:	d3 e8                	shr    %cl,%eax
  803610:	09 d0                	or     %edx,%eax
  803612:	d3 eb                	shr    %cl,%ebx
  803614:	89 da                	mov    %ebx,%edx
  803616:	f7 f7                	div    %edi
  803618:	89 d3                	mov    %edx,%ebx
  80361a:	f7 24 24             	mull   (%esp)
  80361d:	89 c6                	mov    %eax,%esi
  80361f:	89 d1                	mov    %edx,%ecx
  803621:	39 d3                	cmp    %edx,%ebx
  803623:	0f 82 87 00 00 00    	jb     8036b0 <__umoddi3+0x134>
  803629:	0f 84 91 00 00 00    	je     8036c0 <__umoddi3+0x144>
  80362f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803633:	29 f2                	sub    %esi,%edx
  803635:	19 cb                	sbb    %ecx,%ebx
  803637:	89 d8                	mov    %ebx,%eax
  803639:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80363d:	d3 e0                	shl    %cl,%eax
  80363f:	89 e9                	mov    %ebp,%ecx
  803641:	d3 ea                	shr    %cl,%edx
  803643:	09 d0                	or     %edx,%eax
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 eb                	shr    %cl,%ebx
  803649:	89 da                	mov    %ebx,%edx
  80364b:	83 c4 1c             	add    $0x1c,%esp
  80364e:	5b                   	pop    %ebx
  80364f:	5e                   	pop    %esi
  803650:	5f                   	pop    %edi
  803651:	5d                   	pop    %ebp
  803652:	c3                   	ret    
  803653:	90                   	nop
  803654:	89 fd                	mov    %edi,%ebp
  803656:	85 ff                	test   %edi,%edi
  803658:	75 0b                	jne    803665 <__umoddi3+0xe9>
  80365a:	b8 01 00 00 00       	mov    $0x1,%eax
  80365f:	31 d2                	xor    %edx,%edx
  803661:	f7 f7                	div    %edi
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 f0                	mov    %esi,%eax
  803667:	31 d2                	xor    %edx,%edx
  803669:	f7 f5                	div    %ebp
  80366b:	89 c8                	mov    %ecx,%eax
  80366d:	f7 f5                	div    %ebp
  80366f:	89 d0                	mov    %edx,%eax
  803671:	e9 44 ff ff ff       	jmp    8035ba <__umoddi3+0x3e>
  803676:	66 90                	xchg   %ax,%ax
  803678:	89 c8                	mov    %ecx,%eax
  80367a:	89 f2                	mov    %esi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	3b 04 24             	cmp    (%esp),%eax
  803687:	72 06                	jb     80368f <__umoddi3+0x113>
  803689:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80368d:	77 0f                	ja     80369e <__umoddi3+0x122>
  80368f:	89 f2                	mov    %esi,%edx
  803691:	29 f9                	sub    %edi,%ecx
  803693:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803697:	89 14 24             	mov    %edx,(%esp)
  80369a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036a2:	8b 14 24             	mov    (%esp),%edx
  8036a5:	83 c4 1c             	add    $0x1c,%esp
  8036a8:	5b                   	pop    %ebx
  8036a9:	5e                   	pop    %esi
  8036aa:	5f                   	pop    %edi
  8036ab:	5d                   	pop    %ebp
  8036ac:	c3                   	ret    
  8036ad:	8d 76 00             	lea    0x0(%esi),%esi
  8036b0:	2b 04 24             	sub    (%esp),%eax
  8036b3:	19 fa                	sbb    %edi,%edx
  8036b5:	89 d1                	mov    %edx,%ecx
  8036b7:	89 c6                	mov    %eax,%esi
  8036b9:	e9 71 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c4:	72 ea                	jb     8036b0 <__umoddi3+0x134>
  8036c6:	89 d9                	mov    %ebx,%ecx
  8036c8:	e9 62 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
