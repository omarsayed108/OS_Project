
obj/user/tst_custom_fit_2:     file format elf32-i386


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
  800031:	e8 a4 00 00 00       	call   8000da <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 80 1c 80 00       	push   $0x801c80
  80005a:	e8 19 05 00 00       	call   800578 <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 b0 1c 80 00       	push   $0x801cb0
  8000aa:	e8 c9 04 00 00       	call   800578 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 68             	sub    $0x68,%esp
	panic("update is required!!");
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 e9 1c 80 00       	push   $0x801ce9
  8000ce:	6a 19                	push   $0x19
  8000d0:	68 fe 1c 80 00       	push   $0x801cfe
  8000d5:	e8 b0 01 00 00       	call   80028a <_panic>

008000da <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	57                   	push   %edi
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
  8000e0:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e3:	e8 5d 16 00 00       	call   801745 <sys_getenvindex>
  8000e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ee:	89 d0                	mov    %edx,%eax
  8000f0:	01 c0                	add    %eax,%eax
  8000f2:	01 d0                	add    %edx,%eax
  8000f4:	c1 e0 02             	shl    $0x2,%eax
  8000f7:	01 d0                	add    %edx,%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	01 d0                	add    %edx,%eax
  8000fe:	c1 e0 03             	shl    $0x3,%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c1 e0 02             	shl    $0x2,%eax
  800106:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010b:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800110:	a1 40 30 80 00       	mov    0x803040,%eax
  800115:	8a 40 20             	mov    0x20(%eax),%al
  800118:	84 c0                	test   %al,%al
  80011a:	74 0d                	je     800129 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80011c:	a1 40 30 80 00       	mov    0x803040,%eax
  800121:	83 c0 20             	add    $0x20,%eax
  800124:	a3 20 30 80 00       	mov    %eax,0x803020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800129:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012d:	7e 0a                	jle    800139 <libmain+0x5f>
		binaryname = argv[0];
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8b 00                	mov    (%eax),%eax
  800134:	a3 20 30 80 00       	mov    %eax,0x803020

	// call user main routine
	_main(argc, argv);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 79 ff ff ff       	call   8000c0 <_main>
  800147:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014a:	a1 1c 30 80 00       	mov    0x80301c,%eax
  80014f:	85 c0                	test   %eax,%eax
  800151:	0f 84 01 01 00 00    	je     800258 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800157:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80015d:	bb 10 1e 80 00       	mov    $0x801e10,%ebx
  800162:	ba 0e 00 00 00       	mov    $0xe,%edx
  800167:	89 c7                	mov    %eax,%edi
  800169:	89 de                	mov    %ebx,%esi
  80016b:	89 d1                	mov    %edx,%ecx
  80016d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80016f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800172:	b9 56 00 00 00       	mov    $0x56,%ecx
  800177:	b0 00                	mov    $0x0,%al
  800179:	89 d7                	mov    %edx,%edi
  80017b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80017d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800184:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800187:	83 ec 08             	sub    $0x8,%esp
  80018a:	50                   	push   %eax
  80018b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	e8 e4 17 00 00       	call   80197b <sys_utilities>
  800197:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80019a:	e8 2d 13 00 00       	call   8014cc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 30 1d 80 00       	push   $0x801d30
  8001a7:	e8 cc 03 00 00       	call   800578 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	74 18                	je     8001ce <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001b6:	e8 de 17 00 00       	call   801999 <sys_get_optimal_num_faults>
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	50                   	push   %eax
  8001bf:	68 58 1d 80 00       	push   $0x801d58
  8001c4:	e8 af 03 00 00       	call   800578 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	eb 59                	jmp    800227 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ce:	a1 40 30 80 00       	mov    0x803040,%eax
  8001d3:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8001d9:	a1 40 30 80 00       	mov    0x803040,%eax
  8001de:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8001e4:	83 ec 04             	sub    $0x4,%esp
  8001e7:	52                   	push   %edx
  8001e8:	50                   	push   %eax
  8001e9:	68 7c 1d 80 00       	push   $0x801d7c
  8001ee:	e8 85 03 00 00       	call   800578 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f6:	a1 40 30 80 00       	mov    0x803040,%eax
  8001fb:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800201:	a1 40 30 80 00       	mov    0x803040,%eax
  800206:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80020c:	a1 40 30 80 00       	mov    0x803040,%eax
  800211:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800217:	51                   	push   %ecx
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	68 a4 1d 80 00       	push   $0x801da4
  80021f:	e8 54 03 00 00       	call   800578 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800227:	a1 40 30 80 00       	mov    0x803040,%eax
  80022c:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800232:	83 ec 08             	sub    $0x8,%esp
  800235:	50                   	push   %eax
  800236:	68 fc 1d 80 00       	push   $0x801dfc
  80023b:	e8 38 03 00 00       	call   800578 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	68 30 1d 80 00       	push   $0x801d30
  80024b:	e8 28 03 00 00       	call   800578 <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800253:	e8 8e 12 00 00       	call   8014e6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800258:	e8 1f 00 00 00       	call   80027c <exit>
}
  80025d:	90                   	nop
  80025e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800261:	5b                   	pop    %ebx
  800262:	5e                   	pop    %esi
  800263:	5f                   	pop    %edi
  800264:	5d                   	pop    %ebp
  800265:	c3                   	ret    

00800266 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	6a 00                	push   $0x0
  800271:	e8 9b 14 00 00       	call   801711 <sys_destroy_env>
  800276:	83 c4 10             	add    $0x10,%esp
}
  800279:	90                   	nop
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <exit>:

void
exit(void)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800282:	e8 f0 14 00 00       	call   801777 <sys_exit_env>
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800290:	8d 45 10             	lea    0x10(%ebp),%eax
  800293:	83 c0 04             	add    $0x4,%eax
  800296:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800299:	a1 38 f3 81 00       	mov    0x81f338,%eax
  80029e:	85 c0                	test   %eax,%eax
  8002a0:	74 16                	je     8002b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a2:	a1 38 f3 81 00       	mov    0x81f338,%eax
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	50                   	push   %eax
  8002ab:	68 74 1e 80 00       	push   $0x801e74
  8002b0:	e8 c3 02 00 00       	call   800578 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	ff 75 08             	pushl  0x8(%ebp)
  8002c6:	50                   	push   %eax
  8002c7:	68 7c 1e 80 00       	push   $0x801e7c
  8002cc:	6a 74                	push   $0x74
  8002ce:	e8 d2 02 00 00       	call   8005a5 <cprintf_colored>
  8002d3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002df:	50                   	push   %eax
  8002e0:	e8 24 02 00 00       	call   800509 <vcprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	6a 00                	push   $0x0
  8002ed:	68 a4 1e 80 00       	push   $0x801ea4
  8002f2:	e8 12 02 00 00       	call   800509 <vcprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fa:	e8 7d ff ff ff       	call   80027c <exit>

	// should not return here
	while (1) ;
  8002ff:	eb fe                	jmp    8002ff <_panic+0x75>

00800301 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	53                   	push   %ebx
  800305:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 40 30 80 00       	mov    0x803040,%eax
  80030d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
  800316:	39 c2                	cmp    %eax,%edx
  800318:	74 14                	je     80032e <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 a8 1e 80 00       	push   $0x801ea8
  800322:	6a 26                	push   $0x26
  800324:	68 f4 1e 80 00       	push   $0x801ef4
  800329:	e8 5c ff ff ff       	call   80028a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800335:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80033c:	e9 d9 00 00 00       	jmp    80041a <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800344:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	01 d0                	add    %edx,%eax
  800350:	8b 00                	mov    (%eax),%eax
  800352:	85 c0                	test   %eax,%eax
  800354:	75 08                	jne    80035e <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800356:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800359:	e9 b9 00 00 00       	jmp    800417 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80035e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036c:	eb 79                	jmp    8003e7 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036e:	a1 40 30 80 00       	mov    0x803040,%eax
  800373:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800379:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	01 c0                	add    %eax,%eax
  800380:	01 d0                	add    %edx,%eax
  800382:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800389:	01 d8                	add    %ebx,%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	01 c8                	add    %ecx,%eax
  80038f:	8a 40 04             	mov    0x4(%eax),%al
  800392:	84 c0                	test   %al,%al
  800394:	75 4e                	jne    8003e4 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800396:	a1 40 30 80 00       	mov    0x803040,%eax
  80039b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a4:	89 d0                	mov    %edx,%eax
  8003a6:	01 c0                	add    %eax,%eax
  8003a8:	01 d0                	add    %edx,%eax
  8003aa:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003b1:	01 d8                	add    %ebx,%eax
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	01 c8                	add    %ecx,%eax
  8003d5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d7:	39 c2                	cmp    %eax,%edx
  8003d9:	75 09                	jne    8003e4 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8003db:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e2:	eb 19                	jmp    8003fd <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e4:	ff 45 e8             	incl   -0x18(%ebp)
  8003e7:	a1 40 30 80 00       	mov    0x803040,%eax
  8003ec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f5:	39 c2                	cmp    %eax,%edx
  8003f7:	0f 87 71 ff ff ff    	ja     80036e <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800401:	75 14                	jne    800417 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	68 00 1f 80 00       	push   $0x801f00
  80040b:	6a 3a                	push   $0x3a
  80040d:	68 f4 1e 80 00       	push   $0x801ef4
  800412:	e8 73 fe ff ff       	call   80028a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800417:	ff 45 f0             	incl   -0x10(%ebp)
  80041a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800420:	0f 8c 1b ff ff ff    	jl     800341 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800434:	eb 2e                	jmp    800464 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800436:	a1 40 30 80 00       	mov    0x803040,%eax
  80043b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800444:	89 d0                	mov    %edx,%eax
  800446:	01 c0                	add    %eax,%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800451:	01 d8                	add    %ebx,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	01 c8                	add    %ecx,%eax
  800457:	8a 40 04             	mov    0x4(%eax),%al
  80045a:	3c 01                	cmp    $0x1,%al
  80045c:	75 03                	jne    800461 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80045e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800461:	ff 45 e0             	incl   -0x20(%ebp)
  800464:	a1 40 30 80 00       	mov    0x803040,%eax
  800469:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80046f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	77 c0                	ja     800436 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800479:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047c:	74 14                	je     800492 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80047e:	83 ec 04             	sub    $0x4,%esp
  800481:	68 54 1f 80 00       	push   $0x801f54
  800486:	6a 44                	push   $0x44
  800488:	68 f4 1e 80 00       	push   $0x801ef4
  80048d:	e8 f8 fd ff ff       	call   80028a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800492:	90                   	nop
  800493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	53                   	push   %ebx
  80049c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004aa:	89 0a                	mov    %ecx,(%edx)
  8004ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8004af:	88 d1                	mov    %dl,%cl
  8004b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c2:	75 30                	jne    8004f4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004c4:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  8004ca:	a0 64 30 80 00       	mov    0x803064,%al
  8004cf:	0f b6 c0             	movzbl %al,%eax
  8004d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d5:	8b 09                	mov    (%ecx),%ecx
  8004d7:	89 cb                	mov    %ecx,%ebx
  8004d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004dc:	83 c1 08             	add    $0x8,%ecx
  8004df:	52                   	push   %edx
  8004e0:	50                   	push   %eax
  8004e1:	53                   	push   %ebx
  8004e2:	51                   	push   %ecx
  8004e3:	e8 a0 0f 00 00       	call   801488 <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800507:	c9                   	leave  
  800508:	c3                   	ret    

00800509 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800512:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800519:	00 00 00 
	b.cnt = 0;
  80051c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800523:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800526:	ff 75 0c             	pushl  0xc(%ebp)
  800529:	ff 75 08             	pushl  0x8(%ebp)
  80052c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800532:	50                   	push   %eax
  800533:	68 98 04 80 00       	push   $0x800498
  800538:	e8 5a 02 00 00       	call   800797 <vprintfmt>
  80053d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800540:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  800546:	a0 64 30 80 00       	mov    0x803064,%al
  80054b:	0f b6 c0             	movzbl %al,%eax
  80054e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800554:	52                   	push   %edx
  800555:	50                   	push   %eax
  800556:	51                   	push   %ecx
  800557:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055d:	83 c0 08             	add    $0x8,%eax
  800560:	50                   	push   %eax
  800561:	e8 22 0f 00 00       	call   801488 <sys_cputs>
  800566:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800569:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  800570:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80057e:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  800585:	8d 45 0c             	lea    0xc(%ebp),%eax
  800588:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 f4             	pushl  -0xc(%ebp)
  800594:	50                   	push   %eax
  800595:	e8 6f ff ff ff       	call   800509 <vcprintf>
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ab:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	c1 e0 08             	shl    $0x8,%eax
  8005b8:	a3 3c f3 81 00       	mov    %eax,0x81f33c
	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	83 c0 04             	add    $0x4,%eax
  8005c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cf:	50                   	push   %eax
  8005d0:	e8 34 ff ff ff       	call   800509 <vcprintf>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005db:	c7 05 3c f3 81 00 00 	movl   $0x700,0x81f33c
  8005e2:	07 00 00 

	return cnt;
  8005e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e8:	c9                   	leave  
  8005e9:	c3                   	ret    

008005ea <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005f0:	e8 d7 0e 00 00       	call   8014cc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	50                   	push   %eax
  800605:	e8 ff fe ff ff       	call   800509 <vcprintf>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800610:	e8 d1 0e 00 00       	call   8014e6 <sys_unlock_cons>
	return cnt;
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800618:	c9                   	leave  
  800619:	c3                   	ret    

0080061a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
  80061d:	53                   	push   %ebx
  80061e:	83 ec 14             	sub    $0x14,%esp
  800621:	8b 45 10             	mov    0x10(%ebp),%eax
  800624:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062d:	8b 45 18             	mov    0x18(%ebp),%eax
  800630:	ba 00 00 00 00       	mov    $0x0,%edx
  800635:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800638:	77 55                	ja     80068f <printnum+0x75>
  80063a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80063d:	72 05                	jb     800644 <printnum+0x2a>
  80063f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800642:	77 4b                	ja     80068f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800644:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800647:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	52                   	push   %edx
  800653:	50                   	push   %eax
  800654:	ff 75 f4             	pushl  -0xc(%ebp)
  800657:	ff 75 f0             	pushl  -0x10(%ebp)
  80065a:	e8 a9 13 00 00       	call   801a08 <__udivdi3>
  80065f:	83 c4 10             	add    $0x10,%esp
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	ff 75 20             	pushl  0x20(%ebp)
  800668:	53                   	push   %ebx
  800669:	ff 75 18             	pushl  0x18(%ebp)
  80066c:	52                   	push   %edx
  80066d:	50                   	push   %eax
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	ff 75 08             	pushl  0x8(%ebp)
  800674:	e8 a1 ff ff ff       	call   80061a <printnum>
  800679:	83 c4 20             	add    $0x20,%esp
  80067c:	eb 1a                	jmp    800698 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	ff 75 20             	pushl  0x20(%ebp)
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	ff d0                	call   *%eax
  80068c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068f:	ff 4d 1c             	decl   0x1c(%ebp)
  800692:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800696:	7f e6                	jg     80067e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800698:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80069b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a6:	53                   	push   %ebx
  8006a7:	51                   	push   %ecx
  8006a8:	52                   	push   %edx
  8006a9:	50                   	push   %eax
  8006aa:	e8 69 14 00 00       	call   801b18 <__umoddi3>
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	05 b4 21 80 00       	add    $0x8021b4,%eax
  8006b7:	8a 00                	mov    (%eax),%al
  8006b9:	0f be c0             	movsbl %al,%eax
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	50                   	push   %eax
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	ff d0                	call   *%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
}
  8006cb:	90                   	nop
  8006cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d8:	7e 1c                	jle    8006f6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	8d 50 08             	lea    0x8(%eax),%edx
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	89 10                	mov    %edx,(%eax)
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	83 e8 08             	sub    $0x8,%eax
  8006ef:	8b 50 04             	mov    0x4(%eax),%edx
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	eb 40                	jmp    800736 <getuint+0x65>
	else if (lflag)
  8006f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006fa:	74 1e                	je     80071a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	8d 50 04             	lea    0x4(%eax),%edx
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	89 10                	mov    %edx,(%eax)
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	83 e8 04             	sub    $0x4,%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	eb 1c                	jmp    800736 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	8d 50 04             	lea    0x4(%eax),%edx
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	89 10                	mov    %edx,(%eax)
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	83 e8 04             	sub    $0x4,%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800736:	5d                   	pop    %ebp
  800737:	c3                   	ret    

00800738 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80073b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073f:	7e 1c                	jle    80075d <getint+0x25>
		return va_arg(*ap, long long);
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	8d 50 08             	lea    0x8(%eax),%edx
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	89 10                	mov    %edx,(%eax)
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 e8 08             	sub    $0x8,%eax
  800756:	8b 50 04             	mov    0x4(%eax),%edx
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	eb 38                	jmp    800795 <getint+0x5d>
	else if (lflag)
  80075d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800761:	74 1a                	je     80077d <getint+0x45>
		return va_arg(*ap, long);
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	8d 50 04             	lea    0x4(%eax),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 10                	mov    %edx,(%eax)
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	83 e8 04             	sub    $0x4,%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	99                   	cltd   
  80077b:	eb 18                	jmp    800795 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	8d 50 04             	lea    0x4(%eax),%edx
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	89 10                	mov    %edx,(%eax)
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	83 e8 04             	sub    $0x4,%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	99                   	cltd   
}
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	56                   	push   %esi
  80079b:	53                   	push   %ebx
  80079c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079f:	eb 17                	jmp    8007b8 <vprintfmt+0x21>
			if (ch == '\0')
  8007a1:	85 db                	test   %ebx,%ebx
  8007a3:	0f 84 c1 03 00 00    	je     800b6a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	53                   	push   %ebx
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	ff d0                	call   *%eax
  8007b5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bb:	8d 50 01             	lea    0x1(%eax),%edx
  8007be:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c1:	8a 00                	mov    (%eax),%al
  8007c3:	0f b6 d8             	movzbl %al,%ebx
  8007c6:	83 fb 25             	cmp    $0x25,%ebx
  8007c9:	75 d6                	jne    8007a1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007cb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007cf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007e4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ee:	8d 50 01             	lea    0x1(%eax),%edx
  8007f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f4:	8a 00                	mov    (%eax),%al
  8007f6:	0f b6 d8             	movzbl %al,%ebx
  8007f9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007fc:	83 f8 5b             	cmp    $0x5b,%eax
  8007ff:	0f 87 3d 03 00 00    	ja     800b42 <vprintfmt+0x3ab>
  800805:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
  80080c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80080e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800812:	eb d7                	jmp    8007eb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800814:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800818:	eb d1                	jmp    8007eb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80081a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800821:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800824:	89 d0                	mov    %edx,%eax
  800826:	c1 e0 02             	shl    $0x2,%eax
  800829:	01 d0                	add    %edx,%eax
  80082b:	01 c0                	add    %eax,%eax
  80082d:	01 d8                	add    %ebx,%eax
  80082f:	83 e8 30             	sub    $0x30,%eax
  800832:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800835:	8b 45 10             	mov    0x10(%ebp),%eax
  800838:	8a 00                	mov    (%eax),%al
  80083a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80083d:	83 fb 2f             	cmp    $0x2f,%ebx
  800840:	7e 3e                	jle    800880 <vprintfmt+0xe9>
  800842:	83 fb 39             	cmp    $0x39,%ebx
  800845:	7f 39                	jg     800880 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800847:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80084a:	eb d5                	jmp    800821 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 c0 04             	add    $0x4,%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800860:	eb 1f                	jmp    800881 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800862:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800866:	79 83                	jns    8007eb <vprintfmt+0x54>
				width = 0;
  800868:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80086f:	e9 77 ff ff ff       	jmp    8007eb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800874:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80087b:	e9 6b ff ff ff       	jmp    8007eb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800880:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800881:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800885:	0f 89 60 ff ff ff    	jns    8007eb <vprintfmt+0x54>
				width = precision, precision = -1;
  80088b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800891:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800898:	e9 4e ff ff ff       	jmp    8007eb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80089d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008a0:	e9 46 ff ff ff       	jmp    8007eb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	50                   	push   %eax
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	ff d0                	call   *%eax
  8008c2:	83 c4 10             	add    $0x10,%esp
			break;
  8008c5:	e9 9b 02 00 00       	jmp    800b65 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 c0 04             	add    $0x4,%eax
  8008d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 e8 04             	sub    $0x4,%eax
  8008d9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008db:	85 db                	test   %ebx,%ebx
  8008dd:	79 02                	jns    8008e1 <vprintfmt+0x14a>
				err = -err;
  8008df:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008e1:	83 fb 64             	cmp    $0x64,%ebx
  8008e4:	7f 0b                	jg     8008f1 <vprintfmt+0x15a>
  8008e6:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  8008ed:	85 f6                	test   %esi,%esi
  8008ef:	75 19                	jne    80090a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f1:	53                   	push   %ebx
  8008f2:	68 c5 21 80 00       	push   $0x8021c5
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	ff 75 08             	pushl  0x8(%ebp)
  8008fd:	e8 70 02 00 00       	call   800b72 <printfmt>
  800902:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800905:	e9 5b 02 00 00       	jmp    800b65 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80090a:	56                   	push   %esi
  80090b:	68 ce 21 80 00       	push   $0x8021ce
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	ff 75 08             	pushl  0x8(%ebp)
  800916:	e8 57 02 00 00       	call   800b72 <printfmt>
  80091b:	83 c4 10             	add    $0x10,%esp
			break;
  80091e:	e9 42 02 00 00       	jmp    800b65 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 c0 04             	add    $0x4,%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 e8 04             	sub    $0x4,%eax
  800932:	8b 30                	mov    (%eax),%esi
  800934:	85 f6                	test   %esi,%esi
  800936:	75 05                	jne    80093d <vprintfmt+0x1a6>
				p = "(null)";
  800938:	be d1 21 80 00       	mov    $0x8021d1,%esi
			if (width > 0 && padc != '-')
  80093d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800941:	7e 6d                	jle    8009b0 <vprintfmt+0x219>
  800943:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800947:	74 67                	je     8009b0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800949:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	50                   	push   %eax
  800950:	56                   	push   %esi
  800951:	e8 1e 03 00 00       	call   800c74 <strnlen>
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80095c:	eb 16                	jmp    800974 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80095e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800971:	ff 4d e4             	decl   -0x1c(%ebp)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	7f e4                	jg     80095e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097a:	eb 34                	jmp    8009b0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80097c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800980:	74 1c                	je     80099e <vprintfmt+0x207>
  800982:	83 fb 1f             	cmp    $0x1f,%ebx
  800985:	7e 05                	jle    80098c <vprintfmt+0x1f5>
  800987:	83 fb 7e             	cmp    $0x7e,%ebx
  80098a:	7e 12                	jle    80099e <vprintfmt+0x207>
					putch('?', putdat);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	6a 3f                	push   $0x3f
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	ff d0                	call   *%eax
  800999:	83 c4 10             	add    $0x10,%esp
  80099c:	eb 0f                	jmp    8009ad <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	53                   	push   %ebx
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	ff d0                	call   *%eax
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ad:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b0:	89 f0                	mov    %esi,%eax
  8009b2:	8d 70 01             	lea    0x1(%eax),%esi
  8009b5:	8a 00                	mov    (%eax),%al
  8009b7:	0f be d8             	movsbl %al,%ebx
  8009ba:	85 db                	test   %ebx,%ebx
  8009bc:	74 24                	je     8009e2 <vprintfmt+0x24b>
  8009be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c2:	78 b8                	js     80097c <vprintfmt+0x1e5>
  8009c4:	ff 4d e0             	decl   -0x20(%ebp)
  8009c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009cb:	79 af                	jns    80097c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009cd:	eb 13                	jmp    8009e2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 20                	push   $0x20
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009df:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	7f e7                	jg     8009cf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009e8:	e9 78 01 00 00       	jmp    800b65 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f6:	50                   	push   %eax
  8009f7:	e8 3c fd ff ff       	call   800738 <getint>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0b:	85 d2                	test   %edx,%edx
  800a0d:	79 23                	jns    800a32 <vprintfmt+0x29b>
				putch('-', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 2d                	push   $0x2d
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a25:	f7 d8                	neg    %eax
  800a27:	83 d2 00             	adc    $0x0,%edx
  800a2a:	f7 da                	neg    %edx
  800a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a32:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a39:	e9 bc 00 00 00       	jmp    800afa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 e8             	pushl  -0x18(%ebp)
  800a44:	8d 45 14             	lea    0x14(%ebp),%eax
  800a47:	50                   	push   %eax
  800a48:	e8 84 fc ff ff       	call   8006d1 <getuint>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a5d:	e9 98 00 00 00       	jmp    800afa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	6a 58                	push   $0x58
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 58                	push   $0x58
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 ce 00 00 00       	jmp    800b65 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	6a 30                	push   $0x30
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	6a 78                	push   $0x78
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ad2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad9:	eb 1f                	jmp    800afa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae4:	50                   	push   %eax
  800ae5:	e8 e7 fb ff ff       	call   8006d1 <getuint>
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800af3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800afa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b01:	83 ec 04             	sub    $0x4,%esp
  800b04:	52                   	push   %edx
  800b05:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b08:	50                   	push   %eax
  800b09:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	ff 75 08             	pushl  0x8(%ebp)
  800b15:	e8 00 fb ff ff       	call   80061a <printnum>
  800b1a:	83 c4 20             	add    $0x20,%esp
			break;
  800b1d:	eb 46                	jmp    800b65 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			break;
  800b2e:	eb 35                	jmp    800b65 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b30:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
			break;
  800b37:	eb 2c                	jmp    800b65 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b39:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
			break;
  800b40:	eb 23                	jmp    800b65 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	6a 25                	push   $0x25
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	ff d0                	call   *%eax
  800b4f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b52:	ff 4d 10             	decl   0x10(%ebp)
  800b55:	eb 03                	jmp    800b5a <vprintfmt+0x3c3>
  800b57:	ff 4d 10             	decl   0x10(%ebp)
  800b5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5d:	48                   	dec    %eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	3c 25                	cmp    $0x25,%al
  800b62:	75 f3                	jne    800b57 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b64:	90                   	nop
		}
	}
  800b65:	e9 35 fc ff ff       	jmp    80079f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b6a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b78:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7b:	83 c0 04             	add    $0x4,%eax
  800b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b81:	8b 45 10             	mov    0x10(%ebp),%eax
  800b84:	ff 75 f4             	pushl  -0xc(%ebp)
  800b87:	50                   	push   %eax
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	ff 75 08             	pushl  0x8(%ebp)
  800b8e:	e8 04 fc ff ff       	call   800797 <vprintfmt>
  800b93:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b96:	90                   	nop
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	8b 40 08             	mov    0x8(%eax),%eax
  800ba2:	8d 50 01             	lea    0x1(%eax),%edx
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	8b 10                	mov    (%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	8b 40 04             	mov    0x4(%eax),%eax
  800bb6:	39 c2                	cmp    %eax,%edx
  800bb8:	73 12                	jae    800bcc <sprintputch+0x33>
		*b->buf++ = ch;
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc5:	89 0a                	mov    %ecx,(%edx)
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	88 10                	mov    %dl,(%eax)
}
  800bcc:	90                   	nop
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	01 d0                	add    %edx,%eax
  800be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf4:	74 06                	je     800bfc <vsnprintf+0x2d>
  800bf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfa:	7f 07                	jg     800c03 <vsnprintf+0x34>
		return -E_INVAL;
  800bfc:	b8 03 00 00 00       	mov    $0x3,%eax
  800c01:	eb 20                	jmp    800c23 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c03:	ff 75 14             	pushl  0x14(%ebp)
  800c06:	ff 75 10             	pushl  0x10(%ebp)
  800c09:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0c:	50                   	push   %eax
  800c0d:	68 99 0b 80 00       	push   $0x800b99
  800c12:	e8 80 fb ff ff       	call   800797 <vprintfmt>
  800c17:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2e:	83 c0 04             	add    $0x4,%eax
  800c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c34:	8b 45 10             	mov    0x10(%ebp),%eax
  800c37:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3a:	50                   	push   %eax
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	ff 75 08             	pushl  0x8(%ebp)
  800c41:	e8 89 ff ff ff       	call   800bcf <vsnprintf>
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5e:	eb 06                	jmp    800c66 <strlen+0x15>
		n++;
  800c60:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c63:	ff 45 08             	incl   0x8(%ebp)
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	84 c0                	test   %al,%al
  800c6d:	75 f1                	jne    800c60 <strlen+0xf>
		n++;
	return n;
  800c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c81:	eb 09                	jmp    800c8c <strnlen+0x18>
		n++;
  800c83:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c86:	ff 45 08             	incl   0x8(%ebp)
  800c89:	ff 4d 0c             	decl   0xc(%ebp)
  800c8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c90:	74 09                	je     800c9b <strnlen+0x27>
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	84 c0                	test   %al,%al
  800c99:	75 e8                	jne    800c83 <strnlen+0xf>
		n++;
	return n;
  800c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cac:	90                   	nop
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8d 50 01             	lea    0x1(%eax),%edx
  800cb3:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbf:	8a 12                	mov    (%edx),%dl
  800cc1:	88 10                	mov    %dl,(%eax)
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	84 c0                	test   %al,%al
  800cc7:	75 e4                	jne    800cad <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce1:	eb 1f                	jmp    800d02 <strncpy+0x34>
		*dst++ = *src;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8d 50 01             	lea    0x1(%eax),%edx
  800ce9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cef:	8a 12                	mov    (%edx),%dl
  800cf1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	84 c0                	test   %al,%al
  800cfa:	74 03                	je     800cff <strncpy+0x31>
			src++;
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cff:	ff 45 fc             	incl   -0x4(%ebp)
  800d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d08:	72 d9                	jb     800ce3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1f:	74 30                	je     800d51 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d21:	eb 16                	jmp    800d39 <strlcpy+0x2a>
			*dst++ = *src++;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8d 50 01             	lea    0x1(%eax),%edx
  800d29:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d32:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d35:	8a 12                	mov    (%edx),%dl
  800d37:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d39:	ff 4d 10             	decl   0x10(%ebp)
  800d3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d40:	74 09                	je     800d4b <strlcpy+0x3c>
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 d8                	jne    800d23 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d57:	29 c2                	sub    %eax,%edx
  800d59:	89 d0                	mov    %edx,%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d60:	eb 06                	jmp    800d68 <strcmp+0xb>
		p++, q++;
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 0e                	je     800d7f <strcmp+0x22>
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	38 c2                	cmp    %al,%dl
  800d7d:	74 e3                	je     800d62 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	0f b6 d0             	movzbl %al,%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	0f b6 c0             	movzbl %al,%eax
  800d8f:	29 c2                	sub    %eax,%edx
  800d91:	89 d0                	mov    %edx,%eax
}
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d98:	eb 09                	jmp    800da3 <strncmp+0xe>
		n--, p++, q++;
  800d9a:	ff 4d 10             	decl   0x10(%ebp)
  800d9d:	ff 45 08             	incl   0x8(%ebp)
  800da0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da7:	74 17                	je     800dc0 <strncmp+0x2b>
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	84 c0                	test   %al,%al
  800db0:	74 0e                	je     800dc0 <strncmp+0x2b>
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 10                	mov    (%eax),%dl
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	38 c2                	cmp    %al,%dl
  800dbe:	74 da                	je     800d9a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc4:	75 07                	jne    800dcd <strncmp+0x38>
		return 0;
  800dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcb:	eb 14                	jmp    800de1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f b6 d0             	movzbl %al,%edx
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	0f b6 c0             	movzbl %al,%eax
  800ddd:	29 c2                	sub    %eax,%edx
  800ddf:	89 d0                	mov    %edx,%eax
}
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 04             	sub    $0x4,%esp
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800def:	eb 12                	jmp    800e03 <strchr+0x20>
		if (*s == c)
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df9:	75 05                	jne    800e00 <strchr+0x1d>
			return (char *) s;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	eb 11                	jmp    800e11 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	84 c0                	test   %al,%al
  800e0a:	75 e5                	jne    800df1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 04             	sub    $0x4,%esp
  800e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1f:	eb 0d                	jmp    800e2e <strfind+0x1b>
		if (*s == c)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e29:	74 0e                	je     800e39 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e2b:	ff 45 08             	incl   0x8(%ebp)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 ea                	jne    800e21 <strfind+0xe>
  800e37:	eb 01                	jmp    800e3a <strfind+0x27>
		if (*s == c)
			break;
  800e39:	90                   	nop
	return (char *) s;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e4b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e4f:	76 63                	jbe    800eb4 <memset+0x75>
		uint64 data_block = c;
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	99                   	cltd   
  800e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e58:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e61:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e65:	c1 e0 08             	shl    $0x8,%eax
  800e68:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e6b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e74:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e78:	c1 e0 10             	shl    $0x10,%eax
  800e7b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e87:	89 c2                	mov    %eax,%edx
  800e89:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e91:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e94:	eb 18                	jmp    800eae <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e96:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e99:	8d 41 08             	lea    0x8(%ecx),%eax
  800e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea5:	89 01                	mov    %eax,(%ecx)
  800ea7:	89 51 04             	mov    %edx,0x4(%ecx)
  800eaa:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eae:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb2:	77 e2                	ja     800e96 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	74 23                	je     800edd <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ec0:	eb 0e                	jmp    800ed0 <memset+0x91>
			*p8++ = (uint8)c;
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec5:	8d 50 01             	lea    0x1(%eax),%edx
  800ec8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ece:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	75 e5                	jne    800ec2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ef4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef8:	76 24                	jbe    800f1e <memcpy+0x3c>
		while(n >= 8){
  800efa:	eb 1c                	jmp    800f18 <memcpy+0x36>
			*d64 = *s64;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8b 50 04             	mov    0x4(%eax),%edx
  800f02:	8b 00                	mov    (%eax),%eax
  800f04:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f07:	89 01                	mov    %eax,(%ecx)
  800f09:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f0c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f10:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f14:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f18:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f1c:	77 de                	ja     800efc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f22:	74 31                	je     800f55 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f30:	eb 16                	jmp    800f48 <memcpy+0x66>
			*d8++ = *s8++;
  800f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f41:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f44:	8a 12                	mov    (%edx),%dl
  800f46:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f48:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f51:	85 c0                	test   %eax,%eax
  800f53:	75 dd                	jne    800f32 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f72:	73 50                	jae    800fc4 <memmove+0x6a>
  800f74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f77:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7a:	01 d0                	add    %edx,%eax
  800f7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f7f:	76 43                	jbe    800fc4 <memmove+0x6a>
		s += n;
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f8d:	eb 10                	jmp    800f9f <memmove+0x45>
			*--d = *--s;
  800f8f:	ff 4d f8             	decl   -0x8(%ebp)
  800f92:	ff 4d fc             	decl   -0x4(%ebp)
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	8a 10                	mov    (%eax),%dl
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	75 e3                	jne    800f8f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fac:	eb 23                	jmp    800fd1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb1:	8d 50 01             	lea    0x1(%eax),%edx
  800fb4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fbd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc0:	8a 12                	mov    (%edx),%dl
  800fc2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fca:	89 55 10             	mov    %edx,0x10(%ebp)
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	75 dd                	jne    800fae <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fe8:	eb 2a                	jmp    801014 <memcmp+0x3e>
		if (*s1 != *s2)
  800fea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fed:	8a 10                	mov    (%eax),%dl
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	38 c2                	cmp    %al,%dl
  800ff6:	74 16                	je     80100e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ff8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f b6 d0             	movzbl %al,%edx
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f b6 c0             	movzbl %al,%eax
  801008:	29 c2                	sub    %eax,%edx
  80100a:	89 d0                	mov    %edx,%eax
  80100c:	eb 18                	jmp    801026 <memcmp+0x50>
		s1++, s2++;
  80100e:	ff 45 fc             	incl   -0x4(%ebp)
  801011:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101a:	89 55 10             	mov    %edx,0x10(%ebp)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	75 c9                	jne    800fea <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 45 10             	mov    0x10(%ebp),%eax
  801034:	01 d0                	add    %edx,%eax
  801036:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801039:	eb 15                	jmp    801050 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f b6 d0             	movzbl %al,%edx
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	0f b6 c0             	movzbl %al,%eax
  801049:	39 c2                	cmp    %eax,%edx
  80104b:	74 0d                	je     80105a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801056:	72 e3                	jb     80103b <memfind+0x13>
  801058:	eb 01                	jmp    80105b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105a:	90                   	nop
	return (void *) s;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    

00801060 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801066:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80106d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801074:	eb 03                	jmp    801079 <strtol+0x19>
		s++;
  801076:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 20                	cmp    $0x20,%al
  801080:	74 f4                	je     801076 <strtol+0x16>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 09                	cmp    $0x9,%al
  801089:	74 eb                	je     801076 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 2b                	cmp    $0x2b,%al
  801092:	75 05                	jne    801099 <strtol+0x39>
		s++;
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	eb 13                	jmp    8010ac <strtol+0x4c>
	else if (*s == '-')
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	3c 2d                	cmp    $0x2d,%al
  8010a0:	75 0a                	jne    8010ac <strtol+0x4c>
		s++, neg = 1;
  8010a2:	ff 45 08             	incl   0x8(%ebp)
  8010a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b0:	74 06                	je     8010b8 <strtol+0x58>
  8010b2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b6:	75 20                	jne    8010d8 <strtol+0x78>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 30                	cmp    $0x30,%al
  8010bf:	75 17                	jne    8010d8 <strtol+0x78>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	40                   	inc    %eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 78                	cmp    $0x78,%al
  8010c9:	75 0d                	jne    8010d8 <strtol+0x78>
		s += 2, base = 16;
  8010cb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010cf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d6:	eb 28                	jmp    801100 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010dc:	75 15                	jne    8010f3 <strtol+0x93>
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3c 30                	cmp    $0x30,%al
  8010e5:	75 0c                	jne    8010f3 <strtol+0x93>
		s++, base = 8;
  8010e7:	ff 45 08             	incl   0x8(%ebp)
  8010ea:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f1:	eb 0d                	jmp    801100 <strtol+0xa0>
	else if (base == 0)
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	75 07                	jne    801100 <strtol+0xa0>
		base = 10;
  8010f9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 2f                	cmp    $0x2f,%al
  801107:	7e 19                	jle    801122 <strtol+0xc2>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	3c 39                	cmp    $0x39,%al
  801110:	7f 10                	jg     801122 <strtol+0xc2>
			dig = *s - '0';
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	0f be c0             	movsbl %al,%eax
  80111a:	83 e8 30             	sub    $0x30,%eax
  80111d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801120:	eb 42                	jmp    801164 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 60                	cmp    $0x60,%al
  801129:	7e 19                	jle    801144 <strtol+0xe4>
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	3c 7a                	cmp    $0x7a,%al
  801132:	7f 10                	jg     801144 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	0f be c0             	movsbl %al,%eax
  80113c:	83 e8 57             	sub    $0x57,%eax
  80113f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801142:	eb 20                	jmp    801164 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	3c 40                	cmp    $0x40,%al
  80114b:	7e 39                	jle    801186 <strtol+0x126>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	3c 5a                	cmp    $0x5a,%al
  801154:	7f 30                	jg     801186 <strtol+0x126>
			dig = *s - 'A' + 10;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	0f be c0             	movsbl %al,%eax
  80115e:	83 e8 37             	sub    $0x37,%eax
  801161:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801167:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116a:	7d 19                	jge    801185 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80116c:	ff 45 08             	incl   0x8(%ebp)
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	0f af 45 10          	imul   0x10(%ebp),%eax
  801176:	89 c2                	mov    %eax,%edx
  801178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801180:	e9 7b ff ff ff       	jmp    801100 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801185:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801186:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118a:	74 08                	je     801194 <strtol+0x134>
		*endptr = (char *) s;
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801194:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801198:	74 07                	je     8011a1 <strtol+0x141>
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	f7 d8                	neg    %eax
  80119f:	eb 03                	jmp    8011a4 <strtol+0x144>
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <ltostr>:

void
ltostr(long value, char *str)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011be:	79 13                	jns    8011d3 <ltostr+0x2d>
	{
		neg = 1;
  8011c0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011cd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011db:	99                   	cltd   
  8011dc:	f7 f9                	idiv   %ecx
  8011de:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e4:	8d 50 01             	lea    0x1(%eax),%edx
  8011e7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	01 d0                	add    %edx,%eax
  8011f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f4:	83 c2 30             	add    $0x30,%edx
  8011f7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801201:	f7 e9                	imul   %ecx
  801203:	c1 fa 02             	sar    $0x2,%edx
  801206:	89 c8                	mov    %ecx,%eax
  801208:	c1 f8 1f             	sar    $0x1f,%eax
  80120b:	29 c2                	sub    %eax,%edx
  80120d:	89 d0                	mov    %edx,%eax
  80120f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801212:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801216:	75 bb                	jne    8011d3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801222:	48                   	dec    %eax
  801223:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801226:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122a:	74 3d                	je     801269 <ltostr+0xc3>
		start = 1 ;
  80122c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801233:	eb 34                	jmp    801269 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801242:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	01 c8                	add    %ecx,%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801256:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c2                	add    %eax,%edx
  80125e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801261:	88 02                	mov    %al,(%edx)
		start++ ;
  801263:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801266:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c c4                	jl     801235 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801271:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801274:	8b 45 0c             	mov    0xc(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801285:	ff 75 08             	pushl  0x8(%ebp)
  801288:	e8 c4 f9 ff ff       	call   800c51 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	e8 b6 f9 ff ff       	call   800c51 <strlen>
  80129b:	83 c4 04             	add    $0x4,%esp
  80129e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012af:	eb 17                	jmp    8012c8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b7:	01 c2                	add    %eax,%edx
  8012b9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	01 c8                	add    %ecx,%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c5:	ff 45 fc             	incl   -0x4(%ebp)
  8012c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ce:	7c e1                	jl     8012b1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012de:	eb 1f                	jmp    8012ff <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	8d 50 01             	lea    0x1(%eax),%edx
  8012e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ee:	01 c2                	add    %eax,%edx
  8012f0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	01 c8                	add    %ecx,%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012fc:	ff 45 f8             	incl   -0x8(%ebp)
  8012ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801302:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801305:	7c d9                	jl     8012e0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801307:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130a:	8b 45 10             	mov    0x10(%ebp),%eax
  80130d:	01 d0                	add    %edx,%eax
  80130f:	c6 00 00             	movb   $0x0,(%eax)
}
  801312:	90                   	nop
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801318:	8b 45 14             	mov    0x14(%ebp),%eax
  80131b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801321:	8b 45 14             	mov    0x14(%ebp),%eax
  801324:	8b 00                	mov    (%eax),%eax
  801326:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 d0                	add    %edx,%eax
  801332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	eb 0c                	jmp    801346 <strsplit+0x31>
			*string++ = 0;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8d 50 01             	lea    0x1(%eax),%edx
  801340:	89 55 08             	mov    %edx,0x8(%ebp)
  801343:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	84 c0                	test   %al,%al
  80134d:	74 18                	je     801367 <strsplit+0x52>
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	0f be c0             	movsbl %al,%eax
  801357:	50                   	push   %eax
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	e8 83 fa ff ff       	call   800de3 <strchr>
  801360:	83 c4 08             	add    $0x8,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	75 d3                	jne    80133a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 5a                	je     8013ca <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801370:	8b 45 14             	mov    0x14(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	83 f8 0f             	cmp    $0xf,%eax
  801378:	75 07                	jne    801381 <strsplit+0x6c>
		{
			return 0;
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
  80137f:	eb 66                	jmp    8013e7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801381:	8b 45 14             	mov    0x14(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	8d 48 01             	lea    0x1(%eax),%ecx
  801389:	8b 55 14             	mov    0x14(%ebp),%edx
  80138c:	89 0a                	mov    %ecx,(%edx)
  80138e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	01 c2                	add    %eax,%edx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139f:	eb 03                	jmp    8013a4 <strsplit+0x8f>
			string++;
  8013a1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	84 c0                	test   %al,%al
  8013ab:	74 8b                	je     801338 <strsplit+0x23>
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f be c0             	movsbl %al,%eax
  8013b5:	50                   	push   %eax
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	e8 25 fa ff ff       	call   800de3 <strchr>
  8013be:	83 c4 08             	add    $0x8,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	74 dc                	je     8013a1 <strsplit+0x8c>
			string++;
	}
  8013c5:	e9 6e ff ff ff       	jmp    801338 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ca:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ce:	8b 00                	mov    (%eax),%eax
  8013d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fc:	eb 4a                	jmp    801448 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	01 c2                	add    %eax,%edx
  801406:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 c8                	add    %ecx,%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801412:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 40                	cmp    $0x40,%al
  80141e:	7e 25                	jle    801445 <str2lower+0x5c>
  801420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	3c 5a                	cmp    $0x5a,%al
  80142c:	7f 17                	jg     801445 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80142e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	01 d0                	add    %edx,%eax
  801436:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801439:	8b 55 08             	mov    0x8(%ebp),%edx
  80143c:	01 ca                	add    %ecx,%edx
  80143e:	8a 12                	mov    (%edx),%dl
  801440:	83 c2 20             	add    $0x20,%edx
  801443:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801445:	ff 45 fc             	incl   -0x4(%ebp)
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	e8 01 f8 ff ff       	call   800c51 <strlen>
  801450:	83 c4 04             	add    $0x4,%esp
  801453:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801456:	7f a6                	jg     8013fe <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	57                   	push   %edi
  801461:	56                   	push   %esi
  801462:	53                   	push   %ebx
  801463:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801472:	8b 7d 18             	mov    0x18(%ebp),%edi
  801475:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801478:	cd 30                	int    $0x30
  80147a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	5b                   	pop    %ebx
  801484:	5e                   	pop    %esi
  801485:	5f                   	pop    %edi
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    

00801488 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	8b 45 10             	mov    0x10(%ebp),%eax
  801491:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801494:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801497:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	6a 00                	push   $0x0
  8014a0:	51                   	push   %ecx
  8014a1:	52                   	push   %edx
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	50                   	push   %eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	e8 b0 ff ff ff       	call   80145d <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	90                   	nop
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 02                	push   $0x2
  8014c2:	e8 96 ff ff ff       	call   80145d <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 03                	push   $0x3
  8014db:	e8 7d ff ff ff       	call   80145d <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 04                	push   $0x4
  8014f5:	e8 63 ff ff ff       	call   80145d <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	52                   	push   %edx
  801510:	50                   	push   %eax
  801511:	6a 08                	push   $0x8
  801513:	e8 45 ff ff ff       	call   80145d <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	56                   	push   %esi
  801521:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801522:	8b 75 18             	mov    0x18(%ebp),%esi
  801525:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801528:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	56                   	push   %esi
  801532:	53                   	push   %ebx
  801533:	51                   	push   %ecx
  801534:	52                   	push   %edx
  801535:	50                   	push   %eax
  801536:	6a 09                	push   $0x9
  801538:	e8 20 ff ff ff       	call   80145d <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801543:	5b                   	pop    %ebx
  801544:	5e                   	pop    %esi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	6a 0a                	push   $0xa
  801557:	e8 01 ff ff ff       	call   80145d <syscall>
  80155c:	83 c4 18             	add    $0x18,%esp
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	6a 0b                	push   $0xb
  801572:	e8 e6 fe ff ff       	call   80145d <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 0c                	push   $0xc
  80158b:	e8 cd fe ff ff       	call   80145d <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 0d                	push   $0xd
  8015a4:	e8 b4 fe ff ff       	call   80145d <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 0e                	push   $0xe
  8015bd:	e8 9b fe ff ff       	call   80145d <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 0f                	push   $0xf
  8015d6:	e8 82 fe ff ff       	call   80145d <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	6a 10                	push   $0x10
  8015f0:	e8 68 fe ff ff       	call   80145d <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 11                	push   $0x11
  801609:	e8 4f fe ff ff       	call   80145d <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	90                   	nop
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_cputc>:

void
sys_cputc(const char c)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801620:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	50                   	push   %eax
  80162d:	6a 01                	push   $0x1
  80162f:	e8 29 fe ff ff       	call   80145d <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 14                	push   $0x14
  801649:	e8 0f fe ff ff       	call   80145d <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	90                   	nop
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801660:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801663:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	51                   	push   %ecx
  80166d:	52                   	push   %edx
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	50                   	push   %eax
  801672:	6a 15                	push   $0x15
  801674:	e8 e4 fd ff ff       	call   80145d <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801681:	8b 55 0c             	mov    0xc(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	52                   	push   %edx
  80168e:	50                   	push   %eax
  80168f:	6a 16                	push   $0x16
  801691:	e8 c7 fd ff ff       	call   80145d <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80169e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	51                   	push   %ecx
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 17                	push   $0x17
  8016b0:	e8 a8 fd ff ff       	call   80145d <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	6a 18                	push   $0x18
  8016cd:	e8 8b fd ff ff       	call   80145d <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	6a 00                	push   $0x0
  8016df:	ff 75 14             	pushl  0x14(%ebp)
  8016e2:	ff 75 10             	pushl  0x10(%ebp)
  8016e5:	ff 75 0c             	pushl  0xc(%ebp)
  8016e8:	50                   	push   %eax
  8016e9:	6a 19                	push   $0x19
  8016eb:	e8 6d fd ff ff       	call   80145d <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	50                   	push   %eax
  801704:	6a 1a                	push   $0x1a
  801706:	e8 52 fd ff ff       	call   80145d <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	50                   	push   %eax
  801720:	6a 1b                	push   $0x1b
  801722:	e8 36 fd ff ff       	call   80145d <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 05                	push   $0x5
  80173b:	e8 1d fd ff ff       	call   80145d <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 06                	push   $0x6
  801754:	e8 04 fd ff ff       	call   80145d <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 07                	push   $0x7
  80176d:	e8 eb fc ff ff       	call   80145d <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_exit_env>:


void sys_exit_env(void)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 1c                	push   $0x1c
  801786:	e8 d2 fc ff ff       	call   80145d <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	90                   	nop
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801797:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179a:	8d 50 04             	lea    0x4(%eax),%edx
  80179d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	52                   	push   %edx
  8017a7:	50                   	push   %eax
  8017a8:	6a 1d                	push   $0x1d
  8017aa:	e8 ae fc ff ff       	call   80145d <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bb:	89 01                	mov    %eax,(%ecx)
  8017bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	c9                   	leave  
  8017c4:	c2 04 00             	ret    $0x4

008017c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff 75 10             	pushl  0x10(%ebp)
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 13                	push   $0x13
  8017d9:	e8 7f fc ff ff       	call   80145d <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e1:	90                   	nop
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 1e                	push   $0x1e
  8017f3:	e8 65 fc ff ff       	call   80145d <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801809:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	50                   	push   %eax
  801816:	6a 1f                	push   $0x1f
  801818:	e8 40 fc ff ff       	call   80145d <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return ;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <rsttst>:
void rsttst()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 21                	push   $0x21
  801832:	e8 26 fc ff ff       	call   80145d <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
	return ;
  80183a:	90                   	nop
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	8b 45 14             	mov    0x14(%ebp),%eax
  801846:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801849:	8b 55 18             	mov    0x18(%ebp),%edx
  80184c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801850:	52                   	push   %edx
  801851:	50                   	push   %eax
  801852:	ff 75 10             	pushl  0x10(%ebp)
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	ff 75 08             	pushl  0x8(%ebp)
  80185b:	6a 20                	push   $0x20
  80185d:	e8 fb fb ff ff       	call   80145d <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
	return ;
  801865:	90                   	nop
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <chktst>:
void chktst(uint32 n)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	ff 75 08             	pushl  0x8(%ebp)
  801876:	6a 22                	push   $0x22
  801878:	e8 e0 fb ff ff       	call   80145d <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return ;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <inctst>:

void inctst()
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 23                	push   $0x23
  801892:	e8 c6 fb ff ff       	call   80145d <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return ;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <gettst>:
uint32 gettst()
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 24                	push   $0x24
  8018ac:	e8 ac fb ff ff       	call   80145d <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 25                	push   $0x25
  8018c5:	e8 93 fb ff ff       	call   80145d <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
  8018cd:	a3 80 f2 81 00       	mov    %eax,0x81f280
	return uheapPlaceStrategy ;
  8018d2:	a1 80 f2 81 00       	mov    0x81f280,%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	a3 80 f2 81 00       	mov    %eax,0x81f280
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	ff 75 08             	pushl  0x8(%ebp)
  8018ef:	6a 26                	push   $0x26
  8018f1:	e8 67 fb ff ff       	call   80145d <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f9:	90                   	nop
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801900:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801903:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	53                   	push   %ebx
  80190f:	51                   	push   %ecx
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 27                	push   $0x27
  801914:	e8 44 fb ff ff       	call   80145d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	52                   	push   %edx
  801931:	50                   	push   %eax
  801932:	6a 28                	push   $0x28
  801934:	e8 24 fb ff ff       	call   80145d <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801941:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	51                   	push   %ecx
  80194d:	ff 75 10             	pushl  0x10(%ebp)
  801950:	52                   	push   %edx
  801951:	50                   	push   %eax
  801952:	6a 29                	push   $0x29
  801954:	e8 04 fb ff ff       	call   80145d <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 12                	push   $0x12
  801970:	e8 e8 fa ff ff       	call   80145d <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	52                   	push   %edx
  80198b:	50                   	push   %eax
  80198c:	6a 2a                	push   $0x2a
  80198e:	e8 ca fa ff ff       	call   80145d <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
	return;
  801996:	90                   	nop
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 2b                	push   $0x2b
  8019a8:	e8 b0 fa ff ff       	call   80145d <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	ff 75 08             	pushl  0x8(%ebp)
  8019c1:	6a 2d                	push   $0x2d
  8019c3:	e8 95 fa ff ff       	call   80145d <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
	return;
  8019cb:	90                   	nop
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 2c                	push   $0x2c
  8019df:	e8 79 fa ff ff       	call   80145d <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 2e                	push   $0x2e
  8019fd:	e8 5b fa ff ff       	call   80145d <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <__udivdi3>:
  801a08:	55                   	push   %ebp
  801a09:	57                   	push   %edi
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 1c             	sub    $0x1c,%esp
  801a0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1f:	89 ca                	mov    %ecx,%edx
  801a21:	89 f8                	mov    %edi,%eax
  801a23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a27:	85 f6                	test   %esi,%esi
  801a29:	75 2d                	jne    801a58 <__udivdi3+0x50>
  801a2b:	39 cf                	cmp    %ecx,%edi
  801a2d:	77 65                	ja     801a94 <__udivdi3+0x8c>
  801a2f:	89 fd                	mov    %edi,%ebp
  801a31:	85 ff                	test   %edi,%edi
  801a33:	75 0b                	jne    801a40 <__udivdi3+0x38>
  801a35:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3a:	31 d2                	xor    %edx,%edx
  801a3c:	f7 f7                	div    %edi
  801a3e:	89 c5                	mov    %eax,%ebp
  801a40:	31 d2                	xor    %edx,%edx
  801a42:	89 c8                	mov    %ecx,%eax
  801a44:	f7 f5                	div    %ebp
  801a46:	89 c1                	mov    %eax,%ecx
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	f7 f5                	div    %ebp
  801a4c:	89 cf                	mov    %ecx,%edi
  801a4e:	89 fa                	mov    %edi,%edx
  801a50:	83 c4 1c             	add    $0x1c,%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    
  801a58:	39 ce                	cmp    %ecx,%esi
  801a5a:	77 28                	ja     801a84 <__udivdi3+0x7c>
  801a5c:	0f bd fe             	bsr    %esi,%edi
  801a5f:	83 f7 1f             	xor    $0x1f,%edi
  801a62:	75 40                	jne    801aa4 <__udivdi3+0x9c>
  801a64:	39 ce                	cmp    %ecx,%esi
  801a66:	72 0a                	jb     801a72 <__udivdi3+0x6a>
  801a68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a6c:	0f 87 9e 00 00 00    	ja     801b10 <__udivdi3+0x108>
  801a72:	b8 01 00 00 00       	mov    $0x1,%eax
  801a77:	89 fa                	mov    %edi,%edx
  801a79:	83 c4 1c             	add    $0x1c,%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    
  801a81:	8d 76 00             	lea    0x0(%esi),%esi
  801a84:	31 ff                	xor    %edi,%edi
  801a86:	31 c0                	xor    %eax,%eax
  801a88:	89 fa                	mov    %edi,%edx
  801a8a:	83 c4 1c             	add    $0x1c,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5f                   	pop    %edi
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	89 d8                	mov    %ebx,%eax
  801a96:	f7 f7                	div    %edi
  801a98:	31 ff                	xor    %edi,%edi
  801a9a:	89 fa                	mov    %edi,%edx
  801a9c:	83 c4 1c             	add    $0x1c,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5f                   	pop    %edi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    
  801aa4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aa9:	89 eb                	mov    %ebp,%ebx
  801aab:	29 fb                	sub    %edi,%ebx
  801aad:	89 f9                	mov    %edi,%ecx
  801aaf:	d3 e6                	shl    %cl,%esi
  801ab1:	89 c5                	mov    %eax,%ebp
  801ab3:	88 d9                	mov    %bl,%cl
  801ab5:	d3 ed                	shr    %cl,%ebp
  801ab7:	89 e9                	mov    %ebp,%ecx
  801ab9:	09 f1                	or     %esi,%ecx
  801abb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801abf:	89 f9                	mov    %edi,%ecx
  801ac1:	d3 e0                	shl    %cl,%eax
  801ac3:	89 c5                	mov    %eax,%ebp
  801ac5:	89 d6                	mov    %edx,%esi
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 ee                	shr    %cl,%esi
  801acb:	89 f9                	mov    %edi,%ecx
  801acd:	d3 e2                	shl    %cl,%edx
  801acf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad3:	88 d9                	mov    %bl,%cl
  801ad5:	d3 e8                	shr    %cl,%eax
  801ad7:	09 c2                	or     %eax,%edx
  801ad9:	89 d0                	mov    %edx,%eax
  801adb:	89 f2                	mov    %esi,%edx
  801add:	f7 74 24 0c          	divl   0xc(%esp)
  801ae1:	89 d6                	mov    %edx,%esi
  801ae3:	89 c3                	mov    %eax,%ebx
  801ae5:	f7 e5                	mul    %ebp
  801ae7:	39 d6                	cmp    %edx,%esi
  801ae9:	72 19                	jb     801b04 <__udivdi3+0xfc>
  801aeb:	74 0b                	je     801af8 <__udivdi3+0xf0>
  801aed:	89 d8                	mov    %ebx,%eax
  801aef:	31 ff                	xor    %edi,%edi
  801af1:	e9 58 ff ff ff       	jmp    801a4e <__udivdi3+0x46>
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801afc:	89 f9                	mov    %edi,%ecx
  801afe:	d3 e2                	shl    %cl,%edx
  801b00:	39 c2                	cmp    %eax,%edx
  801b02:	73 e9                	jae    801aed <__udivdi3+0xe5>
  801b04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b07:	31 ff                	xor    %edi,%edi
  801b09:	e9 40 ff ff ff       	jmp    801a4e <__udivdi3+0x46>
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	31 c0                	xor    %eax,%eax
  801b12:	e9 37 ff ff ff       	jmp    801a4e <__udivdi3+0x46>
  801b17:	90                   	nop

00801b18 <__umoddi3>:
  801b18:	55                   	push   %ebp
  801b19:	57                   	push   %edi
  801b1a:	56                   	push   %esi
  801b1b:	53                   	push   %ebx
  801b1c:	83 ec 1c             	sub    $0x1c,%esp
  801b1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b37:	89 f3                	mov    %esi,%ebx
  801b39:	89 fa                	mov    %edi,%edx
  801b3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b3f:	89 34 24             	mov    %esi,(%esp)
  801b42:	85 c0                	test   %eax,%eax
  801b44:	75 1a                	jne    801b60 <__umoddi3+0x48>
  801b46:	39 f7                	cmp    %esi,%edi
  801b48:	0f 86 a2 00 00 00    	jbe    801bf0 <__umoddi3+0xd8>
  801b4e:	89 c8                	mov    %ecx,%eax
  801b50:	89 f2                	mov    %esi,%edx
  801b52:	f7 f7                	div    %edi
  801b54:	89 d0                	mov    %edx,%eax
  801b56:	31 d2                	xor    %edx,%edx
  801b58:	83 c4 1c             	add    $0x1c,%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    
  801b60:	39 f0                	cmp    %esi,%eax
  801b62:	0f 87 ac 00 00 00    	ja     801c14 <__umoddi3+0xfc>
  801b68:	0f bd e8             	bsr    %eax,%ebp
  801b6b:	83 f5 1f             	xor    $0x1f,%ebp
  801b6e:	0f 84 ac 00 00 00    	je     801c20 <__umoddi3+0x108>
  801b74:	bf 20 00 00 00       	mov    $0x20,%edi
  801b79:	29 ef                	sub    %ebp,%edi
  801b7b:	89 fe                	mov    %edi,%esi
  801b7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b81:	89 e9                	mov    %ebp,%ecx
  801b83:	d3 e0                	shl    %cl,%eax
  801b85:	89 d7                	mov    %edx,%edi
  801b87:	89 f1                	mov    %esi,%ecx
  801b89:	d3 ef                	shr    %cl,%edi
  801b8b:	09 c7                	or     %eax,%edi
  801b8d:	89 e9                	mov    %ebp,%ecx
  801b8f:	d3 e2                	shl    %cl,%edx
  801b91:	89 14 24             	mov    %edx,(%esp)
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	d3 e0                	shl    %cl,%eax
  801b98:	89 c2                	mov    %eax,%edx
  801b9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9e:	d3 e0                	shl    %cl,%eax
  801ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba8:	89 f1                	mov    %esi,%ecx
  801baa:	d3 e8                	shr    %cl,%eax
  801bac:	09 d0                	or     %edx,%eax
  801bae:	d3 eb                	shr    %cl,%ebx
  801bb0:	89 da                	mov    %ebx,%edx
  801bb2:	f7 f7                	div    %edi
  801bb4:	89 d3                	mov    %edx,%ebx
  801bb6:	f7 24 24             	mull   (%esp)
  801bb9:	89 c6                	mov    %eax,%esi
  801bbb:	89 d1                	mov    %edx,%ecx
  801bbd:	39 d3                	cmp    %edx,%ebx
  801bbf:	0f 82 87 00 00 00    	jb     801c4c <__umoddi3+0x134>
  801bc5:	0f 84 91 00 00 00    	je     801c5c <__umoddi3+0x144>
  801bcb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bcf:	29 f2                	sub    %esi,%edx
  801bd1:	19 cb                	sbb    %ecx,%ebx
  801bd3:	89 d8                	mov    %ebx,%eax
  801bd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bd9:	d3 e0                	shl    %cl,%eax
  801bdb:	89 e9                	mov    %ebp,%ecx
  801bdd:	d3 ea                	shr    %cl,%edx
  801bdf:	09 d0                	or     %edx,%eax
  801be1:	89 e9                	mov    %ebp,%ecx
  801be3:	d3 eb                	shr    %cl,%ebx
  801be5:	89 da                	mov    %ebx,%edx
  801be7:	83 c4 1c             	add    $0x1c,%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5f                   	pop    %edi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    
  801bef:	90                   	nop
  801bf0:	89 fd                	mov    %edi,%ebp
  801bf2:	85 ff                	test   %edi,%edi
  801bf4:	75 0b                	jne    801c01 <__umoddi3+0xe9>
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	31 d2                	xor    %edx,%edx
  801bfd:	f7 f7                	div    %edi
  801bff:	89 c5                	mov    %eax,%ebp
  801c01:	89 f0                	mov    %esi,%eax
  801c03:	31 d2                	xor    %edx,%edx
  801c05:	f7 f5                	div    %ebp
  801c07:	89 c8                	mov    %ecx,%eax
  801c09:	f7 f5                	div    %ebp
  801c0b:	89 d0                	mov    %edx,%eax
  801c0d:	e9 44 ff ff ff       	jmp    801b56 <__umoddi3+0x3e>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	89 c8                	mov    %ecx,%eax
  801c16:	89 f2                	mov    %esi,%edx
  801c18:	83 c4 1c             	add    $0x1c,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
  801c20:	3b 04 24             	cmp    (%esp),%eax
  801c23:	72 06                	jb     801c2b <__umoddi3+0x113>
  801c25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c29:	77 0f                	ja     801c3a <__umoddi3+0x122>
  801c2b:	89 f2                	mov    %esi,%edx
  801c2d:	29 f9                	sub    %edi,%ecx
  801c2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c33:	89 14 24             	mov    %edx,(%esp)
  801c36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3e:	8b 14 24             	mov    (%esp),%edx
  801c41:	83 c4 1c             	add    $0x1c,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	8d 76 00             	lea    0x0(%esi),%esi
  801c4c:	2b 04 24             	sub    (%esp),%eax
  801c4f:	19 fa                	sbb    %edi,%edx
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	89 c6                	mov    %eax,%esi
  801c55:	e9 71 ff ff ff       	jmp    801bcb <__umoddi3+0xb3>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c60:	72 ea                	jb     801c4c <__umoddi3+0x134>
  801c62:	89 d9                	mov    %ebx,%ecx
  801c64:	e9 62 ff ff ff       	jmp    801bcb <__umoddi3+0xb3>
