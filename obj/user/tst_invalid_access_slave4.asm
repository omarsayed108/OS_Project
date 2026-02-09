
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 bd 17 00 00       	call   80183b <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 40 1c 80 00       	push   $0x801c40
  800086:	6a 18                	push   $0x18
  800088:	68 dc 1c 80 00       	push   $0x801cdc
  80008d:	e8 b0 01 00 00       	call   800242 <_panic>

00800092 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80009b:	e8 5d 16 00 00       	call   8016fd <sys_getenvindex>
  8000a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	01 c0                	add    %eax,%eax
  8000aa:	01 d0                	add    %edx,%eax
  8000ac:	c1 e0 02             	shl    $0x2,%eax
  8000af:	01 d0                	add    %edx,%eax
  8000b1:	c1 e0 02             	shl    $0x2,%eax
  8000b4:	01 d0                	add    %edx,%eax
  8000b6:	c1 e0 03             	shl    $0x3,%eax
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	c1 e0 02             	shl    $0x2,%eax
  8000be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cd:	8a 40 20             	mov    0x20(%eax),%al
  8000d0:	84 c0                	test   %al,%al
  8000d2:	74 0d                	je     8000e1 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d9:	83 c0 20             	add    $0x20,%eax
  8000dc:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e5:	7e 0a                	jle    8000f1 <libmain+0x5f>
		binaryname = argv[0];
  8000e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	ff 75 0c             	pushl  0xc(%ebp)
  8000f7:	ff 75 08             	pushl  0x8(%ebp)
  8000fa:	e8 39 ff ff ff       	call   800038 <_main>
  8000ff:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800102:	a1 00 30 80 00       	mov    0x803000,%eax
  800107:	85 c0                	test   %eax,%eax
  800109:	0f 84 01 01 00 00    	je     800210 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80010f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800115:	bb f8 1d 80 00       	mov    $0x801df8,%ebx
  80011a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80011f:	89 c7                	mov    %eax,%edi
  800121:	89 de                	mov    %ebx,%esi
  800123:	89 d1                	mov    %edx,%ecx
  800125:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800127:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80012a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80012f:	b0 00                	mov    $0x0,%al
  800131:	89 d7                	mov    %edx,%edi
  800133:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80013c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	50                   	push   %eax
  800143:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800149:	50                   	push   %eax
  80014a:	e8 e4 17 00 00       	call   801933 <sys_utilities>
  80014f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800152:	e8 2d 13 00 00       	call   801484 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 18 1d 80 00       	push   $0x801d18
  80015f:	e8 cc 03 00 00       	call   800530 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800167:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016a:	85 c0                	test   %eax,%eax
  80016c:	74 18                	je     800186 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80016e:	e8 de 17 00 00       	call   801951 <sys_get_optimal_num_faults>
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	50                   	push   %eax
  800177:	68 40 1d 80 00       	push   $0x801d40
  80017c:	e8 af 03 00 00       	call   800530 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	eb 59                	jmp    8001df <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800186:	a1 20 30 80 00       	mov    0x803020,%eax
  80018b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800191:	a1 20 30 80 00       	mov    0x803020,%eax
  800196:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	52                   	push   %edx
  8001a0:	50                   	push   %eax
  8001a1:	68 64 1d 80 00       	push   $0x801d64
  8001a6:	e8 85 03 00 00       	call   800530 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b3:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8001b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001be:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8001cf:	51                   	push   %ecx
  8001d0:	52                   	push   %edx
  8001d1:	50                   	push   %eax
  8001d2:	68 8c 1d 80 00       	push   $0x801d8c
  8001d7:	e8 54 03 00 00       	call   800530 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	50                   	push   %eax
  8001ee:	68 e4 1d 80 00       	push   $0x801de4
  8001f3:	e8 38 03 00 00       	call   800530 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 18 1d 80 00       	push   $0x801d18
  800203:	e8 28 03 00 00       	call   800530 <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80020b:	e8 8e 12 00 00       	call   80149e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800210:	e8 1f 00 00 00       	call   800234 <exit>
}
  800215:	90                   	nop
  800216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800219:	5b                   	pop    %ebx
  80021a:	5e                   	pop    %esi
  80021b:	5f                   	pop    %edi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	6a 00                	push   $0x0
  800229:	e8 9b 14 00 00       	call   8016c9 <sys_destroy_env>
  80022e:	83 c4 10             	add    $0x10,%esp
}
  800231:	90                   	nop
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <exit>:

void
exit(void)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80023a:	e8 f0 14 00 00       	call   80172f <sys_exit_env>
}
  80023f:	90                   	nop
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800248:	8d 45 10             	lea    0x10(%ebp),%eax
  80024b:	83 c0 04             	add    $0x4,%eax
  80024e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800251:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800256:	85 c0                	test   %eax,%eax
  800258:	74 16                	je     800270 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80025a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	50                   	push   %eax
  800263:	68 5c 1e 80 00       	push   $0x801e5c
  800268:	e8 c3 02 00 00       	call   800530 <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800270:	a1 04 30 80 00       	mov    0x803004,%eax
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 0c             	pushl  0xc(%ebp)
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	50                   	push   %eax
  80027f:	68 64 1e 80 00       	push   $0x801e64
  800284:	6a 74                	push   $0x74
  800286:	e8 d2 02 00 00       	call   80055d <cprintf_colored>
  80028b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80028e:	8b 45 10             	mov    0x10(%ebp),%eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 75 f4             	pushl  -0xc(%ebp)
  800297:	50                   	push   %eax
  800298:	e8 24 02 00 00       	call   8004c1 <vcprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	6a 00                	push   $0x0
  8002a5:	68 8c 1e 80 00       	push   $0x801e8c
  8002aa:	e8 12 02 00 00       	call   8004c1 <vcprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002b2:	e8 7d ff ff ff       	call   800234 <exit>

	// should not return here
	while (1) ;
  8002b7:	eb fe                	jmp    8002b7 <_panic+0x75>

008002b9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	74 14                	je     8002e6 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 90 1e 80 00       	push   $0x801e90
  8002da:	6a 26                	push   $0x26
  8002dc:	68 dc 1e 80 00       	push   $0x801edc
  8002e1:	e8 5c ff ff ff       	call   800242 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002f4:	e9 d9 00 00 00       	jmp    8003d2 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8002f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800303:	8b 45 08             	mov    0x8(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	85 c0                	test   %eax,%eax
  80030c:	75 08                	jne    800316 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80030e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800311:	e9 b9 00 00 00       	jmp    8003cf <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800316:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80031d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800324:	eb 79                	jmp    80039f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800326:	a1 20 30 80 00       	mov    0x803020,%eax
  80032b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800331:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800334:	89 d0                	mov    %edx,%eax
  800336:	01 c0                	add    %eax,%eax
  800338:	01 d0                	add    %edx,%eax
  80033a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800341:	01 d8                	add    %ebx,%eax
  800343:	01 d0                	add    %edx,%eax
  800345:	01 c8                	add    %ecx,%eax
  800347:	8a 40 04             	mov    0x4(%eax),%al
  80034a:	84 c0                	test   %al,%al
  80034c:	75 4e                	jne    80039c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80034e:	a1 20 30 80 00       	mov    0x803020,%eax
  800353:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035c:	89 d0                	mov    %edx,%eax
  80035e:	01 c0                	add    %eax,%eax
  800360:	01 d0                	add    %edx,%eax
  800362:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800369:	01 d8                	add    %ebx,%eax
  80036b:	01 d0                	add    %edx,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 19                	jmp    8003b5 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	0f 87 71 ff ff ff    	ja     800326 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b9:	75 14                	jne    8003cf <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 e8 1e 80 00       	push   $0x801ee8
  8003c3:	6a 3a                	push   $0x3a
  8003c5:	68 dc 1e 80 00       	push   $0x801edc
  8003ca:	e8 73 fe ff ff       	call   800242 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003cf:	ff 45 f0             	incl   -0x10(%ebp)
  8003d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d8:	0f 8c 1b ff ff ff    	jl     8002f9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ec:	eb 2e                	jmp    80041c <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	01 c0                	add    %eax,%eax
  800400:	01 d0                	add    %edx,%eax
  800402:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800409:	01 d8                	add    %ebx,%eax
  80040b:	01 d0                	add    %edx,%eax
  80040d:	01 c8                	add    %ecx,%eax
  80040f:	8a 40 04             	mov    0x4(%eax),%al
  800412:	3c 01                	cmp    $0x1,%al
  800414:	75 03                	jne    800419 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800416:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800419:	ff 45 e0             	incl   -0x20(%ebp)
  80041c:	a1 20 30 80 00       	mov    0x803020,%eax
  800421:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042a:	39 c2                	cmp    %eax,%edx
  80042c:	77 c0                	ja     8003ee <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80042e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800431:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800434:	74 14                	je     80044a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	68 3c 1f 80 00       	push   $0x801f3c
  80043e:	6a 44                	push   $0x44
  800440:	68 dc 1e 80 00       	push   $0x801edc
  800445:	e8 f8 fd ff ff       	call   800242 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044a:	90                   	nop
  80044b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80044e:	c9                   	leave  
  80044f:	c3                   	ret    

00800450 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	53                   	push   %ebx
  800454:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 30                	jne    8004ac <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80047c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800482:	a0 44 30 80 00       	mov    0x803044,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048d:	8b 09                	mov    (%ecx),%ecx
  80048f:	89 cb                	mov    %ecx,%ebx
  800491:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800494:	83 c1 08             	add    $0x8,%ecx
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	53                   	push   %ebx
  80049a:	51                   	push   %ecx
  80049b:	e8 a0 0f 00 00       	call   801440 <sys_cputs>
  8004a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	8b 40 04             	mov    0x4(%eax),%eax
  8004b2:	8d 50 01             	lea    0x1(%eax),%edx
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bb:	90                   	nop
  8004bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d1:	00 00 00 
	b.cnt = 0;
  8004d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004de:	ff 75 0c             	pushl  0xc(%ebp)
  8004e1:	ff 75 08             	pushl  0x8(%ebp)
  8004e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	68 50 04 80 00       	push   $0x800450
  8004f0:	e8 5a 02 00 00       	call   80074f <vprintfmt>
  8004f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004f8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004fe:	a0 44 30 80 00       	mov    0x803044,%al
  800503:	0f b6 c0             	movzbl %al,%eax
  800506:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80050c:	52                   	push   %edx
  80050d:	50                   	push   %eax
  80050e:	51                   	push   %ecx
  80050f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800515:	83 c0 08             	add    $0x8,%eax
  800518:	50                   	push   %eax
  800519:	e8 22 0f 00 00       	call   801440 <sys_cputs>
  80051e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800521:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800528:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80052e:	c9                   	leave  
  80052f:	c3                   	ret    

00800530 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800536:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80053d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800540:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	ff 75 f4             	pushl  -0xc(%ebp)
  80054c:	50                   	push   %eax
  80054d:	e8 6f ff ff ff       	call   8004c1 <vcprintf>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800558:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

0080055d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800563:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	c1 e0 08             	shl    $0x8,%eax
  800570:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800575:	8d 45 0c             	lea    0xc(%ebp),%eax
  800578:	83 c0 04             	add    $0x4,%eax
  80057b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	ff 75 f4             	pushl  -0xc(%ebp)
  800587:	50                   	push   %eax
  800588:	e8 34 ff ff ff       	call   8004c1 <vcprintf>
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800593:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80059a:	07 00 00 

	return cnt;
  80059d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005a8:	e8 d7 0e 00 00       	call   801484 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bc:	50                   	push   %eax
  8005bd:	e8 ff fe ff ff       	call   8004c1 <vcprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005c8:	e8 d1 0e 00 00       	call   80149e <sys_unlock_cons>
	return cnt;
  8005cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d0:	c9                   	leave  
  8005d1:	c3                   	ret    

008005d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	53                   	push   %ebx
  8005d6:	83 ec 14             	sub    $0x14,%esp
  8005d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f0:	77 55                	ja     800647 <printnum+0x75>
  8005f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f5:	72 05                	jb     8005fc <printnum+0x2a>
  8005f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005fa:	77 4b                	ja     800647 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800602:	8b 45 18             	mov    0x18(%ebp),%eax
  800605:	ba 00 00 00 00       	mov    $0x0,%edx
  80060a:	52                   	push   %edx
  80060b:	50                   	push   %eax
  80060c:	ff 75 f4             	pushl  -0xc(%ebp)
  80060f:	ff 75 f0             	pushl  -0x10(%ebp)
  800612:	e8 a9 13 00 00       	call   8019c0 <__udivdi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	ff 75 20             	pushl  0x20(%ebp)
  800620:	53                   	push   %ebx
  800621:	ff 75 18             	pushl  0x18(%ebp)
  800624:	52                   	push   %edx
  800625:	50                   	push   %eax
  800626:	ff 75 0c             	pushl  0xc(%ebp)
  800629:	ff 75 08             	pushl  0x8(%ebp)
  80062c:	e8 a1 ff ff ff       	call   8005d2 <printnum>
  800631:	83 c4 20             	add    $0x20,%esp
  800634:	eb 1a                	jmp    800650 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	ff 75 20             	pushl  0x20(%ebp)
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	ff d0                	call   *%eax
  800644:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800647:	ff 4d 1c             	decl   0x1c(%ebp)
  80064a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064e:	7f e6                	jg     800636 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800650:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800653:	bb 00 00 00 00       	mov    $0x0,%ebx
  800658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065e:	53                   	push   %ebx
  80065f:	51                   	push   %ecx
  800660:	52                   	push   %edx
  800661:	50                   	push   %eax
  800662:	e8 69 14 00 00       	call   801ad0 <__umoddi3>
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	05 b4 21 80 00       	add    $0x8021b4,%eax
  80066f:	8a 00                	mov    (%eax),%al
  800671:	0f be c0             	movsbl %al,%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
}
  800683:	90                   	nop
  800684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800690:	7e 1c                	jle    8006ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	8d 50 08             	lea    0x8(%eax),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	83 e8 08             	sub    $0x8,%eax
  8006a7:	8b 50 04             	mov    0x4(%eax),%edx
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	eb 40                	jmp    8006ee <getuint+0x65>
	else if (lflag)
  8006ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b2:	74 1e                	je     8006d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	8d 50 04             	lea    0x4(%eax),%edx
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	89 10                	mov    %edx,(%eax)
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	83 e8 04             	sub    $0x4,%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d0:	eb 1c                	jmp    8006ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	8d 50 04             	lea    0x4(%eax),%edx
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 10                	mov    %edx,(%eax)
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	83 e8 04             	sub    $0x4,%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ee:	5d                   	pop    %ebp
  8006ef:	c3                   	ret    

008006f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f7:	7e 1c                	jle    800715 <getint+0x25>
		return va_arg(*ap, long long);
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	8d 50 08             	lea    0x8(%eax),%edx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	89 10                	mov    %edx,(%eax)
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	83 e8 08             	sub    $0x8,%eax
  80070e:	8b 50 04             	mov    0x4(%eax),%edx
  800711:	8b 00                	mov    (%eax),%eax
  800713:	eb 38                	jmp    80074d <getint+0x5d>
	else if (lflag)
  800715:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800719:	74 1a                	je     800735 <getint+0x45>
		return va_arg(*ap, long);
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	8d 50 04             	lea    0x4(%eax),%edx
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	89 10                	mov    %edx,(%eax)
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	83 e8 04             	sub    $0x4,%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	99                   	cltd   
  800733:	eb 18                	jmp    80074d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	8d 50 04             	lea    0x4(%eax),%edx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	89 10                	mov    %edx,(%eax)
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	83 e8 04             	sub    $0x4,%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	99                   	cltd   
}
  80074d:	5d                   	pop    %ebp
  80074e:	c3                   	ret    

0080074f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	56                   	push   %esi
  800753:	53                   	push   %ebx
  800754:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800757:	eb 17                	jmp    800770 <vprintfmt+0x21>
			if (ch == '\0')
  800759:	85 db                	test   %ebx,%ebx
  80075b:	0f 84 c1 03 00 00    	je     800b22 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	53                   	push   %ebx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800770:	8b 45 10             	mov    0x10(%ebp),%eax
  800773:	8d 50 01             	lea    0x1(%eax),%edx
  800776:	89 55 10             	mov    %edx,0x10(%ebp)
  800779:	8a 00                	mov    (%eax),%al
  80077b:	0f b6 d8             	movzbl %al,%ebx
  80077e:	83 fb 25             	cmp    $0x25,%ebx
  800781:	75 d6                	jne    800759 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800783:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800787:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800795:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80079c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8d 50 01             	lea    0x1(%eax),%edx
  8007a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ac:	8a 00                	mov    (%eax),%al
  8007ae:	0f b6 d8             	movzbl %al,%ebx
  8007b1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b4:	83 f8 5b             	cmp    $0x5b,%eax
  8007b7:	0f 87 3d 03 00 00    	ja     800afa <vprintfmt+0x3ab>
  8007bd:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
  8007c4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007ca:	eb d7                	jmp    8007a3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007cc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007d0:	eb d1                	jmp    8007a3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007dc:	89 d0                	mov    %edx,%eax
  8007de:	c1 e0 02             	shl    $0x2,%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	01 c0                	add    %eax,%eax
  8007e5:	01 d8                	add    %ebx,%eax
  8007e7:	83 e8 30             	sub    $0x30,%eax
  8007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f0:	8a 00                	mov    (%eax),%al
  8007f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f8:	7e 3e                	jle    800838 <vprintfmt+0xe9>
  8007fa:	83 fb 39             	cmp    $0x39,%ebx
  8007fd:	7f 39                	jg     800838 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800802:	eb d5                	jmp    8007d9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	83 c0 04             	add    $0x4,%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 e8 04             	sub    $0x4,%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800818:	eb 1f                	jmp    800839 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80081a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081e:	79 83                	jns    8007a3 <vprintfmt+0x54>
				width = 0;
  800820:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800827:	e9 77 ff ff ff       	jmp    8007a3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80082c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800833:	e9 6b ff ff ff       	jmp    8007a3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800838:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800839:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083d:	0f 89 60 ff ff ff    	jns    8007a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800843:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800846:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800849:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800850:	e9 4e ff ff ff       	jmp    8007a3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800855:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800858:	e9 46 ff ff ff       	jmp    8007a3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	83 c0 04             	add    $0x4,%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	83 e8 04             	sub    $0x4,%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			break;
  80087d:	e9 9b 02 00 00       	jmp    800b1d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	83 c0 04             	add    $0x4,%eax
  800888:	89 45 14             	mov    %eax,0x14(%ebp)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800893:	85 db                	test   %ebx,%ebx
  800895:	79 02                	jns    800899 <vprintfmt+0x14a>
				err = -err;
  800897:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800899:	83 fb 64             	cmp    $0x64,%ebx
  80089c:	7f 0b                	jg     8008a9 <vprintfmt+0x15a>
  80089e:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  8008a5:	85 f6                	test   %esi,%esi
  8008a7:	75 19                	jne    8008c2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a9:	53                   	push   %ebx
  8008aa:	68 c5 21 80 00       	push   $0x8021c5
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 70 02 00 00       	call   800b2a <printfmt>
  8008ba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008bd:	e9 5b 02 00 00       	jmp    800b1d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008c2:	56                   	push   %esi
  8008c3:	68 ce 21 80 00       	push   $0x8021ce
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 57 02 00 00       	call   800b2a <printfmt>
  8008d3:	83 c4 10             	add    $0x10,%esp
			break;
  8008d6:	e9 42 02 00 00       	jmp    800b1d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	83 c0 04             	add    $0x4,%eax
  8008e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 e8 04             	sub    $0x4,%eax
  8008ea:	8b 30                	mov    (%eax),%esi
  8008ec:	85 f6                	test   %esi,%esi
  8008ee:	75 05                	jne    8008f5 <vprintfmt+0x1a6>
				p = "(null)";
  8008f0:	be d1 21 80 00       	mov    $0x8021d1,%esi
			if (width > 0 && padc != '-')
  8008f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f9:	7e 6d                	jle    800968 <vprintfmt+0x219>
  8008fb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ff:	74 67                	je     800968 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800901:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	50                   	push   %eax
  800908:	56                   	push   %esi
  800909:	e8 1e 03 00 00       	call   800c2c <strnlen>
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800914:	eb 16                	jmp    80092c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800916:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	50                   	push   %eax
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	ff 4d e4             	decl   -0x1c(%ebp)
  80092c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800930:	7f e4                	jg     800916 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800932:	eb 34                	jmp    800968 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800934:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800938:	74 1c                	je     800956 <vprintfmt+0x207>
  80093a:	83 fb 1f             	cmp    $0x1f,%ebx
  80093d:	7e 05                	jle    800944 <vprintfmt+0x1f5>
  80093f:	83 fb 7e             	cmp    $0x7e,%ebx
  800942:	7e 12                	jle    800956 <vprintfmt+0x207>
					putch('?', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 3f                	push   $0x3f
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
  800954:	eb 0f                	jmp    800965 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	53                   	push   %ebx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	ff d0                	call   *%eax
  800962:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800965:	ff 4d e4             	decl   -0x1c(%ebp)
  800968:	89 f0                	mov    %esi,%eax
  80096a:	8d 70 01             	lea    0x1(%eax),%esi
  80096d:	8a 00                	mov    (%eax),%al
  80096f:	0f be d8             	movsbl %al,%ebx
  800972:	85 db                	test   %ebx,%ebx
  800974:	74 24                	je     80099a <vprintfmt+0x24b>
  800976:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097a:	78 b8                	js     800934 <vprintfmt+0x1e5>
  80097c:	ff 4d e0             	decl   -0x20(%ebp)
  80097f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800983:	79 af                	jns    800934 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800985:	eb 13                	jmp    80099a <vprintfmt+0x24b>
				putch(' ', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	6a 20                	push   $0x20
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800997:	ff 4d e4             	decl   -0x1c(%ebp)
  80099a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099e:	7f e7                	jg     800987 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009a0:	e9 78 01 00 00       	jmp    800b1d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	e8 3c fd ff ff       	call   8006f0 <getint>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c3:	85 d2                	test   %edx,%edx
  8009c5:	79 23                	jns    8009ea <vprintfmt+0x29b>
				putch('-', putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	6a 2d                	push   $0x2d
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009dd:	f7 d8                	neg    %eax
  8009df:	83 d2 00             	adc    $0x0,%edx
  8009e2:	f7 da                	neg    %edx
  8009e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f1:	e9 bc 00 00 00       	jmp    800ab2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ff:	50                   	push   %eax
  800a00:	e8 84 fc ff ff       	call   800689 <getuint>
  800a05:	83 c4 10             	add    $0x10,%esp
  800a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a15:	e9 98 00 00 00       	jmp    800ab2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 58                	push   $0x58
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			break;
  800a4a:	e9 ce 00 00 00       	jmp    800b1d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	6a 30                	push   $0x30
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	ff d0                	call   *%eax
  800a5c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 78                	push   $0x78
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	83 c0 04             	add    $0x4,%eax
  800a75:	89 45 14             	mov    %eax,0x14(%ebp)
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	83 e8 04             	sub    $0x4,%eax
  800a7e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a91:	eb 1f                	jmp    800ab2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 e8             	pushl  -0x18(%ebp)
  800a99:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	e8 e7 fb ff ff       	call   800689 <getuint>
  800aa2:	83 c4 10             	add    $0x10,%esp
  800aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab9:	83 ec 04             	sub    $0x4,%esp
  800abc:	52                   	push   %edx
  800abd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac0:	50                   	push   %eax
  800ac1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 08             	pushl  0x8(%ebp)
  800acd:	e8 00 fb ff ff       	call   8005d2 <printnum>
  800ad2:	83 c4 20             	add    $0x20,%esp
			break;
  800ad5:	eb 46                	jmp    800b1d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	53                   	push   %ebx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	ff d0                	call   *%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
			break;
  800ae6:	eb 35                	jmp    800b1d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ae8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aef:	eb 2c                	jmp    800b1d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800af1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800af8:	eb 23                	jmp    800b1d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 25                	push   $0x25
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	eb 03                	jmp    800b12 <vprintfmt+0x3c3>
  800b0f:	ff 4d 10             	decl   0x10(%ebp)
  800b12:	8b 45 10             	mov    0x10(%ebp),%eax
  800b15:	48                   	dec    %eax
  800b16:	8a 00                	mov    (%eax),%al
  800b18:	3c 25                	cmp    $0x25,%al
  800b1a:	75 f3                	jne    800b0f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b1c:	90                   	nop
		}
	}
  800b1d:	e9 35 fc ff ff       	jmp    800757 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b22:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b30:	8d 45 10             	lea    0x10(%ebp),%eax
  800b33:	83 c0 04             	add    $0x4,%eax
  800b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b39:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	50                   	push   %eax
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	ff 75 08             	pushl  0x8(%ebp)
  800b46:	e8 04 fc ff ff       	call   80074f <vprintfmt>
  800b4b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4e:	90                   	nop
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	8b 40 08             	mov    0x8(%eax),%eax
  800b5a:	8d 50 01             	lea    0x1(%eax),%edx
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 10                	mov    (%eax),%edx
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	8b 40 04             	mov    0x4(%eax),%eax
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	73 12                	jae    800b84 <sprintputch+0x33>
		*b->buf++ = ch;
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	8d 48 01             	lea    0x1(%eax),%ecx
  800b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7d:	89 0a                	mov    %ecx,(%edx)
  800b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b82:	88 10                	mov    %dl,(%eax)
}
  800b84:	90                   	nop
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bac:	74 06                	je     800bb4 <vsnprintf+0x2d>
  800bae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb2:	7f 07                	jg     800bbb <vsnprintf+0x34>
		return -E_INVAL;
  800bb4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb9:	eb 20                	jmp    800bdb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bbb:	ff 75 14             	pushl  0x14(%ebp)
  800bbe:	ff 75 10             	pushl  0x10(%ebp)
  800bc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc4:	50                   	push   %eax
  800bc5:	68 51 0b 80 00       	push   $0x800b51
  800bca:	e8 80 fb ff ff       	call   80074f <vprintfmt>
  800bcf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be3:	8d 45 10             	lea    0x10(%ebp),%eax
  800be6:	83 c0 04             	add    $0x4,%eax
  800be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bec:	8b 45 10             	mov    0x10(%ebp),%eax
  800bef:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf2:	50                   	push   %eax
  800bf3:	ff 75 0c             	pushl  0xc(%ebp)
  800bf6:	ff 75 08             	pushl  0x8(%ebp)
  800bf9:	e8 89 ff ff ff       	call   800b87 <vsnprintf>
  800bfe:	83 c4 10             	add    $0x10,%esp
  800c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c16:	eb 06                	jmp    800c1e <strlen+0x15>
		n++;
  800c18:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c1b:	ff 45 08             	incl   0x8(%ebp)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	84 c0                	test   %al,%al
  800c25:	75 f1                	jne    800c18 <strlen+0xf>
		n++;
	return n;
  800c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c39:	eb 09                	jmp    800c44 <strnlen+0x18>
		n++;
  800c3b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3e:	ff 45 08             	incl   0x8(%ebp)
  800c41:	ff 4d 0c             	decl   0xc(%ebp)
  800c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c48:	74 09                	je     800c53 <strnlen+0x27>
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	84 c0                	test   %al,%al
  800c51:	75 e8                	jne    800c3b <strnlen+0xf>
		n++;
	return n;
  800c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c64:	90                   	nop
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8d 50 01             	lea    0x1(%eax),%edx
  800c6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c74:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c77:	8a 12                	mov    (%edx),%dl
  800c79:	88 10                	mov    %dl,(%eax)
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	84 c0                	test   %al,%al
  800c7f:	75 e4                	jne    800c65 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c99:	eb 1f                	jmp    800cba <strncpy+0x34>
		*dst++ = *src;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ca1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca7:	8a 12                	mov    (%edx),%dl
  800ca9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	84 c0                	test   %al,%al
  800cb2:	74 03                	je     800cb7 <strncpy+0x31>
			src++;
  800cb4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb7:	ff 45 fc             	incl   -0x4(%ebp)
  800cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc0:	72 d9                	jb     800c9b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 30                	je     800d09 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd9:	eb 16                	jmp    800cf1 <strlcpy+0x2a>
			*dst++ = *src++;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8d 50 01             	lea    0x1(%eax),%edx
  800ce1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ced:	8a 12                	mov    (%edx),%dl
  800cef:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf1:	ff 4d 10             	decl   0x10(%ebp)
  800cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf8:	74 09                	je     800d03 <strlcpy+0x3c>
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	84 c0                	test   %al,%al
  800d01:	75 d8                	jne    800cdb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0f:	29 c2                	sub    %eax,%edx
  800d11:	89 d0                	mov    %edx,%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d18:	eb 06                	jmp    800d20 <strcmp+0xb>
		p++, q++;
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	84 c0                	test   %al,%al
  800d27:	74 0e                	je     800d37 <strcmp+0x22>
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 10                	mov    (%eax),%dl
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	38 c2                	cmp    %al,%dl
  800d35:	74 e3                	je     800d1a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	0f b6 d0             	movzbl %al,%edx
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	29 c2                	sub    %eax,%edx
  800d49:	89 d0                	mov    %edx,%eax
}
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d50:	eb 09                	jmp    800d5b <strncmp+0xe>
		n--, p++, q++;
  800d52:	ff 4d 10             	decl   0x10(%ebp)
  800d55:	ff 45 08             	incl   0x8(%ebp)
  800d58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	74 17                	je     800d78 <strncmp+0x2b>
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	84 c0                	test   %al,%al
  800d68:	74 0e                	je     800d78 <strncmp+0x2b>
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 10                	mov    (%eax),%dl
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	38 c2                	cmp    %al,%dl
  800d76:	74 da                	je     800d52 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7c:	75 07                	jne    800d85 <strncmp+0x38>
		return 0;
  800d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d83:	eb 14                	jmp    800d99 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d0             	movzbl %al,%edx
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	0f b6 c0             	movzbl %al,%eax
  800d95:	29 c2                	sub    %eax,%edx
  800d97:	89 d0                	mov    %edx,%eax
}
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 04             	sub    $0x4,%esp
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da7:	eb 12                	jmp    800dbb <strchr+0x20>
		if (*s == c)
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db1:	75 05                	jne    800db8 <strchr+0x1d>
			return (char *) s;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	eb 11                	jmp    800dc9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	75 e5                	jne    800da9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 04             	sub    $0x4,%esp
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd7:	eb 0d                	jmp    800de6 <strfind+0x1b>
		if (*s == c)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de1:	74 0e                	je     800df1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	84 c0                	test   %al,%al
  800ded:	75 ea                	jne    800dd9 <strfind+0xe>
  800def:	eb 01                	jmp    800df2 <strfind+0x27>
		if (*s == c)
			break;
  800df1:	90                   	nop
	return (char *) s;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e03:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e07:	76 63                	jbe    800e6c <memset+0x75>
		uint64 data_block = c;
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	99                   	cltd   
  800e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e10:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e19:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e1d:	c1 e0 08             	shl    $0x8,%eax
  800e20:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e23:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e30:	c1 e0 10             	shl    $0x10,%eax
  800e33:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e36:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	b8 00 00 00 00       	mov    $0x0,%eax
  800e46:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e49:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e4c:	eb 18                	jmp    800e66 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e4e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e51:	8d 41 08             	lea    0x8(%ecx),%eax
  800e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5d:	89 01                	mov    %eax,(%ecx)
  800e5f:	89 51 04             	mov    %edx,0x4(%ecx)
  800e62:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e66:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e6a:	77 e2                	ja     800e4e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e70:	74 23                	je     800e95 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e78:	eb 0e                	jmp    800e88 <memset+0x91>
			*p8++ = (uint8)c;
  800e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7d:	8d 50 01             	lea    0x1(%eax),%edx
  800e80:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e86:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	75 e5                	jne    800e7a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb0:	76 24                	jbe    800ed6 <memcpy+0x3c>
		while(n >= 8){
  800eb2:	eb 1c                	jmp    800ed0 <memcpy+0x36>
			*d64 = *s64;
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8b 50 04             	mov    0x4(%eax),%edx
  800eba:	8b 00                	mov    (%eax),%eax
  800ebc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ebf:	89 01                	mov    %eax,(%ecx)
  800ec1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ec4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ec8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ecc:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ed0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ed4:	77 de                	ja     800eb4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 31                	je     800f0d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ee8:	eb 16                	jmp    800f00 <memcpy+0x66>
			*d8++ = *s8++;
  800eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800efc:	8a 12                	mov    (%edx),%dl
  800efe:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 dd                	jne    800eea <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2a:	73 50                	jae    800f7c <memmove+0x6a>
  800f2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	01 d0                	add    %edx,%eax
  800f34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f37:	76 43                	jbe    800f7c <memmove+0x6a>
		s += n;
  800f39:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f45:	eb 10                	jmp    800f57 <memmove+0x45>
			*--d = *--s;
  800f47:	ff 4d f8             	decl   -0x8(%ebp)
  800f4a:	ff 4d fc             	decl   -0x4(%ebp)
  800f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f50:	8a 10                	mov    (%eax),%dl
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f57:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f60:	85 c0                	test   %eax,%eax
  800f62:	75 e3                	jne    800f47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f64:	eb 23                	jmp    800f89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	8d 50 01             	lea    0x1(%eax),%edx
  800f6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f78:	8a 12                	mov    (%edx),%dl
  800f7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f82:	89 55 10             	mov    %edx,0x10(%ebp)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	75 dd                	jne    800f66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fa0:	eb 2a                	jmp    800fcc <memcmp+0x3e>
		if (*s1 != *s2)
  800fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa5:	8a 10                	mov    (%eax),%dl
  800fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	38 c2                	cmp    %al,%dl
  800fae:	74 16                	je     800fc6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	0f b6 d0             	movzbl %al,%edx
  800fb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f b6 c0             	movzbl %al,%eax
  800fc0:	29 c2                	sub    %eax,%edx
  800fc2:	89 d0                	mov    %edx,%eax
  800fc4:	eb 18                	jmp    800fde <memcmp+0x50>
		s1++, s2++;
  800fc6:	ff 45 fc             	incl   -0x4(%ebp)
  800fc9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	75 c9                	jne    800fa2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
  800fee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ff1:	eb 15                	jmp    801008 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f b6 d0             	movzbl %al,%edx
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	0f b6 c0             	movzbl %al,%eax
  801001:	39 c2                	cmp    %eax,%edx
  801003:	74 0d                	je     801012 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100e:	72 e3                	jb     800ff3 <memfind+0x13>
  801010:	eb 01                	jmp    801013 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801012:	90                   	nop
	return (void *) s;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801025:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102c:	eb 03                	jmp    801031 <strtol+0x19>
		s++;
  80102e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 20                	cmp    $0x20,%al
  801038:	74 f4                	je     80102e <strtol+0x16>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 09                	cmp    $0x9,%al
  801041:	74 eb                	je     80102e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	3c 2b                	cmp    $0x2b,%al
  80104a:	75 05                	jne    801051 <strtol+0x39>
		s++;
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	eb 13                	jmp    801064 <strtol+0x4c>
	else if (*s == '-')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2d                	cmp    $0x2d,%al
  801058:	75 0a                	jne    801064 <strtol+0x4c>
		s++, neg = 1;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801068:	74 06                	je     801070 <strtol+0x58>
  80106a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106e:	75 20                	jne    801090 <strtol+0x78>
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	3c 30                	cmp    $0x30,%al
  801077:	75 17                	jne    801090 <strtol+0x78>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	40                   	inc    %eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 78                	cmp    $0x78,%al
  801081:	75 0d                	jne    801090 <strtol+0x78>
		s += 2, base = 16;
  801083:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801087:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108e:	eb 28                	jmp    8010b8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801090:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801094:	75 15                	jne    8010ab <strtol+0x93>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 30                	cmp    $0x30,%al
  80109d:	75 0c                	jne    8010ab <strtol+0x93>
		s++, base = 8;
  80109f:	ff 45 08             	incl   0x8(%ebp)
  8010a2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a9:	eb 0d                	jmp    8010b8 <strtol+0xa0>
	else if (base == 0)
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 07                	jne    8010b8 <strtol+0xa0>
		base = 10;
  8010b1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 2f                	cmp    $0x2f,%al
  8010bf:	7e 19                	jle    8010da <strtol+0xc2>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 39                	cmp    $0x39,%al
  8010c8:	7f 10                	jg     8010da <strtol+0xc2>
			dig = *s - '0';
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	83 e8 30             	sub    $0x30,%eax
  8010d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d8:	eb 42                	jmp    80111c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 60                	cmp    $0x60,%al
  8010e1:	7e 19                	jle    8010fc <strtol+0xe4>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 7a                	cmp    $0x7a,%al
  8010ea:	7f 10                	jg     8010fc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	0f be c0             	movsbl %al,%eax
  8010f4:	83 e8 57             	sub    $0x57,%eax
  8010f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010fa:	eb 20                	jmp    80111c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	3c 40                	cmp    $0x40,%al
  801103:	7e 39                	jle    80113e <strtol+0x126>
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 5a                	cmp    $0x5a,%al
  80110c:	7f 30                	jg     80113e <strtol+0x126>
			dig = *s - 'A' + 10;
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	0f be c0             	movsbl %al,%eax
  801116:	83 e8 37             	sub    $0x37,%eax
  801119:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801122:	7d 19                	jge    80113d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801124:	ff 45 08             	incl   0x8(%ebp)
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112e:	89 c2                	mov    %eax,%edx
  801130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801133:	01 d0                	add    %edx,%eax
  801135:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801138:	e9 7b ff ff ff       	jmp    8010b8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80113d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801142:	74 08                	je     80114c <strtol+0x134>
		*endptr = (char *) s;
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	8b 55 08             	mov    0x8(%ebp),%edx
  80114a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 07                	je     801159 <strtol+0x141>
  801152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801155:	f7 d8                	neg    %eax
  801157:	eb 03                	jmp    80115c <strtol+0x144>
  801159:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <ltostr>:

void
ltostr(long value, char *str)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80116b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	79 13                	jns    80118b <ltostr+0x2d>
	{
		neg = 1;
  801178:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801185:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801188:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801193:	99                   	cltd   
  801194:	f7 f9                	idiv   %ecx
  801196:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	8d 50 01             	lea    0x1(%eax),%edx
  80119f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a2:	89 c2                	mov    %eax,%edx
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ac:	83 c2 30             	add    $0x30,%edx
  8011af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b9:	f7 e9                	imul   %ecx
  8011bb:	c1 fa 02             	sar    $0x2,%edx
  8011be:	89 c8                	mov    %ecx,%eax
  8011c0:	c1 f8 1f             	sar    $0x1f,%eax
  8011c3:	29 c2                	sub    %eax,%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ce:	75 bb                	jne    80118b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	48                   	dec    %eax
  8011db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e2:	74 3d                	je     801221 <ltostr+0xc3>
		start = 1 ;
  8011e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011eb:	eb 34                	jmp    801221 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 d0                	add    %edx,%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80120e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8a 45 eb             	mov    -0x15(%ebp),%al
  801219:	88 02                	mov    %al,(%edx)
		start++ ;
  80121b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80121e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801224:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801227:	7c c4                	jl     8011ed <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801229:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801234:	90                   	nop
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80123d:	ff 75 08             	pushl  0x8(%ebp)
  801240:	e8 c4 f9 ff ff       	call   800c09 <strlen>
  801245:	83 c4 04             	add    $0x4,%esp
  801248:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	e8 b6 f9 ff ff       	call   800c09 <strlen>
  801253:	83 c4 04             	add    $0x4,%esp
  801256:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801267:	eb 17                	jmp    801280 <strcconcat+0x49>
		final[s] = str1[s] ;
  801269:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	01 c8                	add    %ecx,%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80127d:	ff 45 fc             	incl   -0x4(%ebp)
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801283:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801286:	7c e1                	jl     801269 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801288:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801296:	eb 1f                	jmp    8012b7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801298:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129b:	8d 50 01             	lea    0x1(%eax),%edx
  80129e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a1:	89 c2                	mov    %eax,%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 c2                	add    %eax,%edx
  8012a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 c8                	add    %ecx,%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012b4:	ff 45 f8             	incl   -0x8(%ebp)
  8012b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012bd:	7c d9                	jl     801298 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c5:	01 d0                	add    %edx,%eax
  8012c7:	c6 00 00             	movb   $0x0,(%eax)
}
  8012ca:	90                   	nop
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dc:	8b 00                	mov    (%eax),%eax
  8012de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e8:	01 d0                	add    %edx,%eax
  8012ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f0:	eb 0c                	jmp    8012fe <strsplit+0x31>
			*string++ = 0;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8d 50 01             	lea    0x1(%eax),%edx
  8012f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	84 c0                	test   %al,%al
  801305:	74 18                	je     80131f <strsplit+0x52>
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	0f be c0             	movsbl %al,%eax
  80130f:	50                   	push   %eax
  801310:	ff 75 0c             	pushl  0xc(%ebp)
  801313:	e8 83 fa ff ff       	call   800d9b <strchr>
  801318:	83 c4 08             	add    $0x8,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	75 d3                	jne    8012f2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 5a                	je     801382 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	8b 00                	mov    (%eax),%eax
  80132d:	83 f8 0f             	cmp    $0xf,%eax
  801330:	75 07                	jne    801339 <strsplit+0x6c>
		{
			return 0;
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
  801337:	eb 66                	jmp    80139f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801339:	8b 45 14             	mov    0x14(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 48 01             	lea    0x1(%eax),%ecx
  801341:	8b 55 14             	mov    0x14(%ebp),%edx
  801344:	89 0a                	mov    %ecx,(%edx)
  801346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	01 c2                	add    %eax,%edx
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801357:	eb 03                	jmp    80135c <strsplit+0x8f>
			string++;
  801359:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	84 c0                	test   %al,%al
  801363:	74 8b                	je     8012f0 <strsplit+0x23>
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	0f be c0             	movsbl %al,%eax
  80136d:	50                   	push   %eax
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	e8 25 fa ff ff       	call   800d9b <strchr>
  801376:	83 c4 08             	add    $0x8,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	74 dc                	je     801359 <strsplit+0x8c>
			string++;
	}
  80137d:	e9 6e ff ff ff       	jmp    8012f0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801382:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801383:	8b 45 14             	mov    0x14(%ebp),%eax
  801386:	8b 00                	mov    (%eax),%eax
  801388:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138f:	8b 45 10             	mov    0x10(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80139a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b4:	eb 4a                	jmp    801400 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	01 c8                	add    %ecx,%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	01 d0                	add    %edx,%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 40                	cmp    $0x40,%al
  8013d6:	7e 25                	jle    8013fd <str2lower+0x5c>
  8013d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	01 d0                	add    %edx,%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	3c 5a                	cmp    $0x5a,%al
  8013e4:	7f 17                	jg     8013fd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f4:	01 ca                	add    %ecx,%edx
  8013f6:	8a 12                	mov    (%edx),%dl
  8013f8:	83 c2 20             	add    $0x20,%edx
  8013fb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013fd:	ff 45 fc             	incl   -0x4(%ebp)
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	e8 01 f8 ff ff       	call   800c09 <strlen>
  801408:	83 c4 04             	add    $0x4,%esp
  80140b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80140e:	7f a6                	jg     8013b6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801410:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	57                   	push   %edi
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8b 55 0c             	mov    0xc(%ebp),%edx
  801424:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801427:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80142a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80142d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801430:	cd 30                	int    $0x30
  801432:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801435:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	5b                   	pop    %ebx
  80143c:	5e                   	pop    %esi
  80143d:	5f                   	pop    %edi
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 04             	sub    $0x4,%esp
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80144c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80144f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	6a 00                	push   $0x0
  801458:	51                   	push   %ecx
  801459:	52                   	push   %edx
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	50                   	push   %eax
  80145e:	6a 00                	push   $0x0
  801460:	e8 b0 ff ff ff       	call   801415 <syscall>
  801465:	83 c4 18             	add    $0x18,%esp
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <sys_cgetc>:

int
sys_cgetc(void)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 02                	push   $0x2
  80147a:	e8 96 ff ff ff       	call   801415 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 03                	push   $0x3
  801493:	e8 7d ff ff ff       	call   801415 <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
}
  80149b:	90                   	nop
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 04                	push   $0x4
  8014ad:	e8 63 ff ff ff       	call   801415 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	52                   	push   %edx
  8014c8:	50                   	push   %eax
  8014c9:	6a 08                	push   $0x8
  8014cb:	e8 45 ff ff ff       	call   801415 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014da:	8b 75 18             	mov    0x18(%ebp),%esi
  8014dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	51                   	push   %ecx
  8014ec:	52                   	push   %edx
  8014ed:	50                   	push   %eax
  8014ee:	6a 09                	push   $0x9
  8014f0:	e8 20 ff ff ff       	call   801415 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
}
  8014f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fb:	5b                   	pop    %ebx
  8014fc:	5e                   	pop    %esi
  8014fd:	5d                   	pop    %ebp
  8014fe:	c3                   	ret    

008014ff <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	ff 75 08             	pushl  0x8(%ebp)
  80150d:	6a 0a                	push   $0xa
  80150f:	e8 01 ff ff ff       	call   801415 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	ff 75 0c             	pushl  0xc(%ebp)
  801525:	ff 75 08             	pushl  0x8(%ebp)
  801528:	6a 0b                	push   $0xb
  80152a:	e8 e6 fe ff ff       	call   801415 <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 0c                	push   $0xc
  801543:	e8 cd fe ff ff       	call   801415 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 0d                	push   $0xd
  80155c:	e8 b4 fe ff ff       	call   801415 <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 0e                	push   $0xe
  801575:	e8 9b fe ff ff       	call   801415 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 0f                	push   $0xf
  80158e:	e8 82 fe ff ff       	call   801415 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	ff 75 08             	pushl  0x8(%ebp)
  8015a6:	6a 10                	push   $0x10
  8015a8:	e8 68 fe ff ff       	call   801415 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 11                	push   $0x11
  8015c1:	e8 4f fe ff ff       	call   801415 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	90                   	nop
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_cputc>:

void
sys_cputc(const char c)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	50                   	push   %eax
  8015e5:	6a 01                	push   $0x1
  8015e7:	e8 29 fe ff ff       	call   801415 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 14                	push   $0x14
  801601:	e8 0f fe ff ff       	call   801415 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	90                   	nop
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801618:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80161b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	6a 00                	push   $0x0
  801624:	51                   	push   %ecx
  801625:	52                   	push   %edx
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	50                   	push   %eax
  80162a:	6a 15                	push   $0x15
  80162c:	e8 e4 fd ff ff       	call   801415 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	52                   	push   %edx
  801646:	50                   	push   %eax
  801647:	6a 16                	push   $0x16
  801649:	e8 c7 fd ff ff       	call   801415 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801656:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	51                   	push   %ecx
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	6a 17                	push   $0x17
  801668:	e8 a8 fd ff ff       	call   801415 <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801675:	8b 55 0c             	mov    0xc(%ebp),%edx
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	52                   	push   %edx
  801682:	50                   	push   %eax
  801683:	6a 18                	push   $0x18
  801685:	e8 8b fd ff ff       	call   801415 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	6a 00                	push   $0x0
  801697:	ff 75 14             	pushl  0x14(%ebp)
  80169a:	ff 75 10             	pushl  0x10(%ebp)
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	50                   	push   %eax
  8016a1:	6a 19                	push   $0x19
  8016a3:	e8 6d fd ff ff       	call   801415 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	50                   	push   %eax
  8016bc:	6a 1a                	push   $0x1a
  8016be:	e8 52 fd ff ff       	call   801415 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	90                   	nop
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	50                   	push   %eax
  8016d8:	6a 1b                	push   $0x1b
  8016da:	e8 36 fd ff ff       	call   801415 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 05                	push   $0x5
  8016f3:	e8 1d fd ff ff       	call   801415 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 06                	push   $0x6
  80170c:	e8 04 fd ff ff       	call   801415 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 07                	push   $0x7
  801725:	e8 eb fc ff ff       	call   801415 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_exit_env>:


void sys_exit_env(void)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 1c                	push   $0x1c
  80173e:	e8 d2 fc ff ff       	call   801415 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	90                   	nop
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80174f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801752:	8d 50 04             	lea    0x4(%eax),%edx
  801755:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	52                   	push   %edx
  80175f:	50                   	push   %eax
  801760:	6a 1d                	push   $0x1d
  801762:	e8 ae fc ff ff       	call   801415 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
	return result;
  80176a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801770:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801773:	89 01                	mov    %eax,(%ecx)
  801775:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	c9                   	leave  
  80177c:	c2 04 00             	ret    $0x4

0080177f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	ff 75 10             	pushl  0x10(%ebp)
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 13                	push   $0x13
  801791:	e8 7f fc ff ff       	call   801415 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_rcr2>:
uint32 sys_rcr2()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 1e                	push   $0x1e
  8017ab:	e8 65 fc ff ff       	call   801415 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	50                   	push   %eax
  8017ce:	6a 1f                	push   $0x1f
  8017d0:	e8 40 fc ff ff       	call   801415 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d8:	90                   	nop
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <rsttst>:
void rsttst()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 21                	push   $0x21
  8017ea:	e8 26 fc ff ff       	call   801415 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801801:	8b 55 18             	mov    0x18(%ebp),%edx
  801804:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801808:	52                   	push   %edx
  801809:	50                   	push   %eax
  80180a:	ff 75 10             	pushl  0x10(%ebp)
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	6a 20                	push   $0x20
  801815:	e8 fb fb ff ff       	call   801415 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
	return ;
  80181d:	90                   	nop
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <chktst>:
void chktst(uint32 n)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	6a 22                	push   $0x22
  801830:	e8 e0 fb ff ff       	call   801415 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
	return ;
  801838:	90                   	nop
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <inctst>:

void inctst()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 23                	push   $0x23
  80184a:	e8 c6 fb ff ff       	call   801415 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
	return ;
  801852:	90                   	nop
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <gettst>:
uint32 gettst()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 24                	push   $0x24
  801864:	e8 ac fb ff ff       	call   801415 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 25                	push   $0x25
  80187d:	e8 93 fb ff ff       	call   801415 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
  801885:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80188a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 08             	pushl  0x8(%ebp)
  8018a7:	6a 26                	push   $0x26
  8018a9:	e8 67 fb ff ff       	call   801415 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b1:	90                   	nop
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	53                   	push   %ebx
  8018c7:	51                   	push   %ecx
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 27                	push   $0x27
  8018cc:	e8 44 fb ff ff       	call   801415 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 28                	push   $0x28
  8018ec:	e8 24 fb ff ff       	call   801415 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	51                   	push   %ecx
  801905:	ff 75 10             	pushl  0x10(%ebp)
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	6a 29                	push   $0x29
  80190c:	e8 04 fb ff ff       	call   801415 <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	ff 75 10             	pushl  0x10(%ebp)
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	6a 12                	push   $0x12
  801928:	e8 e8 fa ff ff       	call   801415 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
	return ;
  801930:	90                   	nop
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801936:	8b 55 0c             	mov    0xc(%ebp),%edx
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	52                   	push   %edx
  801943:	50                   	push   %eax
  801944:	6a 2a                	push   $0x2a
  801946:	e8 ca fa ff ff       	call   801415 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
	return;
  80194e:	90                   	nop
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 2b                	push   $0x2b
  801960:	e8 b0 fa ff ff       	call   801415 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	ff 75 08             	pushl  0x8(%ebp)
  801979:	6a 2d                	push   $0x2d
  80197b:	e8 95 fa ff ff       	call   801415 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
	return;
  801983:	90                   	nop
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	6a 2c                	push   $0x2c
  801997:	e8 79 fa ff ff       	call   801415 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
	return ;
  80199f:	90                   	nop
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 2e                	push   $0x2e
  8019b5:	e8 5b fa ff ff       	call   801415 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <__udivdi3>:
  8019c0:	55                   	push   %ebp
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 1c             	sub    $0x1c,%esp
  8019c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d7:	89 ca                	mov    %ecx,%edx
  8019d9:	89 f8                	mov    %edi,%eax
  8019db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019df:	85 f6                	test   %esi,%esi
  8019e1:	75 2d                	jne    801a10 <__udivdi3+0x50>
  8019e3:	39 cf                	cmp    %ecx,%edi
  8019e5:	77 65                	ja     801a4c <__udivdi3+0x8c>
  8019e7:	89 fd                	mov    %edi,%ebp
  8019e9:	85 ff                	test   %edi,%edi
  8019eb:	75 0b                	jne    8019f8 <__udivdi3+0x38>
  8019ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f2:	31 d2                	xor    %edx,%edx
  8019f4:	f7 f7                	div    %edi
  8019f6:	89 c5                	mov    %eax,%ebp
  8019f8:	31 d2                	xor    %edx,%edx
  8019fa:	89 c8                	mov    %ecx,%eax
  8019fc:	f7 f5                	div    %ebp
  8019fe:	89 c1                	mov    %eax,%ecx
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	f7 f5                	div    %ebp
  801a04:	89 cf                	mov    %ecx,%edi
  801a06:	89 fa                	mov    %edi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	39 ce                	cmp    %ecx,%esi
  801a12:	77 28                	ja     801a3c <__udivdi3+0x7c>
  801a14:	0f bd fe             	bsr    %esi,%edi
  801a17:	83 f7 1f             	xor    $0x1f,%edi
  801a1a:	75 40                	jne    801a5c <__udivdi3+0x9c>
  801a1c:	39 ce                	cmp    %ecx,%esi
  801a1e:	72 0a                	jb     801a2a <__udivdi3+0x6a>
  801a20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a24:	0f 87 9e 00 00 00    	ja     801ac8 <__udivdi3+0x108>
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	89 fa                	mov    %edi,%edx
  801a31:	83 c4 1c             	add    $0x1c,%esp
  801a34:	5b                   	pop    %ebx
  801a35:	5e                   	pop    %esi
  801a36:	5f                   	pop    %edi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    
  801a39:	8d 76 00             	lea    0x0(%esi),%esi
  801a3c:	31 ff                	xor    %edi,%edi
  801a3e:	31 c0                	xor    %eax,%eax
  801a40:	89 fa                	mov    %edi,%edx
  801a42:	83 c4 1c             	add    $0x1c,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5f                   	pop    %edi
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    
  801a4a:	66 90                	xchg   %ax,%ax
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	f7 f7                	div    %edi
  801a50:	31 ff                	xor    %edi,%edi
  801a52:	89 fa                	mov    %edi,%edx
  801a54:	83 c4 1c             	add    $0x1c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
  801a5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a61:	89 eb                	mov    %ebp,%ebx
  801a63:	29 fb                	sub    %edi,%ebx
  801a65:	89 f9                	mov    %edi,%ecx
  801a67:	d3 e6                	shl    %cl,%esi
  801a69:	89 c5                	mov    %eax,%ebp
  801a6b:	88 d9                	mov    %bl,%cl
  801a6d:	d3 ed                	shr    %cl,%ebp
  801a6f:	89 e9                	mov    %ebp,%ecx
  801a71:	09 f1                	or     %esi,%ecx
  801a73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a77:	89 f9                	mov    %edi,%ecx
  801a79:	d3 e0                	shl    %cl,%eax
  801a7b:	89 c5                	mov    %eax,%ebp
  801a7d:	89 d6                	mov    %edx,%esi
  801a7f:	88 d9                	mov    %bl,%cl
  801a81:	d3 ee                	shr    %cl,%esi
  801a83:	89 f9                	mov    %edi,%ecx
  801a85:	d3 e2                	shl    %cl,%edx
  801a87:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a8b:	88 d9                	mov    %bl,%cl
  801a8d:	d3 e8                	shr    %cl,%eax
  801a8f:	09 c2                	or     %eax,%edx
  801a91:	89 d0                	mov    %edx,%eax
  801a93:	89 f2                	mov    %esi,%edx
  801a95:	f7 74 24 0c          	divl   0xc(%esp)
  801a99:	89 d6                	mov    %edx,%esi
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	f7 e5                	mul    %ebp
  801a9f:	39 d6                	cmp    %edx,%esi
  801aa1:	72 19                	jb     801abc <__udivdi3+0xfc>
  801aa3:	74 0b                	je     801ab0 <__udivdi3+0xf0>
  801aa5:	89 d8                	mov    %ebx,%eax
  801aa7:	31 ff                	xor    %edi,%edi
  801aa9:	e9 58 ff ff ff       	jmp    801a06 <__udivdi3+0x46>
  801aae:	66 90                	xchg   %ax,%ax
  801ab0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ab4:	89 f9                	mov    %edi,%ecx
  801ab6:	d3 e2                	shl    %cl,%edx
  801ab8:	39 c2                	cmp    %eax,%edx
  801aba:	73 e9                	jae    801aa5 <__udivdi3+0xe5>
  801abc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801abf:	31 ff                	xor    %edi,%edi
  801ac1:	e9 40 ff ff ff       	jmp    801a06 <__udivdi3+0x46>
  801ac6:	66 90                	xchg   %ax,%ax
  801ac8:	31 c0                	xor    %eax,%eax
  801aca:	e9 37 ff ff ff       	jmp    801a06 <__udivdi3+0x46>
  801acf:	90                   	nop

00801ad0 <__umoddi3>:
  801ad0:	55                   	push   %ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801adb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801adf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ae3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ae7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aeb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aef:	89 f3                	mov    %esi,%ebx
  801af1:	89 fa                	mov    %edi,%edx
  801af3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af7:	89 34 24             	mov    %esi,(%esp)
  801afa:	85 c0                	test   %eax,%eax
  801afc:	75 1a                	jne    801b18 <__umoddi3+0x48>
  801afe:	39 f7                	cmp    %esi,%edi
  801b00:	0f 86 a2 00 00 00    	jbe    801ba8 <__umoddi3+0xd8>
  801b06:	89 c8                	mov    %ecx,%eax
  801b08:	89 f2                	mov    %esi,%edx
  801b0a:	f7 f7                	div    %edi
  801b0c:	89 d0                	mov    %edx,%eax
  801b0e:	31 d2                	xor    %edx,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	39 f0                	cmp    %esi,%eax
  801b1a:	0f 87 ac 00 00 00    	ja     801bcc <__umoddi3+0xfc>
  801b20:	0f bd e8             	bsr    %eax,%ebp
  801b23:	83 f5 1f             	xor    $0x1f,%ebp
  801b26:	0f 84 ac 00 00 00    	je     801bd8 <__umoddi3+0x108>
  801b2c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b31:	29 ef                	sub    %ebp,%edi
  801b33:	89 fe                	mov    %edi,%esi
  801b35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 e0                	shl    %cl,%eax
  801b3d:	89 d7                	mov    %edx,%edi
  801b3f:	89 f1                	mov    %esi,%ecx
  801b41:	d3 ef                	shr    %cl,%edi
  801b43:	09 c7                	or     %eax,%edi
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 e2                	shl    %cl,%edx
  801b49:	89 14 24             	mov    %edx,(%esp)
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	d3 e0                	shl    %cl,%eax
  801b50:	89 c2                	mov    %eax,%edx
  801b52:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b56:	d3 e0                	shl    %cl,%eax
  801b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b60:	89 f1                	mov    %esi,%ecx
  801b62:	d3 e8                	shr    %cl,%eax
  801b64:	09 d0                	or     %edx,%eax
  801b66:	d3 eb                	shr    %cl,%ebx
  801b68:	89 da                	mov    %ebx,%edx
  801b6a:	f7 f7                	div    %edi
  801b6c:	89 d3                	mov    %edx,%ebx
  801b6e:	f7 24 24             	mull   (%esp)
  801b71:	89 c6                	mov    %eax,%esi
  801b73:	89 d1                	mov    %edx,%ecx
  801b75:	39 d3                	cmp    %edx,%ebx
  801b77:	0f 82 87 00 00 00    	jb     801c04 <__umoddi3+0x134>
  801b7d:	0f 84 91 00 00 00    	je     801c14 <__umoddi3+0x144>
  801b83:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b87:	29 f2                	sub    %esi,%edx
  801b89:	19 cb                	sbb    %ecx,%ebx
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b91:	d3 e0                	shl    %cl,%eax
  801b93:	89 e9                	mov    %ebp,%ecx
  801b95:	d3 ea                	shr    %cl,%edx
  801b97:	09 d0                	or     %edx,%eax
  801b99:	89 e9                	mov    %ebp,%ecx
  801b9b:	d3 eb                	shr    %cl,%ebx
  801b9d:	89 da                	mov    %ebx,%edx
  801b9f:	83 c4 1c             	add    $0x1c,%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5f                   	pop    %edi
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    
  801ba7:	90                   	nop
  801ba8:	89 fd                	mov    %edi,%ebp
  801baa:	85 ff                	test   %edi,%edi
  801bac:	75 0b                	jne    801bb9 <__umoddi3+0xe9>
  801bae:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb3:	31 d2                	xor    %edx,%edx
  801bb5:	f7 f7                	div    %edi
  801bb7:	89 c5                	mov    %eax,%ebp
  801bb9:	89 f0                	mov    %esi,%eax
  801bbb:	31 d2                	xor    %edx,%edx
  801bbd:	f7 f5                	div    %ebp
  801bbf:	89 c8                	mov    %ecx,%eax
  801bc1:	f7 f5                	div    %ebp
  801bc3:	89 d0                	mov    %edx,%eax
  801bc5:	e9 44 ff ff ff       	jmp    801b0e <__umoddi3+0x3e>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	89 c8                	mov    %ecx,%eax
  801bce:	89 f2                	mov    %esi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	3b 04 24             	cmp    (%esp),%eax
  801bdb:	72 06                	jb     801be3 <__umoddi3+0x113>
  801bdd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801be1:	77 0f                	ja     801bf2 <__umoddi3+0x122>
  801be3:	89 f2                	mov    %esi,%edx
  801be5:	29 f9                	sub    %edi,%ecx
  801be7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801beb:	89 14 24             	mov    %edx,(%esp)
  801bee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bf6:	8b 14 24             	mov    (%esp),%edx
  801bf9:	83 c4 1c             	add    $0x1c,%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5f                   	pop    %edi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    
  801c01:	8d 76 00             	lea    0x0(%esi),%esi
  801c04:	2b 04 24             	sub    (%esp),%eax
  801c07:	19 fa                	sbb    %edi,%edx
  801c09:	89 d1                	mov    %edx,%ecx
  801c0b:	89 c6                	mov    %eax,%esi
  801c0d:	e9 71 ff ff ff       	jmp    801b83 <__umoddi3+0xb3>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c18:	72 ea                	jb     801c04 <__umoddi3+0x134>
  801c1a:	89 d9                	mov    %ebx,%ecx
  801c1c:	e9 62 ff ff ff       	jmp    801b83 <__umoddi3+0xb3>
