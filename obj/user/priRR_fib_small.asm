
obj/user/priRR_fib_small:     file format elf32-i386


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
  800031:	e8 a7 00 00 00       	call   8000dd <libmain>
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
	i1 = 8;
  800048:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 44 00 00 00       	call   80009e <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 80 1c 80 00       	push   $0x801c80
  80006e:	e8 7a 05 00 00       	call   8005ed <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	if (res != 34)
  800076:	83 7d f0 22          	cmpl   $0x22,-0x10(%ebp)
  80007a:	74 1a                	je     800096 <_main+0x5e>
		panic("[envID %d] wrong result!", myEnv->env_id);
  80007c:	a1 20 30 80 00       	mov    0x803020,%eax
  800081:	8b 40 10             	mov    0x10(%eax),%eax
  800084:	50                   	push   %eax
  800085:	68 94 1c 80 00       	push   $0x801c94
  80008a:	6a 13                	push   $0x13
  80008c:	68 ad 1c 80 00       	push   $0x801cad
  800091:	e8 f7 01 00 00       	call   80028d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800096:	e8 eb 17 00 00       	call   801886 <inctst>

	return;
  80009b:	90                   	nop
}
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <fibonacci>:


int fibonacci(int n)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	53                   	push   %ebx
  8000a2:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000a9:	7f 07                	jg     8000b2 <fibonacci+0x14>
		return 1 ;
  8000ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b0:	eb 26                	jmp    8000d8 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b5:	48                   	dec    %eax
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	50                   	push   %eax
  8000ba:	e8 df ff ff ff       	call   80009e <fibonacci>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	89 c3                	mov    %eax,%ebx
  8000c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c7:	83 e8 02             	sub    $0x2,%eax
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	50                   	push   %eax
  8000ce:	e8 cb ff ff ff       	call   80009e <fibonacci>
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	01 d8                	add    %ebx,%eax
}
  8000d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    

008000dd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	57                   	push   %edi
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e6:	e8 5d 16 00 00       	call   801748 <sys_getenvindex>
  8000eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f1:	89 d0                	mov    %edx,%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	c1 e0 02             	shl    $0x2,%eax
  8000ff:	01 d0                	add    %edx,%eax
  800101:	c1 e0 03             	shl    $0x3,%eax
  800104:	01 d0                	add    %edx,%eax
  800106:	c1 e0 02             	shl    $0x2,%eax
  800109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8a 40 20             	mov    0x20(%eax),%al
  80011b:	84 c0                	test   %al,%al
  80011d:	74 0d                	je     80012c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80011f:	a1 20 30 80 00       	mov    0x803020,%eax
  800124:	83 c0 20             	add    $0x20,%eax
  800127:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800130:	7e 0a                	jle    80013c <libmain+0x5f>
		binaryname = argv[0];
  800132:	8b 45 0c             	mov    0xc(%ebp),%eax
  800135:	8b 00                	mov    (%eax),%eax
  800137:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 0c             	pushl  0xc(%ebp)
  800142:	ff 75 08             	pushl  0x8(%ebp)
  800145:	e8 ee fe ff ff       	call   800038 <_main>
  80014a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014d:	a1 00 30 80 00       	mov    0x803000,%eax
  800152:	85 c0                	test   %eax,%eax
  800154:	0f 84 01 01 00 00    	je     80025b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80015a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800160:	bb bc 1d 80 00       	mov    $0x801dbc,%ebx
  800165:	ba 0e 00 00 00       	mov    $0xe,%edx
  80016a:	89 c7                	mov    %eax,%edi
  80016c:	89 de                	mov    %ebx,%esi
  80016e:	89 d1                	mov    %edx,%ecx
  800170:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800172:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800175:	b9 56 00 00 00       	mov    $0x56,%ecx
  80017a:	b0 00                	mov    $0x0,%al
  80017c:	89 d7                	mov    %edx,%edi
  80017e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800180:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800187:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	50                   	push   %eax
  80018e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 e4 17 00 00       	call   80197e <sys_utilities>
  80019a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80019d:	e8 2d 13 00 00       	call   8014cf <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	68 dc 1c 80 00       	push   $0x801cdc
  8001aa:	e8 cc 03 00 00       	call   80057b <cprintf>
  8001af:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b5:	85 c0                	test   %eax,%eax
  8001b7:	74 18                	je     8001d1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001b9:	e8 de 17 00 00       	call   80199c <sys_get_optimal_num_faults>
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 04 1d 80 00       	push   $0x801d04
  8001c7:	e8 af 03 00 00       	call   80057b <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	eb 59                	jmp    80022a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d6:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8001dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e1:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	52                   	push   %edx
  8001eb:	50                   	push   %eax
  8001ec:	68 28 1d 80 00       	push   $0x801d28
  8001f1:	e8 85 03 00 00       	call   80057b <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fe:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800204:	a1 20 30 80 00       	mov    0x803020,%eax
  800209:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80021a:	51                   	push   %ecx
  80021b:	52                   	push   %edx
  80021c:	50                   	push   %eax
  80021d:	68 50 1d 80 00       	push   $0x801d50
  800222:	e8 54 03 00 00       	call   80057b <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	50                   	push   %eax
  800239:	68 a8 1d 80 00       	push   $0x801da8
  80023e:	e8 38 03 00 00       	call   80057b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 dc 1c 80 00       	push   $0x801cdc
  80024e:	e8 28 03 00 00       	call   80057b <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800256:	e8 8e 12 00 00       	call   8014e9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80025b:	e8 1f 00 00 00       	call   80027f <exit>
}
  800260:	90                   	nop
  800261:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800264:	5b                   	pop    %ebx
  800265:	5e                   	pop    %esi
  800266:	5f                   	pop    %edi
  800267:	5d                   	pop    %ebp
  800268:	c3                   	ret    

00800269 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	6a 00                	push   $0x0
  800274:	e8 9b 14 00 00       	call   801714 <sys_destroy_env>
  800279:	83 c4 10             	add    $0x10,%esp
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <exit>:

void
exit(void)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800285:	e8 f0 14 00 00       	call   80177a <sys_exit_env>
}
  80028a:	90                   	nop
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800293:	8d 45 10             	lea    0x10(%ebp),%eax
  800296:	83 c0 04             	add    $0x4,%eax
  800299:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	74 16                	je     8002bb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	68 20 1e 80 00       	push   $0x801e20
  8002b3:	e8 c3 02 00 00       	call   80057b <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 28 1e 80 00       	push   $0x801e28
  8002cf:	6a 74                	push   $0x74
  8002d1:	e8 d2 02 00 00       	call   8005a8 <cprintf_colored>
  8002d6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e2:	50                   	push   %eax
  8002e3:	e8 24 02 00 00       	call   80050c <vcprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	6a 00                	push   $0x0
  8002f0:	68 50 1e 80 00       	push   $0x801e50
  8002f5:	e8 12 02 00 00       	call   80050c <vcprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fd:	e8 7d ff ff ff       	call   80027f <exit>

	// should not return here
	while (1) ;
  800302:	eb fe                	jmp    800302 <_panic+0x75>

00800304 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	53                   	push   %ebx
  800308:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80030b:	a1 20 30 80 00       	mov    0x803020,%eax
  800310:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	39 c2                	cmp    %eax,%edx
  80031b:	74 14                	je     800331 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80031d:	83 ec 04             	sub    $0x4,%esp
  800320:	68 54 1e 80 00       	push   $0x801e54
  800325:	6a 26                	push   $0x26
  800327:	68 a0 1e 80 00       	push   $0x801ea0
  80032c:	e8 5c ff ff ff       	call   80028d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800338:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80033f:	e9 d9 00 00 00       	jmp    80041d <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800347:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 d0                	add    %edx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	85 c0                	test   %eax,%eax
  800357:	75 08                	jne    800361 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800359:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80035c:	e9 b9 00 00 00       	jmp    80041a <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800361:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800368:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036f:	eb 79                	jmp    8003ea <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800371:	a1 20 30 80 00       	mov    0x803020,%eax
  800376:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80037c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037f:	89 d0                	mov    %edx,%eax
  800381:	01 c0                	add    %eax,%eax
  800383:	01 d0                	add    %edx,%eax
  800385:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80038c:	01 d8                	add    %ebx,%eax
  80038e:	01 d0                	add    %edx,%eax
  800390:	01 c8                	add    %ecx,%eax
  800392:	8a 40 04             	mov    0x4(%eax),%al
  800395:	84 c0                	test   %al,%al
  800397:	75 4e                	jne    8003e7 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800399:	a1 20 30 80 00       	mov    0x803020,%eax
  80039e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a7:	89 d0                	mov    %edx,%eax
  8003a9:	01 c0                	add    %eax,%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003b4:	01 d8                	add    %ebx,%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	01 c8                	add    %ecx,%eax
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	01 c8                	add    %ecx,%eax
  8003d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003da:	39 c2                	cmp    %eax,%edx
  8003dc:	75 09                	jne    8003e7 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8003de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e5:	eb 19                	jmp    800400 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	ff 45 e8             	incl   -0x18(%ebp)
  8003ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ef:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f8:	39 c2                	cmp    %eax,%edx
  8003fa:	0f 87 71 ff ff ff    	ja     800371 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800400:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800404:	75 14                	jne    80041a <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	68 ac 1e 80 00       	push   $0x801eac
  80040e:	6a 3a                	push   $0x3a
  800410:	68 a0 1e 80 00       	push   $0x801ea0
  800415:	e8 73 fe ff ff       	call   80028d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80041a:	ff 45 f0             	incl   -0x10(%ebp)
  80041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800420:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800423:	0f 8c 1b ff ff ff    	jl     800344 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800429:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800430:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800437:	eb 2e                	jmp    800467 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800439:	a1 20 30 80 00       	mov    0x803020,%eax
  80043e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800444:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800447:	89 d0                	mov    %edx,%eax
  800449:	01 c0                	add    %eax,%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800454:	01 d8                	add    %ebx,%eax
  800456:	01 d0                	add    %edx,%eax
  800458:	01 c8                	add    %ecx,%eax
  80045a:	8a 40 04             	mov    0x4(%eax),%al
  80045d:	3c 01                	cmp    $0x1,%al
  80045f:	75 03                	jne    800464 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800461:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800464:	ff 45 e0             	incl   -0x20(%ebp)
  800467:	a1 20 30 80 00       	mov    0x803020,%eax
  80046c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 c0                	ja     800439 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047f:	74 14                	je     800495 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800481:	83 ec 04             	sub    $0x4,%esp
  800484:	68 00 1f 80 00       	push   $0x801f00
  800489:	6a 44                	push   $0x44
  80048b:	68 a0 1e 80 00       	push   $0x801ea0
  800490:	e8 f8 fd ff ff       	call   80028d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800495:	90                   	nop
  800496:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	53                   	push   %ebx
  80049f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	89 0a                	mov    %ecx,(%edx)
  8004af:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b2:	88 d1                	mov    %dl,%cl
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c5:	75 30                	jne    8004f7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004c7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004cd:	a0 44 30 80 00       	mov    0x803044,%al
  8004d2:	0f b6 c0             	movzbl %al,%eax
  8004d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d8:	8b 09                	mov    (%ecx),%ecx
  8004da:	89 cb                	mov    %ecx,%ebx
  8004dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004df:	83 c1 08             	add    $0x8,%ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	53                   	push   %ebx
  8004e5:	51                   	push   %ecx
  8004e6:	e8 a0 0f 00 00       	call   80148b <sys_cputs>
  8004eb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fa:	8b 40 04             	mov    0x4(%eax),%eax
  8004fd:	8d 50 01             	lea    0x1(%eax),%edx
  800500:	8b 45 0c             	mov    0xc(%ebp),%eax
  800503:	89 50 04             	mov    %edx,0x4(%eax)
}
  800506:	90                   	nop
  800507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80050a:	c9                   	leave  
  80050b:	c3                   	ret    

0080050c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800515:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80051c:	00 00 00 
	b.cnt = 0;
  80051f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800526:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800535:	50                   	push   %eax
  800536:	68 9b 04 80 00       	push   $0x80049b
  80053b:	e8 5a 02 00 00       	call   80079a <vprintfmt>
  800540:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800543:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800549:	a0 44 30 80 00       	mov    0x803044,%al
  80054e:	0f b6 c0             	movzbl %al,%eax
  800551:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800557:	52                   	push   %edx
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800560:	83 c0 08             	add    $0x8,%eax
  800563:	50                   	push   %eax
  800564:	e8 22 0f 00 00       	call   80148b <sys_cputs>
  800569:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80056c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800573:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800579:	c9                   	leave  
  80057a:	c3                   	ret    

0080057b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
  80057e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800581:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800588:	8d 45 0c             	lea    0xc(%ebp),%eax
  80058b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	ff 75 f4             	pushl  -0xc(%ebp)
  800597:	50                   	push   %eax
  800598:	e8 6f ff ff ff       	call   80050c <vcprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ae:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	c1 e0 08             	shl    $0x8,%eax
  8005bb:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c3:	83 c0 04             	add    $0x4,%eax
  8005c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d2:	50                   	push   %eax
  8005d3:	e8 34 ff ff ff       	call   80050c <vcprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005de:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005e5:	07 00 00 

	return cnt;
  8005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005eb:	c9                   	leave  
  8005ec:	c3                   	ret    

008005ed <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005f3:	e8 d7 0e 00 00       	call   8014cf <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005f8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	ff 75 f4             	pushl  -0xc(%ebp)
  800607:	50                   	push   %eax
  800608:	e8 ff fe ff ff       	call   80050c <vcprintf>
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800613:	e8 d1 0e 00 00       	call   8014e9 <sys_unlock_cons>
	return cnt;
  800618:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061b:	c9                   	leave  
  80061c:	c3                   	ret    

0080061d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	53                   	push   %ebx
  800621:	83 ec 14             	sub    $0x14,%esp
  800624:	8b 45 10             	mov    0x10(%ebp),%eax
  800627:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800630:	8b 45 18             	mov    0x18(%ebp),%eax
  800633:	ba 00 00 00 00       	mov    $0x0,%edx
  800638:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80063b:	77 55                	ja     800692 <printnum+0x75>
  80063d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800640:	72 05                	jb     800647 <printnum+0x2a>
  800642:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800645:	77 4b                	ja     800692 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800647:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80064a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80064d:	8b 45 18             	mov    0x18(%ebp),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	ff 75 f4             	pushl  -0xc(%ebp)
  80065a:	ff 75 f0             	pushl  -0x10(%ebp)
  80065d:	e8 aa 13 00 00       	call   801a0c <__udivdi3>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	83 ec 04             	sub    $0x4,%esp
  800668:	ff 75 20             	pushl  0x20(%ebp)
  80066b:	53                   	push   %ebx
  80066c:	ff 75 18             	pushl  0x18(%ebp)
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 0c             	pushl  0xc(%ebp)
  800674:	ff 75 08             	pushl  0x8(%ebp)
  800677:	e8 a1 ff ff ff       	call   80061d <printnum>
  80067c:	83 c4 20             	add    $0x20,%esp
  80067f:	eb 1a                	jmp    80069b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	ff 75 20             	pushl  0x20(%ebp)
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	ff d0                	call   *%eax
  80068f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800692:	ff 4d 1c             	decl   0x1c(%ebp)
  800695:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800699:	7f e6                	jg     800681 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80069e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a9:	53                   	push   %ebx
  8006aa:	51                   	push   %ecx
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	e8 6a 14 00 00       	call   801b1c <__umoddi3>
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	05 74 21 80 00       	add    $0x802174,%eax
  8006ba:	8a 00                	mov    (%eax),%al
  8006bc:	0f be c0             	movsbl %al,%eax
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	50                   	push   %eax
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	ff d0                	call   *%eax
  8006cb:	83 c4 10             	add    $0x10,%esp
}
  8006ce:	90                   	nop
  8006cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006db:	7e 1c                	jle    8006f9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	8d 50 08             	lea    0x8(%eax),%edx
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	89 10                	mov    %edx,(%eax)
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	83 e8 08             	sub    $0x8,%eax
  8006f2:	8b 50 04             	mov    0x4(%eax),%edx
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	eb 40                	jmp    800739 <getuint+0x65>
	else if (lflag)
  8006f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006fd:	74 1e                	je     80071d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	8d 50 04             	lea    0x4(%eax),%edx
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	89 10                	mov    %edx,(%eax)
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	83 e8 04             	sub    $0x4,%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	ba 00 00 00 00       	mov    $0x0,%edx
  80071b:	eb 1c                	jmp    800739 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	8d 50 04             	lea    0x4(%eax),%edx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	89 10                	mov    %edx,(%eax)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	83 e8 04             	sub    $0x4,%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800739:	5d                   	pop    %ebp
  80073a:	c3                   	ret    

0080073b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80073e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800742:	7e 1c                	jle    800760 <getint+0x25>
		return va_arg(*ap, long long);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 08             	lea    0x8(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 08             	sub    $0x8,%eax
  800759:	8b 50 04             	mov    0x4(%eax),%edx
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	eb 38                	jmp    800798 <getint+0x5d>
	else if (lflag)
  800760:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800764:	74 1a                	je     800780 <getint+0x45>
		return va_arg(*ap, long);
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	8d 50 04             	lea    0x4(%eax),%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	89 10                	mov    %edx,(%eax)
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	83 e8 04             	sub    $0x4,%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	99                   	cltd   
  80077e:	eb 18                	jmp    800798 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
}
  800798:	5d                   	pop    %ebp
  800799:	c3                   	ret    

0080079a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	56                   	push   %esi
  80079e:	53                   	push   %ebx
  80079f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a2:	eb 17                	jmp    8007bb <vprintfmt+0x21>
			if (ch == '\0')
  8007a4:	85 db                	test   %ebx,%ebx
  8007a6:	0f 84 c1 03 00 00    	je     800b6d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	53                   	push   %ebx
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007be:	8d 50 01             	lea    0x1(%eax),%edx
  8007c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c4:	8a 00                	mov    (%eax),%al
  8007c6:	0f b6 d8             	movzbl %al,%ebx
  8007c9:	83 fb 25             	cmp    $0x25,%ebx
  8007cc:	75 d6                	jne    8007a4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007d2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	8d 50 01             	lea    0x1(%eax),%edx
  8007f4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f7:	8a 00                	mov    (%eax),%al
  8007f9:	0f b6 d8             	movzbl %al,%ebx
  8007fc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007ff:	83 f8 5b             	cmp    $0x5b,%eax
  800802:	0f 87 3d 03 00 00    	ja     800b45 <vprintfmt+0x3ab>
  800808:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  80080f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800811:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800815:	eb d7                	jmp    8007ee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800817:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80081b:	eb d1                	jmp    8007ee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80081d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800824:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	c1 e0 02             	shl    $0x2,%eax
  80082c:	01 d0                	add    %edx,%eax
  80082e:	01 c0                	add    %eax,%eax
  800830:	01 d8                	add    %ebx,%eax
  800832:	83 e8 30             	sub    $0x30,%eax
  800835:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800838:	8b 45 10             	mov    0x10(%ebp),%eax
  80083b:	8a 00                	mov    (%eax),%al
  80083d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800840:	83 fb 2f             	cmp    $0x2f,%ebx
  800843:	7e 3e                	jle    800883 <vprintfmt+0xe9>
  800845:	83 fb 39             	cmp    $0x39,%ebx
  800848:	7f 39                	jg     800883 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80084d:	eb d5                	jmp    800824 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	83 c0 04             	add    $0x4,%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 e8 04             	sub    $0x4,%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800863:	eb 1f                	jmp    800884 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800865:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800869:	79 83                	jns    8007ee <vprintfmt+0x54>
				width = 0;
  80086b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800872:	e9 77 ff ff ff       	jmp    8007ee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800877:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80087e:	e9 6b ff ff ff       	jmp    8007ee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800883:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800888:	0f 89 60 ff ff ff    	jns    8007ee <vprintfmt+0x54>
				width = precision, precision = -1;
  80088e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800894:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80089b:	e9 4e ff ff ff       	jmp    8007ee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008a3:	e9 46 ff ff ff       	jmp    8007ee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 c0 04             	add    $0x4,%eax
  8008ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 e8 04             	sub    $0x4,%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
			break;
  8008c8:	e9 9b 02 00 00       	jmp    800b68 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 c0 04             	add    $0x4,%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 e8 04             	sub    $0x4,%eax
  8008dc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008de:	85 db                	test   %ebx,%ebx
  8008e0:	79 02                	jns    8008e4 <vprintfmt+0x14a>
				err = -err;
  8008e2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008e4:	83 fb 64             	cmp    $0x64,%ebx
  8008e7:	7f 0b                	jg     8008f4 <vprintfmt+0x15a>
  8008e9:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  8008f0:	85 f6                	test   %esi,%esi
  8008f2:	75 19                	jne    80090d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f4:	53                   	push   %ebx
  8008f5:	68 85 21 80 00       	push   $0x802185
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	ff 75 08             	pushl  0x8(%ebp)
  800900:	e8 70 02 00 00       	call   800b75 <printfmt>
  800905:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800908:	e9 5b 02 00 00       	jmp    800b68 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80090d:	56                   	push   %esi
  80090e:	68 8e 21 80 00       	push   $0x80218e
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	ff 75 08             	pushl  0x8(%ebp)
  800919:	e8 57 02 00 00       	call   800b75 <printfmt>
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 42 02 00 00       	jmp    800b68 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 30                	mov    (%eax),%esi
  800937:	85 f6                	test   %esi,%esi
  800939:	75 05                	jne    800940 <vprintfmt+0x1a6>
				p = "(null)";
  80093b:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800940:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800944:	7e 6d                	jle    8009b3 <vprintfmt+0x219>
  800946:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80094a:	74 67                	je     8009b3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	50                   	push   %eax
  800953:	56                   	push   %esi
  800954:	e8 1e 03 00 00       	call   800c77 <strnlen>
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80095f:	eb 16                	jmp    800977 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800961:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	50                   	push   %eax
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800974:	ff 4d e4             	decl   -0x1c(%ebp)
  800977:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097b:	7f e4                	jg     800961 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097d:	eb 34                	jmp    8009b3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80097f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800983:	74 1c                	je     8009a1 <vprintfmt+0x207>
  800985:	83 fb 1f             	cmp    $0x1f,%ebx
  800988:	7e 05                	jle    80098f <vprintfmt+0x1f5>
  80098a:	83 fb 7e             	cmp    $0x7e,%ebx
  80098d:	7e 12                	jle    8009a1 <vprintfmt+0x207>
					putch('?', putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	6a 3f                	push   $0x3f
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	ff d0                	call   *%eax
  80099c:	83 c4 10             	add    $0x10,%esp
  80099f:	eb 0f                	jmp    8009b0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b3:	89 f0                	mov    %esi,%eax
  8009b5:	8d 70 01             	lea    0x1(%eax),%esi
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
  8009bd:	85 db                	test   %ebx,%ebx
  8009bf:	74 24                	je     8009e5 <vprintfmt+0x24b>
  8009c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c5:	78 b8                	js     80097f <vprintfmt+0x1e5>
  8009c7:	ff 4d e0             	decl   -0x20(%ebp)
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	79 af                	jns    80097f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d0:	eb 13                	jmp    8009e5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	6a 20                	push   $0x20
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e9:	7f e7                	jg     8009d2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009eb:	e9 78 01 00 00       	jmp    800b68 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f9:	50                   	push   %eax
  8009fa:	e8 3c fd ff ff       	call   80073b <getint>
  8009ff:	83 c4 10             	add    $0x10,%esp
  800a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0e:	85 d2                	test   %edx,%edx
  800a10:	79 23                	jns    800a35 <vprintfmt+0x29b>
				putch('-', putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	6a 2d                	push   $0x2d
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	f7 d8                	neg    %eax
  800a2a:	83 d2 00             	adc    $0x0,%edx
  800a2d:	f7 da                	neg    %edx
  800a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3c:	e9 bc 00 00 00       	jmp    800afd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 e8             	pushl  -0x18(%ebp)
  800a47:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4a:	50                   	push   %eax
  800a4b:	e8 84 fc ff ff       	call   8006d4 <getuint>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a59:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a60:	e9 98 00 00 00       	jmp    800afd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	6a 58                	push   $0x58
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	6a 58                	push   $0x58
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	6a 58                	push   $0x58
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
			break;
  800a95:	e9 ce 00 00 00       	jmp    800b68 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 30                	push   $0x30
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 0c             	pushl  0xc(%ebp)
  800ab0:	6a 78                	push   $0x78
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	ff d0                	call   *%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 e8 04             	sub    $0x4,%eax
  800ac9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ace:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ad5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800adc:	eb 1f                	jmp    800afd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae7:	50                   	push   %eax
  800ae8:	e8 e7 fb ff ff       	call   8006d4 <getuint>
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800af6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800afd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b04:	83 ec 04             	sub    $0x4,%esp
  800b07:	52                   	push   %edx
  800b08:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b0b:	50                   	push   %eax
  800b0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0f:	ff 75 f0             	pushl  -0x10(%ebp)
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	ff 75 08             	pushl  0x8(%ebp)
  800b18:	e8 00 fb ff ff       	call   80061d <printnum>
  800b1d:	83 c4 20             	add    $0x20,%esp
			break;
  800b20:	eb 46                	jmp    800b68 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	53                   	push   %ebx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	ff d0                	call   *%eax
  800b2e:	83 c4 10             	add    $0x10,%esp
			break;
  800b31:	eb 35                	jmp    800b68 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b33:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b3a:	eb 2c                	jmp    800b68 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b3c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b43:	eb 23                	jmp    800b68 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	6a 25                	push   $0x25
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b55:	ff 4d 10             	decl   0x10(%ebp)
  800b58:	eb 03                	jmp    800b5d <vprintfmt+0x3c3>
  800b5a:	ff 4d 10             	decl   0x10(%ebp)
  800b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b60:	48                   	dec    %eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	3c 25                	cmp    $0x25,%al
  800b65:	75 f3                	jne    800b5a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b67:	90                   	nop
		}
	}
  800b68:	e9 35 fc ff ff       	jmp    8007a2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7e:	83 c0 04             	add    $0x4,%eax
  800b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 04 fc ff ff       	call   80079a <vprintfmt>
  800b96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b99:	90                   	nop
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	8b 40 08             	mov    0x8(%eax),%eax
  800ba5:	8d 50 01             	lea    0x1(%eax),%edx
  800ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	8b 10                	mov    (%eax),%edx
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb6:	8b 40 04             	mov    0x4(%eax),%eax
  800bb9:	39 c2                	cmp    %eax,%edx
  800bbb:	73 12                	jae    800bcf <sprintputch+0x33>
		*b->buf++ = ch;
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	8b 00                	mov    (%eax),%eax
  800bc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc8:	89 0a                	mov    %ecx,(%edx)
  800bca:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcd:	88 10                	mov    %dl,(%eax)
}
  800bcf:	90                   	nop
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	01 d0                	add    %edx,%eax
  800be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf7:	74 06                	je     800bff <vsnprintf+0x2d>
  800bf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfd:	7f 07                	jg     800c06 <vsnprintf+0x34>
		return -E_INVAL;
  800bff:	b8 03 00 00 00       	mov    $0x3,%eax
  800c04:	eb 20                	jmp    800c26 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c06:	ff 75 14             	pushl  0x14(%ebp)
  800c09:	ff 75 10             	pushl  0x10(%ebp)
  800c0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0f:	50                   	push   %eax
  800c10:	68 9c 0b 80 00       	push   $0x800b9c
  800c15:	e8 80 fb ff ff       	call   80079a <vprintfmt>
  800c1a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c20:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c26:	c9                   	leave  
  800c27:	c3                   	ret    

00800c28 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c31:	83 c0 04             	add    $0x4,%eax
  800c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	ff 75 08             	pushl  0x8(%ebp)
  800c44:	e8 89 ff ff ff       	call   800bd2 <vsnprintf>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c61:	eb 06                	jmp    800c69 <strlen+0x15>
		n++;
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c66:	ff 45 08             	incl   0x8(%ebp)
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	84 c0                	test   %al,%al
  800c70:	75 f1                	jne    800c63 <strlen+0xf>
		n++;
	return n;
  800c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c84:	eb 09                	jmp    800c8f <strnlen+0x18>
		n++;
  800c86:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c89:	ff 45 08             	incl   0x8(%ebp)
  800c8c:	ff 4d 0c             	decl   0xc(%ebp)
  800c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c93:	74 09                	je     800c9e <strnlen+0x27>
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	75 e8                	jne    800c86 <strnlen+0xf>
		n++;
	return n;
  800c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800caf:	90                   	nop
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8d 50 01             	lea    0x1(%eax),%edx
  800cb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc2:	8a 12                	mov    (%edx),%dl
  800cc4:	88 10                	mov    %dl,(%eax)
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	84 c0                	test   %al,%al
  800cca:	75 e4                	jne    800cb0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ccc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 1f                	jmp    800d05 <strncpy+0x34>
		*dst++ = *src;
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8d 50 01             	lea    0x1(%eax),%edx
  800cec:	89 55 08             	mov    %edx,0x8(%ebp)
  800cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf2:	8a 12                	mov    (%edx),%dl
  800cf4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	84 c0                	test   %al,%al
  800cfd:	74 03                	je     800d02 <strncpy+0x31>
			src++;
  800cff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d02:	ff 45 fc             	incl   -0x4(%ebp)
  800d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d08:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0b:	72 d9                	jb     800ce6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d22:	74 30                	je     800d54 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d24:	eb 16                	jmp    800d3c <strlcpy+0x2a>
			*dst++ = *src++;
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d38:	8a 12                	mov    (%edx),%dl
  800d3a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d43:	74 09                	je     800d4e <strlcpy+0x3c>
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	84 c0                	test   %al,%al
  800d4c:	75 d8                	jne    800d26 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5a:	29 c2                	sub    %eax,%edx
  800d5c:	89 d0                	mov    %edx,%eax
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d63:	eb 06                	jmp    800d6b <strcmp+0xb>
		p++, q++;
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	74 0e                	je     800d82 <strcmp+0x22>
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 10                	mov    (%eax),%dl
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	38 c2                	cmp    %al,%dl
  800d80:	74 e3                	je     800d65 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f b6 d0             	movzbl %al,%edx
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 c0             	movzbl %al,%eax
  800d92:	29 c2                	sub    %eax,%edx
  800d94:	89 d0                	mov    %edx,%eax
}
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9b:	eb 09                	jmp    800da6 <strncmp+0xe>
		n--, p++, q++;
  800d9d:	ff 4d 10             	decl   0x10(%ebp)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800daa:	74 17                	je     800dc3 <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	84 c0                	test   %al,%al
  800db3:	74 0e                	je     800dc3 <strncmp+0x2b>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 10                	mov    (%eax),%dl
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	38 c2                	cmp    %al,%dl
  800dc1:	74 da                	je     800d9d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc7:	75 07                	jne    800dd0 <strncmp+0x38>
		return 0;
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dce:	eb 14                	jmp    800de4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	0f b6 d0             	movzbl %al,%edx
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 c0             	movzbl %al,%eax
  800de0:	29 c2                	sub    %eax,%edx
  800de2:	89 d0                	mov    %edx,%eax
}
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 04             	sub    $0x4,%esp
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df2:	eb 12                	jmp    800e06 <strchr+0x20>
		if (*s == c)
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfc:	75 05                	jne    800e03 <strchr+0x1d>
			return (char *) s;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	eb 11                	jmp    800e14 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 e5                	jne    800df4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 04             	sub    $0x4,%esp
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e22:	eb 0d                	jmp    800e31 <strfind+0x1b>
		if (*s == c)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2c:	74 0e                	je     800e3c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e2e:	ff 45 08             	incl   0x8(%ebp)
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	84 c0                	test   %al,%al
  800e38:	75 ea                	jne    800e24 <strfind+0xe>
  800e3a:	eb 01                	jmp    800e3d <strfind+0x27>
		if (*s == c)
			break;
  800e3c:	90                   	nop
	return (char *) s;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e4e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e52:	76 63                	jbe    800eb7 <memset+0x75>
		uint64 data_block = c;
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	99                   	cltd   
  800e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e64:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e68:	c1 e0 08             	shl    $0x8,%eax
  800e6b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e6e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e77:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e7b:	c1 e0 10             	shl    $0x10,%eax
  800e7e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e81:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8a:	89 c2                	mov    %eax,%edx
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e91:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e94:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e97:	eb 18                	jmp    800eb1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e99:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e9c:	8d 41 08             	lea    0x8(%ecx),%eax
  800e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea8:	89 01                	mov    %eax,(%ecx)
  800eaa:	89 51 04             	mov    %edx,0x4(%ecx)
  800ead:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eb1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb5:	77 e2                	ja     800e99 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	74 23                	je     800ee0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ec3:	eb 0e                	jmp    800ed3 <memset+0x91>
			*p8++ = (uint8)c;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec8:	8d 50 01             	lea    0x1(%eax),%edx
  800ecb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed9:	89 55 10             	mov    %edx,0x10(%ebp)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	75 e5                	jne    800ec5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ef7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efb:	76 24                	jbe    800f21 <memcpy+0x3c>
		while(n >= 8){
  800efd:	eb 1c                	jmp    800f1b <memcpy+0x36>
			*d64 = *s64;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0a:	89 01                	mov    %eax,(%ecx)
  800f0c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f0f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f13:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f17:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f1b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f1f:	77 de                	ja     800eff <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 31                	je     800f58 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f33:	eb 16                	jmp    800f4b <memcpy+0x66>
			*d8++ = *s8++;
  800f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f38:	8d 50 01             	lea    0x1(%eax),%edx
  800f3b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f44:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f47:	8a 12                	mov    (%edx),%dl
  800f49:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f51:	89 55 10             	mov    %edx,0x10(%ebp)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	75 dd                	jne    800f35 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f72:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f75:	73 50                	jae    800fc7 <memmove+0x6a>
  800f77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f82:	76 43                	jbe    800fc7 <memmove+0x6a>
		s += n;
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f90:	eb 10                	jmp    800fa2 <memmove+0x45>
			*--d = *--s;
  800f92:	ff 4d f8             	decl   -0x8(%ebp)
  800f95:	ff 4d fc             	decl   -0x4(%ebp)
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 10                	mov    (%eax),%dl
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	75 e3                	jne    800f92 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800faf:	eb 23                	jmp    800fd4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb4:	8d 50 01             	lea    0x1(%eax),%edx
  800fb7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc3:	8a 12                	mov    (%edx),%dl
  800fc5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	75 dd                	jne    800fb1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800feb:	eb 2a                	jmp    801017 <memcmp+0x3e>
		if (*s1 != *s2)
  800fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff0:	8a 10                	mov    (%eax),%dl
  800ff2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	38 c2                	cmp    %al,%dl
  800ff9:	74 16                	je     801011 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 d0             	movzbl %al,%edx
  801003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f b6 c0             	movzbl %al,%eax
  80100b:	29 c2                	sub    %eax,%edx
  80100d:	89 d0                	mov    %edx,%eax
  80100f:	eb 18                	jmp    801029 <memcmp+0x50>
		s1++, s2++;
  801011:	ff 45 fc             	incl   -0x4(%ebp)
  801014:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 c9                	jne    800fed <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801024:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103c:	eb 15                	jmp    801053 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 d0             	movzbl %al,%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	0f b6 c0             	movzbl %al,%eax
  80104c:	39 c2                	cmp    %eax,%edx
  80104e:	74 0d                	je     80105d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801050:	ff 45 08             	incl   0x8(%ebp)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801059:	72 e3                	jb     80103e <memfind+0x13>
  80105b:	eb 01                	jmp    80105e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105d:	90                   	nop
	return (void *) s;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801069:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801070:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801077:	eb 03                	jmp    80107c <strtol+0x19>
		s++;
  801079:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	3c 20                	cmp    $0x20,%al
  801083:	74 f4                	je     801079 <strtol+0x16>
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3c 09                	cmp    $0x9,%al
  80108c:	74 eb                	je     801079 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	3c 2b                	cmp    $0x2b,%al
  801095:	75 05                	jne    80109c <strtol+0x39>
		s++;
  801097:	ff 45 08             	incl   0x8(%ebp)
  80109a:	eb 13                	jmp    8010af <strtol+0x4c>
	else if (*s == '-')
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 2d                	cmp    $0x2d,%al
  8010a3:	75 0a                	jne    8010af <strtol+0x4c>
		s++, neg = 1;
  8010a5:	ff 45 08             	incl   0x8(%ebp)
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b3:	74 06                	je     8010bb <strtol+0x58>
  8010b5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b9:	75 20                	jne    8010db <strtol+0x78>
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 30                	cmp    $0x30,%al
  8010c2:	75 17                	jne    8010db <strtol+0x78>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	40                   	inc    %eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 78                	cmp    $0x78,%al
  8010cc:	75 0d                	jne    8010db <strtol+0x78>
		s += 2, base = 16;
  8010ce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d9:	eb 28                	jmp    801103 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010df:	75 15                	jne    8010f6 <strtol+0x93>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 30                	cmp    $0x30,%al
  8010e8:	75 0c                	jne    8010f6 <strtol+0x93>
		s++, base = 8;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f4:	eb 0d                	jmp    801103 <strtol+0xa0>
	else if (base == 0)
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	75 07                	jne    801103 <strtol+0xa0>
		base = 10;
  8010fc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	3c 2f                	cmp    $0x2f,%al
  80110a:	7e 19                	jle    801125 <strtol+0xc2>
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 39                	cmp    $0x39,%al
  801113:	7f 10                	jg     801125 <strtol+0xc2>
			dig = *s - '0';
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	0f be c0             	movsbl %al,%eax
  80111d:	83 e8 30             	sub    $0x30,%eax
  801120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801123:	eb 42                	jmp    801167 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 60                	cmp    $0x60,%al
  80112c:	7e 19                	jle    801147 <strtol+0xe4>
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	3c 7a                	cmp    $0x7a,%al
  801135:	7f 10                	jg     801147 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f be c0             	movsbl %al,%eax
  80113f:	83 e8 57             	sub    $0x57,%eax
  801142:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801145:	eb 20                	jmp    801167 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 40                	cmp    $0x40,%al
  80114e:	7e 39                	jle    801189 <strtol+0x126>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	3c 5a                	cmp    $0x5a,%al
  801157:	7f 30                	jg     801189 <strtol+0x126>
			dig = *s - 'A' + 10;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	0f be c0             	movsbl %al,%eax
  801161:	83 e8 37             	sub    $0x37,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116d:	7d 19                	jge    801188 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80116f:	ff 45 08             	incl   0x8(%ebp)
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	0f af 45 10          	imul   0x10(%ebp),%eax
  801179:	89 c2                	mov    %eax,%edx
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801183:	e9 7b ff ff ff       	jmp    801103 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801188:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801189:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118d:	74 08                	je     801197 <strtol+0x134>
		*endptr = (char *) s;
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	8b 55 08             	mov    0x8(%ebp),%edx
  801195:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801197:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119b:	74 07                	je     8011a4 <strtol+0x141>
  80119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a0:	f7 d8                	neg    %eax
  8011a2:	eb 03                	jmp    8011a7 <strtol+0x144>
  8011a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <ltostr>:

void
ltostr(long value, char *str)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c1:	79 13                	jns    8011d6 <ltostr+0x2d>
	{
		neg = 1;
  8011c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011de:	99                   	cltd   
  8011df:	f7 f9                	idiv   %ecx
  8011e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ed:	89 c2                	mov    %eax,%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f7:	83 c2 30             	add    $0x30,%edx
  8011fa:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ff:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801204:	f7 e9                	imul   %ecx
  801206:	c1 fa 02             	sar    $0x2,%edx
  801209:	89 c8                	mov    %ecx,%eax
  80120b:	c1 f8 1f             	sar    $0x1f,%eax
  80120e:	29 c2                	sub    %eax,%edx
  801210:	89 d0                	mov    %edx,%eax
  801212:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801215:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801219:	75 bb                	jne    8011d6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	48                   	dec    %eax
  801226:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801229:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122d:	74 3d                	je     80126c <ltostr+0xc3>
		start = 1 ;
  80122f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801236:	eb 34                	jmp    80126c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801238:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	01 d0                	add    %edx,%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 c2                	add    %eax,%edx
  80124d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 c8                	add    %ecx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 c2                	add    %eax,%edx
  801261:	8a 45 eb             	mov    -0x15(%ebp),%al
  801264:	88 02                	mov    %al,(%edx)
		start++ ;
  801266:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801269:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801272:	7c c4                	jl     801238 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801274:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801288:	ff 75 08             	pushl  0x8(%ebp)
  80128b:	e8 c4 f9 ff ff       	call   800c54 <strlen>
  801290:	83 c4 04             	add    $0x4,%esp
  801293:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 b6 f9 ff ff       	call   800c54 <strlen>
  80129e:	83 c4 04             	add    $0x4,%esp
  8012a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b2:	eb 17                	jmp    8012cb <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	01 c8                	add    %ecx,%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c8:	ff 45 fc             	incl   -0x4(%ebp)
  8012cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d1:	7c e1                	jl     8012b4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e1:	eb 1f                	jmp    801302 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e6:	8d 50 01             	lea    0x1(%eax),%edx
  8012e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 c2                	add    %eax,%edx
  8012f3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 c8                	add    %ecx,%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ff:	ff 45 f8             	incl   -0x8(%ebp)
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801308:	7c d9                	jl     8012e3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	c6 00 00             	movb   $0x0,(%eax)
}
  801315:	90                   	nop
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801324:	8b 45 14             	mov    0x14(%ebp),%eax
  801327:	8b 00                	mov    (%eax),%eax
  801329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801330:	8b 45 10             	mov    0x10(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133b:	eb 0c                	jmp    801349 <strsplit+0x31>
			*string++ = 0;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 08             	mov    %edx,0x8(%ebp)
  801346:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	84 c0                	test   %al,%al
  801350:	74 18                	je     80136a <strsplit+0x52>
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f be c0             	movsbl %al,%eax
  80135a:	50                   	push   %eax
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	e8 83 fa ff ff       	call   800de6 <strchr>
  801363:	83 c4 08             	add    $0x8,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	75 d3                	jne    80133d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 5a                	je     8013cd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	83 f8 0f             	cmp    $0xf,%eax
  80137b:	75 07                	jne    801384 <strsplit+0x6c>
		{
			return 0;
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	eb 66                	jmp    8013ea <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801384:	8b 45 14             	mov    0x14(%ebp),%eax
  801387:	8b 00                	mov    (%eax),%eax
  801389:	8d 48 01             	lea    0x1(%eax),%ecx
  80138c:	8b 55 14             	mov    0x14(%ebp),%edx
  80138f:	89 0a                	mov    %ecx,(%edx)
  801391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 c2                	add    %eax,%edx
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a2:	eb 03                	jmp    8013a7 <strsplit+0x8f>
			string++;
  8013a4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	84 c0                	test   %al,%al
  8013ae:	74 8b                	je     80133b <strsplit+0x23>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	0f be c0             	movsbl %al,%eax
  8013b8:	50                   	push   %eax
  8013b9:	ff 75 0c             	pushl  0xc(%ebp)
  8013bc:	e8 25 fa ff ff       	call   800de6 <strchr>
  8013c1:	83 c4 08             	add    $0x8,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	74 dc                	je     8013a4 <strsplit+0x8c>
			string++;
	}
  8013c8:	e9 6e ff ff ff       	jmp    80133b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013cd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013da:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dd:	01 d0                	add    %edx,%eax
  8013df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ff:	eb 4a                	jmp    80144b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	01 c2                	add    %eax,%edx
  801409:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 c8                	add    %ecx,%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801415:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 40                	cmp    $0x40,%al
  801421:	7e 25                	jle    801448 <str2lower+0x5c>
  801423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 5a                	cmp    $0x5a,%al
  80142f:	7f 17                	jg     801448 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	01 d0                	add    %edx,%eax
  801439:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143c:	8b 55 08             	mov    0x8(%ebp),%edx
  80143f:	01 ca                	add    %ecx,%edx
  801441:	8a 12                	mov    (%edx),%dl
  801443:	83 c2 20             	add    $0x20,%edx
  801446:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801448:	ff 45 fc             	incl   -0x4(%ebp)
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	e8 01 f8 ff ff       	call   800c54 <strlen>
  801453:	83 c4 04             	add    $0x4,%esp
  801456:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801459:	7f a6                	jg     801401 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	57                   	push   %edi
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
  801466:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801472:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801475:	8b 7d 18             	mov    0x18(%ebp),%edi
  801478:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147b:	cd 30                	int    $0x30
  80147d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801480:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5f                   	pop    %edi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    

0080148b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801497:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	51                   	push   %ecx
  8014a4:	52                   	push   %edx
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	50                   	push   %eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	e8 b0 ff ff ff       	call   801460 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	90                   	nop
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 02                	push   $0x2
  8014c5:	e8 96 ff ff ff       	call   801460 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 03                	push   $0x3
  8014de:	e8 7d ff ff ff       	call   801460 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	90                   	nop
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 04                	push   $0x4
  8014f8:	e8 63 ff ff ff       	call   801460 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	90                   	nop
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801506:	8b 55 0c             	mov    0xc(%ebp),%edx
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	52                   	push   %edx
  801513:	50                   	push   %eax
  801514:	6a 08                	push   $0x8
  801516:	e8 45 ff ff ff       	call   801460 <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801525:	8b 75 18             	mov    0x18(%ebp),%esi
  801528:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	56                   	push   %esi
  801535:	53                   	push   %ebx
  801536:	51                   	push   %ecx
  801537:	52                   	push   %edx
  801538:	50                   	push   %eax
  801539:	6a 09                	push   $0x9
  80153b:	e8 20 ff ff ff       	call   801460 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    

0080154a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	ff 75 08             	pushl  0x8(%ebp)
  801558:	6a 0a                	push   $0xa
  80155a:	e8 01 ff ff ff       	call   801460 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	ff 75 08             	pushl  0x8(%ebp)
  801573:	6a 0b                	push   $0xb
  801575:	e8 e6 fe ff ff       	call   801460 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 0c                	push   $0xc
  80158e:	e8 cd fe ff ff       	call   801460 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 0d                	push   $0xd
  8015a7:	e8 b4 fe ff ff       	call   801460 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 0e                	push   $0xe
  8015c0:	e8 9b fe ff ff       	call   801460 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0f                	push   $0xf
  8015d9:	e8 82 fe ff ff       	call   801460 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	ff 75 08             	pushl  0x8(%ebp)
  8015f1:	6a 10                	push   $0x10
  8015f3:	e8 68 fe ff ff       	call   801460 <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 11                	push   $0x11
  80160c:	e8 4f fe ff ff       	call   801460 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	90                   	nop
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_cputc>:

void
sys_cputc(const char c)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801623:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	50                   	push   %eax
  801630:	6a 01                	push   $0x1
  801632:	e8 29 fe ff ff       	call   801460 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 14                	push   $0x14
  80164c:	e8 0f fe ff ff       	call   801460 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801663:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801666:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	6a 00                	push   $0x0
  80166f:	51                   	push   %ecx
  801670:	52                   	push   %edx
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	50                   	push   %eax
  801675:	6a 15                	push   $0x15
  801677:	e8 e4 fd ff ff       	call   801460 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801684:	8b 55 0c             	mov    0xc(%ebp),%edx
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	52                   	push   %edx
  801691:	50                   	push   %eax
  801692:	6a 16                	push   $0x16
  801694:	e8 c7 fd ff ff       	call   801460 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	51                   	push   %ecx
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 17                	push   $0x17
  8016b3:	e8 a8 fd ff ff       	call   801460 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	52                   	push   %edx
  8016cd:	50                   	push   %eax
  8016ce:	6a 18                	push   $0x18
  8016d0:	e8 8b fd ff ff       	call   801460 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 14             	pushl  0x14(%ebp)
  8016e5:	ff 75 10             	pushl  0x10(%ebp)
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	50                   	push   %eax
  8016ec:	6a 19                	push   $0x19
  8016ee:	e8 6d fd ff ff       	call   801460 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	50                   	push   %eax
  801707:	6a 1a                	push   $0x1a
  801709:	e8 52 fd ff ff       	call   801460 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	90                   	nop
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	50                   	push   %eax
  801723:	6a 1b                	push   $0x1b
  801725:	e8 36 fd ff ff       	call   801460 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 05                	push   $0x5
  80173e:	e8 1d fd ff ff       	call   801460 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 06                	push   $0x6
  801757:	e8 04 fd ff ff       	call   801460 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 07                	push   $0x7
  801770:	e8 eb fc ff ff       	call   801460 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_exit_env>:


void sys_exit_env(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 1c                	push   $0x1c
  801789:	e8 d2 fc ff ff       	call   801460 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179d:	8d 50 04             	lea    0x4(%eax),%edx
  8017a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 1d                	push   $0x1d
  8017ad:	e8 ae fc ff ff       	call   801460 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017be:	89 01                	mov    %eax,(%ecx)
  8017c0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	c9                   	leave  
  8017c7:	c2 04 00             	ret    $0x4

008017ca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 10             	pushl  0x10(%ebp)
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	6a 13                	push   $0x13
  8017dc:	e8 7f fc ff ff       	call   801460 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e4:	90                   	nop
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 1e                	push   $0x1e
  8017f6:	e8 65 fc ff ff       	call   801460 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80180c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	50                   	push   %eax
  801819:	6a 1f                	push   $0x1f
  80181b:	e8 40 fc ff ff       	call   801460 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return ;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <rsttst>:
void rsttst()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 21                	push   $0x21
  801835:	e8 26 fc ff ff       	call   801460 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return ;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80184c:	8b 55 18             	mov    0x18(%ebp),%edx
  80184f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	ff 75 08             	pushl  0x8(%ebp)
  80185e:	6a 20                	push   $0x20
  801860:	e8 fb fb ff ff       	call   801460 <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
	return ;
  801868:	90                   	nop
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <chktst>:
void chktst(uint32 n)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	6a 22                	push   $0x22
  80187b:	e8 e0 fb ff ff       	call   801460 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return ;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <inctst>:

void inctst()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 23                	push   $0x23
  801895:	e8 c6 fb ff ff       	call   801460 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
	return ;
  80189d:	90                   	nop
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <gettst>:
uint32 gettst()
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 24                	push   $0x24
  8018af:	e8 ac fb ff ff       	call   801460 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 25                	push   $0x25
  8018c8:	e8 93 fb ff ff       	call   801460 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
  8018d0:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018d5:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 08             	pushl  0x8(%ebp)
  8018f2:	6a 26                	push   $0x26
  8018f4:	e8 67 fb ff ff       	call   801460 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fc:	90                   	nop
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801903:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801906:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	53                   	push   %ebx
  801912:	51                   	push   %ecx
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	6a 27                	push   $0x27
  801917:	e8 44 fb ff ff       	call   801460 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 28                	push   $0x28
  801937:	e8 24 fb ff ff       	call   801460 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801944:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	51                   	push   %ecx
  801950:	ff 75 10             	pushl  0x10(%ebp)
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 29                	push   $0x29
  801957:	e8 04 fb ff ff       	call   801460 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	ff 75 10             	pushl  0x10(%ebp)
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 12                	push   $0x12
  801973:	e8 e8 fa ff ff       	call   801460 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
	return ;
  80197b:	90                   	nop
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801981:	8b 55 0c             	mov    0xc(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 2a                	push   $0x2a
  801991:	e8 ca fa ff ff       	call   801460 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
	return;
  801999:	90                   	nop
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 2b                	push   $0x2b
  8019ab:	e8 b0 fa ff ff       	call   801460 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	6a 2d                	push   $0x2d
  8019c6:	e8 95 fa ff ff       	call   801460 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
	return;
  8019ce:	90                   	nop
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	ff 75 08             	pushl  0x8(%ebp)
  8019e0:	6a 2c                	push   $0x2c
  8019e2:	e8 79 fa ff ff       	call   801460 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 2e                	push   $0x2e
  801a00:	e8 5b fa ff ff       	call   801460 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
	return ;
  801a08:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    
  801a0b:	90                   	nop

00801a0c <__udivdi3>:
  801a0c:	55                   	push   %ebp
  801a0d:	57                   	push   %edi
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 1c             	sub    $0x1c,%esp
  801a13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a23:	89 ca                	mov    %ecx,%edx
  801a25:	89 f8                	mov    %edi,%eax
  801a27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a2b:	85 f6                	test   %esi,%esi
  801a2d:	75 2d                	jne    801a5c <__udivdi3+0x50>
  801a2f:	39 cf                	cmp    %ecx,%edi
  801a31:	77 65                	ja     801a98 <__udivdi3+0x8c>
  801a33:	89 fd                	mov    %edi,%ebp
  801a35:	85 ff                	test   %edi,%edi
  801a37:	75 0b                	jne    801a44 <__udivdi3+0x38>
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	31 d2                	xor    %edx,%edx
  801a40:	f7 f7                	div    %edi
  801a42:	89 c5                	mov    %eax,%ebp
  801a44:	31 d2                	xor    %edx,%edx
  801a46:	89 c8                	mov    %ecx,%eax
  801a48:	f7 f5                	div    %ebp
  801a4a:	89 c1                	mov    %eax,%ecx
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	f7 f5                	div    %ebp
  801a50:	89 cf                	mov    %ecx,%edi
  801a52:	89 fa                	mov    %edi,%edx
  801a54:	83 c4 1c             	add    $0x1c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
  801a5c:	39 ce                	cmp    %ecx,%esi
  801a5e:	77 28                	ja     801a88 <__udivdi3+0x7c>
  801a60:	0f bd fe             	bsr    %esi,%edi
  801a63:	83 f7 1f             	xor    $0x1f,%edi
  801a66:	75 40                	jne    801aa8 <__udivdi3+0x9c>
  801a68:	39 ce                	cmp    %ecx,%esi
  801a6a:	72 0a                	jb     801a76 <__udivdi3+0x6a>
  801a6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a70:	0f 87 9e 00 00 00    	ja     801b14 <__udivdi3+0x108>
  801a76:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7b:	89 fa                	mov    %edi,%edx
  801a7d:	83 c4 1c             	add    $0x1c,%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5f                   	pop    %edi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    
  801a85:	8d 76 00             	lea    0x0(%esi),%esi
  801a88:	31 ff                	xor    %edi,%edi
  801a8a:	31 c0                	xor    %eax,%eax
  801a8c:	89 fa                	mov    %edi,%edx
  801a8e:	83 c4 1c             	add    $0x1c,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5f                   	pop    %edi
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    
  801a96:	66 90                	xchg   %ax,%ax
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	f7 f7                	div    %edi
  801a9c:	31 ff                	xor    %edi,%edi
  801a9e:	89 fa                	mov    %edi,%edx
  801aa0:	83 c4 1c             	add    $0x1c,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    
  801aa8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aad:	89 eb                	mov    %ebp,%ebx
  801aaf:	29 fb                	sub    %edi,%ebx
  801ab1:	89 f9                	mov    %edi,%ecx
  801ab3:	d3 e6                	shl    %cl,%esi
  801ab5:	89 c5                	mov    %eax,%ebp
  801ab7:	88 d9                	mov    %bl,%cl
  801ab9:	d3 ed                	shr    %cl,%ebp
  801abb:	89 e9                	mov    %ebp,%ecx
  801abd:	09 f1                	or     %esi,%ecx
  801abf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ac3:	89 f9                	mov    %edi,%ecx
  801ac5:	d3 e0                	shl    %cl,%eax
  801ac7:	89 c5                	mov    %eax,%ebp
  801ac9:	89 d6                	mov    %edx,%esi
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 ee                	shr    %cl,%esi
  801acf:	89 f9                	mov    %edi,%ecx
  801ad1:	d3 e2                	shl    %cl,%edx
  801ad3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 e8                	shr    %cl,%eax
  801adb:	09 c2                	or     %eax,%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	89 f2                	mov    %esi,%edx
  801ae1:	f7 74 24 0c          	divl   0xc(%esp)
  801ae5:	89 d6                	mov    %edx,%esi
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	f7 e5                	mul    %ebp
  801aeb:	39 d6                	cmp    %edx,%esi
  801aed:	72 19                	jb     801b08 <__udivdi3+0xfc>
  801aef:	74 0b                	je     801afc <__udivdi3+0xf0>
  801af1:	89 d8                	mov    %ebx,%eax
  801af3:	31 ff                	xor    %edi,%edi
  801af5:	e9 58 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b00:	89 f9                	mov    %edi,%ecx
  801b02:	d3 e2                	shl    %cl,%edx
  801b04:	39 c2                	cmp    %eax,%edx
  801b06:	73 e9                	jae    801af1 <__udivdi3+0xe5>
  801b08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b0b:	31 ff                	xor    %edi,%edi
  801b0d:	e9 40 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	31 c0                	xor    %eax,%eax
  801b16:	e9 37 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801b1b:	90                   	nop

00801b1c <__umoddi3>:
  801b1c:	55                   	push   %ebp
  801b1d:	57                   	push   %edi
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	83 ec 1c             	sub    $0x1c,%esp
  801b23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3b:	89 f3                	mov    %esi,%ebx
  801b3d:	89 fa                	mov    %edi,%edx
  801b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b43:	89 34 24             	mov    %esi,(%esp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 1a                	jne    801b64 <__umoddi3+0x48>
  801b4a:	39 f7                	cmp    %esi,%edi
  801b4c:	0f 86 a2 00 00 00    	jbe    801bf4 <__umoddi3+0xd8>
  801b52:	89 c8                	mov    %ecx,%eax
  801b54:	89 f2                	mov    %esi,%edx
  801b56:	f7 f7                	div    %edi
  801b58:	89 d0                	mov    %edx,%eax
  801b5a:	31 d2                	xor    %edx,%edx
  801b5c:	83 c4 1c             	add    $0x1c,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
  801b64:	39 f0                	cmp    %esi,%eax
  801b66:	0f 87 ac 00 00 00    	ja     801c18 <__umoddi3+0xfc>
  801b6c:	0f bd e8             	bsr    %eax,%ebp
  801b6f:	83 f5 1f             	xor    $0x1f,%ebp
  801b72:	0f 84 ac 00 00 00    	je     801c24 <__umoddi3+0x108>
  801b78:	bf 20 00 00 00       	mov    $0x20,%edi
  801b7d:	29 ef                	sub    %ebp,%edi
  801b7f:	89 fe                	mov    %edi,%esi
  801b81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b85:	89 e9                	mov    %ebp,%ecx
  801b87:	d3 e0                	shl    %cl,%eax
  801b89:	89 d7                	mov    %edx,%edi
  801b8b:	89 f1                	mov    %esi,%ecx
  801b8d:	d3 ef                	shr    %cl,%edi
  801b8f:	09 c7                	or     %eax,%edi
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 e2                	shl    %cl,%edx
  801b95:	89 14 24             	mov    %edx,(%esp)
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	d3 e0                	shl    %cl,%eax
  801b9c:	89 c2                	mov    %eax,%edx
  801b9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba2:	d3 e0                	shl    %cl,%eax
  801ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bac:	89 f1                	mov    %esi,%ecx
  801bae:	d3 e8                	shr    %cl,%eax
  801bb0:	09 d0                	or     %edx,%eax
  801bb2:	d3 eb                	shr    %cl,%ebx
  801bb4:	89 da                	mov    %ebx,%edx
  801bb6:	f7 f7                	div    %edi
  801bb8:	89 d3                	mov    %edx,%ebx
  801bba:	f7 24 24             	mull   (%esp)
  801bbd:	89 c6                	mov    %eax,%esi
  801bbf:	89 d1                	mov    %edx,%ecx
  801bc1:	39 d3                	cmp    %edx,%ebx
  801bc3:	0f 82 87 00 00 00    	jb     801c50 <__umoddi3+0x134>
  801bc9:	0f 84 91 00 00 00    	je     801c60 <__umoddi3+0x144>
  801bcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bd3:	29 f2                	sub    %esi,%edx
  801bd5:	19 cb                	sbb    %ecx,%ebx
  801bd7:	89 d8                	mov    %ebx,%eax
  801bd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bdd:	d3 e0                	shl    %cl,%eax
  801bdf:	89 e9                	mov    %ebp,%ecx
  801be1:	d3 ea                	shr    %cl,%edx
  801be3:	09 d0                	or     %edx,%eax
  801be5:	89 e9                	mov    %ebp,%ecx
  801be7:	d3 eb                	shr    %cl,%ebx
  801be9:	89 da                	mov    %ebx,%edx
  801beb:	83 c4 1c             	add    $0x1c,%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5f                   	pop    %edi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    
  801bf3:	90                   	nop
  801bf4:	89 fd                	mov    %edi,%ebp
  801bf6:	85 ff                	test   %edi,%edi
  801bf8:	75 0b                	jne    801c05 <__umoddi3+0xe9>
  801bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801bff:	31 d2                	xor    %edx,%edx
  801c01:	f7 f7                	div    %edi
  801c03:	89 c5                	mov    %eax,%ebp
  801c05:	89 f0                	mov    %esi,%eax
  801c07:	31 d2                	xor    %edx,%edx
  801c09:	f7 f5                	div    %ebp
  801c0b:	89 c8                	mov    %ecx,%eax
  801c0d:	f7 f5                	div    %ebp
  801c0f:	89 d0                	mov    %edx,%eax
  801c11:	e9 44 ff ff ff       	jmp    801b5a <__umoddi3+0x3e>
  801c16:	66 90                	xchg   %ax,%ax
  801c18:	89 c8                	mov    %ecx,%eax
  801c1a:	89 f2                	mov    %esi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	3b 04 24             	cmp    (%esp),%eax
  801c27:	72 06                	jb     801c2f <__umoddi3+0x113>
  801c29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c2d:	77 0f                	ja     801c3e <__umoddi3+0x122>
  801c2f:	89 f2                	mov    %esi,%edx
  801c31:	29 f9                	sub    %edi,%ecx
  801c33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c37:	89 14 24             	mov    %edx,(%esp)
  801c3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c42:	8b 14 24             	mov    (%esp),%edx
  801c45:	83 c4 1c             	add    $0x1c,%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5e                   	pop    %esi
  801c4a:	5f                   	pop    %edi
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    
  801c4d:	8d 76 00             	lea    0x0(%esi),%esi
  801c50:	2b 04 24             	sub    (%esp),%eax
  801c53:	19 fa                	sbb    %edi,%edx
  801c55:	89 d1                	mov    %edx,%ecx
  801c57:	89 c6                	mov    %eax,%esi
  801c59:	e9 71 ff ff ff       	jmp    801bcf <__umoddi3+0xb3>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c64:	72 ea                	jb     801c50 <__umoddi3+0x134>
  801c66:	89 d9                	mov    %ebx,%ecx
  801c68:	e9 62 ff ff ff       	jmp    801bcf <__umoddi3+0xb3>
