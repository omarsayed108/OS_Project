
obj/user/tst_invalid_access_slave3:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
	//[1] Non=reserved User Heap
	uint32 *ptr = (uint32*)(USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE);
  80003e:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 bd 17 00 00       	call   801810 <inctst>
	panic("tst invalid access failed: Attempt to access a non-reserved (unmarked) user heap page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 00 1c 80 00       	push   $0x801c00
  80005b:	6a 0e                	push   $0xe
  80005d:	68 8c 1c 80 00       	push   $0x801c8c
  800062:	e8 b0 01 00 00       	call   800217 <_panic>

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 5d 16 00 00       	call   8016d2 <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	01 c0                	add    %eax,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	c1 e0 02             	shl    $0x2,%eax
  800084:	01 d0                	add    %edx,%eax
  800086:	c1 e0 02             	shl    $0x2,%eax
  800089:	01 d0                	add    %edx,%eax
  80008b:	c1 e0 03             	shl    $0x3,%eax
  80008e:	01 d0                	add    %edx,%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009d:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a2:	8a 40 20             	mov    0x20(%eax),%al
  8000a5:	84 c0                	test   %al,%al
  8000a7:	74 0d                	je     8000b6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ae:	83 c0 20             	add    $0x20,%eax
  8000b1:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ba:	7e 0a                	jle    8000c6 <libmain+0x5f>
		binaryname = argv[0];
  8000bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bf:	8b 00                	mov    (%eax),%eax
  8000c1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	ff 75 0c             	pushl  0xc(%ebp)
  8000cc:	ff 75 08             	pushl  0x8(%ebp)
  8000cf:	e8 64 ff ff ff       	call   800038 <_main>
  8000d4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 84 01 01 00 00    	je     8001e5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ea:	bb a8 1d 80 00       	mov    $0x801da8,%ebx
  8000ef:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000f4:	89 c7                	mov    %eax,%edi
  8000f6:	89 de                	mov    %ebx,%esi
  8000f8:	89 d1                	mov    %edx,%ecx
  8000fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000fc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ff:	b9 56 00 00 00       	mov    $0x56,%ecx
  800104:	b0 00                	mov    $0x0,%al
  800106:	89 d7                	mov    %edx,%edi
  800108:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80010a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800111:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	50                   	push   %eax
  800118:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 e4 17 00 00       	call   801908 <sys_utilities>
  800124:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800127:	e8 2d 13 00 00       	call   801459 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	68 c8 1c 80 00       	push   $0x801cc8
  800134:	e8 cc 03 00 00       	call   800505 <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 18                	je     80015b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800143:	e8 de 17 00 00       	call   801926 <sys_get_optimal_num_faults>
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	50                   	push   %eax
  80014c:	68 f0 1c 80 00       	push   $0x801cf0
  800151:	e8 af 03 00 00       	call   800505 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	eb 59                	jmp    8001b4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015b:	a1 20 30 80 00       	mov    0x803020,%eax
  800160:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	52                   	push   %edx
  800175:	50                   	push   %eax
  800176:	68 14 1d 80 00       	push   $0x801d14
  80017b:	e8 85 03 00 00       	call   800505 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800183:	a1 20 30 80 00       	mov    0x803020,%eax
  800188:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80018e:	a1 20 30 80 00       	mov    0x803020,%eax
  800193:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800199:	a1 20 30 80 00       	mov    0x803020,%eax
  80019e:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8001a4:	51                   	push   %ecx
  8001a5:	52                   	push   %edx
  8001a6:	50                   	push   %eax
  8001a7:	68 3c 1d 80 00       	push   $0x801d3c
  8001ac:	e8 54 03 00 00       	call   800505 <cprintf>
  8001b1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b9:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	68 94 1d 80 00       	push   $0x801d94
  8001c8:	e8 38 03 00 00       	call   800505 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	68 c8 1c 80 00       	push   $0x801cc8
  8001d8:	e8 28 03 00 00       	call   800505 <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e0:	e8 8e 12 00 00       	call   801473 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001e5:	e8 1f 00 00 00       	call   800209 <exit>
}
  8001ea:	90                   	nop
  8001eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5f                   	pop    %edi
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    

008001f3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	6a 00                	push   $0x0
  8001fe:	e8 9b 14 00 00       	call   80169e <sys_destroy_env>
  800203:	83 c4 10             	add    $0x10,%esp
}
  800206:	90                   	nop
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <exit>:

void
exit(void)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020f:	e8 f0 14 00 00       	call   801704 <sys_exit_env>
}
  800214:	90                   	nop
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80021d:	8d 45 10             	lea    0x10(%ebp),%eax
  800220:	83 c0 04             	add    $0x4,%eax
  800223:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800226:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80022b:	85 c0                	test   %eax,%eax
  80022d:	74 16                	je     800245 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80022f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	50                   	push   %eax
  800238:	68 0c 1e 80 00       	push   $0x801e0c
  80023d:	e8 c3 02 00 00       	call   800505 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800245:	a1 04 30 80 00       	mov    0x803004,%eax
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	50                   	push   %eax
  800254:	68 14 1e 80 00       	push   $0x801e14
  800259:	6a 74                	push   $0x74
  80025b:	e8 d2 02 00 00       	call   800532 <cprintf_colored>
  800260:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800263:	8b 45 10             	mov    0x10(%ebp),%eax
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	ff 75 f4             	pushl  -0xc(%ebp)
  80026c:	50                   	push   %eax
  80026d:	e8 24 02 00 00       	call   800496 <vcprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	6a 00                	push   $0x0
  80027a:	68 3c 1e 80 00       	push   $0x801e3c
  80027f:	e8 12 02 00 00       	call   800496 <vcprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800287:	e8 7d ff ff ff       	call   800209 <exit>

	// should not return here
	while (1) ;
  80028c:	eb fe                	jmp    80028c <_panic+0x75>

0080028e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	53                   	push   %ebx
  800292:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	39 c2                	cmp    %eax,%edx
  8002a5:	74 14                	je     8002bb <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 40 1e 80 00       	push   $0x801e40
  8002af:	6a 26                	push   $0x26
  8002b1:	68 8c 1e 80 00       	push   $0x801e8c
  8002b6:	e8 5c ff ff ff       	call   800217 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002c9:	e9 d9 00 00 00       	jmp    8003a7 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8002ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	8b 00                	mov    (%eax),%eax
  8002df:	85 c0                	test   %eax,%eax
  8002e1:	75 08                	jne    8002eb <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8002e3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002e6:	e9 b9 00 00 00       	jmp    8003a4 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8002eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002f9:	eb 79                	jmp    800374 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800300:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800306:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800309:	89 d0                	mov    %edx,%eax
  80030b:	01 c0                	add    %eax,%eax
  80030d:	01 d0                	add    %edx,%eax
  80030f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800316:	01 d8                	add    %ebx,%eax
  800318:	01 d0                	add    %edx,%eax
  80031a:	01 c8                	add    %ecx,%eax
  80031c:	8a 40 04             	mov    0x4(%eax),%al
  80031f:	84 c0                	test   %al,%al
  800321:	75 4e                	jne    800371 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80032e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800331:	89 d0                	mov    %edx,%eax
  800333:	01 c0                	add    %eax,%eax
  800335:	01 d0                	add    %edx,%eax
  800337:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80033e:	01 d8                	add    %ebx,%eax
  800340:	01 d0                	add    %edx,%eax
  800342:	01 c8                	add    %ecx,%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800349:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80034c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800351:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800364:	39 c2                	cmp    %eax,%edx
  800366:	75 09                	jne    800371 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800368:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80036f:	eb 19                	jmp    80038a <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800371:	ff 45 e8             	incl   -0x18(%ebp)
  800374:	a1 20 30 80 00       	mov    0x803020,%eax
  800379:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800382:	39 c2                	cmp    %eax,%edx
  800384:	0f 87 71 ff ff ff    	ja     8002fb <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80038a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80038e:	75 14                	jne    8003a4 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	68 98 1e 80 00       	push   $0x801e98
  800398:	6a 3a                	push   $0x3a
  80039a:	68 8c 1e 80 00       	push   $0x801e8c
  80039f:	e8 73 fe ff ff       	call   800217 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003a4:	ff 45 f0             	incl   -0x10(%ebp)
  8003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ad:	0f 8c 1b ff ff ff    	jl     8002ce <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c1:	eb 2e                	jmp    8003f1 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	01 c0                	add    %eax,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003de:	01 d8                	add    %ebx,%eax
  8003e0:	01 d0                	add    %edx,%eax
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	8a 40 04             	mov    0x4(%eax),%al
  8003e7:	3c 01                	cmp    $0x1,%al
  8003e9:	75 03                	jne    8003ee <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8003eb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ee:	ff 45 e0             	incl   -0x20(%ebp)
  8003f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ff:	39 c2                	cmp    %eax,%edx
  800401:	77 c0                	ja     8003c3 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800409:	74 14                	je     80041f <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80040b:	83 ec 04             	sub    $0x4,%esp
  80040e:	68 ec 1e 80 00       	push   $0x801eec
  800413:	6a 44                	push   $0x44
  800415:	68 8c 1e 80 00       	push   $0x801e8c
  80041a:	e8 f8 fd ff ff       	call   800217 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80041f:	90                   	nop
  800420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	53                   	push   %ebx
  800429:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80042c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	8d 48 01             	lea    0x1(%eax),%ecx
  800434:	8b 55 0c             	mov    0xc(%ebp),%edx
  800437:	89 0a                	mov    %ecx,(%edx)
  800439:	8b 55 08             	mov    0x8(%ebp),%edx
  80043c:	88 d1                	mov    %dl,%cl
  80043e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800441:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044f:	75 30                	jne    800481 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800451:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800457:	a0 44 30 80 00       	mov    0x803044,%al
  80045c:	0f b6 c0             	movzbl %al,%eax
  80045f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800462:	8b 09                	mov    (%ecx),%ecx
  800464:	89 cb                	mov    %ecx,%ebx
  800466:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800469:	83 c1 08             	add    $0x8,%ecx
  80046c:	52                   	push   %edx
  80046d:	50                   	push   %eax
  80046e:	53                   	push   %ebx
  80046f:	51                   	push   %ecx
  800470:	e8 a0 0f 00 00       	call   801415 <sys_cputs>
  800475:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 40 04             	mov    0x4(%eax),%eax
  800487:	8d 50 01             	lea    0x1(%eax),%edx
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800490:	90                   	nop
  800491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80049f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004a6:	00 00 00 
	b.cnt = 0;
  8004a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004b0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004b3:	ff 75 0c             	pushl  0xc(%ebp)
  8004b6:	ff 75 08             	pushl  0x8(%ebp)
  8004b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004bf:	50                   	push   %eax
  8004c0:	68 25 04 80 00       	push   $0x800425
  8004c5:	e8 5a 02 00 00       	call   800724 <vprintfmt>
  8004ca:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004cd:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004d3:	a0 44 30 80 00       	mov    0x803044,%al
  8004d8:	0f b6 c0             	movzbl %al,%eax
  8004db:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004e1:	52                   	push   %edx
  8004e2:	50                   	push   %eax
  8004e3:	51                   	push   %ecx
  8004e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ea:	83 c0 08             	add    $0x8,%eax
  8004ed:	50                   	push   %eax
  8004ee:	e8 22 0f 00 00       	call   801415 <sys_cputs>
  8004f3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004f6:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800503:	c9                   	leave  
  800504:	c3                   	ret    

00800505 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80050b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800512:	8d 45 0c             	lea    0xc(%ebp),%eax
  800515:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 f4             	pushl  -0xc(%ebp)
  800521:	50                   	push   %eax
  800522:	e8 6f ff ff ff       	call   800496 <vcprintf>
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80052d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800538:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	c1 e0 08             	shl    $0x8,%eax
  800545:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80054a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054d:	83 c0 04             	add    $0x4,%eax
  800550:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	ff 75 f4             	pushl  -0xc(%ebp)
  80055c:	50                   	push   %eax
  80055d:	e8 34 ff ff ff       	call   800496 <vcprintf>
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800568:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80056f:	07 00 00 

	return cnt;
  800572:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80057d:	e8 d7 0e 00 00       	call   801459 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800582:	8d 45 0c             	lea    0xc(%ebp),%eax
  800585:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	ff 75 f4             	pushl  -0xc(%ebp)
  800591:	50                   	push   %eax
  800592:	e8 ff fe ff ff       	call   800496 <vcprintf>
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80059d:	e8 d1 0e 00 00       	call   801473 <sys_unlock_cons>
	return cnt;
  8005a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	53                   	push   %ebx
  8005ab:	83 ec 14             	sub    $0x14,%esp
  8005ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c5:	77 55                	ja     80061c <printnum+0x75>
  8005c7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ca:	72 05                	jb     8005d1 <printnum+0x2a>
  8005cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005cf:	77 4b                	ja     80061c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005da:	ba 00 00 00 00       	mov    $0x0,%edx
  8005df:	52                   	push   %edx
  8005e0:	50                   	push   %eax
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e7:	e8 ac 13 00 00       	call   801998 <__udivdi3>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	53                   	push   %ebx
  8005f6:	ff 75 18             	pushl  0x18(%ebp)
  8005f9:	52                   	push   %edx
  8005fa:	50                   	push   %eax
  8005fb:	ff 75 0c             	pushl  0xc(%ebp)
  8005fe:	ff 75 08             	pushl  0x8(%ebp)
  800601:	e8 a1 ff ff ff       	call   8005a7 <printnum>
  800606:	83 c4 20             	add    $0x20,%esp
  800609:	eb 1a                	jmp    800625 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	ff 75 0c             	pushl  0xc(%ebp)
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	ff d0                	call   *%eax
  800619:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061c:	ff 4d 1c             	decl   0x1c(%ebp)
  80061f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800623:	7f e6                	jg     80060b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800625:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800628:	bb 00 00 00 00       	mov    $0x0,%ebx
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800633:	53                   	push   %ebx
  800634:	51                   	push   %ecx
  800635:	52                   	push   %edx
  800636:	50                   	push   %eax
  800637:	e8 6c 14 00 00       	call   801aa8 <__umoddi3>
  80063c:	83 c4 10             	add    $0x10,%esp
  80063f:	05 54 21 80 00       	add    $0x802154,%eax
  800644:	8a 00                	mov    (%eax),%al
  800646:	0f be c0             	movsbl %al,%eax
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	50                   	push   %eax
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	ff d0                	call   *%eax
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800661:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800665:	7e 1c                	jle    800683 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	8d 50 08             	lea    0x8(%eax),%edx
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	89 10                	mov    %edx,(%eax)
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	83 e8 08             	sub    $0x8,%eax
  80067c:	8b 50 04             	mov    0x4(%eax),%edx
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	eb 40                	jmp    8006c3 <getuint+0x65>
	else if (lflag)
  800683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800687:	74 1e                	je     8006a7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	8d 50 04             	lea    0x4(%eax),%edx
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	89 10                	mov    %edx,(%eax)
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	83 e8 04             	sub    $0x4,%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a5:	eb 1c                	jmp    8006c3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006c3:	5d                   	pop    %ebp
  8006c4:	c3                   	ret    

008006c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006c5:	55                   	push   %ebp
  8006c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cc:	7e 1c                	jle    8006ea <getint+0x25>
		return va_arg(*ap, long long);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 08             	lea    0x8(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 08             	sub    $0x8,%eax
  8006e3:	8b 50 04             	mov    0x4(%eax),%edx
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	eb 38                	jmp    800722 <getint+0x5d>
	else if (lflag)
  8006ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ee:	74 1a                	je     80070a <getint+0x45>
		return va_arg(*ap, long);
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	8d 50 04             	lea    0x4(%eax),%edx
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	89 10                	mov    %edx,(%eax)
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	83 e8 04             	sub    $0x4,%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	99                   	cltd   
  800708:	eb 18                	jmp    800722 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	8d 50 04             	lea    0x4(%eax),%edx
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	89 10                	mov    %edx,(%eax)
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	83 e8 04             	sub    $0x4,%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	99                   	cltd   
}
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    

00800724 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	56                   	push   %esi
  800728:	53                   	push   %ebx
  800729:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072c:	eb 17                	jmp    800745 <vprintfmt+0x21>
			if (ch == '\0')
  80072e:	85 db                	test   %ebx,%ebx
  800730:	0f 84 c1 03 00 00    	je     800af7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	53                   	push   %ebx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800745:	8b 45 10             	mov    0x10(%ebp),%eax
  800748:	8d 50 01             	lea    0x1(%eax),%edx
  80074b:	89 55 10             	mov    %edx,0x10(%ebp)
  80074e:	8a 00                	mov    (%eax),%al
  800750:	0f b6 d8             	movzbl %al,%ebx
  800753:	83 fb 25             	cmp    $0x25,%ebx
  800756:	75 d6                	jne    80072e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800758:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80075c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800763:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80076a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800771:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	8d 50 01             	lea    0x1(%eax),%edx
  80077e:	89 55 10             	mov    %edx,0x10(%ebp)
  800781:	8a 00                	mov    (%eax),%al
  800783:	0f b6 d8             	movzbl %al,%ebx
  800786:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800789:	83 f8 5b             	cmp    $0x5b,%eax
  80078c:	0f 87 3d 03 00 00    	ja     800acf <vprintfmt+0x3ab>
  800792:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  800799:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80079b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d7                	jmp    800778 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007a5:	eb d1                	jmp    800778 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007b1:	89 d0                	mov    %edx,%eax
  8007b3:	c1 e0 02             	shl    $0x2,%eax
  8007b6:	01 d0                	add    %edx,%eax
  8007b8:	01 c0                	add    %eax,%eax
  8007ba:	01 d8                	add    %ebx,%eax
  8007bc:	83 e8 30             	sub    $0x30,%eax
  8007bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c5:	8a 00                	mov    (%eax),%al
  8007c7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ca:	83 fb 2f             	cmp    $0x2f,%ebx
  8007cd:	7e 3e                	jle    80080d <vprintfmt+0xe9>
  8007cf:	83 fb 39             	cmp    $0x39,%ebx
  8007d2:	7f 39                	jg     80080d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d7:	eb d5                	jmp    8007ae <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	83 c0 04             	add    $0x4,%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	83 e8 04             	sub    $0x4,%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ed:	eb 1f                	jmp    80080e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	79 83                	jns    800778 <vprintfmt+0x54>
				width = 0;
  8007f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007fc:	e9 77 ff ff ff       	jmp    800778 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800801:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800808:	e9 6b ff ff ff       	jmp    800778 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80080d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	0f 89 60 ff ff ff    	jns    800778 <vprintfmt+0x54>
				width = precision, precision = -1;
  800818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80081b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80081e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800825:	e9 4e ff ff ff       	jmp    800778 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80082a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80082d:	e9 46 ff ff ff       	jmp    800778 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	50                   	push   %eax
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
			break;
  800852:	e9 9b 02 00 00       	jmp    800af2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 c0 04             	add    $0x4,%eax
  80085d:	89 45 14             	mov    %eax,0x14(%ebp)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 e8 04             	sub    $0x4,%eax
  800866:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800868:	85 db                	test   %ebx,%ebx
  80086a:	79 02                	jns    80086e <vprintfmt+0x14a>
				err = -err;
  80086c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80086e:	83 fb 64             	cmp    $0x64,%ebx
  800871:	7f 0b                	jg     80087e <vprintfmt+0x15a>
  800873:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  80087a:	85 f6                	test   %esi,%esi
  80087c:	75 19                	jne    800897 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80087e:	53                   	push   %ebx
  80087f:	68 65 21 80 00       	push   $0x802165
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 70 02 00 00       	call   800aff <printfmt>
  80088f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800892:	e9 5b 02 00 00       	jmp    800af2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800897:	56                   	push   %esi
  800898:	68 6e 21 80 00       	push   $0x80216e
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	ff 75 08             	pushl  0x8(%ebp)
  8008a3:	e8 57 02 00 00       	call   800aff <printfmt>
  8008a8:	83 c4 10             	add    $0x10,%esp
			break;
  8008ab:	e9 42 02 00 00       	jmp    800af2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	83 c0 04             	add    $0x4,%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 30                	mov    (%eax),%esi
  8008c1:	85 f6                	test   %esi,%esi
  8008c3:	75 05                	jne    8008ca <vprintfmt+0x1a6>
				p = "(null)";
  8008c5:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  8008ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ce:	7e 6d                	jle    80093d <vprintfmt+0x219>
  8008d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008d4:	74 67                	je     80093d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	50                   	push   %eax
  8008dd:	56                   	push   %esi
  8008de:	e8 1e 03 00 00       	call   800c01 <strnlen>
  8008e3:	83 c4 10             	add    $0x10,%esp
  8008e6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e9:	eb 16                	jmp    800901 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008eb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800905:	7f e4                	jg     8008eb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800907:	eb 34                	jmp    80093d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800909:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80090d:	74 1c                	je     80092b <vprintfmt+0x207>
  80090f:	83 fb 1f             	cmp    $0x1f,%ebx
  800912:	7e 05                	jle    800919 <vprintfmt+0x1f5>
  800914:	83 fb 7e             	cmp    $0x7e,%ebx
  800917:	7e 12                	jle    80092b <vprintfmt+0x207>
					putch('?', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	6a 3f                	push   $0x3f
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	eb 0f                	jmp    80093a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	53                   	push   %ebx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093a:	ff 4d e4             	decl   -0x1c(%ebp)
  80093d:	89 f0                	mov    %esi,%eax
  80093f:	8d 70 01             	lea    0x1(%eax),%esi
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f be d8             	movsbl %al,%ebx
  800947:	85 db                	test   %ebx,%ebx
  800949:	74 24                	je     80096f <vprintfmt+0x24b>
  80094b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094f:	78 b8                	js     800909 <vprintfmt+0x1e5>
  800951:	ff 4d e0             	decl   -0x20(%ebp)
  800954:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800958:	79 af                	jns    800909 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095a:	eb 13                	jmp    80096f <vprintfmt+0x24b>
				putch(' ', putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	6a 20                	push   $0x20
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096c:	ff 4d e4             	decl   -0x1c(%ebp)
  80096f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800973:	7f e7                	jg     80095c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800975:	e9 78 01 00 00       	jmp    800af2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 e8             	pushl  -0x18(%ebp)
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
  800983:	50                   	push   %eax
  800984:	e8 3c fd ff ff       	call   8006c5 <getint>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800998:	85 d2                	test   %edx,%edx
  80099a:	79 23                	jns    8009bf <vprintfmt+0x29b>
				putch('-', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	6a 2d                	push   $0x2d
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b2:	f7 d8                	neg    %eax
  8009b4:	83 d2 00             	adc    $0x0,%edx
  8009b7:	f7 da                	neg    %edx
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c6:	e9 bc 00 00 00       	jmp    800a87 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 84 fc ff ff       	call   80065e <getuint>
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ea:	e9 98 00 00 00       	jmp    800a87 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 58                	push   $0x58
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			break;
  800a1f:	e9 ce 00 00 00       	jmp    800af2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 30                	push   $0x30
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 78                	push   $0x78
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	83 c0 04             	add    $0x4,%eax
  800a4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	83 e8 04             	sub    $0x4,%eax
  800a53:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a66:	eb 1f                	jmp    800a87 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	e8 e7 fb ff ff       	call   80065e <getuint>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a87:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	52                   	push   %edx
  800a92:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a95:	50                   	push   %eax
  800a96:	ff 75 f4             	pushl  -0xc(%ebp)
  800a99:	ff 75 f0             	pushl  -0x10(%ebp)
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	e8 00 fb ff ff       	call   8005a7 <printnum>
  800aa7:	83 c4 20             	add    $0x20,%esp
			break;
  800aaa:	eb 46                	jmp    800af2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	53                   	push   %ebx
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			break;
  800abb:	eb 35                	jmp    800af2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800abd:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ac4:	eb 2c                	jmp    800af2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ac6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800acd:	eb 23                	jmp    800af2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	6a 25                	push   $0x25
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800adf:	ff 4d 10             	decl   0x10(%ebp)
  800ae2:	eb 03                	jmp    800ae7 <vprintfmt+0x3c3>
  800ae4:	ff 4d 10             	decl   0x10(%ebp)
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	48                   	dec    %eax
  800aeb:	8a 00                	mov    (%eax),%al
  800aed:	3c 25                	cmp    $0x25,%al
  800aef:	75 f3                	jne    800ae4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800af1:	90                   	nop
		}
	}
  800af2:	e9 35 fc ff ff       	jmp    80072c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800afb:	5b                   	pop    %ebx
  800afc:	5e                   	pop    %esi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b05:	8d 45 10             	lea    0x10(%ebp),%eax
  800b08:	83 c0 04             	add    $0x4,%eax
  800b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 0c             	pushl  0xc(%ebp)
  800b18:	ff 75 08             	pushl  0x8(%ebp)
  800b1b:	e8 04 fc ff ff       	call   800724 <vprintfmt>
  800b20:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b23:	90                   	nop
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    

00800b26 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	8b 40 08             	mov    0x8(%eax),%eax
  800b2f:	8d 50 01             	lea    0x1(%eax),%edx
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 10                	mov    (%eax),%edx
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8b 40 04             	mov    0x4(%eax),%eax
  800b43:	39 c2                	cmp    %eax,%edx
  800b45:	73 12                	jae    800b59 <sprintputch+0x33>
		*b->buf++ = ch;
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b52:	89 0a                	mov    %ecx,(%edx)
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	88 10                	mov    %dl,(%eax)
}
  800b59:	90                   	nop
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	01 d0                	add    %edx,%eax
  800b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b81:	74 06                	je     800b89 <vsnprintf+0x2d>
  800b83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b87:	7f 07                	jg     800b90 <vsnprintf+0x34>
		return -E_INVAL;
  800b89:	b8 03 00 00 00       	mov    $0x3,%eax
  800b8e:	eb 20                	jmp    800bb0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b90:	ff 75 14             	pushl  0x14(%ebp)
  800b93:	ff 75 10             	pushl  0x10(%ebp)
  800b96:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b99:	50                   	push   %eax
  800b9a:	68 26 0b 80 00       	push   $0x800b26
  800b9f:	e8 80 fb ff ff       	call   800724 <vprintfmt>
  800ba4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800baa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bbb:	83 c0 04             	add    $0x4,%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc7:	50                   	push   %eax
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	ff 75 08             	pushl  0x8(%ebp)
  800bce:	e8 89 ff ff ff       	call   800b5c <vsnprintf>
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800be4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800beb:	eb 06                	jmp    800bf3 <strlen+0x15>
		n++;
  800bed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf0:	ff 45 08             	incl   0x8(%ebp)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	75 f1                	jne    800bed <strlen+0xf>
		n++;
	return n;
  800bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bff:	c9                   	leave  
  800c00:	c3                   	ret    

00800c01 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0e:	eb 09                	jmp    800c19 <strnlen+0x18>
		n++;
  800c10:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c13:	ff 45 08             	incl   0x8(%ebp)
  800c16:	ff 4d 0c             	decl   0xc(%ebp)
  800c19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1d:	74 09                	je     800c28 <strnlen+0x27>
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	84 c0                	test   %al,%al
  800c26:	75 e8                	jne    800c10 <strnlen+0xf>
		n++;
	return n;
  800c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c39:	90                   	nop
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8d 50 01             	lea    0x1(%eax),%edx
  800c40:	89 55 08             	mov    %edx,0x8(%ebp)
  800c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c49:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c4c:	8a 12                	mov    (%edx),%dl
  800c4e:	88 10                	mov    %dl,(%eax)
  800c50:	8a 00                	mov    (%eax),%al
  800c52:	84 c0                	test   %al,%al
  800c54:	75 e4                	jne    800c3a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6e:	eb 1f                	jmp    800c8f <strncpy+0x34>
		*dst++ = *src;
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8d 50 01             	lea    0x1(%eax),%edx
  800c76:	89 55 08             	mov    %edx,0x8(%ebp)
  800c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7c:	8a 12                	mov    (%edx),%dl
  800c7e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	74 03                	je     800c8c <strncpy+0x31>
			src++;
  800c89:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c8c:	ff 45 fc             	incl   -0x4(%ebp)
  800c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c92:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c95:	72 d9                	jb     800c70 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cac:	74 30                	je     800cde <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cae:	eb 16                	jmp    800cc6 <strlcpy+0x2a>
			*dst++ = *src++;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8d 50 01             	lea    0x1(%eax),%edx
  800cb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc2:	8a 12                	mov    (%edx),%dl
  800cc4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cc6:	ff 4d 10             	decl   0x10(%ebp)
  800cc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccd:	74 09                	je     800cd8 <strlcpy+0x3c>
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	75 d8                	jne    800cb0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce4:	29 c2                	sub    %eax,%edx
  800ce6:	89 d0                	mov    %edx,%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ced:	eb 06                	jmp    800cf5 <strcmp+0xb>
		p++, q++;
  800cef:	ff 45 08             	incl   0x8(%ebp)
  800cf2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	74 0e                	je     800d0c <strcmp+0x22>
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 10                	mov    (%eax),%dl
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	38 c2                	cmp    %al,%dl
  800d0a:	74 e3                	je     800cef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f b6 d0             	movzbl %al,%edx
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f b6 c0             	movzbl %al,%eax
  800d1c:	29 c2                	sub    %eax,%edx
  800d1e:	89 d0                	mov    %edx,%eax
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d25:	eb 09                	jmp    800d30 <strncmp+0xe>
		n--, p++, q++;
  800d27:	ff 4d 10             	decl   0x10(%ebp)
  800d2a:	ff 45 08             	incl   0x8(%ebp)
  800d2d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d34:	74 17                	je     800d4d <strncmp+0x2b>
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strncmp+0x2b>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 da                	je     800d27 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d51:	75 07                	jne    800d5a <strncmp+0x38>
		return 0;
  800d53:	b8 00 00 00 00       	mov    $0x0,%eax
  800d58:	eb 14                	jmp    800d6e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	0f b6 d0             	movzbl %al,%edx
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f b6 c0             	movzbl %al,%eax
  800d6a:	29 c2                	sub    %eax,%edx
  800d6c:	89 d0                	mov    %edx,%eax
}
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 04             	sub    $0x4,%esp
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7c:	eb 12                	jmp    800d90 <strchr+0x20>
		if (*s == c)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d86:	75 05                	jne    800d8d <strchr+0x1d>
			return (char *) s;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	eb 11                	jmp    800d9e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d8d:	ff 45 08             	incl   0x8(%ebp)
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	84 c0                	test   %al,%al
  800d97:	75 e5                	jne    800d7e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 04             	sub    $0x4,%esp
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dac:	eb 0d                	jmp    800dbb <strfind+0x1b>
		if (*s == c)
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db6:	74 0e                	je     800dc6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	75 ea                	jne    800dae <strfind+0xe>
  800dc4:	eb 01                	jmp    800dc7 <strfind+0x27>
		if (*s == c)
			break;
  800dc6:	90                   	nop
	return (char *) s;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dd8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ddc:	76 63                	jbe    800e41 <memset+0x75>
		uint64 data_block = c;
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	99                   	cltd   
  800de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de5:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800deb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dee:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800df2:	c1 e0 08             	shl    $0x8,%eax
  800df5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e01:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e05:	c1 e0 10             	shl    $0x10,%eax
  800e08:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e0b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e14:	89 c2                	mov    %eax,%edx
  800e16:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e1e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e21:	eb 18                	jmp    800e3b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e23:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e26:	8d 41 08             	lea    0x8(%ecx),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e32:	89 01                	mov    %eax,(%ecx)
  800e34:	89 51 04             	mov    %edx,0x4(%ecx)
  800e37:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e3b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e3f:	77 e2                	ja     800e23 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e45:	74 23                	je     800e6a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e4d:	eb 0e                	jmp    800e5d <memset+0x91>
			*p8++ = (uint8)c;
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e63:	89 55 10             	mov    %edx,0x10(%ebp)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	75 e5                	jne    800e4f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e81:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e85:	76 24                	jbe    800eab <memcpy+0x3c>
		while(n >= 8){
  800e87:	eb 1c                	jmp    800ea5 <memcpy+0x36>
			*d64 = *s64;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8b 50 04             	mov    0x4(%eax),%edx
  800e8f:	8b 00                	mov    (%eax),%eax
  800e91:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e94:	89 01                	mov    %eax,(%ecx)
  800e96:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e99:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e9d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ea1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ea5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea9:	77 de                	ja     800e89 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaf:	74 31                	je     800ee2 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ebd:	eb 16                	jmp    800ed5 <memcpy+0x66>
			*d8++ = *s8++;
  800ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec2:	8d 50 01             	lea    0x1(%eax),%edx
  800ec5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ece:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ed1:	8a 12                	mov    (%edx),%dl
  800ed3:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	75 dd                	jne    800ebf <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eff:	73 50                	jae    800f51 <memmove+0x6a>
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8b 45 10             	mov    0x10(%ebp),%eax
  800f07:	01 d0                	add    %edx,%eax
  800f09:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f0c:	76 43                	jbe    800f51 <memmove+0x6a>
		s += n;
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f1a:	eb 10                	jmp    800f2c <memmove+0x45>
			*--d = *--s;
  800f1c:	ff 4d f8             	decl   -0x8(%ebp)
  800f1f:	ff 4d fc             	decl   -0x4(%ebp)
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	8a 10                	mov    (%eax),%dl
  800f27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f32:	89 55 10             	mov    %edx,0x10(%ebp)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	75 e3                	jne    800f1c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f39:	eb 23                	jmp    800f5e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f4d:	8a 12                	mov    (%edx),%dl
  800f4f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f51:	8b 45 10             	mov    0x10(%ebp),%eax
  800f54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f57:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	75 dd                	jne    800f3b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f75:	eb 2a                	jmp    800fa1 <memcmp+0x3e>
		if (*s1 != *s2)
  800f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7a:	8a 10                	mov    (%eax),%dl
  800f7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	38 c2                	cmp    %al,%dl
  800f83:	74 16                	je     800f9b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	0f b6 d0             	movzbl %al,%edx
  800f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 c0             	movzbl %al,%eax
  800f95:	29 c2                	sub    %eax,%edx
  800f97:	89 d0                	mov    %edx,%eax
  800f99:	eb 18                	jmp    800fb3 <memcmp+0x50>
		s1++, s2++;
  800f9b:	ff 45 fc             	incl   -0x4(%ebp)
  800f9e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	89 55 10             	mov    %edx,0x10(%ebp)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	75 c9                	jne    800f77 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	01 d0                	add    %edx,%eax
  800fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fc6:	eb 15                	jmp    800fdd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f b6 d0             	movzbl %al,%edx
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	0f b6 c0             	movzbl %al,%eax
  800fd6:	39 c2                	cmp    %eax,%edx
  800fd8:	74 0d                	je     800fe7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fe3:	72 e3                	jb     800fc8 <memfind+0x13>
  800fe5:	eb 01                	jmp    800fe8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fe7:	90                   	nop
	return (void *) s;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ff3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ffa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801001:	eb 03                	jmp    801006 <strtol+0x19>
		s++;
  801003:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	3c 20                	cmp    $0x20,%al
  80100d:	74 f4                	je     801003 <strtol+0x16>
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3c 09                	cmp    $0x9,%al
  801016:	74 eb                	je     801003 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	3c 2b                	cmp    $0x2b,%al
  80101f:	75 05                	jne    801026 <strtol+0x39>
		s++;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	eb 13                	jmp    801039 <strtol+0x4c>
	else if (*s == '-')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 2d                	cmp    $0x2d,%al
  80102d:	75 0a                	jne    801039 <strtol+0x4c>
		s++, neg = 1;
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801039:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103d:	74 06                	je     801045 <strtol+0x58>
  80103f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801043:	75 20                	jne    801065 <strtol+0x78>
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	3c 30                	cmp    $0x30,%al
  80104c:	75 17                	jne    801065 <strtol+0x78>
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	40                   	inc    %eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 78                	cmp    $0x78,%al
  801056:	75 0d                	jne    801065 <strtol+0x78>
		s += 2, base = 16;
  801058:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80105c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801063:	eb 28                	jmp    80108d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801065:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801069:	75 15                	jne    801080 <strtol+0x93>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 30                	cmp    $0x30,%al
  801072:	75 0c                	jne    801080 <strtol+0x93>
		s++, base = 8;
  801074:	ff 45 08             	incl   0x8(%ebp)
  801077:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80107e:	eb 0d                	jmp    80108d <strtol+0xa0>
	else if (base == 0)
  801080:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801084:	75 07                	jne    80108d <strtol+0xa0>
		base = 10;
  801086:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 2f                	cmp    $0x2f,%al
  801094:	7e 19                	jle    8010af <strtol+0xc2>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 39                	cmp    $0x39,%al
  80109d:	7f 10                	jg     8010af <strtol+0xc2>
			dig = *s - '0';
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 30             	sub    $0x30,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 42                	jmp    8010f1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 60                	cmp    $0x60,%al
  8010b6:	7e 19                	jle    8010d1 <strtol+0xe4>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 7a                	cmp    $0x7a,%al
  8010bf:	7f 10                	jg     8010d1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 57             	sub    $0x57,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cf:	eb 20                	jmp    8010f1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	3c 40                	cmp    $0x40,%al
  8010d8:	7e 39                	jle    801113 <strtol+0x126>
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 5a                	cmp    $0x5a,%al
  8010e1:	7f 30                	jg     801113 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	0f be c0             	movsbl %al,%eax
  8010eb:	83 e8 37             	sub    $0x37,%eax
  8010ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f7:	7d 19                	jge    801112 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010f9:	ff 45 08             	incl   0x8(%ebp)
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	0f af 45 10          	imul   0x10(%ebp),%eax
  801103:	89 c2                	mov    %eax,%edx
  801105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80110d:	e9 7b ff ff ff       	jmp    80108d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801112:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801113:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801117:	74 08                	je     801121 <strtol+0x134>
		*endptr = (char *) s;
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	8b 55 08             	mov    0x8(%ebp),%edx
  80111f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801121:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801125:	74 07                	je     80112e <strtol+0x141>
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	f7 d8                	neg    %eax
  80112c:	eb 03                	jmp    801131 <strtol+0x144>
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <ltostr>:

void
ltostr(long value, char *str)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801140:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80114b:	79 13                	jns    801160 <ltostr+0x2d>
	{
		neg = 1;
  80114d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80115a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80115d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801168:	99                   	cltd   
  801169:	f7 f9                	idiv   %ecx
  80116b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80116e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801171:	8d 50 01             	lea    0x1(%eax),%edx
  801174:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	01 d0                	add    %edx,%eax
  80117e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801181:	83 c2 30             	add    $0x30,%edx
  801184:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801186:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801189:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80118e:	f7 e9                	imul   %ecx
  801190:	c1 fa 02             	sar    $0x2,%edx
  801193:	89 c8                	mov    %ecx,%eax
  801195:	c1 f8 1f             	sar    $0x1f,%eax
  801198:	29 c2                	sub    %eax,%edx
  80119a:	89 d0                	mov    %edx,%eax
  80119c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80119f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a3:	75 bb                	jne    801160 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011af:	48                   	dec    %eax
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b7:	74 3d                	je     8011f6 <ltostr+0xc3>
		start = 1 ;
  8011b9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011c0:	eb 34                	jmp    8011f6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	01 c2                	add    %eax,%edx
  8011d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	01 c8                	add    %ecx,%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	01 c2                	add    %eax,%edx
  8011eb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011ee:	88 02                	mov    %al,(%edx)
		start++ ;
  8011f0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fc:	7c c4                	jl     8011c2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801209:	90                   	nop
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 c4 f9 ff ff       	call   800bde <strlen>
  80121a:	83 c4 04             	add    $0x4,%esp
  80121d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	e8 b6 f9 ff ff       	call   800bde <strlen>
  801228:	83 c4 04             	add    $0x4,%esp
  80122b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80123c:	eb 17                	jmp    801255 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801241:	8b 45 10             	mov    0x10(%ebp),%eax
  801244:	01 c2                	add    %eax,%edx
  801246:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	01 c8                	add    %ecx,%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801252:	ff 45 fc             	incl   -0x4(%ebp)
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80125b:	7c e1                	jl     80123e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801264:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80126b:	eb 1f                	jmp    80128c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801270:	8d 50 01             	lea    0x1(%eax),%edx
  801273:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801276:	89 c2                	mov    %eax,%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 c2                	add    %eax,%edx
  80127d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	01 c8                	add    %ecx,%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801289:	ff 45 f8             	incl   -0x8(%ebp)
  80128c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801292:	7c d9                	jl     80126d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801294:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c6 00 00             	movb   $0x0,(%eax)
}
  80129f:	90                   	nop
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	01 d0                	add    %edx,%eax
  8012bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c5:	eb 0c                	jmp    8012d3 <strsplit+0x31>
			*string++ = 0;
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8d 50 01             	lea    0x1(%eax),%edx
  8012cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8012d0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	84 c0                	test   %al,%al
  8012da:	74 18                	je     8012f4 <strsplit+0x52>
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	e8 83 fa ff ff       	call   800d70 <strchr>
  8012ed:	83 c4 08             	add    $0x8,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	75 d3                	jne    8012c7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	84 c0                	test   %al,%al
  8012fb:	74 5a                	je     801357 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	8b 00                	mov    (%eax),%eax
  801302:	83 f8 0f             	cmp    $0xf,%eax
  801305:	75 07                	jne    80130e <strsplit+0x6c>
		{
			return 0;
  801307:	b8 00 00 00 00       	mov    $0x0,%eax
  80130c:	eb 66                	jmp    801374 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130e:	8b 45 14             	mov    0x14(%ebp),%eax
  801311:	8b 00                	mov    (%eax),%eax
  801313:	8d 48 01             	lea    0x1(%eax),%ecx
  801316:	8b 55 14             	mov    0x14(%ebp),%edx
  801319:	89 0a                	mov    %ecx,(%edx)
  80131b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 c2                	add    %eax,%edx
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132c:	eb 03                	jmp    801331 <strsplit+0x8f>
			string++;
  80132e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	84 c0                	test   %al,%al
  801338:	74 8b                	je     8012c5 <strsplit+0x23>
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	0f be c0             	movsbl %al,%eax
  801342:	50                   	push   %eax
  801343:	ff 75 0c             	pushl  0xc(%ebp)
  801346:	e8 25 fa ff ff       	call   800d70 <strchr>
  80134b:	83 c4 08             	add    $0x8,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	74 dc                	je     80132e <strsplit+0x8c>
			string++;
	}
  801352:	e9 6e ff ff ff       	jmp    8012c5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801357:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801358:	8b 45 14             	mov    0x14(%ebp),%eax
  80135b:	8b 00                	mov    (%eax),%eax
  80135d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801364:	8b 45 10             	mov    0x10(%ebp),%eax
  801367:	01 d0                	add    %edx,%eax
  801369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801389:	eb 4a                	jmp    8013d5 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80138b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	01 c2                	add    %eax,%edx
  801393:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	01 c8                	add    %ecx,%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a5:	01 d0                	add    %edx,%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	3c 40                	cmp    $0x40,%al
  8013ab:	7e 25                	jle    8013d2 <str2lower+0x5c>
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	3c 5a                	cmp    $0x5a,%al
  8013b9:	7f 17                	jg     8013d2 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	01 d0                	add    %edx,%eax
  8013c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c9:	01 ca                	add    %ecx,%edx
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	83 c2 20             	add    $0x20,%edx
  8013d0:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013d2:	ff 45 fc             	incl   -0x4(%ebp)
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	e8 01 f8 ff ff       	call   800bde <strlen>
  8013dd:	83 c4 04             	add    $0x4,%esp
  8013e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e3:	7f a6                	jg     80138b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	57                   	push   %edi
  8013ee:	56                   	push   %esi
  8013ef:	53                   	push   %ebx
  8013f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801402:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801405:	cd 30                	int    $0x30
  801407:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80140a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	5b                   	pop    %ebx
  801411:	5e                   	pop    %esi
  801412:	5f                   	pop    %edi
  801413:	5d                   	pop    %ebp
  801414:	c3                   	ret    

00801415 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801421:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801424:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	6a 00                	push   $0x0
  80142d:	51                   	push   %ecx
  80142e:	52                   	push   %edx
  80142f:	ff 75 0c             	pushl  0xc(%ebp)
  801432:	50                   	push   %eax
  801433:	6a 00                	push   $0x0
  801435:	e8 b0 ff ff ff       	call   8013ea <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_cgetc>:

int
sys_cgetc(void)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 02                	push   $0x2
  80144f:	e8 96 ff ff ff       	call   8013ea <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 03                	push   $0x3
  801468:	e8 7d ff ff ff       	call   8013ea <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	90                   	nop
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 04                	push   $0x4
  801482:	e8 63 ff ff ff       	call   8013ea <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	52                   	push   %edx
  80149d:	50                   	push   %eax
  80149e:	6a 08                	push   $0x8
  8014a0:	e8 45 ff ff ff       	call   8013ea <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	56                   	push   %esi
  8014ae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014af:	8b 75 18             	mov    0x18(%ebp),%esi
  8014b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	56                   	push   %esi
  8014bf:	53                   	push   %ebx
  8014c0:	51                   	push   %ecx
  8014c1:	52                   	push   %edx
  8014c2:	50                   	push   %eax
  8014c3:	6a 09                	push   $0x9
  8014c5:	e8 20 ff ff ff       	call   8013ea <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d0:	5b                   	pop    %ebx
  8014d1:	5e                   	pop    %esi
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	6a 0a                	push   $0xa
  8014e4:	e8 01 ff ff ff       	call   8013ea <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	ff 75 08             	pushl  0x8(%ebp)
  8014fd:	6a 0b                	push   $0xb
  8014ff:	e8 e6 fe ff ff       	call   8013ea <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 0c                	push   $0xc
  801518:	e8 cd fe ff ff       	call   8013ea <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 0d                	push   $0xd
  801531:	e8 b4 fe ff ff       	call   8013ea <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 0e                	push   $0xe
  80154a:	e8 9b fe ff ff       	call   8013ea <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 0f                	push   $0xf
  801563:	e8 82 fe ff ff       	call   8013ea <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	6a 10                	push   $0x10
  80157d:	e8 68 fe ff ff       	call   8013ea <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 11                	push   $0x11
  801596:	e8 4f fe ff ff       	call   8013ea <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	90                   	nop
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	50                   	push   %eax
  8015ba:	6a 01                	push   $0x1
  8015bc:	e8 29 fe ff ff       	call   8013ea <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 14                	push   $0x14
  8015d6:	e8 0f fe ff ff       	call   8013ea <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	90                   	nop
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015ed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	51                   	push   %ecx
  8015fa:	52                   	push   %edx
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	50                   	push   %eax
  8015ff:	6a 15                	push   $0x15
  801601:	e8 e4 fd ff ff       	call   8013ea <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	6a 16                	push   $0x16
  80161e:	e8 c7 fd ff ff       	call   8013ea <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80162b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80162e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	51                   	push   %ecx
  801639:	52                   	push   %edx
  80163a:	50                   	push   %eax
  80163b:	6a 17                	push   $0x17
  80163d:	e8 a8 fd ff ff       	call   8013ea <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	6a 18                	push   $0x18
  80165a:	e8 8b fd ff ff       	call   8013ea <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	ff 75 14             	pushl  0x14(%ebp)
  80166f:	ff 75 10             	pushl  0x10(%ebp)
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	50                   	push   %eax
  801676:	6a 19                	push   $0x19
  801678:	e8 6d fd ff ff       	call   8013ea <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	50                   	push   %eax
  801691:	6a 1a                	push   $0x1a
  801693:	e8 52 fd ff ff       	call   8013ea <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	50                   	push   %eax
  8016ad:	6a 1b                	push   $0x1b
  8016af:	e8 36 fd ff ff       	call   8013ea <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 05                	push   $0x5
  8016c8:	e8 1d fd ff ff       	call   8013ea <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 06                	push   $0x6
  8016e1:	e8 04 fd ff ff       	call   8013ea <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 07                	push   $0x7
  8016fa:	e8 eb fc ff ff       	call   8013ea <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_exit_env>:


void sys_exit_env(void)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 1c                	push   $0x1c
  801713:	e8 d2 fc ff ff       	call   8013ea <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	90                   	nop
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801724:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801727:	8d 50 04             	lea    0x4(%eax),%edx
  80172a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 1d                	push   $0x1d
  801737:	e8 ae fc ff ff       	call   8013ea <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
	return result;
  80173f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801742:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801745:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801748:	89 01                	mov    %eax,(%ecx)
  80174a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	c9                   	leave  
  801751:	c2 04 00             	ret    $0x4

00801754 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	ff 75 10             	pushl  0x10(%ebp)
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	ff 75 08             	pushl  0x8(%ebp)
  801764:	6a 13                	push   $0x13
  801766:	e8 7f fc ff ff       	call   8013ea <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
	return ;
  80176e:	90                   	nop
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_rcr2>:
uint32 sys_rcr2()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 1e                	push   $0x1e
  801780:	e8 65 fc ff ff       	call   8013ea <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801796:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	50                   	push   %eax
  8017a3:	6a 1f                	push   $0x1f
  8017a5:	e8 40 fc ff ff       	call   8013ea <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ad:	90                   	nop
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <rsttst>:
void rsttst()
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 21                	push   $0x21
  8017bf:	e8 26 fc ff ff       	call   8013ea <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c7:	90                   	nop
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017d6:	8b 55 18             	mov    0x18(%ebp),%edx
  8017d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017dd:	52                   	push   %edx
  8017de:	50                   	push   %eax
  8017df:	ff 75 10             	pushl  0x10(%ebp)
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	6a 20                	push   $0x20
  8017ea:	e8 fb fb ff ff       	call   8013ea <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <chktst>:
void chktst(uint32 n)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	6a 22                	push   $0x22
  801805:	e8 e0 fb ff ff       	call   8013ea <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
	return ;
  80180d:	90                   	nop
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <inctst>:

void inctst()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 23                	push   $0x23
  80181f:	e8 c6 fb ff ff       	call   8013ea <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return ;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <gettst>:
uint32 gettst()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 24                	push   $0x24
  801839:	e8 ac fb ff ff       	call   8013ea <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 25                	push   $0x25
  801852:	e8 93 fb ff ff       	call   8013ea <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
  80185a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80185f:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	6a 26                	push   $0x26
  80187e:	e8 67 fb ff ff       	call   8013ea <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
	return ;
  801886:	90                   	nop
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80188d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801890:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	53                   	push   %ebx
  80189c:	51                   	push   %ecx
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 27                	push   $0x27
  8018a1:	e8 44 fb ff ff       	call   8013ea <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 28                	push   $0x28
  8018c1:	e8 24 fb ff ff       	call   8013ea <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	51                   	push   %ecx
  8018da:	ff 75 10             	pushl  0x10(%ebp)
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 29                	push   $0x29
  8018e1:	e8 04 fb ff ff       	call   8013ea <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 10             	pushl  0x10(%ebp)
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	6a 12                	push   $0x12
  8018fd:	e8 e8 fa ff ff       	call   8013ea <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
	return ;
  801905:	90                   	nop
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 2a                	push   $0x2a
  80191b:	e8 ca fa ff ff       	call   8013ea <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
	return;
  801923:	90                   	nop
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 2b                	push   $0x2b
  801935:	e8 b0 fa ff ff       	call   8013ea <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 2d                	push   $0x2d
  801950:	e8 95 fa ff ff       	call   8013ea <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	6a 2c                	push   $0x2c
  80196c:	e8 79 fa ff ff       	call   8013ea <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
	return ;
  801974:	90                   	nop
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 2e                	push   $0x2e
  80198a:	e8 5b fa ff ff       	call   8013ea <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
	return ;
  801992:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    
  801995:	66 90                	xchg   %ax,%ax
  801997:	90                   	nop

00801998 <__udivdi3>:
  801998:	55                   	push   %ebp
  801999:	57                   	push   %edi
  80199a:	56                   	push   %esi
  80199b:	53                   	push   %ebx
  80199c:	83 ec 1c             	sub    $0x1c,%esp
  80199f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019af:	89 ca                	mov    %ecx,%edx
  8019b1:	89 f8                	mov    %edi,%eax
  8019b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019b7:	85 f6                	test   %esi,%esi
  8019b9:	75 2d                	jne    8019e8 <__udivdi3+0x50>
  8019bb:	39 cf                	cmp    %ecx,%edi
  8019bd:	77 65                	ja     801a24 <__udivdi3+0x8c>
  8019bf:	89 fd                	mov    %edi,%ebp
  8019c1:	85 ff                	test   %edi,%edi
  8019c3:	75 0b                	jne    8019d0 <__udivdi3+0x38>
  8019c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ca:	31 d2                	xor    %edx,%edx
  8019cc:	f7 f7                	div    %edi
  8019ce:	89 c5                	mov    %eax,%ebp
  8019d0:	31 d2                	xor    %edx,%edx
  8019d2:	89 c8                	mov    %ecx,%eax
  8019d4:	f7 f5                	div    %ebp
  8019d6:	89 c1                	mov    %eax,%ecx
  8019d8:	89 d8                	mov    %ebx,%eax
  8019da:	f7 f5                	div    %ebp
  8019dc:	89 cf                	mov    %ecx,%edi
  8019de:	89 fa                	mov    %edi,%edx
  8019e0:	83 c4 1c             	add    $0x1c,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5f                   	pop    %edi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    
  8019e8:	39 ce                	cmp    %ecx,%esi
  8019ea:	77 28                	ja     801a14 <__udivdi3+0x7c>
  8019ec:	0f bd fe             	bsr    %esi,%edi
  8019ef:	83 f7 1f             	xor    $0x1f,%edi
  8019f2:	75 40                	jne    801a34 <__udivdi3+0x9c>
  8019f4:	39 ce                	cmp    %ecx,%esi
  8019f6:	72 0a                	jb     801a02 <__udivdi3+0x6a>
  8019f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019fc:	0f 87 9e 00 00 00    	ja     801aa0 <__udivdi3+0x108>
  801a02:	b8 01 00 00 00       	mov    $0x1,%eax
  801a07:	89 fa                	mov    %edi,%edx
  801a09:	83 c4 1c             	add    $0x1c,%esp
  801a0c:	5b                   	pop    %ebx
  801a0d:	5e                   	pop    %esi
  801a0e:	5f                   	pop    %edi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    
  801a11:	8d 76 00             	lea    0x0(%esi),%esi
  801a14:	31 ff                	xor    %edi,%edi
  801a16:	31 c0                	xor    %eax,%eax
  801a18:	89 fa                	mov    %edi,%edx
  801a1a:	83 c4 1c             	add    $0x1c,%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5f                   	pop    %edi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    
  801a22:	66 90                	xchg   %ax,%ax
  801a24:	89 d8                	mov    %ebx,%eax
  801a26:	f7 f7                	div    %edi
  801a28:	31 ff                	xor    %edi,%edi
  801a2a:	89 fa                	mov    %edi,%edx
  801a2c:	83 c4 1c             	add    $0x1c,%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5f                   	pop    %edi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
  801a34:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a39:	89 eb                	mov    %ebp,%ebx
  801a3b:	29 fb                	sub    %edi,%ebx
  801a3d:	89 f9                	mov    %edi,%ecx
  801a3f:	d3 e6                	shl    %cl,%esi
  801a41:	89 c5                	mov    %eax,%ebp
  801a43:	88 d9                	mov    %bl,%cl
  801a45:	d3 ed                	shr    %cl,%ebp
  801a47:	89 e9                	mov    %ebp,%ecx
  801a49:	09 f1                	or     %esi,%ecx
  801a4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a4f:	89 f9                	mov    %edi,%ecx
  801a51:	d3 e0                	shl    %cl,%eax
  801a53:	89 c5                	mov    %eax,%ebp
  801a55:	89 d6                	mov    %edx,%esi
  801a57:	88 d9                	mov    %bl,%cl
  801a59:	d3 ee                	shr    %cl,%esi
  801a5b:	89 f9                	mov    %edi,%ecx
  801a5d:	d3 e2                	shl    %cl,%edx
  801a5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a63:	88 d9                	mov    %bl,%cl
  801a65:	d3 e8                	shr    %cl,%eax
  801a67:	09 c2                	or     %eax,%edx
  801a69:	89 d0                	mov    %edx,%eax
  801a6b:	89 f2                	mov    %esi,%edx
  801a6d:	f7 74 24 0c          	divl   0xc(%esp)
  801a71:	89 d6                	mov    %edx,%esi
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	f7 e5                	mul    %ebp
  801a77:	39 d6                	cmp    %edx,%esi
  801a79:	72 19                	jb     801a94 <__udivdi3+0xfc>
  801a7b:	74 0b                	je     801a88 <__udivdi3+0xf0>
  801a7d:	89 d8                	mov    %ebx,%eax
  801a7f:	31 ff                	xor    %edi,%edi
  801a81:	e9 58 ff ff ff       	jmp    8019de <__udivdi3+0x46>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a8c:	89 f9                	mov    %edi,%ecx
  801a8e:	d3 e2                	shl    %cl,%edx
  801a90:	39 c2                	cmp    %eax,%edx
  801a92:	73 e9                	jae    801a7d <__udivdi3+0xe5>
  801a94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a97:	31 ff                	xor    %edi,%edi
  801a99:	e9 40 ff ff ff       	jmp    8019de <__udivdi3+0x46>
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	31 c0                	xor    %eax,%eax
  801aa2:	e9 37 ff ff ff       	jmp    8019de <__udivdi3+0x46>
  801aa7:	90                   	nop

00801aa8 <__umoddi3>:
  801aa8:	55                   	push   %ebp
  801aa9:	57                   	push   %edi
  801aaa:	56                   	push   %esi
  801aab:	53                   	push   %ebx
  801aac:	83 ec 1c             	sub    $0x1c,%esp
  801aaf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ab3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ab7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801abb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801abf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ac7:	89 f3                	mov    %esi,%ebx
  801ac9:	89 fa                	mov    %edi,%edx
  801acb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801acf:	89 34 24             	mov    %esi,(%esp)
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	75 1a                	jne    801af0 <__umoddi3+0x48>
  801ad6:	39 f7                	cmp    %esi,%edi
  801ad8:	0f 86 a2 00 00 00    	jbe    801b80 <__umoddi3+0xd8>
  801ade:	89 c8                	mov    %ecx,%eax
  801ae0:	89 f2                	mov    %esi,%edx
  801ae2:	f7 f7                	div    %edi
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	31 d2                	xor    %edx,%edx
  801ae8:	83 c4 1c             	add    $0x1c,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5f                   	pop    %edi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    
  801af0:	39 f0                	cmp    %esi,%eax
  801af2:	0f 87 ac 00 00 00    	ja     801ba4 <__umoddi3+0xfc>
  801af8:	0f bd e8             	bsr    %eax,%ebp
  801afb:	83 f5 1f             	xor    $0x1f,%ebp
  801afe:	0f 84 ac 00 00 00    	je     801bb0 <__umoddi3+0x108>
  801b04:	bf 20 00 00 00       	mov    $0x20,%edi
  801b09:	29 ef                	sub    %ebp,%edi
  801b0b:	89 fe                	mov    %edi,%esi
  801b0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b11:	89 e9                	mov    %ebp,%ecx
  801b13:	d3 e0                	shl    %cl,%eax
  801b15:	89 d7                	mov    %edx,%edi
  801b17:	89 f1                	mov    %esi,%ecx
  801b19:	d3 ef                	shr    %cl,%edi
  801b1b:	09 c7                	or     %eax,%edi
  801b1d:	89 e9                	mov    %ebp,%ecx
  801b1f:	d3 e2                	shl    %cl,%edx
  801b21:	89 14 24             	mov    %edx,(%esp)
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	d3 e0                	shl    %cl,%eax
  801b28:	89 c2                	mov    %eax,%edx
  801b2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2e:	d3 e0                	shl    %cl,%eax
  801b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b34:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b38:	89 f1                	mov    %esi,%ecx
  801b3a:	d3 e8                	shr    %cl,%eax
  801b3c:	09 d0                	or     %edx,%eax
  801b3e:	d3 eb                	shr    %cl,%ebx
  801b40:	89 da                	mov    %ebx,%edx
  801b42:	f7 f7                	div    %edi
  801b44:	89 d3                	mov    %edx,%ebx
  801b46:	f7 24 24             	mull   (%esp)
  801b49:	89 c6                	mov    %eax,%esi
  801b4b:	89 d1                	mov    %edx,%ecx
  801b4d:	39 d3                	cmp    %edx,%ebx
  801b4f:	0f 82 87 00 00 00    	jb     801bdc <__umoddi3+0x134>
  801b55:	0f 84 91 00 00 00    	je     801bec <__umoddi3+0x144>
  801b5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b5f:	29 f2                	sub    %esi,%edx
  801b61:	19 cb                	sbb    %ecx,%ebx
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b69:	d3 e0                	shl    %cl,%eax
  801b6b:	89 e9                	mov    %ebp,%ecx
  801b6d:	d3 ea                	shr    %cl,%edx
  801b6f:	09 d0                	or     %edx,%eax
  801b71:	89 e9                	mov    %ebp,%ecx
  801b73:	d3 eb                	shr    %cl,%ebx
  801b75:	89 da                	mov    %ebx,%edx
  801b77:	83 c4 1c             	add    $0x1c,%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5f                   	pop    %edi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    
  801b7f:	90                   	nop
  801b80:	89 fd                	mov    %edi,%ebp
  801b82:	85 ff                	test   %edi,%edi
  801b84:	75 0b                	jne    801b91 <__umoddi3+0xe9>
  801b86:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8b:	31 d2                	xor    %edx,%edx
  801b8d:	f7 f7                	div    %edi
  801b8f:	89 c5                	mov    %eax,%ebp
  801b91:	89 f0                	mov    %esi,%eax
  801b93:	31 d2                	xor    %edx,%edx
  801b95:	f7 f5                	div    %ebp
  801b97:	89 c8                	mov    %ecx,%eax
  801b99:	f7 f5                	div    %ebp
  801b9b:	89 d0                	mov    %edx,%eax
  801b9d:	e9 44 ff ff ff       	jmp    801ae6 <__umoddi3+0x3e>
  801ba2:	66 90                	xchg   %ax,%ax
  801ba4:	89 c8                	mov    %ecx,%eax
  801ba6:	89 f2                	mov    %esi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	3b 04 24             	cmp    (%esp),%eax
  801bb3:	72 06                	jb     801bbb <__umoddi3+0x113>
  801bb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bb9:	77 0f                	ja     801bca <__umoddi3+0x122>
  801bbb:	89 f2                	mov    %esi,%edx
  801bbd:	29 f9                	sub    %edi,%ecx
  801bbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bc3:	89 14 24             	mov    %edx,(%esp)
  801bc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bca:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bce:	8b 14 24             	mov    (%esp),%edx
  801bd1:	83 c4 1c             	add    $0x1c,%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
  801bd9:	8d 76 00             	lea    0x0(%esi),%esi
  801bdc:	2b 04 24             	sub    (%esp),%eax
  801bdf:	19 fa                	sbb    %edi,%edx
  801be1:	89 d1                	mov    %edx,%ecx
  801be3:	89 c6                	mov    %eax,%esi
  801be5:	e9 71 ff ff ff       	jmp    801b5b <__umoddi3+0xb3>
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bf0:	72 ea                	jb     801bdc <__umoddi3+0x134>
  801bf2:	89 d9                	mov    %ebx,%ecx
  801bf4:	e9 62 ff ff ff       	jmp    801b5b <__umoddi3+0xb3>
