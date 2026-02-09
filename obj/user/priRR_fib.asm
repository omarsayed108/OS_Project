
obj/user/priRR_fib:     file format elf32-i386


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
  800031:	e8 aa 00 00 00       	call   8000e0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  800048:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 47 00 00 00       	call   8000a1 <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 80 1c 80 00       	push   $0x801c80
  80006e:	e8 7d 05 00 00       	call   8005f0 <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  800076:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  80007d:	74 1a                	je     800099 <_main+0x61>
		panic("[envID %d] wrong result!", myEnv->env_id);
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 40 10             	mov    0x10(%eax),%eax
  800087:	50                   	push   %eax
  800088:	68 94 1c 80 00       	push   $0x801c94
  80008d:	6a 13                	push   $0x13
  80008f:	68 ad 1c 80 00       	push   $0x801cad
  800094:	e8 f7 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800099:	e8 eb 17 00 00       	call   801889 <inctst>

	return;
  80009e:	90                   	nop
}
  80009f:	c9                   	leave  
  8000a0:	c3                   	ret    

008000a1 <fibonacci>:


int fibonacci(int n)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	53                   	push   %ebx
  8000a5:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <fibonacci+0x14>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 26                	jmp    8000db <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 df ff ff ff       	call   8000a1 <fibonacci>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ca:	83 e8 02             	sub    $0x2,%eax
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	e8 cb ff ff ff       	call   8000a1 <fibonacci>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	01 d8                	add    %ebx,%eax
}
  8000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e9:	e8 5d 16 00 00       	call   80174b <sys_getenvindex>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f4:	89 d0                	mov    %edx,%eax
  8000f6:	01 c0                	add    %eax,%eax
  8000f8:	01 d0                	add    %edx,%eax
  8000fa:	c1 e0 02             	shl    $0x2,%eax
  8000fd:	01 d0                	add    %edx,%eax
  8000ff:	c1 e0 02             	shl    $0x2,%eax
  800102:	01 d0                	add    %edx,%eax
  800104:	c1 e0 03             	shl    $0x3,%eax
  800107:	01 d0                	add    %edx,%eax
  800109:	c1 e0 02             	shl    $0x2,%eax
  80010c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800111:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8a 40 20             	mov    0x20(%eax),%al
  80011e:	84 c0                	test   %al,%al
  800120:	74 0d                	je     80012f <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800122:	a1 20 30 80 00       	mov    0x803020,%eax
  800127:	83 c0 20             	add    $0x20,%eax
  80012a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800133:	7e 0a                	jle    80013f <libmain+0x5f>
		binaryname = argv[0];
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	8b 00                	mov    (%eax),%eax
  80013a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	ff 75 0c             	pushl  0xc(%ebp)
  800145:	ff 75 08             	pushl  0x8(%ebp)
  800148:	e8 eb fe ff ff       	call   800038 <_main>
  80014d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800150:	a1 00 30 80 00       	mov    0x803000,%eax
  800155:	85 c0                	test   %eax,%eax
  800157:	0f 84 01 01 00 00    	je     80025e <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80015d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800163:	bb b8 1d 80 00       	mov    $0x801db8,%ebx
  800168:	ba 0e 00 00 00       	mov    $0xe,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800175:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800178:	b9 56 00 00 00       	mov    $0x56,%ecx
  80017d:	b0 00                	mov    $0x0,%al
  80017f:	89 d7                	mov    %edx,%edi
  800181:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800183:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80018a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	50                   	push   %eax
  800191:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	e8 e4 17 00 00       	call   801981 <sys_utilities>
  80019d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a0:	e8 2d 13 00 00       	call   8014d2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	68 d8 1c 80 00       	push   $0x801cd8
  8001ad:	e8 cc 03 00 00       	call   80057e <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	74 18                	je     8001d4 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001bc:	e8 de 17 00 00       	call   80199f <sys_get_optimal_num_faults>
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	50                   	push   %eax
  8001c5:	68 00 1d 80 00       	push   $0x801d00
  8001ca:	e8 af 03 00 00       	call   80057e <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	eb 59                	jmp    80022d <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d9:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	52                   	push   %edx
  8001ee:	50                   	push   %eax
  8001ef:	68 24 1d 80 00       	push   $0x801d24
  8001f4:	e8 85 03 00 00       	call   80057e <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800201:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800207:	a1 20 30 80 00       	mov    0x803020,%eax
  80020c:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80021d:	51                   	push   %ecx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 4c 1d 80 00       	push   $0x801d4c
  800225:	e8 54 03 00 00       	call   80057e <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	50                   	push   %eax
  80023c:	68 a4 1d 80 00       	push   $0x801da4
  800241:	e8 38 03 00 00       	call   80057e <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	68 d8 1c 80 00       	push   $0x801cd8
  800251:	e8 28 03 00 00       	call   80057e <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800259:	e8 8e 12 00 00       	call   8014ec <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80025e:	e8 1f 00 00 00       	call   800282 <exit>
}
  800263:	90                   	nop
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 9b 14 00 00       	call   801717 <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 f0 14 00 00       	call   80177d <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 1c 1e 80 00       	push   $0x801e1c
  8002b6:	e8 c3 02 00 00       	call   80057e <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	ff 75 0c             	pushl  0xc(%ebp)
  8002c9:	ff 75 08             	pushl  0x8(%ebp)
  8002cc:	50                   	push   %eax
  8002cd:	68 24 1e 80 00       	push   $0x801e24
  8002d2:	6a 74                	push   $0x74
  8002d4:	e8 d2 02 00 00       	call   8005ab <cprintf_colored>
  8002d9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e5:	50                   	push   %eax
  8002e6:	e8 24 02 00 00       	call   80050f <vcprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	6a 00                	push   $0x0
  8002f3:	68 4c 1e 80 00       	push   $0x801e4c
  8002f8:	e8 12 02 00 00       	call   80050f <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800300:	e8 7d ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800305:	eb fe                	jmp    800305 <_panic+0x75>

00800307 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	53                   	push   %ebx
  80030b:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	74 14                	je     800334 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 50 1e 80 00       	push   $0x801e50
  800328:	6a 26                	push   $0x26
  80032a:	68 9c 1e 80 00       	push   $0x801e9c
  80032f:	e8 5c ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80033b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800342:	e9 d9 00 00 00       	jmp    800420 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	01 d0                	add    %edx,%eax
  800356:	8b 00                	mov    (%eax),%eax
  800358:	85 c0                	test   %eax,%eax
  80035a:	75 08                	jne    800364 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80035c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80035f:	e9 b9 00 00 00       	jmp    80041d <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800364:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80036b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800372:	eb 79                	jmp    8003ed <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800374:	a1 20 30 80 00       	mov    0x803020,%eax
  800379:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80037f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800382:	89 d0                	mov    %edx,%eax
  800384:	01 c0                	add    %eax,%eax
  800386:	01 d0                	add    %edx,%eax
  800388:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80038f:	01 d8                	add    %ebx,%eax
  800391:	01 d0                	add    %edx,%eax
  800393:	01 c8                	add    %ecx,%eax
  800395:	8a 40 04             	mov    0x4(%eax),%al
  800398:	84 c0                	test   %al,%al
  80039a:	75 4e                	jne    8003ea <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039c:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a1:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003aa:	89 d0                	mov    %edx,%eax
  8003ac:	01 c0                	add    %eax,%eax
  8003ae:	01 d0                	add    %edx,%eax
  8003b0:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003b7:	01 d8                	add    %ebx,%eax
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	01 c8                	add    %ecx,%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	01 c8                	add    %ecx,%eax
  8003db:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003dd:	39 c2                	cmp    %eax,%edx
  8003df:	75 09                	jne    8003ea <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8003e1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e8:	eb 19                	jmp    800403 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ea:	ff 45 e8             	incl   -0x18(%ebp)
  8003ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	0f 87 71 ff ff ff    	ja     800374 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800403:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800407:	75 14                	jne    80041d <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	68 a8 1e 80 00       	push   $0x801ea8
  800411:	6a 3a                	push   $0x3a
  800413:	68 9c 1e 80 00       	push   $0x801e9c
  800418:	e8 73 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80041d:	ff 45 f0             	incl   -0x10(%ebp)
  800420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800423:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800426:	0f 8c 1b ff ff ff    	jl     800347 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80042c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800433:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80043a:	eb 2e                	jmp    80046a <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80043c:	a1 20 30 80 00       	mov    0x803020,%eax
  800441:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044a:	89 d0                	mov    %edx,%eax
  80044c:	01 c0                	add    %eax,%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800457:	01 d8                	add    %ebx,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	01 c8                	add    %ecx,%eax
  80045d:	8a 40 04             	mov    0x4(%eax),%al
  800460:	3c 01                	cmp    $0x1,%al
  800462:	75 03                	jne    800467 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800464:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e0             	incl   -0x20(%ebp)
  80046a:	a1 20 30 80 00       	mov    0x803020,%eax
  80046f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800478:	39 c2                	cmp    %eax,%edx
  80047a:	77 c0                	ja     80043c <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800482:	74 14                	je     800498 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 fc 1e 80 00       	push   $0x801efc
  80048c:	6a 44                	push   $0x44
  80048e:	68 9c 1e 80 00       	push   $0x801e9c
  800493:	e8 f8 fd ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800498:	90                   	nop
  800499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b0:	89 0a                	mov    %ecx,(%edx)
  8004b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b5:	88 d1                	mov    %dl,%cl
  8004b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ba:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c8:	75 30                	jne    8004fa <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004ca:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004d0:	a0 44 30 80 00       	mov    0x803044,%al
  8004d5:	0f b6 c0             	movzbl %al,%eax
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	8b 09                	mov    (%ecx),%ecx
  8004dd:	89 cb                	mov    %ecx,%ebx
  8004df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004e2:	83 c1 08             	add    $0x8,%ecx
  8004e5:	52                   	push   %edx
  8004e6:	50                   	push   %eax
  8004e7:	53                   	push   %ebx
  8004e8:	51                   	push   %ecx
  8004e9:	e8 a0 0f 00 00       	call   80148e <sys_cputs>
  8004ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	8b 40 04             	mov    0x4(%eax),%eax
  800500:	8d 50 01             	lea    0x1(%eax),%edx
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	89 50 04             	mov    %edx,0x4(%eax)
}
  800509:	90                   	nop
  80050a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800518:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80051f:	00 00 00 
	b.cnt = 0;
  800522:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800529:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80052c:	ff 75 0c             	pushl  0xc(%ebp)
  80052f:	ff 75 08             	pushl  0x8(%ebp)
  800532:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800538:	50                   	push   %eax
  800539:	68 9e 04 80 00       	push   $0x80049e
  80053e:	e8 5a 02 00 00       	call   80079d <vprintfmt>
  800543:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800546:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80054c:	a0 44 30 80 00       	mov    0x803044,%al
  800551:	0f b6 c0             	movzbl %al,%eax
  800554:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80055a:	52                   	push   %edx
  80055b:	50                   	push   %eax
  80055c:	51                   	push   %ecx
  80055d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800563:	83 c0 08             	add    $0x8,%eax
  800566:	50                   	push   %eax
  800567:	e8 22 0f 00 00       	call   80148e <sys_cputs>
  80056c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80056f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800576:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800584:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80058b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80058e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 6f ff ff ff       	call   80050f <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a9:	c9                   	leave  
  8005aa:	c3                   	ret    

008005ab <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	c1 e0 08             	shl    $0x8,%eax
  8005be:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c6:	83 c0 04             	add    $0x4,%eax
  8005c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	e8 34 ff ff ff       	call   80050f <vcprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005e1:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005e8:	07 00 00 

	return cnt;
  8005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    

008005f0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
  8005f3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005f6:	e8 d7 0e 00 00       	call   8014d2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	ff 75 f4             	pushl  -0xc(%ebp)
  80060a:	50                   	push   %eax
  80060b:	e8 ff fe ff ff       	call   80050f <vcprintf>
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800616:	e8 d1 0e 00 00       	call   8014ec <sys_unlock_cons>
	return cnt;
  80061b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061e:	c9                   	leave  
  80061f:	c3                   	ret    

00800620 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	53                   	push   %ebx
  800624:	83 ec 14             	sub    $0x14,%esp
  800627:	8b 45 10             	mov    0x10(%ebp),%eax
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800633:	8b 45 18             	mov    0x18(%ebp),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
  80063b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80063e:	77 55                	ja     800695 <printnum+0x75>
  800640:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800643:	72 05                	jb     80064a <printnum+0x2a>
  800645:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800648:	77 4b                	ja     800695 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80064d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800650:	8b 45 18             	mov    0x18(%ebp),%eax
  800653:	ba 00 00 00 00       	mov    $0x0,%edx
  800658:	52                   	push   %edx
  800659:	50                   	push   %eax
  80065a:	ff 75 f4             	pushl  -0xc(%ebp)
  80065d:	ff 75 f0             	pushl  -0x10(%ebp)
  800660:	e8 ab 13 00 00       	call   801a10 <__udivdi3>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	ff 75 20             	pushl  0x20(%ebp)
  80066e:	53                   	push   %ebx
  80066f:	ff 75 18             	pushl  0x18(%ebp)
  800672:	52                   	push   %edx
  800673:	50                   	push   %eax
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	ff 75 08             	pushl  0x8(%ebp)
  80067a:	e8 a1 ff ff ff       	call   800620 <printnum>
  80067f:	83 c4 20             	add    $0x20,%esp
  800682:	eb 1a                	jmp    80069e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	ff 75 20             	pushl  0x20(%ebp)
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	ff d0                	call   *%eax
  800692:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800695:	ff 4d 1c             	decl   0x1c(%ebp)
  800698:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80069c:	7f e6                	jg     800684 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ac:	53                   	push   %ebx
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	e8 6b 14 00 00       	call   801b20 <__umoddi3>
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	05 74 21 80 00       	add    $0x802174,%eax
  8006bd:	8a 00                	mov    (%eax),%al
  8006bf:	0f be c0             	movsbl %al,%eax
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	ff 75 0c             	pushl  0xc(%ebp)
  8006c8:	50                   	push   %eax
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	ff d0                	call   *%eax
  8006ce:	83 c4 10             	add    $0x10,%esp
}
  8006d1:	90                   	nop
  8006d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006de:	7e 1c                	jle    8006fc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	8d 50 08             	lea    0x8(%eax),%edx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	89 10                	mov    %edx,(%eax)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	83 e8 08             	sub    $0x8,%eax
  8006f5:	8b 50 04             	mov    0x4(%eax),%edx
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	eb 40                	jmp    80073c <getuint+0x65>
	else if (lflag)
  8006fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800700:	74 1e                	je     800720 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	8d 50 04             	lea    0x4(%eax),%edx
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	89 10                	mov    %edx,(%eax)
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	83 e8 04             	sub    $0x4,%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	eb 1c                	jmp    80073c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	8d 50 04             	lea    0x4(%eax),%edx
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	89 10                	mov    %edx,(%eax)
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	83 e8 04             	sub    $0x4,%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80073c:	5d                   	pop    %ebp
  80073d:	c3                   	ret    

0080073e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800741:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800745:	7e 1c                	jle    800763 <getint+0x25>
		return va_arg(*ap, long long);
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	8d 50 08             	lea    0x8(%eax),%edx
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	89 10                	mov    %edx,(%eax)
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	83 e8 08             	sub    $0x8,%eax
  80075c:	8b 50 04             	mov    0x4(%eax),%edx
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	eb 38                	jmp    80079b <getint+0x5d>
	else if (lflag)
  800763:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800767:	74 1a                	je     800783 <getint+0x45>
		return va_arg(*ap, long);
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	8d 50 04             	lea    0x4(%eax),%edx
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	89 10                	mov    %edx,(%eax)
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	83 e8 04             	sub    $0x4,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	99                   	cltd   
  800781:	eb 18                	jmp    80079b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	99                   	cltd   
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	56                   	push   %esi
  8007a1:	53                   	push   %ebx
  8007a2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a5:	eb 17                	jmp    8007be <vprintfmt+0x21>
			if (ch == '\0')
  8007a7:	85 db                	test   %ebx,%ebx
  8007a9:	0f 84 c1 03 00 00    	je     800b70 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	53                   	push   %ebx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007be:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c1:	8d 50 01             	lea    0x1(%eax),%edx
  8007c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c7:	8a 00                	mov    (%eax),%al
  8007c9:	0f b6 d8             	movzbl %al,%ebx
  8007cc:	83 fb 25             	cmp    $0x25,%ebx
  8007cf:	75 d6                	jne    8007a7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f4:	8d 50 01             	lea    0x1(%eax),%edx
  8007f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007fa:	8a 00                	mov    (%eax),%al
  8007fc:	0f b6 d8             	movzbl %al,%ebx
  8007ff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800802:	83 f8 5b             	cmp    $0x5b,%eax
  800805:	0f 87 3d 03 00 00    	ja     800b48 <vprintfmt+0x3ab>
  80080b:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800812:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800814:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800818:	eb d7                	jmp    8007f1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80081a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d1                	jmp    8007f1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800820:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800827:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80082a:	89 d0                	mov    %edx,%eax
  80082c:	c1 e0 02             	shl    $0x2,%eax
  80082f:	01 d0                	add    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d8                	add    %ebx,%eax
  800835:	83 e8 30             	sub    $0x30,%eax
  800838:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80083b:	8b 45 10             	mov    0x10(%ebp),%eax
  80083e:	8a 00                	mov    (%eax),%al
  800840:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800843:	83 fb 2f             	cmp    $0x2f,%ebx
  800846:	7e 3e                	jle    800886 <vprintfmt+0xe9>
  800848:	83 fb 39             	cmp    $0x39,%ebx
  80084b:	7f 39                	jg     800886 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800850:	eb d5                	jmp    800827 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800866:	eb 1f                	jmp    800887 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800868:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086c:	79 83                	jns    8007f1 <vprintfmt+0x54>
				width = 0;
  80086e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800875:	e9 77 ff ff ff       	jmp    8007f1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80087a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800881:	e9 6b ff ff ff       	jmp    8007f1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800886:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800887:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088b:	0f 89 60 ff ff ff    	jns    8007f1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800897:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80089e:	e9 4e ff ff ff       	jmp    8007f1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008a6:	e9 46 ff ff ff       	jmp    8007f1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	83 c0 04             	add    $0x4,%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	83 e8 04             	sub    $0x4,%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	50                   	push   %eax
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 9b 02 00 00       	jmp    800b6b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e1:	85 db                	test   %ebx,%ebx
  8008e3:	79 02                	jns    8008e7 <vprintfmt+0x14a>
				err = -err;
  8008e5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008e7:	83 fb 64             	cmp    $0x64,%ebx
  8008ea:	7f 0b                	jg     8008f7 <vprintfmt+0x15a>
  8008ec:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  8008f3:	85 f6                	test   %esi,%esi
  8008f5:	75 19                	jne    800910 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f7:	53                   	push   %ebx
  8008f8:	68 85 21 80 00       	push   $0x802185
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	ff 75 08             	pushl  0x8(%ebp)
  800903:	e8 70 02 00 00       	call   800b78 <printfmt>
  800908:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80090b:	e9 5b 02 00 00       	jmp    800b6b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800910:	56                   	push   %esi
  800911:	68 8e 21 80 00       	push   $0x80218e
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	ff 75 08             	pushl  0x8(%ebp)
  80091c:	e8 57 02 00 00       	call   800b78 <printfmt>
  800921:	83 c4 10             	add    $0x10,%esp
			break;
  800924:	e9 42 02 00 00       	jmp    800b6b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	83 c0 04             	add    $0x4,%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 30                	mov    (%eax),%esi
  80093a:	85 f6                	test   %esi,%esi
  80093c:	75 05                	jne    800943 <vprintfmt+0x1a6>
				p = "(null)";
  80093e:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800943:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800947:	7e 6d                	jle    8009b6 <vprintfmt+0x219>
  800949:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80094d:	74 67                	je     8009b6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	50                   	push   %eax
  800956:	56                   	push   %esi
  800957:	e8 1e 03 00 00       	call   800c7a <strnlen>
  80095c:	83 c4 10             	add    $0x10,%esp
  80095f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800962:	eb 16                	jmp    80097a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800964:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	50                   	push   %eax
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800977:	ff 4d e4             	decl   -0x1c(%ebp)
  80097a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097e:	7f e4                	jg     800964 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800980:	eb 34                	jmp    8009b6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800982:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800986:	74 1c                	je     8009a4 <vprintfmt+0x207>
  800988:	83 fb 1f             	cmp    $0x1f,%ebx
  80098b:	7e 05                	jle    800992 <vprintfmt+0x1f5>
  80098d:	83 fb 7e             	cmp    $0x7e,%ebx
  800990:	7e 12                	jle    8009a4 <vprintfmt+0x207>
					putch('?', putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	6a 3f                	push   $0x3f
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	eb 0f                	jmp    8009b3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	ff d0                	call   *%eax
  8009b0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b6:	89 f0                	mov    %esi,%eax
  8009b8:	8d 70 01             	lea    0x1(%eax),%esi
  8009bb:	8a 00                	mov    (%eax),%al
  8009bd:	0f be d8             	movsbl %al,%ebx
  8009c0:	85 db                	test   %ebx,%ebx
  8009c2:	74 24                	je     8009e8 <vprintfmt+0x24b>
  8009c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c8:	78 b8                	js     800982 <vprintfmt+0x1e5>
  8009ca:	ff 4d e0             	decl   -0x20(%ebp)
  8009cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d1:	79 af                	jns    800982 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d3:	eb 13                	jmp    8009e8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	6a 20                	push   $0x20
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	ff d0                	call   *%eax
  8009e2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ec:	7f e7                	jg     8009d5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ee:	e9 78 01 00 00       	jmp    800b6b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fc:	50                   	push   %eax
  8009fd:	e8 3c fd ff ff       	call   80073e <getint>
  800a02:	83 c4 10             	add    $0x10,%esp
  800a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a11:	85 d2                	test   %edx,%edx
  800a13:	79 23                	jns    800a38 <vprintfmt+0x29b>
				putch('-', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 2d                	push   $0x2d
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2b:	f7 d8                	neg    %eax
  800a2d:	83 d2 00             	adc    $0x0,%edx
  800a30:	f7 da                	neg    %edx
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a38:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4d:	50                   	push   %eax
  800a4e:	e8 84 fc ff ff       	call   8006d7 <getuint>
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a63:	e9 98 00 00 00       	jmp    800b00 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 58                	push   $0x58
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	6a 58                	push   $0x58
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	6a 58                	push   $0x58
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			break;
  800a98:	e9 ce 00 00 00       	jmp    800b6b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	6a 30                	push   $0x30
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	ff d0                	call   *%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	6a 78                	push   $0x78
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 c0 04             	add    $0x4,%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ad8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800adf:	eb 1f                	jmp    800b00 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae7:	8d 45 14             	lea    0x14(%ebp),%eax
  800aea:	50                   	push   %eax
  800aeb:	e8 e7 fb ff ff       	call   8006d7 <getuint>
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800af9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b00:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b07:	83 ec 04             	sub    $0x4,%esp
  800b0a:	52                   	push   %edx
  800b0b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b0e:	50                   	push   %eax
  800b0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b12:	ff 75 f0             	pushl  -0x10(%ebp)
  800b15:	ff 75 0c             	pushl  0xc(%ebp)
  800b18:	ff 75 08             	pushl  0x8(%ebp)
  800b1b:	e8 00 fb ff ff       	call   800620 <printnum>
  800b20:	83 c4 20             	add    $0x20,%esp
			break;
  800b23:	eb 46                	jmp    800b6b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 0c             	pushl  0xc(%ebp)
  800b2b:	53                   	push   %ebx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
  800b31:	83 c4 10             	add    $0x10,%esp
			break;
  800b34:	eb 35                	jmp    800b6b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b36:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b3d:	eb 2c                	jmp    800b6b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b3f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b46:	eb 23                	jmp    800b6b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 25                	push   $0x25
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b58:	ff 4d 10             	decl   0x10(%ebp)
  800b5b:	eb 03                	jmp    800b60 <vprintfmt+0x3c3>
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	8b 45 10             	mov    0x10(%ebp),%eax
  800b63:	48                   	dec    %eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	3c 25                	cmp    $0x25,%al
  800b68:	75 f3                	jne    800b5d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b6a:	90                   	nop
		}
	}
  800b6b:	e9 35 fc ff ff       	jmp    8007a5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b70:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b81:	83 c0 04             	add    $0x4,%eax
  800b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b87:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8d:	50                   	push   %eax
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	ff 75 08             	pushl  0x8(%ebp)
  800b94:	e8 04 fc ff ff       	call   80079d <vprintfmt>
  800b99:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b9c:	90                   	nop
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	8b 40 08             	mov    0x8(%eax),%eax
  800ba8:	8d 50 01             	lea    0x1(%eax),%edx
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	8b 10                	mov    (%eax),%edx
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 04             	mov    0x4(%eax),%eax
  800bbc:	39 c2                	cmp    %eax,%edx
  800bbe:	73 12                	jae    800bd2 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcb:	89 0a                	mov    %ecx,(%edx)
  800bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd0:	88 10                	mov    %dl,(%eax)
}
  800bd2:	90                   	nop
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	01 d0                	add    %edx,%eax
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bfa:	74 06                	je     800c02 <vsnprintf+0x2d>
  800bfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c00:	7f 07                	jg     800c09 <vsnprintf+0x34>
		return -E_INVAL;
  800c02:	b8 03 00 00 00       	mov    $0x3,%eax
  800c07:	eb 20                	jmp    800c29 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c09:	ff 75 14             	pushl  0x14(%ebp)
  800c0c:	ff 75 10             	pushl  0x10(%ebp)
  800c0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c12:	50                   	push   %eax
  800c13:	68 9f 0b 80 00       	push   $0x800b9f
  800c18:	e8 80 fb ff ff       	call   80079d <vprintfmt>
  800c1d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c23:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c31:	8d 45 10             	lea    0x10(%ebp),%eax
  800c34:	83 c0 04             	add    $0x4,%eax
  800c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c40:	50                   	push   %eax
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	ff 75 08             	pushl  0x8(%ebp)
  800c47:	e8 89 ff ff ff       	call   800bd5 <vsnprintf>
  800c4c:	83 c4 10             	add    $0x10,%esp
  800c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c64:	eb 06                	jmp    800c6c <strlen+0x15>
		n++;
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c69:	ff 45 08             	incl   0x8(%ebp)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	75 f1                	jne    800c66 <strlen+0xf>
		n++;
	return n;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c87:	eb 09                	jmp    800c92 <strnlen+0x18>
		n++;
  800c89:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8c:	ff 45 08             	incl   0x8(%ebp)
  800c8f:	ff 4d 0c             	decl   0xc(%ebp)
  800c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c96:	74 09                	je     800ca1 <strnlen+0x27>
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 e8                	jne    800c89 <strnlen+0xf>
		n++;
	return n;
  800ca1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb2:	90                   	nop
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8d 50 01             	lea    0x1(%eax),%edx
  800cb9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc5:	8a 12                	mov    (%edx),%dl
  800cc7:	88 10                	mov    %dl,(%eax)
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	84 c0                	test   %al,%al
  800ccd:	75 e4                	jne    800cb3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce7:	eb 1f                	jmp    800d08 <strncpy+0x34>
		*dst++ = *src;
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8d 50 01             	lea    0x1(%eax),%edx
  800cef:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf5:	8a 12                	mov    (%edx),%dl
  800cf7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	84 c0                	test   %al,%al
  800d00:	74 03                	je     800d05 <strncpy+0x31>
			src++;
  800d02:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
  800d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0e:	72 d9                	jb     800ce9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d10:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d25:	74 30                	je     800d57 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d27:	eb 16                	jmp    800d3f <strlcpy+0x2a>
			*dst++ = *src++;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8d 50 01             	lea    0x1(%eax),%edx
  800d2f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d38:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d3b:	8a 12                	mov    (%edx),%dl
  800d3d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3f:	ff 4d 10             	decl   0x10(%ebp)
  800d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d46:	74 09                	je     800d51 <strlcpy+0x3c>
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	75 d8                	jne    800d29 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d66:	eb 06                	jmp    800d6e <strcmp+0xb>
		p++, q++;
  800d68:	ff 45 08             	incl   0x8(%ebp)
  800d6b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	74 0e                	je     800d85 <strcmp+0x22>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 10                	mov    (%eax),%dl
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	38 c2                	cmp    %al,%dl
  800d83:	74 e3                	je     800d68 <strcmp+0x5>
		p++, q++;
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

00800d9b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9e:	eb 09                	jmp    800da9 <strncmp+0xe>
		n--, p++, q++;
  800da0:	ff 4d 10             	decl   0x10(%ebp)
  800da3:	ff 45 08             	incl   0x8(%ebp)
  800da6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 17                	je     800dc6 <strncmp+0x2b>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	74 0e                	je     800dc6 <strncmp+0x2b>
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 10                	mov    (%eax),%dl
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	38 c2                	cmp    %al,%dl
  800dc4:	74 da                	je     800da0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dca:	75 07                	jne    800dd3 <strncmp+0x38>
		return 0;
  800dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd1:	eb 14                	jmp    800de7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	0f b6 d0             	movzbl %al,%edx
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 c0             	movzbl %al,%eax
  800de3:	29 c2                	sub    %eax,%edx
  800de5:	89 d0                	mov    %edx,%eax
}
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 04             	sub    $0x4,%esp
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df5:	eb 12                	jmp    800e09 <strchr+0x20>
		if (*s == c)
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dff:	75 05                	jne    800e06 <strchr+0x1d>
			return (char *) s;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	eb 11                	jmp    800e17 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e06:	ff 45 08             	incl   0x8(%ebp)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 e5                	jne    800df7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 04             	sub    $0x4,%esp
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e25:	eb 0d                	jmp    800e34 <strfind+0x1b>
		if (*s == c)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2f:	74 0e                	je     800e3f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	84 c0                	test   %al,%al
  800e3b:	75 ea                	jne    800e27 <strfind+0xe>
  800e3d:	eb 01                	jmp    800e40 <strfind+0x27>
		if (*s == c)
			break;
  800e3f:	90                   	nop
	return (char *) s;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e51:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e55:	76 63                	jbe    800eba <memset+0x75>
		uint64 data_block = c;
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	99                   	cltd   
  800e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e67:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e6b:	c1 e0 08             	shl    $0x8,%eax
  800e6e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e71:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e7e:	c1 e0 10             	shl    $0x10,%eax
  800e81:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e84:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8d:	89 c2                	mov    %eax,%edx
  800e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e94:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e97:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e9a:	eb 18                	jmp    800eb4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e9c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e9f:	8d 41 08             	lea    0x8(%ecx),%eax
  800ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eab:	89 01                	mov    %eax,(%ecx)
  800ead:	89 51 04             	mov    %edx,0x4(%ecx)
  800eb0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eb4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb8:	77 e2                	ja     800e9c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 23                	je     800ee3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x91>
			*p8++ = (uint8)c;
  800ec8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	75 e5                	jne    800ec8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800efa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efe:	76 24                	jbe    800f24 <memcpy+0x3c>
		while(n >= 8){
  800f00:	eb 1c                	jmp    800f1e <memcpy+0x36>
			*d64 = *s64;
  800f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f05:	8b 50 04             	mov    0x4(%eax),%edx
  800f08:	8b 00                	mov    (%eax),%eax
  800f0a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0d:	89 01                	mov    %eax,(%ecx)
  800f0f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f12:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f16:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f1a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f1e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f22:	77 de                	ja     800f02 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f28:	74 31                	je     800f5b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f36:	eb 16                	jmp    800f4e <memcpy+0x66>
			*d8++ = *s8++;
  800f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3b:	8d 50 01             	lea    0x1(%eax),%edx
  800f3e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f47:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f4a:	8a 12                	mov    (%edx),%dl
  800f4c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f54:	89 55 10             	mov    %edx,0x10(%ebp)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	75 dd                	jne    800f38 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f78:	73 50                	jae    800fca <memmove+0x6a>
  800f7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	01 d0                	add    %edx,%eax
  800f82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f85:	76 43                	jbe    800fca <memmove+0x6a>
		s += n;
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f93:	eb 10                	jmp    800fa5 <memmove+0x45>
			*--d = *--s;
  800f95:	ff 4d f8             	decl   -0x8(%ebp)
  800f98:	ff 4d fc             	decl   -0x4(%ebp)
  800f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9e:	8a 10                	mov    (%eax),%dl
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fab:	89 55 10             	mov    %edx,0x10(%ebp)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	75 e3                	jne    800f95 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb2:	eb 23                	jmp    800fd7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8d 50 01             	lea    0x1(%eax),%edx
  800fba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc6:	8a 12                	mov    (%edx),%dl
  800fc8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	75 dd                	jne    800fb4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fee:	eb 2a                	jmp    80101a <memcmp+0x3e>
		if (*s1 != *s2)
  800ff0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff3:	8a 10                	mov    (%eax),%dl
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	38 c2                	cmp    %al,%dl
  800ffc:	74 16                	je     801014 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f b6 d0             	movzbl %al,%edx
  801006:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	0f b6 c0             	movzbl %al,%eax
  80100e:	29 c2                	sub    %eax,%edx
  801010:	89 d0                	mov    %edx,%eax
  801012:	eb 18                	jmp    80102c <memcmp+0x50>
		s1++, s2++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
  801017:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801020:	89 55 10             	mov    %edx,0x10(%ebp)
  801023:	85 c0                	test   %eax,%eax
  801025:	75 c9                	jne    800ff0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102c:	c9                   	leave  
  80102d:	c3                   	ret    

0080102e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	01 d0                	add    %edx,%eax
  80103c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103f:	eb 15                	jmp    801056 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f b6 d0             	movzbl %al,%edx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	0f b6 c0             	movzbl %al,%eax
  80104f:	39 c2                	cmp    %eax,%edx
  801051:	74 0d                	je     801060 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801053:	ff 45 08             	incl   0x8(%ebp)
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105c:	72 e3                	jb     801041 <memfind+0x13>
  80105e:	eb 01                	jmp    801061 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801060:	90                   	nop
	return (void *) s;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801073:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107a:	eb 03                	jmp    80107f <strtol+0x19>
		s++;
  80107c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 20                	cmp    $0x20,%al
  801086:	74 f4                	je     80107c <strtol+0x16>
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 09                	cmp    $0x9,%al
  80108f:	74 eb                	je     80107c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 2b                	cmp    $0x2b,%al
  801098:	75 05                	jne    80109f <strtol+0x39>
		s++;
  80109a:	ff 45 08             	incl   0x8(%ebp)
  80109d:	eb 13                	jmp    8010b2 <strtol+0x4c>
	else if (*s == '-')
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 2d                	cmp    $0x2d,%al
  8010a6:	75 0a                	jne    8010b2 <strtol+0x4c>
		s++, neg = 1;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
  8010ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b6:	74 06                	je     8010be <strtol+0x58>
  8010b8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bc:	75 20                	jne    8010de <strtol+0x78>
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3c 30                	cmp    $0x30,%al
  8010c5:	75 17                	jne    8010de <strtol+0x78>
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	40                   	inc    %eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	3c 78                	cmp    $0x78,%al
  8010cf:	75 0d                	jne    8010de <strtol+0x78>
		s += 2, base = 16;
  8010d1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010dc:	eb 28                	jmp    801106 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	75 15                	jne    8010f9 <strtol+0x93>
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 30                	cmp    $0x30,%al
  8010eb:	75 0c                	jne    8010f9 <strtol+0x93>
		s++, base = 8;
  8010ed:	ff 45 08             	incl   0x8(%ebp)
  8010f0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f7:	eb 0d                	jmp    801106 <strtol+0xa0>
	else if (base == 0)
  8010f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fd:	75 07                	jne    801106 <strtol+0xa0>
		base = 10;
  8010ff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	3c 2f                	cmp    $0x2f,%al
  80110d:	7e 19                	jle    801128 <strtol+0xc2>
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	3c 39                	cmp    $0x39,%al
  801116:	7f 10                	jg     801128 <strtol+0xc2>
			dig = *s - '0';
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f be c0             	movsbl %al,%eax
  801120:	83 e8 30             	sub    $0x30,%eax
  801123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801126:	eb 42                	jmp    80116a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3c 60                	cmp    $0x60,%al
  80112f:	7e 19                	jle    80114a <strtol+0xe4>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 7a                	cmp    $0x7a,%al
  801138:	7f 10                	jg     80114a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f be c0             	movsbl %al,%eax
  801142:	83 e8 57             	sub    $0x57,%eax
  801145:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801148:	eb 20                	jmp    80116a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 40                	cmp    $0x40,%al
  801151:	7e 39                	jle    80118c <strtol+0x126>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 5a                	cmp    $0x5a,%al
  80115a:	7f 30                	jg     80118c <strtol+0x126>
			dig = *s - 'A' + 10;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	0f be c0             	movsbl %al,%eax
  801164:	83 e8 37             	sub    $0x37,%eax
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80116a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801170:	7d 19                	jge    80118b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801172:	ff 45 08             	incl   0x8(%ebp)
  801175:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801178:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801186:	e9 7b ff ff ff       	jmp    801106 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801190:	74 08                	je     80119a <strtol+0x134>
		*endptr = (char *) s;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 55 08             	mov    0x8(%ebp),%edx
  801198:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80119a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119e:	74 07                	je     8011a7 <strtol+0x141>
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	f7 d8                	neg    %eax
  8011a5:	eb 03                	jmp    8011aa <strtol+0x144>
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <ltostr>:

void
ltostr(long value, char *str)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c4:	79 13                	jns    8011d9 <ltostr+0x2d>
	{
		neg = 1;
  8011c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e1:	99                   	cltd   
  8011e2:	f7 f9                	idiv   %ecx
  8011e4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fa:	83 c2 30             	add    $0x30,%edx
  8011fd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801202:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801207:	f7 e9                	imul   %ecx
  801209:	c1 fa 02             	sar    $0x2,%edx
  80120c:	89 c8                	mov    %ecx,%eax
  80120e:	c1 f8 1f             	sar    $0x1f,%eax
  801211:	29 c2                	sub    %eax,%edx
  801213:	89 d0                	mov    %edx,%eax
  801215:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121c:	75 bb                	jne    8011d9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	48                   	dec    %eax
  801229:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80122c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801230:	74 3d                	je     80126f <ltostr+0xc3>
		start = 1 ;
  801232:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801239:	eb 34                	jmp    80126f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80123b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 d0                	add    %edx,%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801253:	8b 45 0c             	mov    0xc(%ebp),%eax
  801256:	01 c8                	add    %ecx,%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80125c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8a 45 eb             	mov    -0x15(%ebp),%al
  801267:	88 02                	mov    %al,(%edx)
		start++ ;
  801269:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801272:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801275:	7c c4                	jl     80123b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801277:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801282:	90                   	nop
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80128b:	ff 75 08             	pushl  0x8(%ebp)
  80128e:	e8 c4 f9 ff ff       	call   800c57 <strlen>
  801293:	83 c4 04             	add    $0x4,%esp
  801296:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	e8 b6 f9 ff ff       	call   800c57 <strlen>
  8012a1:	83 c4 04             	add    $0x4,%esp
  8012a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b5:	eb 17                	jmp    8012ce <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	01 c2                	add    %eax,%edx
  8012bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	01 c8                	add    %ecx,%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
  8012ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d4:	7c e1                	jl     8012b7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e4:	eb 1f                	jmp    801305 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	01 c2                	add    %eax,%edx
  8012f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 c8                	add    %ecx,%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801302:	ff 45 f8             	incl   -0x8(%ebp)
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80130b:	7c d9                	jl     8012e6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	c6 00 00             	movb   $0x0,(%eax)
}
  801318:	90                   	nop
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131e:	8b 45 14             	mov    0x14(%ebp),%eax
  801321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801327:	8b 45 14             	mov    0x14(%ebp),%eax
  80132a:	8b 00                	mov    (%eax),%eax
  80132c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 d0                	add    %edx,%eax
  801338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133e:	eb 0c                	jmp    80134c <strsplit+0x31>
			*string++ = 0;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8d 50 01             	lea    0x1(%eax),%edx
  801346:	89 55 08             	mov    %edx,0x8(%ebp)
  801349:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 18                	je     80136d <strsplit+0x52>
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	0f be c0             	movsbl %al,%eax
  80135d:	50                   	push   %eax
  80135e:	ff 75 0c             	pushl  0xc(%ebp)
  801361:	e8 83 fa ff ff       	call   800de9 <strchr>
  801366:	83 c4 08             	add    $0x8,%esp
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 d3                	jne    801340 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8a 00                	mov    (%eax),%al
  801372:	84 c0                	test   %al,%al
  801374:	74 5a                	je     8013d0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	83 f8 0f             	cmp    $0xf,%eax
  80137e:	75 07                	jne    801387 <strsplit+0x6c>
		{
			return 0;
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	eb 66                	jmp    8013ed <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801387:	8b 45 14             	mov    0x14(%ebp),%eax
  80138a:	8b 00                	mov    (%eax),%eax
  80138c:	8d 48 01             	lea    0x1(%eax),%ecx
  80138f:	8b 55 14             	mov    0x14(%ebp),%edx
  801392:	89 0a                	mov    %ecx,(%edx)
  801394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139b:	8b 45 10             	mov    0x10(%ebp),%eax
  80139e:	01 c2                	add    %eax,%edx
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a5:	eb 03                	jmp    8013aa <strsplit+0x8f>
			string++;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	84 c0                	test   %al,%al
  8013b1:	74 8b                	je     80133e <strsplit+0x23>
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	0f be c0             	movsbl %al,%eax
  8013bb:	50                   	push   %eax
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	e8 25 fa ff ff       	call   800de9 <strchr>
  8013c4:	83 c4 08             	add    $0x8,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 dc                	je     8013a7 <strsplit+0x8c>
			string++;
	}
  8013cb:	e9 6e ff ff ff       	jmp    80133e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013d0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d4:	8b 00                	mov    (%eax),%eax
  8013d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801402:	eb 4a                	jmp    80144e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801404:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	01 c2                	add    %eax,%edx
  80140c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	01 c8                	add    %ecx,%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801418:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	3c 40                	cmp    $0x40,%al
  801424:	7e 25                	jle    80144b <str2lower+0x5c>
  801426:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	3c 5a                	cmp    $0x5a,%al
  801432:	7f 17                	jg     80144b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801434:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	01 d0                	add    %edx,%eax
  80143c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143f:	8b 55 08             	mov    0x8(%ebp),%edx
  801442:	01 ca                	add    %ecx,%edx
  801444:	8a 12                	mov    (%edx),%dl
  801446:	83 c2 20             	add    $0x20,%edx
  801449:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80144b:	ff 45 fc             	incl   -0x4(%ebp)
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	e8 01 f8 ff ff       	call   800c57 <strlen>
  801456:	83 c4 04             	add    $0x4,%esp
  801459:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80145c:	7f a6                	jg     801404 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	57                   	push   %edi
  801467:	56                   	push   %esi
  801468:	53                   	push   %ebx
  801469:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801472:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801475:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801478:	8b 7d 18             	mov    0x18(%ebp),%edi
  80147b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147e:	cd 30                	int    $0x30
  801480:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801483:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	5b                   	pop    %ebx
  80148a:	5e                   	pop    %esi
  80148b:	5f                   	pop    %edi
  80148c:	5d                   	pop    %ebp
  80148d:	c3                   	ret    

0080148e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80149a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	6a 00                	push   $0x0
  8014a6:	51                   	push   %ecx
  8014a7:	52                   	push   %edx
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	50                   	push   %eax
  8014ac:	6a 00                	push   $0x0
  8014ae:	e8 b0 ff ff ff       	call   801463 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	90                   	nop
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 02                	push   $0x2
  8014c8:	e8 96 ff ff ff       	call   801463 <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 03                	push   $0x3
  8014e1:	e8 7d ff ff ff       	call   801463 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 04                	push   $0x4
  8014fb:	e8 63 ff ff ff       	call   801463 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 08                	push   $0x8
  801519:	e8 45 ff ff ff       	call   801463 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	56                   	push   %esi
  801527:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801528:	8b 75 18             	mov    0x18(%ebp),%esi
  80152b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801531:	8b 55 0c             	mov    0xc(%ebp),%edx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	51                   	push   %ecx
  80153a:	52                   	push   %edx
  80153b:	50                   	push   %eax
  80153c:	6a 09                	push   $0x9
  80153e:	e8 20 ff ff ff       	call   801463 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
}
  801546:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801549:	5b                   	pop    %ebx
  80154a:	5e                   	pop    %esi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    

0080154d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	ff 75 08             	pushl  0x8(%ebp)
  80155b:	6a 0a                	push   $0xa
  80155d:	e8 01 ff ff ff       	call   801463 <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	ff 75 08             	pushl  0x8(%ebp)
  801576:	6a 0b                	push   $0xb
  801578:	e8 e6 fe ff ff       	call   801463 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 0c                	push   $0xc
  801591:	e8 cd fe ff ff       	call   801463 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 0d                	push   $0xd
  8015aa:	e8 b4 fe ff ff       	call   801463 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 0e                	push   $0xe
  8015c3:	e8 9b fe ff ff       	call   801463 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 0f                	push   $0xf
  8015dc:	e8 82 fe ff ff       	call   801463 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	6a 10                	push   $0x10
  8015f6:	e8 68 fe ff ff       	call   801463 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 11                	push   $0x11
  80160f:	e8 4f fe ff ff       	call   801463 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_cputc>:

void
sys_cputc(const char c)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801626:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	50                   	push   %eax
  801633:	6a 01                	push   $0x1
  801635:	e8 29 fe ff ff       	call   801463 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	90                   	nop
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 14                	push   $0x14
  80164f:	e8 0f fe ff ff       	call   801463 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	90                   	nop
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801666:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801669:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	51                   	push   %ecx
  801673:	52                   	push   %edx
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	50                   	push   %eax
  801678:	6a 15                	push   $0x15
  80167a:	e8 e4 fd ff ff       	call   801463 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	52                   	push   %edx
  801694:	50                   	push   %eax
  801695:	6a 16                	push   $0x16
  801697:	e8 c7 fd ff ff       	call   801463 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	51                   	push   %ecx
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	6a 17                	push   $0x17
  8016b6:	e8 a8 fd ff ff       	call   801463 <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	6a 18                	push   $0x18
  8016d3:	e8 8b fd ff ff       	call   801463 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 14             	pushl  0x14(%ebp)
  8016e8:	ff 75 10             	pushl  0x10(%ebp)
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	50                   	push   %eax
  8016ef:	6a 19                	push   $0x19
  8016f1:	e8 6d fd ff ff       	call   801463 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	50                   	push   %eax
  80170a:	6a 1a                	push   $0x1a
  80170c:	e8 52 fd ff ff       	call   801463 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	50                   	push   %eax
  801726:	6a 1b                	push   $0x1b
  801728:	e8 36 fd ff ff       	call   801463 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 05                	push   $0x5
  801741:	e8 1d fd ff ff       	call   801463 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 06                	push   $0x6
  80175a:	e8 04 fd ff ff       	call   801463 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 07                	push   $0x7
  801773:	e8 eb fc ff ff       	call   801463 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_exit_env>:


void sys_exit_env(void)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 1c                	push   $0x1c
  80178c:	e8 d2 fc ff ff       	call   801463 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	90                   	nop
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a0:	8d 50 04             	lea    0x4(%eax),%edx
  8017a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	52                   	push   %edx
  8017ad:	50                   	push   %eax
  8017ae:	6a 1d                	push   $0x1d
  8017b0:	e8 ae fc ff ff       	call   801463 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c1:	89 01                	mov    %eax,(%ecx)
  8017c3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	c9                   	leave  
  8017ca:	c2 04 00             	ret    $0x4

008017cd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	ff 75 10             	pushl  0x10(%ebp)
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	6a 13                	push   $0x13
  8017df:	e8 7f fc ff ff       	call   801463 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e7:	90                   	nop
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_rcr2>:
uint32 sys_rcr2()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 1e                	push   $0x1e
  8017f9:	e8 65 fc ff ff       	call   801463 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80180f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	50                   	push   %eax
  80181c:	6a 1f                	push   $0x1f
  80181e:	e8 40 fc ff ff       	call   801463 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
	return ;
  801826:	90                   	nop
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <rsttst>:
void rsttst()
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 21                	push   $0x21
  801838:	e8 26 fc ff ff       	call   801463 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
	return ;
  801840:	90                   	nop
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	8b 45 14             	mov    0x14(%ebp),%eax
  80184c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80184f:	8b 55 18             	mov    0x18(%ebp),%edx
  801852:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801856:	52                   	push   %edx
  801857:	50                   	push   %eax
  801858:	ff 75 10             	pushl  0x10(%ebp)
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	6a 20                	push   $0x20
  801863:	e8 fb fb ff ff       	call   801463 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
	return ;
  80186b:	90                   	nop
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <chktst>:
void chktst(uint32 n)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	6a 22                	push   $0x22
  80187e:	e8 e0 fb ff ff       	call   801463 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
	return ;
  801886:	90                   	nop
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <inctst>:

void inctst()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 23                	push   $0x23
  801898:	e8 c6 fb ff ff       	call   801463 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a0:	90                   	nop
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <gettst>:
uint32 gettst()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 24                	push   $0x24
  8018b2:	e8 ac fb ff ff       	call   801463 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 25                	push   $0x25
  8018cb:	e8 93 fb ff ff       	call   801463 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
  8018d3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018d8:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	6a 26                	push   $0x26
  8018f7:	e8 67 fb ff ff       	call   801463 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ff:	90                   	nop
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801906:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801909:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	6a 00                	push   $0x0
  801914:	53                   	push   %ebx
  801915:	51                   	push   %ecx
  801916:	52                   	push   %edx
  801917:	50                   	push   %eax
  801918:	6a 27                	push   $0x27
  80191a:	e8 44 fb ff ff       	call   801463 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 28                	push   $0x28
  80193a:	e8 24 fb ff ff       	call   801463 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801947:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	51                   	push   %ecx
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 29                	push   $0x29
  80195a:	e8 04 fb ff ff       	call   801463 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 10             	pushl  0x10(%ebp)
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 12                	push   $0x12
  801976:	e8 e8 fa ff ff       	call   801463 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return ;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	52                   	push   %edx
  801991:	50                   	push   %eax
  801992:	6a 2a                	push   $0x2a
  801994:	e8 ca fa ff ff       	call   801463 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
	return;
  80199c:	90                   	nop
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 2b                	push   $0x2b
  8019ae:	e8 b0 fa ff ff       	call   801463 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 2d                	push   $0x2d
  8019c9:	e8 95 fa ff ff       	call   801463 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	6a 2c                	push   $0x2c
  8019e5:	e8 79 fa ff ff       	call   801463 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ed:	90                   	nop
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 2e                	push   $0x2e
  801a03:	e8 5b fa ff ff       	call   801463 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0b:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    
  801a0e:	66 90                	xchg   %ax,%ax

00801a10 <__udivdi3>:
  801a10:	55                   	push   %ebp
  801a11:	57                   	push   %edi
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	83 ec 1c             	sub    $0x1c,%esp
  801a17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a27:	89 ca                	mov    %ecx,%edx
  801a29:	89 f8                	mov    %edi,%eax
  801a2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a2f:	85 f6                	test   %esi,%esi
  801a31:	75 2d                	jne    801a60 <__udivdi3+0x50>
  801a33:	39 cf                	cmp    %ecx,%edi
  801a35:	77 65                	ja     801a9c <__udivdi3+0x8c>
  801a37:	89 fd                	mov    %edi,%ebp
  801a39:	85 ff                	test   %edi,%edi
  801a3b:	75 0b                	jne    801a48 <__udivdi3+0x38>
  801a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a42:	31 d2                	xor    %edx,%edx
  801a44:	f7 f7                	div    %edi
  801a46:	89 c5                	mov    %eax,%ebp
  801a48:	31 d2                	xor    %edx,%edx
  801a4a:	89 c8                	mov    %ecx,%eax
  801a4c:	f7 f5                	div    %ebp
  801a4e:	89 c1                	mov    %eax,%ecx
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	f7 f5                	div    %ebp
  801a54:	89 cf                	mov    %ecx,%edi
  801a56:	89 fa                	mov    %edi,%edx
  801a58:	83 c4 1c             	add    $0x1c,%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5f                   	pop    %edi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    
  801a60:	39 ce                	cmp    %ecx,%esi
  801a62:	77 28                	ja     801a8c <__udivdi3+0x7c>
  801a64:	0f bd fe             	bsr    %esi,%edi
  801a67:	83 f7 1f             	xor    $0x1f,%edi
  801a6a:	75 40                	jne    801aac <__udivdi3+0x9c>
  801a6c:	39 ce                	cmp    %ecx,%esi
  801a6e:	72 0a                	jb     801a7a <__udivdi3+0x6a>
  801a70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a74:	0f 87 9e 00 00 00    	ja     801b18 <__udivdi3+0x108>
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	89 fa                	mov    %edi,%edx
  801a81:	83 c4 1c             	add    $0x1c,%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5f                   	pop    %edi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    
  801a89:	8d 76 00             	lea    0x0(%esi),%esi
  801a8c:	31 ff                	xor    %edi,%edi
  801a8e:	31 c0                	xor    %eax,%eax
  801a90:	89 fa                	mov    %edi,%edx
  801a92:	83 c4 1c             	add    $0x1c,%esp
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5f                   	pop    %edi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    
  801a9a:	66 90                	xchg   %ax,%ax
  801a9c:	89 d8                	mov    %ebx,%eax
  801a9e:	f7 f7                	div    %edi
  801aa0:	31 ff                	xor    %edi,%edi
  801aa2:	89 fa                	mov    %edi,%edx
  801aa4:	83 c4 1c             	add    $0x1c,%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5f                   	pop    %edi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
  801aac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ab1:	89 eb                	mov    %ebp,%ebx
  801ab3:	29 fb                	sub    %edi,%ebx
  801ab5:	89 f9                	mov    %edi,%ecx
  801ab7:	d3 e6                	shl    %cl,%esi
  801ab9:	89 c5                	mov    %eax,%ebp
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 ed                	shr    %cl,%ebp
  801abf:	89 e9                	mov    %ebp,%ecx
  801ac1:	09 f1                	or     %esi,%ecx
  801ac3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ac7:	89 f9                	mov    %edi,%ecx
  801ac9:	d3 e0                	shl    %cl,%eax
  801acb:	89 c5                	mov    %eax,%ebp
  801acd:	89 d6                	mov    %edx,%esi
  801acf:	88 d9                	mov    %bl,%cl
  801ad1:	d3 ee                	shr    %cl,%esi
  801ad3:	89 f9                	mov    %edi,%ecx
  801ad5:	d3 e2                	shl    %cl,%edx
  801ad7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801adb:	88 d9                	mov    %bl,%cl
  801add:	d3 e8                	shr    %cl,%eax
  801adf:	09 c2                	or     %eax,%edx
  801ae1:	89 d0                	mov    %edx,%eax
  801ae3:	89 f2                	mov    %esi,%edx
  801ae5:	f7 74 24 0c          	divl   0xc(%esp)
  801ae9:	89 d6                	mov    %edx,%esi
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	f7 e5                	mul    %ebp
  801aef:	39 d6                	cmp    %edx,%esi
  801af1:	72 19                	jb     801b0c <__udivdi3+0xfc>
  801af3:	74 0b                	je     801b00 <__udivdi3+0xf0>
  801af5:	89 d8                	mov    %ebx,%eax
  801af7:	31 ff                	xor    %edi,%edi
  801af9:	e9 58 ff ff ff       	jmp    801a56 <__udivdi3+0x46>
  801afe:	66 90                	xchg   %ax,%ax
  801b00:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b04:	89 f9                	mov    %edi,%ecx
  801b06:	d3 e2                	shl    %cl,%edx
  801b08:	39 c2                	cmp    %eax,%edx
  801b0a:	73 e9                	jae    801af5 <__udivdi3+0xe5>
  801b0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b0f:	31 ff                	xor    %edi,%edi
  801b11:	e9 40 ff ff ff       	jmp    801a56 <__udivdi3+0x46>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	31 c0                	xor    %eax,%eax
  801b1a:	e9 37 ff ff ff       	jmp    801a56 <__udivdi3+0x46>
  801b1f:	90                   	nop

00801b20 <__umoddi3>:
  801b20:	55                   	push   %ebp
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 1c             	sub    $0x1c,%esp
  801b27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3f:	89 f3                	mov    %esi,%ebx
  801b41:	89 fa                	mov    %edi,%edx
  801b43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b47:	89 34 24             	mov    %esi,(%esp)
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	75 1a                	jne    801b68 <__umoddi3+0x48>
  801b4e:	39 f7                	cmp    %esi,%edi
  801b50:	0f 86 a2 00 00 00    	jbe    801bf8 <__umoddi3+0xd8>
  801b56:	89 c8                	mov    %ecx,%eax
  801b58:	89 f2                	mov    %esi,%edx
  801b5a:	f7 f7                	div    %edi
  801b5c:	89 d0                	mov    %edx,%eax
  801b5e:	31 d2                	xor    %edx,%edx
  801b60:	83 c4 1c             	add    $0x1c,%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5f                   	pop    %edi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
  801b68:	39 f0                	cmp    %esi,%eax
  801b6a:	0f 87 ac 00 00 00    	ja     801c1c <__umoddi3+0xfc>
  801b70:	0f bd e8             	bsr    %eax,%ebp
  801b73:	83 f5 1f             	xor    $0x1f,%ebp
  801b76:	0f 84 ac 00 00 00    	je     801c28 <__umoddi3+0x108>
  801b7c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b81:	29 ef                	sub    %ebp,%edi
  801b83:	89 fe                	mov    %edi,%esi
  801b85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 e0                	shl    %cl,%eax
  801b8d:	89 d7                	mov    %edx,%edi
  801b8f:	89 f1                	mov    %esi,%ecx
  801b91:	d3 ef                	shr    %cl,%edi
  801b93:	09 c7                	or     %eax,%edi
  801b95:	89 e9                	mov    %ebp,%ecx
  801b97:	d3 e2                	shl    %cl,%edx
  801b99:	89 14 24             	mov    %edx,(%esp)
  801b9c:	89 d8                	mov    %ebx,%eax
  801b9e:	d3 e0                	shl    %cl,%eax
  801ba0:	89 c2                	mov    %eax,%edx
  801ba2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba6:	d3 e0                	shl    %cl,%eax
  801ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bac:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb0:	89 f1                	mov    %esi,%ecx
  801bb2:	d3 e8                	shr    %cl,%eax
  801bb4:	09 d0                	or     %edx,%eax
  801bb6:	d3 eb                	shr    %cl,%ebx
  801bb8:	89 da                	mov    %ebx,%edx
  801bba:	f7 f7                	div    %edi
  801bbc:	89 d3                	mov    %edx,%ebx
  801bbe:	f7 24 24             	mull   (%esp)
  801bc1:	89 c6                	mov    %eax,%esi
  801bc3:	89 d1                	mov    %edx,%ecx
  801bc5:	39 d3                	cmp    %edx,%ebx
  801bc7:	0f 82 87 00 00 00    	jb     801c54 <__umoddi3+0x134>
  801bcd:	0f 84 91 00 00 00    	je     801c64 <__umoddi3+0x144>
  801bd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bd7:	29 f2                	sub    %esi,%edx
  801bd9:	19 cb                	sbb    %ecx,%ebx
  801bdb:	89 d8                	mov    %ebx,%eax
  801bdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801be1:	d3 e0                	shl    %cl,%eax
  801be3:	89 e9                	mov    %ebp,%ecx
  801be5:	d3 ea                	shr    %cl,%edx
  801be7:	09 d0                	or     %edx,%eax
  801be9:	89 e9                	mov    %ebp,%ecx
  801beb:	d3 eb                	shr    %cl,%ebx
  801bed:	89 da                	mov    %ebx,%edx
  801bef:	83 c4 1c             	add    $0x1c,%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    
  801bf7:	90                   	nop
  801bf8:	89 fd                	mov    %edi,%ebp
  801bfa:	85 ff                	test   %edi,%edi
  801bfc:	75 0b                	jne    801c09 <__umoddi3+0xe9>
  801bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801c03:	31 d2                	xor    %edx,%edx
  801c05:	f7 f7                	div    %edi
  801c07:	89 c5                	mov    %eax,%ebp
  801c09:	89 f0                	mov    %esi,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	f7 f5                	div    %ebp
  801c0f:	89 c8                	mov    %ecx,%eax
  801c11:	f7 f5                	div    %ebp
  801c13:	89 d0                	mov    %edx,%eax
  801c15:	e9 44 ff ff ff       	jmp    801b5e <__umoddi3+0x3e>
  801c1a:	66 90                	xchg   %ax,%ax
  801c1c:	89 c8                	mov    %ecx,%eax
  801c1e:	89 f2                	mov    %esi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	3b 04 24             	cmp    (%esp),%eax
  801c2b:	72 06                	jb     801c33 <__umoddi3+0x113>
  801c2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c31:	77 0f                	ja     801c42 <__umoddi3+0x122>
  801c33:	89 f2                	mov    %esi,%edx
  801c35:	29 f9                	sub    %edi,%ecx
  801c37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c3b:	89 14 24             	mov    %edx,(%esp)
  801c3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c42:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c46:	8b 14 24             	mov    (%esp),%edx
  801c49:	83 c4 1c             	add    $0x1c,%esp
  801c4c:	5b                   	pop    %ebx
  801c4d:	5e                   	pop    %esi
  801c4e:	5f                   	pop    %edi
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    
  801c51:	8d 76 00             	lea    0x0(%esi),%esi
  801c54:	2b 04 24             	sub    (%esp),%eax
  801c57:	19 fa                	sbb    %edi,%edx
  801c59:	89 d1                	mov    %edx,%ecx
  801c5b:	89 c6                	mov    %eax,%esi
  801c5d:	e9 71 ff ff ff       	jmp    801bd3 <__umoddi3+0xb3>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c68:	72 ea                	jb     801c54 <__umoddi3+0x134>
  801c6a:	89 d9                	mov    %ebx,%ecx
  801c6c:	e9 62 ff ff ff       	jmp    801bd3 <__umoddi3+0xb3>
