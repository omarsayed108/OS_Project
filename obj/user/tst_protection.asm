
obj/user/tst_protection:     file format elf32-i386


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
  800031:	e8 bc 00 00 00       	call   8000f2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 20 30 80 00       	mov    0x803020,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 a0 1c 80 00       	push   $0x801ca0
  800060:	6a 12                	push   $0x12
  800062:	68 bc 1c 80 00       	push   $0x801cbc
  800067:	e8 36 02 00 00       	call   8002a2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int numOfSlaves = 3;
  80006c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
	rsttst();
  800073:	e8 c3 17 00 00       	call   80183b <rsttst>
	//[1] Run programs that allocate many shared variables
	for (int i = 0; i < numOfSlaves; ++i) {
  800078:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80007f:	eb 47                	jmp    8000c8 <_main+0x90>
		int32 envId = sys_create_env("protection_slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  80008c:	a1 20 30 80 00       	mov    0x803020,%eax
  800091:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800097:	89 c1                	mov    %eax,%ecx
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a4:	52                   	push   %edx
  8000a5:	51                   	push   %ecx
  8000a6:	50                   	push   %eax
  8000a7:	68 d2 1c 80 00       	push   $0x801cd2
  8000ac:	e8 3e 16 00 00       	call   8016ef <sys_create_env>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		sys_run_env(envId);
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8000bd:	e8 4b 16 00 00       	call   80170d <sys_run_env>
  8000c2:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int numOfSlaves = 3;
	rsttst();
	//[1] Run programs that allocate many shared variables
	for (int i = 0; i < numOfSlaves; ++i) {
  8000c5:	ff 45 f4             	incl   -0xc(%ebp)
  8000c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000ce:	7c b1                	jl     800081 <_main+0x49>
		int32 envId = sys_create_env("protection_slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(envId);
	}

	while (gettst() != numOfSlaves) ;
  8000d0:	90                   	nop
  8000d1:	e8 df 17 00 00       	call   8018b5 <gettst>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000db:	39 c2                	cmp    %eax,%edx
  8000dd:	75 f2                	jne    8000d1 <_main+0x99>

	cprintf("%~\nCongratulations... test protection is run successfully\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 e4 1c 80 00       	push   $0x801ce4
  8000e7:	e8 a4 04 00 00       	call   800590 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp

}
  8000ef:	90                   	nop
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fb:	e8 5d 16 00 00       	call   80175d <sys_getenvindex>
  800100:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800103:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800106:	89 d0                	mov    %edx,%eax
  800108:	01 c0                	add    %eax,%eax
  80010a:	01 d0                	add    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	c1 e0 02             	shl    $0x2,%eax
  800114:	01 d0                	add    %edx,%eax
  800116:	c1 e0 03             	shl    $0x3,%eax
  800119:	01 d0                	add    %edx,%eax
  80011b:	c1 e0 02             	shl    $0x2,%eax
  80011e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800123:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800128:	a1 20 30 80 00       	mov    0x803020,%eax
  80012d:	8a 40 20             	mov    0x20(%eax),%al
  800130:	84 c0                	test   %al,%al
  800132:	74 0d                	je     800141 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800134:	a1 20 30 80 00       	mov    0x803020,%eax
  800139:	83 c0 20             	add    $0x20,%eax
  80013c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800145:	7e 0a                	jle    800151 <libmain+0x5f>
		binaryname = argv[0];
  800147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014a:	8b 00                	mov    (%eax),%eax
  80014c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	ff 75 0c             	pushl  0xc(%ebp)
  800157:	ff 75 08             	pushl  0x8(%ebp)
  80015a:	e8 d9 fe ff ff       	call   800038 <_main>
  80015f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800162:	a1 00 30 80 00       	mov    0x803000,%eax
  800167:	85 c0                	test   %eax,%eax
  800169:	0f 84 01 01 00 00    	je     800270 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80016f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800175:	bb 18 1e 80 00       	mov    $0x801e18,%ebx
  80017a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017f:	89 c7                	mov    %eax,%edi
  800181:	89 de                	mov    %ebx,%esi
  800183:	89 d1                	mov    %edx,%ecx
  800185:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800187:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80018a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80018f:	b0 00                	mov    $0x0,%al
  800191:	89 d7                	mov    %edx,%edi
  800193:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800195:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80019c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	50                   	push   %eax
  8001a3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a9:	50                   	push   %eax
  8001aa:	e8 e4 17 00 00       	call   801993 <sys_utilities>
  8001af:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b2:	e8 2d 13 00 00       	call   8014e4 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 38 1d 80 00       	push   $0x801d38
  8001bf:	e8 cc 03 00 00       	call   800590 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	74 18                	je     8001e6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001ce:	e8 de 17 00 00       	call   8019b1 <sys_get_optimal_num_faults>
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	50                   	push   %eax
  8001d7:	68 60 1d 80 00       	push   $0x801d60
  8001dc:	e8 af 03 00 00       	call   800590 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	eb 59                	jmp    80023f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001eb:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	52                   	push   %edx
  800200:	50                   	push   %eax
  800201:	68 84 1d 80 00       	push   $0x801d84
  800206:	e8 85 03 00 00       	call   800590 <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800219:	a1 20 30 80 00       	mov    0x803020,%eax
  80021e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80022f:	51                   	push   %ecx
  800230:	52                   	push   %edx
  800231:	50                   	push   %eax
  800232:	68 ac 1d 80 00       	push   $0x801dac
  800237:	e8 54 03 00 00       	call   800590 <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80023f:	a1 20 30 80 00       	mov    0x803020,%eax
  800244:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	50                   	push   %eax
  80024e:	68 04 1e 80 00       	push   $0x801e04
  800253:	e8 38 03 00 00       	call   800590 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 38 1d 80 00       	push   $0x801d38
  800263:	e8 28 03 00 00       	call   800590 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026b:	e8 8e 12 00 00       	call   8014fe <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800270:	e8 1f 00 00 00       	call   800294 <exit>
}
  800275:	90                   	nop
  800276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	5d                   	pop    %ebp
  80027d:	c3                   	ret    

0080027e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	6a 00                	push   $0x0
  800289:	e8 9b 14 00 00       	call   801729 <sys_destroy_env>
  80028e:	83 c4 10             	add    $0x10,%esp
}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <exit>:

void
exit(void)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029a:	e8 f0 14 00 00       	call   80178f <sys_exit_env>
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ab:	83 c0 04             	add    $0x4,%eax
  8002ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b1:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	74 16                	je     8002d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ba:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	50                   	push   %eax
  8002c3:	68 7c 1e 80 00       	push   $0x801e7c
  8002c8:	e8 c3 02 00 00       	call   800590 <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	ff 75 0c             	pushl  0xc(%ebp)
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	50                   	push   %eax
  8002df:	68 84 1e 80 00       	push   $0x801e84
  8002e4:	6a 74                	push   $0x74
  8002e6:	e8 d2 02 00 00       	call   8005bd <cprintf_colored>
  8002eb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f7:	50                   	push   %eax
  8002f8:	e8 24 02 00 00       	call   800521 <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	6a 00                	push   $0x0
  800305:	68 ac 1e 80 00       	push   $0x801eac
  80030a:	e8 12 02 00 00       	call   800521 <vcprintf>
  80030f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800312:	e8 7d ff ff ff       	call   800294 <exit>

	// should not return here
	while (1) ;
  800317:	eb fe                	jmp    800317 <_panic+0x75>

00800319 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	53                   	push   %ebx
  80031d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80032b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032e:	39 c2                	cmp    %eax,%edx
  800330:	74 14                	je     800346 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 b0 1e 80 00       	push   $0x801eb0
  80033a:	6a 26                	push   $0x26
  80033c:	68 fc 1e 80 00       	push   $0x801efc
  800341:	e8 5c ff ff ff       	call   8002a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80034d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800354:	e9 d9 00 00 00       	jmp    800432 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800363:	8b 45 08             	mov    0x8(%ebp),%eax
  800366:	01 d0                	add    %edx,%eax
  800368:	8b 00                	mov    (%eax),%eax
  80036a:	85 c0                	test   %eax,%eax
  80036c:	75 08                	jne    800376 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80036e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800371:	e9 b9 00 00 00       	jmp    80042f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800376:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800384:	eb 79                	jmp    8003ff <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800386:	a1 20 30 80 00       	mov    0x803020,%eax
  80038b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800391:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800394:	89 d0                	mov    %edx,%eax
  800396:	01 c0                	add    %eax,%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003a1:	01 d8                	add    %ebx,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	01 c8                	add    %ecx,%eax
  8003a7:	8a 40 04             	mov    0x4(%eax),%al
  8003aa:	84 c0                	test   %al,%al
  8003ac:	75 4e                	jne    8003fc <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bc:	89 d0                	mov    %edx,%eax
  8003be:	01 c0                	add    %eax,%eax
  8003c0:	01 d0                	add    %edx,%eax
  8003c2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003c9:	01 d8                	add    %ebx,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	01 c8                	add    %ecx,%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ef:	39 c2                	cmp    %eax,%edx
  8003f1:	75 09                	jne    8003fc <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8003f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fa:	eb 19                	jmp    800415 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fc:	ff 45 e8             	incl   -0x18(%ebp)
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040d:	39 c2                	cmp    %eax,%edx
  80040f:	0f 87 71 ff ff ff    	ja     800386 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800415:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800419:	75 14                	jne    80042f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	68 08 1f 80 00       	push   $0x801f08
  800423:	6a 3a                	push   $0x3a
  800425:	68 fc 1e 80 00       	push   $0x801efc
  80042a:	e8 73 fe ff ff       	call   8002a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042f:	ff 45 f0             	incl   -0x10(%ebp)
  800432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800435:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800438:	0f 8c 1b ff ff ff    	jl     800359 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80043e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800445:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80044c:	eb 2e                	jmp    80047c <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80044e:	a1 20 30 80 00       	mov    0x803020,%eax
  800453:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045c:	89 d0                	mov    %edx,%eax
  80045e:	01 c0                	add    %eax,%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800469:	01 d8                	add    %ebx,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	01 c8                	add    %ecx,%eax
  80046f:	8a 40 04             	mov    0x4(%eax),%al
  800472:	3c 01                	cmp    $0x1,%al
  800474:	75 03                	jne    800479 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800476:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800479:	ff 45 e0             	incl   -0x20(%ebp)
  80047c:	a1 20 30 80 00       	mov    0x803020,%eax
  800481:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048a:	39 c2                	cmp    %eax,%edx
  80048c:	77 c0                	ja     80044e <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800491:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800494:	74 14                	je     8004aa <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 5c 1f 80 00       	push   $0x801f5c
  80049e:	6a 44                	push   $0x44
  8004a0:	68 fc 1e 80 00       	push   $0x801efc
  8004a5:	e8 f8 fd ff ff       	call   8002a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004aa:	90                   	nop
  8004ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 30                	jne    80050c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004dc:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004e2:	a0 44 30 80 00       	mov    0x803044,%al
  8004e7:	0f b6 c0             	movzbl %al,%eax
  8004ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ed:	8b 09                	mov    (%ecx),%ecx
  8004ef:	89 cb                	mov    %ecx,%ebx
  8004f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f4:	83 c1 08             	add    $0x8,%ecx
  8004f7:	52                   	push   %edx
  8004f8:	50                   	push   %eax
  8004f9:	53                   	push   %ebx
  8004fa:	51                   	push   %ecx
  8004fb:	e8 a0 0f 00 00       	call   8014a0 <sys_cputs>
  800500:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 40 04             	mov    0x4(%eax),%eax
  800512:	8d 50 01             	lea    0x1(%eax),%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	89 50 04             	mov    %edx,0x4(%eax)
}
  80051b:	90                   	nop
  80051c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800531:	00 00 00 
	b.cnt = 0;
  800534:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80053e:	ff 75 0c             	pushl  0xc(%ebp)
  800541:	ff 75 08             	pushl  0x8(%ebp)
  800544:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054a:	50                   	push   %eax
  80054b:	68 b0 04 80 00       	push   $0x8004b0
  800550:	e8 5a 02 00 00       	call   8007af <vprintfmt>
  800555:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800558:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80055e:	a0 44 30 80 00       	mov    0x803044,%al
  800563:	0f b6 c0             	movzbl %al,%eax
  800566:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80056c:	52                   	push   %edx
  80056d:	50                   	push   %eax
  80056e:	51                   	push   %ecx
  80056f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800575:	83 c0 08             	add    $0x8,%eax
  800578:	50                   	push   %eax
  800579:	e8 22 0f 00 00       	call   8014a0 <sys_cputs>
  80057e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800581:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800588:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800596:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80059d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ac:	50                   	push   %eax
  8005ad:	e8 6f ff ff ff       	call   800521 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005bb:	c9                   	leave  
  8005bc:	c3                   	ret    

008005bd <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005bd:	55                   	push   %ebp
  8005be:	89 e5                	mov    %esp,%ebp
  8005c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	c1 e0 08             	shl    $0x8,%eax
  8005d0:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	50                   	push   %eax
  8005e8:	e8 34 ff ff ff       	call   800521 <vcprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005f3:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005fa:	07 00 00 

	return cnt;
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800608:	e8 d7 0e 00 00       	call   8014e4 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80060d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800610:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	50                   	push   %eax
  80061d:	e8 ff fe ff ff       	call   800521 <vcprintf>
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800628:	e8 d1 0e 00 00       	call   8014fe <sys_unlock_cons>
	return cnt;
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	53                   	push   %ebx
  800636:	83 ec 14             	sub    $0x14,%esp
  800639:	8b 45 10             	mov    0x10(%ebp),%eax
  80063c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800645:	8b 45 18             	mov    0x18(%ebp),%eax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800650:	77 55                	ja     8006a7 <printnum+0x75>
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	72 05                	jb     80065c <printnum+0x2a>
  800657:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065a:	77 4b                	ja     8006a7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80065c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800662:	8b 45 18             	mov    0x18(%ebp),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	52                   	push   %edx
  80066b:	50                   	push   %eax
  80066c:	ff 75 f4             	pushl  -0xc(%ebp)
  80066f:	ff 75 f0             	pushl  -0x10(%ebp)
  800672:	e8 a9 13 00 00       	call   801a20 <__udivdi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	ff 75 20             	pushl  0x20(%ebp)
  800680:	53                   	push   %ebx
  800681:	ff 75 18             	pushl  0x18(%ebp)
  800684:	52                   	push   %edx
  800685:	50                   	push   %eax
  800686:	ff 75 0c             	pushl  0xc(%ebp)
  800689:	ff 75 08             	pushl  0x8(%ebp)
  80068c:	e8 a1 ff ff ff       	call   800632 <printnum>
  800691:	83 c4 20             	add    $0x20,%esp
  800694:	eb 1a                	jmp    8006b0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 0c             	pushl  0xc(%ebp)
  80069c:	ff 75 20             	pushl  0x20(%ebp)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006aa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ae:	7f e6                	jg     800696 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006be:	53                   	push   %ebx
  8006bf:	51                   	push   %ecx
  8006c0:	52                   	push   %edx
  8006c1:	50                   	push   %eax
  8006c2:	e8 69 14 00 00       	call   801b30 <__umoddi3>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	05 d4 21 80 00       	add    $0x8021d4,%eax
  8006cf:	8a 00                	mov    (%eax),%al
  8006d1:	0f be c0             	movsbl %al,%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	50                   	push   %eax
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	ff d0                	call   *%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
}
  8006e3:	90                   	nop
  8006e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f0:	7e 1c                	jle    80070e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	8d 50 08             	lea    0x8(%eax),%edx
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	89 10                	mov    %edx,(%eax)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	83 e8 08             	sub    $0x8,%eax
  800707:	8b 50 04             	mov    0x4(%eax),%edx
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	eb 40                	jmp    80074e <getuint+0x65>
	else if (lflag)
  80070e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800712:	74 1e                	je     800732 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	8d 50 04             	lea    0x4(%eax),%edx
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	89 10                	mov    %edx,(%eax)
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	eb 1c                	jmp    80074e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	8d 50 04             	lea    0x4(%eax),%edx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	89 10                	mov    %edx,(%eax)
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	83 e8 04             	sub    $0x4,%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800753:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800757:	7e 1c                	jle    800775 <getint+0x25>
		return va_arg(*ap, long long);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8d 50 08             	lea    0x8(%eax),%edx
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	89 10                	mov    %edx,(%eax)
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	83 e8 08             	sub    $0x8,%eax
  80076e:	8b 50 04             	mov    0x4(%eax),%edx
  800771:	8b 00                	mov    (%eax),%eax
  800773:	eb 38                	jmp    8007ad <getint+0x5d>
	else if (lflag)
  800775:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800779:	74 1a                	je     800795 <getint+0x45>
		return va_arg(*ap, long);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	99                   	cltd   
  800793:	eb 18                	jmp    8007ad <getint+0x5d>
	else
		return va_arg(*ap, int);
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	89 10                	mov    %edx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	99                   	cltd   
}
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	56                   	push   %esi
  8007b3:	53                   	push   %ebx
  8007b4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b7:	eb 17                	jmp    8007d0 <vprintfmt+0x21>
			if (ch == '\0')
  8007b9:	85 db                	test   %ebx,%ebx
  8007bb:	0f 84 c1 03 00 00    	je     800b82 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	8d 50 01             	lea    0x1(%eax),%edx
  8007d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d9:	8a 00                	mov    (%eax),%al
  8007db:	0f b6 d8             	movzbl %al,%ebx
  8007de:	83 fb 25             	cmp    $0x25,%ebx
  8007e1:	75 d6                	jne    8007b9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	8d 50 01             	lea    0x1(%eax),%edx
  800809:	89 55 10             	mov    %edx,0x10(%ebp)
  80080c:	8a 00                	mov    (%eax),%al
  80080e:	0f b6 d8             	movzbl %al,%ebx
  800811:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800814:	83 f8 5b             	cmp    $0x5b,%eax
  800817:	0f 87 3d 03 00 00    	ja     800b5a <vprintfmt+0x3ab>
  80081d:	8b 04 85 f8 21 80 00 	mov    0x8021f8(,%eax,4),%eax
  800824:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800826:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082a:	eb d7                	jmp    800803 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80082c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800830:	eb d1                	jmp    800803 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800832:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800839:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	c1 e0 02             	shl    $0x2,%eax
  800841:	01 d0                	add    %edx,%eax
  800843:	01 c0                	add    %eax,%eax
  800845:	01 d8                	add    %ebx,%eax
  800847:	83 e8 30             	sub    $0x30,%eax
  80084a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	8a 00                	mov    (%eax),%al
  800852:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800855:	83 fb 2f             	cmp    $0x2f,%ebx
  800858:	7e 3e                	jle    800898 <vprintfmt+0xe9>
  80085a:	83 fb 39             	cmp    $0x39,%ebx
  80085d:	7f 39                	jg     800898 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800862:	eb d5                	jmp    800839 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	83 c0 04             	add    $0x4,%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 e8 04             	sub    $0x4,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800878:	eb 1f                	jmp    800899 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087e:	79 83                	jns    800803 <vprintfmt+0x54>
				width = 0;
  800880:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800887:	e9 77 ff ff ff       	jmp    800803 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80088c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800893:	e9 6b ff ff ff       	jmp    800803 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800898:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089d:	0f 89 60 ff ff ff    	jns    800803 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b0:	e9 4e ff ff ff       	jmp    800803 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b8:	e9 46 ff ff ff       	jmp    800803 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 c0 04             	add    $0x4,%eax
  8008c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	83 e8 04             	sub    $0x4,%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	ff d0                	call   *%eax
  8008da:	83 c4 10             	add    $0x10,%esp
			break;
  8008dd:	e9 9b 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	83 c0 04             	add    $0x4,%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f3:	85 db                	test   %ebx,%ebx
  8008f5:	79 02                	jns    8008f9 <vprintfmt+0x14a>
				err = -err;
  8008f7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f9:	83 fb 64             	cmp    $0x64,%ebx
  8008fc:	7f 0b                	jg     800909 <vprintfmt+0x15a>
  8008fe:	8b 34 9d 40 20 80 00 	mov    0x802040(,%ebx,4),%esi
  800905:	85 f6                	test   %esi,%esi
  800907:	75 19                	jne    800922 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800909:	53                   	push   %ebx
  80090a:	68 e5 21 80 00       	push   $0x8021e5
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 70 02 00 00       	call   800b8a <printfmt>
  80091a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091d:	e9 5b 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800922:	56                   	push   %esi
  800923:	68 ee 21 80 00       	push   $0x8021ee
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	ff 75 08             	pushl  0x8(%ebp)
  80092e:	e8 57 02 00 00       	call   800b8a <printfmt>
  800933:	83 c4 10             	add    $0x10,%esp
			break;
  800936:	e9 42 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 c0 04             	add    $0x4,%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 30                	mov    (%eax),%esi
  80094c:	85 f6                	test   %esi,%esi
  80094e:	75 05                	jne    800955 <vprintfmt+0x1a6>
				p = "(null)";
  800950:	be f1 21 80 00       	mov    $0x8021f1,%esi
			if (width > 0 && padc != '-')
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	7e 6d                	jle    8009c8 <vprintfmt+0x219>
  80095b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095f:	74 67                	je     8009c8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	50                   	push   %eax
  800968:	56                   	push   %esi
  800969:	e8 1e 03 00 00       	call   800c8c <strnlen>
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800974:	eb 16                	jmp    80098c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800976:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	50                   	push   %eax
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
  800986:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800989:	ff 4d e4             	decl   -0x1c(%ebp)
  80098c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800990:	7f e4                	jg     800976 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800992:	eb 34                	jmp    8009c8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800994:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800998:	74 1c                	je     8009b6 <vprintfmt+0x207>
  80099a:	83 fb 1f             	cmp    $0x1f,%ebx
  80099d:	7e 05                	jle    8009a4 <vprintfmt+0x1f5>
  80099f:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a2:	7e 12                	jle    8009b6 <vprintfmt+0x207>
					putch('?', putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	6a 3f                	push   $0x3f
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	eb 0f                	jmp    8009c5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c8:	89 f0                	mov    %esi,%eax
  8009ca:	8d 70 01             	lea    0x1(%eax),%esi
  8009cd:	8a 00                	mov    (%eax),%al
  8009cf:	0f be d8             	movsbl %al,%ebx
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	74 24                	je     8009fa <vprintfmt+0x24b>
  8009d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009da:	78 b8                	js     800994 <vprintfmt+0x1e5>
  8009dc:	ff 4d e0             	decl   -0x20(%ebp)
  8009df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e3:	79 af                	jns    800994 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e5:	eb 13                	jmp    8009fa <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 20                	push   $0x20
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fe:	7f e7                	jg     8009e7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a00:	e9 78 01 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0e:	50                   	push   %eax
  800a0f:	e8 3c fd ff ff       	call   800750 <getint>
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a23:	85 d2                	test   %edx,%edx
  800a25:	79 23                	jns    800a4a <vprintfmt+0x29b>
				putch('-', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 2d                	push   $0x2d
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3d:	f7 d8                	neg    %eax
  800a3f:	83 d2 00             	adc    $0x0,%edx
  800a42:	f7 da                	neg    %edx
  800a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a51:	e9 bc 00 00 00       	jmp    800b12 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5f:	50                   	push   %eax
  800a60:	e8 84 fc ff ff       	call   8006e9 <getuint>
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a75:	e9 98 00 00 00       	jmp    800b12 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	6a 58                	push   $0x58
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 58                	push   $0x58
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 58                	push   $0x58
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			break;
  800aaa:	e9 ce 00 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	6a 30                	push   $0x30
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 78                	push   $0x78
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	83 e8 04             	sub    $0x4,%eax
  800ade:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af1:	eb 1f                	jmp    800b12 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 e8             	pushl  -0x18(%ebp)
  800af9:	8d 45 14             	lea    0x14(%ebp),%eax
  800afc:	50                   	push   %eax
  800afd:	e8 e7 fb ff ff       	call   8006e9 <getuint>
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b0b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b12:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	52                   	push   %edx
  800b1d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b20:	50                   	push   %eax
  800b21:	ff 75 f4             	pushl  -0xc(%ebp)
  800b24:	ff 75 f0             	pushl  -0x10(%ebp)
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	ff 75 08             	pushl  0x8(%ebp)
  800b2d:	e8 00 fb ff ff       	call   800632 <printnum>
  800b32:	83 c4 20             	add    $0x20,%esp
			break;
  800b35:	eb 46                	jmp    800b7d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	53                   	push   %ebx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
			break;
  800b46:	eb 35                	jmp    800b7d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b48:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b4f:	eb 2c                	jmp    800b7d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b51:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b58:	eb 23                	jmp    800b7d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	6a 25                	push   $0x25
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6a:	ff 4d 10             	decl   0x10(%ebp)
  800b6d:	eb 03                	jmp    800b72 <vprintfmt+0x3c3>
  800b6f:	ff 4d 10             	decl   0x10(%ebp)
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	48                   	dec    %eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	3c 25                	cmp    $0x25,%al
  800b7a:	75 f3                	jne    800b6f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b7c:	90                   	nop
		}
	}
  800b7d:	e9 35 fc ff ff       	jmp    8007b7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b82:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b90:	8d 45 10             	lea    0x10(%ebp),%eax
  800b93:	83 c0 04             	add    $0x4,%eax
  800b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9f:	50                   	push   %eax
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	ff 75 08             	pushl  0x8(%ebp)
  800ba6:	e8 04 fc ff ff       	call   8007af <vprintfmt>
  800bab:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bae:	90                   	nop
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 40 08             	mov    0x8(%eax),%eax
  800bba:	8d 50 01             	lea    0x1(%eax),%edx
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8b 10                	mov    (%eax),%edx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	8b 40 04             	mov    0x4(%eax),%eax
  800bce:	39 c2                	cmp    %eax,%edx
  800bd0:	73 12                	jae    800be4 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	8d 48 01             	lea    0x1(%eax),%ecx
  800bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdd:	89 0a                	mov    %ecx,(%edx)
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	88 10                	mov    %dl,(%eax)
}
  800be4:	90                   	nop
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	01 d0                	add    %edx,%eax
  800bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0c:	74 06                	je     800c14 <vsnprintf+0x2d>
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	7f 07                	jg     800c1b <vsnprintf+0x34>
		return -E_INVAL;
  800c14:	b8 03 00 00 00       	mov    $0x3,%eax
  800c19:	eb 20                	jmp    800c3b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1b:	ff 75 14             	pushl  0x14(%ebp)
  800c1e:	ff 75 10             	pushl  0x10(%ebp)
  800c21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c24:	50                   	push   %eax
  800c25:	68 b1 0b 80 00       	push   $0x800bb1
  800c2a:	e8 80 fb ff ff       	call   8007af <vprintfmt>
  800c2f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c35:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c43:	8d 45 10             	lea    0x10(%ebp),%eax
  800c46:	83 c0 04             	add    $0x4,%eax
  800c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c52:	50                   	push   %eax
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	e8 89 ff ff ff       	call   800be7 <vsnprintf>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c76:	eb 06                	jmp    800c7e <strlen+0x15>
		n++;
  800c78:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 f1                	jne    800c78 <strlen+0xf>
		n++;
	return n;
  800c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c99:	eb 09                	jmp    800ca4 <strnlen+0x18>
		n++;
  800c9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9e:	ff 45 08             	incl   0x8(%ebp)
  800ca1:	ff 4d 0c             	decl   0xc(%ebp)
  800ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca8:	74 09                	je     800cb3 <strnlen+0x27>
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	84 c0                	test   %al,%al
  800cb1:	75 e8                	jne    800c9b <strnlen+0xf>
		n++;
	return n;
  800cb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc4:	90                   	nop
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	84 c0                	test   %al,%al
  800cdf:	75 e4                	jne    800cc5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf9:	eb 1f                	jmp    800d1a <strncpy+0x34>
		*dst++ = *src;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8d 50 01             	lea    0x1(%eax),%edx
  800d01:	89 55 08             	mov    %edx,0x8(%ebp)
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	8a 12                	mov    (%edx),%dl
  800d09:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	74 03                	je     800d17 <strncpy+0x31>
			src++;
  800d14:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d17:	ff 45 fc             	incl   -0x4(%ebp)
  800d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d20:	72 d9                	jb     800cfb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d37:	74 30                	je     800d69 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d39:	eb 16                	jmp    800d51 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8d 50 01             	lea    0x1(%eax),%edx
  800d41:	89 55 08             	mov    %edx,0x8(%ebp)
  800d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4d:	8a 12                	mov    (%edx),%dl
  800d4f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d51:	ff 4d 10             	decl   0x10(%ebp)
  800d54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d58:	74 09                	je     800d63 <strlcpy+0x3c>
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	84 c0                	test   %al,%al
  800d61:	75 d8                	jne    800d3b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6f:	29 c2                	sub    %eax,%edx
  800d71:	89 d0                	mov    %edx,%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d78:	eb 06                	jmp    800d80 <strcmp+0xb>
		p++, q++;
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	74 0e                	je     800d97 <strcmp+0x22>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 10                	mov    (%eax),%dl
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	38 c2                	cmp    %al,%dl
  800d95:	74 e3                	je     800d7a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f b6 d0             	movzbl %al,%edx
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	0f b6 c0             	movzbl %al,%eax
  800da7:	29 c2                	sub    %eax,%edx
  800da9:	89 d0                	mov    %edx,%eax
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db0:	eb 09                	jmp    800dbb <strncmp+0xe>
		n--, p++, q++;
  800db2:	ff 4d 10             	decl   0x10(%ebp)
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	74 17                	je     800dd8 <strncmp+0x2b>
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	74 0e                	je     800dd8 <strncmp+0x2b>
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 10                	mov    (%eax),%dl
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	38 c2                	cmp    %al,%dl
  800dd6:	74 da                	je     800db2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	75 07                	jne    800de5 <strncmp+0x38>
		return 0;
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	eb 14                	jmp    800df9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 d0             	movzbl %al,%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 c0             	movzbl %al,%eax
  800df5:	29 c2                	sub    %eax,%edx
  800df7:	89 d0                	mov    %edx,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 04             	sub    $0x4,%esp
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e07:	eb 12                	jmp    800e1b <strchr+0x20>
		if (*s == c)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e11:	75 05                	jne    800e18 <strchr+0x1d>
			return (char *) s;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	eb 11                	jmp    800e29 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e18:	ff 45 08             	incl   0x8(%ebp)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 e5                	jne    800e09 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e37:	eb 0d                	jmp    800e46 <strfind+0x1b>
		if (*s == c)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e41:	74 0e                	je     800e51 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 ea                	jne    800e39 <strfind+0xe>
  800e4f:	eb 01                	jmp    800e52 <strfind+0x27>
		if (*s == c)
			break;
  800e51:	90                   	nop
	return (char *) s;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e63:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e67:	76 63                	jbe    800ecc <memset+0x75>
		uint64 data_block = c;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	99                   	cltd   
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e79:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e7d:	c1 e0 08             	shl    $0x8,%eax
  800e80:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e83:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e90:	c1 e0 10             	shl    $0x10,%eax
  800e93:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e96:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eac:	eb 18                	jmp    800ec6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb1:	8d 41 08             	lea    0x8(%ecx),%eax
  800eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebd:	89 01                	mov    %eax,(%ecx)
  800ebf:	89 51 04             	mov    %edx,0x4(%ecx)
  800ec2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ec6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eca:	77 e2                	ja     800eae <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed0:	74 23                	je     800ef5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 0e                	jmp    800ee8 <memset+0x91>
			*p8++ = (uint8)c;
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 e5                	jne    800eda <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f0c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f10:	76 24                	jbe    800f36 <memcpy+0x3c>
		while(n >= 8){
  800f12:	eb 1c                	jmp    800f30 <memcpy+0x36>
			*d64 = *s64;
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f17:	8b 50 04             	mov    0x4(%eax),%edx
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f1f:	89 01                	mov    %eax,(%ecx)
  800f21:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f24:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f28:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f2c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f34:	77 de                	ja     800f14 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	74 31                	je     800f6d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f48:	eb 16                	jmp    800f60 <memcpy+0x66>
			*d8++ = *s8++;
  800f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f59:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f5c:	8a 12                	mov    (%edx),%dl
  800f5e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f66:	89 55 10             	mov    %edx,0x10(%ebp)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	75 dd                	jne    800f4a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8a:	73 50                	jae    800fdc <memmove+0x6a>
  800f8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f97:	76 43                	jbe    800fdc <memmove+0x6a>
		s += n;
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa5:	eb 10                	jmp    800fb7 <memmove+0x45>
			*--d = *--s;
  800fa7:	ff 4d f8             	decl   -0x8(%ebp)
  800faa:	ff 4d fc             	decl   -0x4(%ebp)
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	8a 10                	mov    (%eax),%dl
  800fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	75 e3                	jne    800fa7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc4:	eb 23                	jmp    800fe9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd8:	8a 12                	mov    (%edx),%dl
  800fda:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	75 dd                	jne    800fc6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801000:	eb 2a                	jmp    80102c <memcmp+0x3e>
		if (*s1 != *s2)
  801002:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801005:	8a 10                	mov    (%eax),%dl
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	38 c2                	cmp    %al,%dl
  80100e:	74 16                	je     801026 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f b6 d0             	movzbl %al,%edx
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	0f b6 c0             	movzbl %al,%eax
  801020:	29 c2                	sub    %eax,%edx
  801022:	89 d0                	mov    %edx,%eax
  801024:	eb 18                	jmp    80103e <memcmp+0x50>
		s1++, s2++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
  801029:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	89 55 10             	mov    %edx,0x10(%ebp)
  801035:	85 c0                	test   %eax,%eax
  801037:	75 c9                	jne    801002 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801051:	eb 15                	jmp    801068 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f b6 d0             	movzbl %al,%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	0f b6 c0             	movzbl %al,%eax
  801061:	39 c2                	cmp    %eax,%edx
  801063:	74 0d                	je     801072 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801065:	ff 45 08             	incl   0x8(%ebp)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80106e:	72 e3                	jb     801053 <memfind+0x13>
  801070:	eb 01                	jmp    801073 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801072:	90                   	nop
	return (void *) s;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80107e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801085:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108c:	eb 03                	jmp    801091 <strtol+0x19>
		s++;
  80108e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 20                	cmp    $0x20,%al
  801098:	74 f4                	je     80108e <strtol+0x16>
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3c 09                	cmp    $0x9,%al
  8010a1:	74 eb                	je     80108e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 2b                	cmp    $0x2b,%al
  8010aa:	75 05                	jne    8010b1 <strtol+0x39>
		s++;
  8010ac:	ff 45 08             	incl   0x8(%ebp)
  8010af:	eb 13                	jmp    8010c4 <strtol+0x4c>
	else if (*s == '-')
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 2d                	cmp    $0x2d,%al
  8010b8:	75 0a                	jne    8010c4 <strtol+0x4c>
		s++, neg = 1;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	74 06                	je     8010d0 <strtol+0x58>
  8010ca:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ce:	75 20                	jne    8010f0 <strtol+0x78>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 30                	cmp    $0x30,%al
  8010d7:	75 17                	jne    8010f0 <strtol+0x78>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	40                   	inc    %eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 78                	cmp    $0x78,%al
  8010e1:	75 0d                	jne    8010f0 <strtol+0x78>
		s += 2, base = 16;
  8010e3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ee:	eb 28                	jmp    801118 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	75 15                	jne    80110b <strtol+0x93>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 0c                	jne    80110b <strtol+0x93>
		s++, base = 8;
  8010ff:	ff 45 08             	incl   0x8(%ebp)
  801102:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801109:	eb 0d                	jmp    801118 <strtol+0xa0>
	else if (base == 0)
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	75 07                	jne    801118 <strtol+0xa0>
		base = 10;
  801111:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 2f                	cmp    $0x2f,%al
  80111f:	7e 19                	jle    80113a <strtol+0xc2>
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	3c 39                	cmp    $0x39,%al
  801128:	7f 10                	jg     80113a <strtol+0xc2>
			dig = *s - '0';
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	0f be c0             	movsbl %al,%eax
  801132:	83 e8 30             	sub    $0x30,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801138:	eb 42                	jmp    80117c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 60                	cmp    $0x60,%al
  801141:	7e 19                	jle    80115c <strtol+0xe4>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	3c 7a                	cmp    $0x7a,%al
  80114a:	7f 10                	jg     80115c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	83 e8 57             	sub    $0x57,%eax
  801157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115a:	eb 20                	jmp    80117c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 40                	cmp    $0x40,%al
  801163:	7e 39                	jle    80119e <strtol+0x126>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 5a                	cmp    $0x5a,%al
  80116c:	7f 30                	jg     80119e <strtol+0x126>
			dig = *s - 'A' + 10;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f be c0             	movsbl %al,%eax
  801176:	83 e8 37             	sub    $0x37,%eax
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801182:	7d 19                	jge    80119d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801198:	e9 7b ff ff ff       	jmp    801118 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80119d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80119e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a2:	74 08                	je     8011ac <strtol+0x134>
		*endptr = (char *) s;
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b0:	74 07                	je     8011b9 <strtol+0x141>
  8011b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b5:	f7 d8                	neg    %eax
  8011b7:	eb 03                	jmp    8011bc <strtol+0x144>
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <ltostr>:

void
ltostr(long value, char *str)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d6:	79 13                	jns    8011eb <ltostr+0x2d>
	{
		neg = 1;
  8011d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011e5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011f3:	99                   	cltd   
  8011f4:	f7 f9                	idiv   %ecx
  8011f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fc:	8d 50 01             	lea    0x1(%eax),%edx
  8011ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801202:	89 c2                	mov    %eax,%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80120c:	83 c2 30             	add    $0x30,%edx
  80120f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801211:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801214:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801219:	f7 e9                	imul   %ecx
  80121b:	c1 fa 02             	sar    $0x2,%edx
  80121e:	89 c8                	mov    %ecx,%eax
  801220:	c1 f8 1f             	sar    $0x1f,%eax
  801223:	29 c2                	sub    %eax,%edx
  801225:	89 d0                	mov    %edx,%eax
  801227:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80122a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122e:	75 bb                	jne    8011eb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	48                   	dec    %eax
  80123b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80123e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801242:	74 3d                	je     801281 <ltostr+0xc3>
		start = 1 ;
  801244:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80124b:	eb 34                	jmp    801281 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80125a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80126e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c2                	add    %eax,%edx
  801276:	8a 45 eb             	mov    -0x15(%ebp),%al
  801279:	88 02                	mov    %al,(%edx)
		start++ ;
  80127b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80127e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801284:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801287:	7c c4                	jl     80124d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801289:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801294:	90                   	nop
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 c4 f9 ff ff       	call   800c69 <strlen>
  8012a5:	83 c4 04             	add    $0x4,%esp
  8012a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	e8 b6 f9 ff ff       	call   800c69 <strlen>
  8012b3:	83 c4 04             	add    $0x4,%esp
  8012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c7:	eb 17                	jmp    8012e0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	01 c2                	add    %eax,%edx
  8012d1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	01 c8                	add    %ecx,%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012dd:	ff 45 fc             	incl   -0x4(%ebp)
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012e6:	7c e1                	jl     8012c9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012f6:	eb 1f                	jmp    801317 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fb:	8d 50 01             	lea    0x1(%eax),%edx
  8012fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801301:	89 c2                	mov    %eax,%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 c8                	add    %ecx,%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801314:	ff 45 f8             	incl   -0x8(%ebp)
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80131d:	7c d9                	jl     8012f8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80131f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	c6 00 00             	movb   $0x0,(%eax)
}
  80132a:	90                   	nop
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801330:	8b 45 14             	mov    0x14(%ebp),%eax
  801333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801339:	8b 45 14             	mov    0x14(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801350:	eb 0c                	jmp    80135e <strsplit+0x31>
			*string++ = 0;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8d 50 01             	lea    0x1(%eax),%edx
  801358:	89 55 08             	mov    %edx,0x8(%ebp)
  80135b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 18                	je     80137f <strsplit+0x52>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	0f be c0             	movsbl %al,%eax
  80136f:	50                   	push   %eax
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	e8 83 fa ff ff       	call   800dfb <strchr>
  801378:	83 c4 08             	add    $0x8,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	75 d3                	jne    801352 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	74 5a                	je     8013e2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801388:	8b 45 14             	mov    0x14(%ebp),%eax
  80138b:	8b 00                	mov    (%eax),%eax
  80138d:	83 f8 0f             	cmp    $0xf,%eax
  801390:	75 07                	jne    801399 <strsplit+0x6c>
		{
			return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	eb 66                	jmp    8013ff <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801399:	8b 45 14             	mov    0x14(%ebp),%eax
  80139c:	8b 00                	mov    (%eax),%eax
  80139e:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a4:	89 0a                	mov    %ecx,(%edx)
  8013a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	01 c2                	add    %eax,%edx
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b7:	eb 03                	jmp    8013bc <strsplit+0x8f>
			string++;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	84 c0                	test   %al,%al
  8013c3:	74 8b                	je     801350 <strsplit+0x23>
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	0f be c0             	movsbl %al,%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 75 0c             	pushl  0xc(%ebp)
  8013d1:	e8 25 fa ff ff       	call   800dfb <strchr>
  8013d6:	83 c4 08             	add    $0x8,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 dc                	je     8013b9 <strsplit+0x8c>
			string++;
	}
  8013dd:	e9 6e ff ff ff       	jmp    801350 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013e2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013fa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80140d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801414:	eb 4a                	jmp    801460 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801416:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	01 c2                	add    %eax,%edx
  80141e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 c8                	add    %ecx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3c 40                	cmp    $0x40,%al
  801436:	7e 25                	jle    80145d <str2lower+0x5c>
  801438:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	3c 5a                	cmp    $0x5a,%al
  801444:	7f 17                	jg     80145d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801451:	8b 55 08             	mov    0x8(%ebp),%edx
  801454:	01 ca                	add    %ecx,%edx
  801456:	8a 12                	mov    (%edx),%dl
  801458:	83 c2 20             	add    $0x20,%edx
  80145b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80145d:	ff 45 fc             	incl   -0x4(%ebp)
  801460:	ff 75 0c             	pushl  0xc(%ebp)
  801463:	e8 01 f8 ff ff       	call   800c69 <strlen>
  801468:	83 c4 04             	add    $0x4,%esp
  80146b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80146e:	7f a6                	jg     801416 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801470:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	57                   	push   %edi
  801479:	56                   	push   %esi
  80147a:	53                   	push   %ebx
  80147b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8b 55 0c             	mov    0xc(%ebp),%edx
  801484:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801487:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80148a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80148d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801490:	cd 30                	int    $0x30
  801492:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	5b                   	pop    %ebx
  80149c:	5e                   	pop    %esi
  80149d:	5f                   	pop    %edi
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    

008014a0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	6a 00                	push   $0x0
  8014b8:	51                   	push   %ecx
  8014b9:	52                   	push   %edx
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	50                   	push   %eax
  8014be:	6a 00                	push   $0x0
  8014c0:	e8 b0 ff ff ff       	call   801475 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_cgetc>:

int
sys_cgetc(void)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 02                	push   $0x2
  8014da:	e8 96 ff ff ff       	call   801475 <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 03                	push   $0x3
  8014f3:	e8 7d ff ff ff       	call   801475 <syscall>
  8014f8:	83 c4 18             	add    $0x18,%esp
}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 04                	push   $0x4
  80150d:	e8 63 ff ff ff       	call   801475 <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	90                   	nop
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	6a 08                	push   $0x8
  80152b:	e8 45 ff ff ff       	call   801475 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	56                   	push   %esi
  801539:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80153a:	8b 75 18             	mov    0x18(%ebp),%esi
  80153d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801540:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	51                   	push   %ecx
  80154c:	52                   	push   %edx
  80154d:	50                   	push   %eax
  80154e:	6a 09                	push   $0x9
  801550:	e8 20 ff ff ff       	call   801475 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
}
  801558:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155b:	5b                   	pop    %ebx
  80155c:	5e                   	pop    %esi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	ff 75 08             	pushl  0x8(%ebp)
  80156d:	6a 0a                	push   $0xa
  80156f:	e8 01 ff ff ff       	call   801475 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	6a 0b                	push   $0xb
  80158a:	e8 e6 fe ff ff       	call   801475 <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 0c                	push   $0xc
  8015a3:	e8 cd fe ff ff       	call   801475 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 0d                	push   $0xd
  8015bc:	e8 b4 fe ff ff       	call   801475 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 0e                	push   $0xe
  8015d5:	e8 9b fe ff ff       	call   801475 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 0f                	push   $0xf
  8015ee:	e8 82 fe ff ff       	call   801475 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	ff 75 08             	pushl  0x8(%ebp)
  801606:	6a 10                	push   $0x10
  801608:	e8 68 fe ff ff       	call   801475 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 11                	push   $0x11
  801621:	e8 4f fe ff ff       	call   801475 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_cputc>:

void
sys_cputc(const char c)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801638:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	50                   	push   %eax
  801645:	6a 01                	push   $0x1
  801647:	e8 29 fe ff ff       	call   801475 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	90                   	nop
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 14                	push   $0x14
  801661:	e8 0f fe ff ff       	call   801475 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801678:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80167b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	51                   	push   %ecx
  801685:	52                   	push   %edx
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	50                   	push   %eax
  80168a:	6a 15                	push   $0x15
  80168c:	e8 e4 fd ff ff       	call   801475 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	6a 16                	push   $0x16
  8016a9:	e8 c7 fd ff ff       	call   801475 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	51                   	push   %ecx
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 17                	push   $0x17
  8016c8:	e8 a8 fd ff ff       	call   801475 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	52                   	push   %edx
  8016e2:	50                   	push   %eax
  8016e3:	6a 18                	push   $0x18
  8016e5:	e8 8b fd ff ff       	call   801475 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	6a 00                	push   $0x0
  8016f7:	ff 75 14             	pushl  0x14(%ebp)
  8016fa:	ff 75 10             	pushl  0x10(%ebp)
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	50                   	push   %eax
  801701:	6a 19                	push   $0x19
  801703:	e8 6d fd ff ff       	call   801475 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	50                   	push   %eax
  80171c:	6a 1a                	push   $0x1a
  80171e:	e8 52 fd ff ff       	call   801475 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	90                   	nop
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	50                   	push   %eax
  801738:	6a 1b                	push   $0x1b
  80173a:	e8 36 fd ff ff       	call   801475 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 05                	push   $0x5
  801753:	e8 1d fd ff ff       	call   801475 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 06                	push   $0x6
  80176c:	e8 04 fd ff ff       	call   801475 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 07                	push   $0x7
  801785:	e8 eb fc ff ff       	call   801475 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_exit_env>:


void sys_exit_env(void)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 1c                	push   $0x1c
  80179e:	e8 d2 fc ff ff       	call   801475 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	90                   	nop
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b2:	8d 50 04             	lea    0x4(%eax),%edx
  8017b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	52                   	push   %edx
  8017bf:	50                   	push   %eax
  8017c0:	6a 1d                	push   $0x1d
  8017c2:	e8 ae fc ff ff       	call   801475 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d3:	89 01                	mov    %eax,(%ecx)
  8017d5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	c9                   	leave  
  8017dc:	c2 04 00             	ret    $0x4

008017df <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 10             	pushl  0x10(%ebp)
  8017e9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ec:	ff 75 08             	pushl  0x8(%ebp)
  8017ef:	6a 13                	push   $0x13
  8017f1:	e8 7f fc ff ff       	call   801475 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f9:	90                   	nop
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_rcr2>:
uint32 sys_rcr2()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 1e                	push   $0x1e
  80180b:	e8 65 fc ff ff       	call   801475 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801821:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	50                   	push   %eax
  80182e:	6a 1f                	push   $0x1f
  801830:	e8 40 fc ff ff       	call   801475 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
	return ;
  801838:	90                   	nop
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <rsttst>:
void rsttst()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 21                	push   $0x21
  80184a:	e8 26 fc ff ff       	call   801475 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
	return ;
  801852:	90                   	nop
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	8b 45 14             	mov    0x14(%ebp),%eax
  80185e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801861:	8b 55 18             	mov    0x18(%ebp),%edx
  801864:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	ff 75 10             	pushl  0x10(%ebp)
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	6a 20                	push   $0x20
  801875:	e8 fb fb ff ff       	call   801475 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
	return ;
  80187d:	90                   	nop
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <chktst>:
void chktst(uint32 n)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	6a 22                	push   $0x22
  801890:	e8 e0 fb ff ff       	call   801475 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return ;
  801898:	90                   	nop
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <inctst>:

void inctst()
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 23                	push   $0x23
  8018aa:	e8 c6 fb ff ff       	call   801475 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b2:	90                   	nop
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <gettst>:
uint32 gettst()
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 24                	push   $0x24
  8018c4:	e8 ac fb ff ff       	call   801475 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 25                	push   $0x25
  8018dd:	e8 93 fb ff ff       	call   801475 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
  8018e5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018ea:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	6a 26                	push   $0x26
  801909:	e8 67 fb ff ff       	call   801475 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return ;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801918:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	53                   	push   %ebx
  801927:	51                   	push   %ecx
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 27                	push   $0x27
  80192c:	e8 44 fb ff ff       	call   801475 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 28                	push   $0x28
  80194c:	e8 24 fb ff ff       	call   801475 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801959:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	51                   	push   %ecx
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	6a 29                	push   $0x29
  80196c:	e8 04 fb ff ff       	call   801475 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 10             	pushl  0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	6a 12                	push   $0x12
  801988:	e8 e8 fa ff ff       	call   801475 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
	return ;
  801990:	90                   	nop
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801996:	8b 55 0c             	mov    0xc(%ebp),%edx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	52                   	push   %edx
  8019a3:	50                   	push   %eax
  8019a4:	6a 2a                	push   $0x2a
  8019a6:	e8 ca fa ff ff       	call   801475 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 2b                	push   $0x2b
  8019c0:	e8 b0 fa ff ff       	call   801475 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	6a 2d                	push   $0x2d
  8019db:	e8 95 fa ff ff       	call   801475 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	ff 75 08             	pushl  0x8(%ebp)
  8019f5:	6a 2c                	push   $0x2c
  8019f7:	e8 79 fa ff ff       	call   801475 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ff:	90                   	nop
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 2e                	push   $0x2e
  801a15:	e8 5b fa ff ff       	call   801475 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <__udivdi3>:
  801a20:	55                   	push   %ebp
  801a21:	57                   	push   %edi
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
  801a24:	83 ec 1c             	sub    $0x1c,%esp
  801a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a37:	89 ca                	mov    %ecx,%edx
  801a39:	89 f8                	mov    %edi,%eax
  801a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a3f:	85 f6                	test   %esi,%esi
  801a41:	75 2d                	jne    801a70 <__udivdi3+0x50>
  801a43:	39 cf                	cmp    %ecx,%edi
  801a45:	77 65                	ja     801aac <__udivdi3+0x8c>
  801a47:	89 fd                	mov    %edi,%ebp
  801a49:	85 ff                	test   %edi,%edi
  801a4b:	75 0b                	jne    801a58 <__udivdi3+0x38>
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a52:	31 d2                	xor    %edx,%edx
  801a54:	f7 f7                	div    %edi
  801a56:	89 c5                	mov    %eax,%ebp
  801a58:	31 d2                	xor    %edx,%edx
  801a5a:	89 c8                	mov    %ecx,%eax
  801a5c:	f7 f5                	div    %ebp
  801a5e:	89 c1                	mov    %eax,%ecx
  801a60:	89 d8                	mov    %ebx,%eax
  801a62:	f7 f5                	div    %ebp
  801a64:	89 cf                	mov    %ecx,%edi
  801a66:	89 fa                	mov    %edi,%edx
  801a68:	83 c4 1c             	add    $0x1c,%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5f                   	pop    %edi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
  801a70:	39 ce                	cmp    %ecx,%esi
  801a72:	77 28                	ja     801a9c <__udivdi3+0x7c>
  801a74:	0f bd fe             	bsr    %esi,%edi
  801a77:	83 f7 1f             	xor    $0x1f,%edi
  801a7a:	75 40                	jne    801abc <__udivdi3+0x9c>
  801a7c:	39 ce                	cmp    %ecx,%esi
  801a7e:	72 0a                	jb     801a8a <__udivdi3+0x6a>
  801a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a84:	0f 87 9e 00 00 00    	ja     801b28 <__udivdi3+0x108>
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	89 fa                	mov    %edi,%edx
  801a91:	83 c4 1c             	add    $0x1c,%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5f                   	pop    %edi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    
  801a99:	8d 76 00             	lea    0x0(%esi),%esi
  801a9c:	31 ff                	xor    %edi,%edi
  801a9e:	31 c0                	xor    %eax,%eax
  801aa0:	89 fa                	mov    %edi,%edx
  801aa2:	83 c4 1c             	add    $0x1c,%esp
  801aa5:	5b                   	pop    %ebx
  801aa6:	5e                   	pop    %esi
  801aa7:	5f                   	pop    %edi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	f7 f7                	div    %edi
  801ab0:	31 ff                	xor    %edi,%edi
  801ab2:	89 fa                	mov    %edi,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ac1:	89 eb                	mov    %ebp,%ebx
  801ac3:	29 fb                	sub    %edi,%ebx
  801ac5:	89 f9                	mov    %edi,%ecx
  801ac7:	d3 e6                	shl    %cl,%esi
  801ac9:	89 c5                	mov    %eax,%ebp
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 ed                	shr    %cl,%ebp
  801acf:	89 e9                	mov    %ebp,%ecx
  801ad1:	09 f1                	or     %esi,%ecx
  801ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ad7:	89 f9                	mov    %edi,%ecx
  801ad9:	d3 e0                	shl    %cl,%eax
  801adb:	89 c5                	mov    %eax,%ebp
  801add:	89 d6                	mov    %edx,%esi
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 ee                	shr    %cl,%esi
  801ae3:	89 f9                	mov    %edi,%ecx
  801ae5:	d3 e2                	shl    %cl,%edx
  801ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 e8                	shr    %cl,%eax
  801aef:	09 c2                	or     %eax,%edx
  801af1:	89 d0                	mov    %edx,%eax
  801af3:	89 f2                	mov    %esi,%edx
  801af5:	f7 74 24 0c          	divl   0xc(%esp)
  801af9:	89 d6                	mov    %edx,%esi
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	f7 e5                	mul    %ebp
  801aff:	39 d6                	cmp    %edx,%esi
  801b01:	72 19                	jb     801b1c <__udivdi3+0xfc>
  801b03:	74 0b                	je     801b10 <__udivdi3+0xf0>
  801b05:	89 d8                	mov    %ebx,%eax
  801b07:	31 ff                	xor    %edi,%edi
  801b09:	e9 58 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b14:	89 f9                	mov    %edi,%ecx
  801b16:	d3 e2                	shl    %cl,%edx
  801b18:	39 c2                	cmp    %eax,%edx
  801b1a:	73 e9                	jae    801b05 <__udivdi3+0xe5>
  801b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b1f:	31 ff                	xor    %edi,%edi
  801b21:	e9 40 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	31 c0                	xor    %eax,%eax
  801b2a:	e9 37 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b2f:	90                   	nop

00801b30 <__umoddi3>:
  801b30:	55                   	push   %ebp
  801b31:	57                   	push   %edi
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 1c             	sub    $0x1c,%esp
  801b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b4f:	89 f3                	mov    %esi,%ebx
  801b51:	89 fa                	mov    %edi,%edx
  801b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b57:	89 34 24             	mov    %esi,(%esp)
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	75 1a                	jne    801b78 <__umoddi3+0x48>
  801b5e:	39 f7                	cmp    %esi,%edi
  801b60:	0f 86 a2 00 00 00    	jbe    801c08 <__umoddi3+0xd8>
  801b66:	89 c8                	mov    %ecx,%eax
  801b68:	89 f2                	mov    %esi,%edx
  801b6a:	f7 f7                	div    %edi
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	31 d2                	xor    %edx,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	39 f0                	cmp    %esi,%eax
  801b7a:	0f 87 ac 00 00 00    	ja     801c2c <__umoddi3+0xfc>
  801b80:	0f bd e8             	bsr    %eax,%ebp
  801b83:	83 f5 1f             	xor    $0x1f,%ebp
  801b86:	0f 84 ac 00 00 00    	je     801c38 <__umoddi3+0x108>
  801b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b91:	29 ef                	sub    %ebp,%edi
  801b93:	89 fe                	mov    %edi,%esi
  801b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b99:	89 e9                	mov    %ebp,%ecx
  801b9b:	d3 e0                	shl    %cl,%eax
  801b9d:	89 d7                	mov    %edx,%edi
  801b9f:	89 f1                	mov    %esi,%ecx
  801ba1:	d3 ef                	shr    %cl,%edi
  801ba3:	09 c7                	or     %eax,%edi
  801ba5:	89 e9                	mov    %ebp,%ecx
  801ba7:	d3 e2                	shl    %cl,%edx
  801ba9:	89 14 24             	mov    %edx,(%esp)
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	d3 e0                	shl    %cl,%eax
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb6:	d3 e0                	shl    %cl,%eax
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc0:	89 f1                	mov    %esi,%ecx
  801bc2:	d3 e8                	shr    %cl,%eax
  801bc4:	09 d0                	or     %edx,%eax
  801bc6:	d3 eb                	shr    %cl,%ebx
  801bc8:	89 da                	mov    %ebx,%edx
  801bca:	f7 f7                	div    %edi
  801bcc:	89 d3                	mov    %edx,%ebx
  801bce:	f7 24 24             	mull   (%esp)
  801bd1:	89 c6                	mov    %eax,%esi
  801bd3:	89 d1                	mov    %edx,%ecx
  801bd5:	39 d3                	cmp    %edx,%ebx
  801bd7:	0f 82 87 00 00 00    	jb     801c64 <__umoddi3+0x134>
  801bdd:	0f 84 91 00 00 00    	je     801c74 <__umoddi3+0x144>
  801be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801be7:	29 f2                	sub    %esi,%edx
  801be9:	19 cb                	sbb    %ecx,%ebx
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bf1:	d3 e0                	shl    %cl,%eax
  801bf3:	89 e9                	mov    %ebp,%ecx
  801bf5:	d3 ea                	shr    %cl,%edx
  801bf7:	09 d0                	or     %edx,%eax
  801bf9:	89 e9                	mov    %ebp,%ecx
  801bfb:	d3 eb                	shr    %cl,%ebx
  801bfd:	89 da                	mov    %ebx,%edx
  801bff:	83 c4 1c             	add    $0x1c,%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5f                   	pop    %edi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    
  801c07:	90                   	nop
  801c08:	89 fd                	mov    %edi,%ebp
  801c0a:	85 ff                	test   %edi,%edi
  801c0c:	75 0b                	jne    801c19 <__umoddi3+0xe9>
  801c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c13:	31 d2                	xor    %edx,%edx
  801c15:	f7 f7                	div    %edi
  801c17:	89 c5                	mov    %eax,%ebp
  801c19:	89 f0                	mov    %esi,%eax
  801c1b:	31 d2                	xor    %edx,%edx
  801c1d:	f7 f5                	div    %ebp
  801c1f:	89 c8                	mov    %ecx,%eax
  801c21:	f7 f5                	div    %ebp
  801c23:	89 d0                	mov    %edx,%eax
  801c25:	e9 44 ff ff ff       	jmp    801b6e <__umoddi3+0x3e>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	89 c8                	mov    %ecx,%eax
  801c2e:	89 f2                	mov    %esi,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	3b 04 24             	cmp    (%esp),%eax
  801c3b:	72 06                	jb     801c43 <__umoddi3+0x113>
  801c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c41:	77 0f                	ja     801c52 <__umoddi3+0x122>
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	29 f9                	sub    %edi,%ecx
  801c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c4b:	89 14 24             	mov    %edx,(%esp)
  801c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c56:	8b 14 24             	mov    (%esp),%edx
  801c59:	83 c4 1c             	add    $0x1c,%esp
  801c5c:	5b                   	pop    %ebx
  801c5d:	5e                   	pop    %esi
  801c5e:	5f                   	pop    %edi
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    
  801c61:	8d 76 00             	lea    0x0(%esi),%esi
  801c64:	2b 04 24             	sub    (%esp),%eax
  801c67:	19 fa                	sbb    %edi,%edx
  801c69:	89 d1                	mov    %edx,%ecx
  801c6b:	89 c6                	mov    %eax,%esi
  801c6d:	e9 71 ff ff ff       	jmp    801be3 <__umoddi3+0xb3>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c78:	72 ea                	jb     801c64 <__umoddi3+0x134>
  801c7a:	89 d9                	mov    %ebx,%ecx
  801c7c:	e9 62 ff ff ff       	jmp    801be3 <__umoddi3+0xb3>
