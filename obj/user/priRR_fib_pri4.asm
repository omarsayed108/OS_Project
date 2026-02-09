
obj/user/priRR_fib_pri4:     file format elf32-i386


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
  800031:	e8 c0 00 00 00       	call   8000f6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int fibonacci(int n);
extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	sys_env_set_priority(myEnv->env_id, 4);
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 40 10             	mov    0x10(%eax),%eax
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	6a 04                	push   $0x4
  80004e:	50                   	push   %eax
  80004f:	e8 b2 19 00 00       	call   801a06 <sys_env_set_priority>
  800054:	83 c4 10             	add    $0x10,%esp

	int i1=0;
  800057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  80005e:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	ff 75 f4             	pushl  -0xc(%ebp)
  80006b:	e8 47 00 00 00       	call   8000b7 <fibonacci>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	ff 75 f0             	pushl  -0x10(%ebp)
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	68 a0 1c 80 00       	push   $0x801ca0
  800084:	e8 7d 05 00 00       	call   800606 <atomic_cprintf>
  800089:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  80008c:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  800093:	74 1a                	je     8000af <_main+0x77>
		panic("[envID %d] wrong result!", myEnv->env_id);
  800095:	a1 20 30 80 00       	mov    0x803020,%eax
  80009a:	8b 40 10             	mov    0x10(%eax),%eax
  80009d:	50                   	push   %eax
  80009e:	68 b4 1c 80 00       	push   $0x801cb4
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 cd 1c 80 00       	push   $0x801ccd
  8000aa:	e8 f7 01 00 00       	call   8002a6 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8000af:	e8 eb 17 00 00       	call   80189f <inctst>

	return;
  8000b4:	90                   	nop
}
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <fibonacci>:


int fibonacci(int n)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000be:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c2:	7f 07                	jg     8000cb <fibonacci+0x14>
		return 1 ;
  8000c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c9:	eb 26                	jmp    8000f1 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ce:	48                   	dec    %eax
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	50                   	push   %eax
  8000d3:	e8 df ff ff ff       	call   8000b7 <fibonacci>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 c3                	mov    %eax,%ebx
  8000dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e0:	83 e8 02             	sub    $0x2,%eax
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	50                   	push   %eax
  8000e7:	e8 cb ff ff ff       	call   8000b7 <fibonacci>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	01 d8                	add    %ebx,%eax
}
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000ff:	e8 5d 16 00 00       	call   801761 <sys_getenvindex>
  800104:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	01 c0                	add    %eax,%eax
  80010e:	01 d0                	add    %edx,%eax
  800110:	c1 e0 02             	shl    $0x2,%eax
  800113:	01 d0                	add    %edx,%eax
  800115:	c1 e0 02             	shl    $0x2,%eax
  800118:	01 d0                	add    %edx,%eax
  80011a:	c1 e0 03             	shl    $0x3,%eax
  80011d:	01 d0                	add    %edx,%eax
  80011f:	c1 e0 02             	shl    $0x2,%eax
  800122:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800127:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80012c:	a1 20 30 80 00       	mov    0x803020,%eax
  800131:	8a 40 20             	mov    0x20(%eax),%al
  800134:	84 c0                	test   %al,%al
  800136:	74 0d                	je     800145 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800138:	a1 20 30 80 00       	mov    0x803020,%eax
  80013d:	83 c0 20             	add    $0x20,%eax
  800140:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800145:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800149:	7e 0a                	jle    800155 <libmain+0x5f>
		binaryname = argv[0];
  80014b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014e:	8b 00                	mov    (%eax),%eax
  800150:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800155:	83 ec 08             	sub    $0x8,%esp
  800158:	ff 75 0c             	pushl  0xc(%ebp)
  80015b:	ff 75 08             	pushl  0x8(%ebp)
  80015e:	e8 d5 fe ff ff       	call   800038 <_main>
  800163:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800166:	a1 00 30 80 00       	mov    0x803000,%eax
  80016b:	85 c0                	test   %eax,%eax
  80016d:	0f 84 01 01 00 00    	je     800274 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800173:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800179:	bb dc 1d 80 00       	mov    $0x801ddc,%ebx
  80017e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800183:	89 c7                	mov    %eax,%edi
  800185:	89 de                	mov    %ebx,%esi
  800187:	89 d1                	mov    %edx,%ecx
  800189:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80018b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80018e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800193:	b0 00                	mov    $0x0,%al
  800195:	89 d7                	mov    %edx,%edi
  800197:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800199:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	50                   	push   %eax
  8001a7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ad:	50                   	push   %eax
  8001ae:	e8 e4 17 00 00       	call   801997 <sys_utilities>
  8001b3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b6:	e8 2d 13 00 00       	call   8014e8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 fc 1c 80 00       	push   $0x801cfc
  8001c3:	e8 cc 03 00 00       	call   800594 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	74 18                	je     8001ea <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001d2:	e8 de 17 00 00       	call   8019b5 <sys_get_optimal_num_faults>
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	50                   	push   %eax
  8001db:	68 24 1d 80 00       	push   $0x801d24
  8001e0:	e8 af 03 00 00       	call   800594 <cprintf>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	eb 59                	jmp    800243 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ef:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 48 1d 80 00       	push   $0x801d48
  80020a:	e8 85 03 00 00       	call   800594 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80021d:	a1 20 30 80 00       	mov    0x803020,%eax
  800222:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800233:	51                   	push   %ecx
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 70 1d 80 00       	push   $0x801d70
  80023b:	e8 54 03 00 00       	call   800594 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800243:	a1 20 30 80 00       	mov    0x803020,%eax
  800248:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	50                   	push   %eax
  800252:	68 c8 1d 80 00       	push   $0x801dc8
  800257:	e8 38 03 00 00       	call   800594 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	68 fc 1c 80 00       	push   $0x801cfc
  800267:	e8 28 03 00 00       	call   800594 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026f:	e8 8e 12 00 00       	call   801502 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800274:	e8 1f 00 00 00       	call   800298 <exit>
}
  800279:	90                   	nop
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	6a 00                	push   $0x0
  80028d:	e8 9b 14 00 00       	call   80172d <sys_destroy_env>
  800292:	83 c4 10             	add    $0x10,%esp
}
  800295:	90                   	nop
  800296:	c9                   	leave  
  800297:	c3                   	ret    

00800298 <exit>:

void
exit(void)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029e:	e8 f0 14 00 00       	call   801793 <sys_exit_env>
}
  8002a3:	90                   	nop
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8002af:	83 c0 04             	add    $0x4,%eax
  8002b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	74 16                	je     8002d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002be:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 40 1e 80 00       	push   $0x801e40
  8002cc:	e8 c3 02 00 00       	call   800594 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 0c             	pushl  0xc(%ebp)
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	50                   	push   %eax
  8002e3:	68 48 1e 80 00       	push   $0x801e48
  8002e8:	6a 74                	push   $0x74
  8002ea:	e8 d2 02 00 00       	call   8005c1 <cprintf_colored>
  8002ef:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fb:	50                   	push   %eax
  8002fc:	e8 24 02 00 00       	call   800525 <vcprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	6a 00                	push   $0x0
  800309:	68 70 1e 80 00       	push   $0x801e70
  80030e:	e8 12 02 00 00       	call   800525 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800316:	e8 7d ff ff ff       	call   800298 <exit>

	// should not return here
	while (1) ;
  80031b:	eb fe                	jmp    80031b <_panic+0x75>

0080031d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	53                   	push   %ebx
  800321:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800324:	a1 20 30 80 00       	mov    0x803020,%eax
  800329:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	74 14                	je     80034a <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800336:	83 ec 04             	sub    $0x4,%esp
  800339:	68 74 1e 80 00       	push   $0x801e74
  80033e:	6a 26                	push   $0x26
  800340:	68 c0 1e 80 00       	push   $0x801ec0
  800345:	e8 5c ff ff ff       	call   8002a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80034a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800358:	e9 d9 00 00 00       	jmp    800436 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800360:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	8b 00                	mov    (%eax),%eax
  80036e:	85 c0                	test   %eax,%eax
  800370:	75 08                	jne    80037a <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800372:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800375:	e9 b9 00 00 00       	jmp    800433 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80037a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800381:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800388:	eb 79                	jmp    800403 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80038a:	a1 20 30 80 00       	mov    0x803020,%eax
  80038f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800395:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800398:	89 d0                	mov    %edx,%eax
  80039a:	01 c0                	add    %eax,%eax
  80039c:	01 d0                	add    %edx,%eax
  80039e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003a5:	01 d8                	add    %ebx,%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8a 40 04             	mov    0x4(%eax),%al
  8003ae:	84 c0                	test   %al,%al
  8003b0:	75 4e                	jne    800400 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c0:	89 d0                	mov    %edx,%eax
  8003c2:	01 c0                	add    %eax,%eax
  8003c4:	01 d0                	add    %edx,%eax
  8003c6:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003cd:	01 d8                	add    %ebx,%eax
  8003cf:	01 d0                	add    %edx,%eax
  8003d1:	01 c8                	add    %ecx,%eax
  8003d3:	8b 00                	mov    (%eax),%eax
  8003d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f3:	39 c2                	cmp    %eax,%edx
  8003f5:	75 09                	jne    800400 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8003f7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fe:	eb 19                	jmp    800419 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800400:	ff 45 e8             	incl   -0x18(%ebp)
  800403:	a1 20 30 80 00       	mov    0x803020,%eax
  800408:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	0f 87 71 ff ff ff    	ja     80038a <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80041d:	75 14                	jne    800433 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80041f:	83 ec 04             	sub    $0x4,%esp
  800422:	68 cc 1e 80 00       	push   $0x801ecc
  800427:	6a 3a                	push   $0x3a
  800429:	68 c0 1e 80 00       	push   $0x801ec0
  80042e:	e8 73 fe ff ff       	call   8002a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800433:	ff 45 f0             	incl   -0x10(%ebp)
  800436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800439:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043c:	0f 8c 1b ff ff ff    	jl     80035d <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800442:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800449:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800450:	eb 2e                	jmp    800480 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800452:	a1 20 30 80 00       	mov    0x803020,%eax
  800457:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80045d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800460:	89 d0                	mov    %edx,%eax
  800462:	01 c0                	add    %eax,%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80046d:	01 d8                	add    %ebx,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 30 80 00       	mov    0x803020,%eax
  800485:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 c0                	ja     800452 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 20 1f 80 00       	push   $0x801f20
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 c0 1e 80 00       	push   $0x801ec0
  8004a9:	e8 f8 fd ff ff       	call   8002a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	53                   	push   %ebx
  8004b8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8004c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c6:	89 0a                	mov    %ecx,(%edx)
  8004c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8004cb:	88 d1                	mov    %dl,%cl
  8004cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004de:	75 30                	jne    800510 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004e0:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004e6:	a0 44 30 80 00       	mov    0x803044,%al
  8004eb:	0f b6 c0             	movzbl %al,%eax
  8004ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f1:	8b 09                	mov    (%ecx),%ecx
  8004f3:	89 cb                	mov    %ecx,%ebx
  8004f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f8:	83 c1 08             	add    $0x8,%ecx
  8004fb:	52                   	push   %edx
  8004fc:	50                   	push   %eax
  8004fd:	53                   	push   %ebx
  8004fe:	51                   	push   %ecx
  8004ff:	e8 a0 0f 00 00       	call   8014a4 <sys_cputs>
  800504:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800510:	8b 45 0c             	mov    0xc(%ebp),%eax
  800513:	8b 40 04             	mov    0x4(%eax),%eax
  800516:	8d 50 01             	lea    0x1(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80051f:	90                   	nop
  800520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800535:	00 00 00 
	b.cnt = 0;
  800538:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800542:	ff 75 0c             	pushl  0xc(%ebp)
  800545:	ff 75 08             	pushl  0x8(%ebp)
  800548:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054e:	50                   	push   %eax
  80054f:	68 b4 04 80 00       	push   $0x8004b4
  800554:	e8 5a 02 00 00       	call   8007b3 <vprintfmt>
  800559:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80055c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800562:	a0 44 30 80 00       	mov    0x803044,%al
  800567:	0f b6 c0             	movzbl %al,%eax
  80056a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800570:	52                   	push   %edx
  800571:	50                   	push   %eax
  800572:	51                   	push   %ecx
  800573:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800579:	83 c0 08             	add    $0x8,%eax
  80057c:	50                   	push   %eax
  80057d:	e8 22 0f 00 00       	call   8014a4 <sys_cputs>
  800582:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800585:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80058c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80059a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	e8 6f ff ff ff       	call   800525 <vcprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005bf:	c9                   	leave  
  8005c0:	c3                   	ret    

008005c1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	c1 e0 08             	shl    $0x8,%eax
  8005d4:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005d9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005dc:	83 c0 04             	add    $0x4,%eax
  8005df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005eb:	50                   	push   %eax
  8005ec:	e8 34 ff ff ff       	call   800525 <vcprintf>
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005f7:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005fe:	07 00 00 

	return cnt;
  800601:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80060c:	e8 d7 0e 00 00       	call   8014e8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800611:	8d 45 0c             	lea    0xc(%ebp),%eax
  800614:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	ff 75 f4             	pushl  -0xc(%ebp)
  800620:	50                   	push   %eax
  800621:	e8 ff fe ff ff       	call   800525 <vcprintf>
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80062c:	e8 d1 0e 00 00       	call   801502 <sys_unlock_cons>
	return cnt;
  800631:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	53                   	push   %ebx
  80063a:	83 ec 14             	sub    $0x14,%esp
  80063d:	8b 45 10             	mov    0x10(%ebp),%eax
  800640:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800649:	8b 45 18             	mov    0x18(%ebp),%eax
  80064c:	ba 00 00 00 00       	mov    $0x0,%edx
  800651:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800654:	77 55                	ja     8006ab <printnum+0x75>
  800656:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800659:	72 05                	jb     800660 <printnum+0x2a>
  80065b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065e:	77 4b                	ja     8006ab <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800660:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800663:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800666:	8b 45 18             	mov    0x18(%ebp),%eax
  800669:	ba 00 00 00 00       	mov    $0x0,%edx
  80066e:	52                   	push   %edx
  80066f:	50                   	push   %eax
  800670:	ff 75 f4             	pushl  -0xc(%ebp)
  800673:	ff 75 f0             	pushl  -0x10(%ebp)
  800676:	e8 a9 13 00 00       	call   801a24 <__udivdi3>
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	ff 75 20             	pushl  0x20(%ebp)
  800684:	53                   	push   %ebx
  800685:	ff 75 18             	pushl  0x18(%ebp)
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	ff 75 0c             	pushl  0xc(%ebp)
  80068d:	ff 75 08             	pushl  0x8(%ebp)
  800690:	e8 a1 ff ff ff       	call   800636 <printnum>
  800695:	83 c4 20             	add    $0x20,%esp
  800698:	eb 1a                	jmp    8006b4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	ff 75 20             	pushl  0x20(%ebp)
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ab:	ff 4d 1c             	decl   0x1c(%ebp)
  8006ae:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b2:	7f e6                	jg     80069a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c2:	53                   	push   %ebx
  8006c3:	51                   	push   %ecx
  8006c4:	52                   	push   %edx
  8006c5:	50                   	push   %eax
  8006c6:	e8 69 14 00 00       	call   801b34 <__umoddi3>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	05 94 21 80 00       	add    $0x802194,%eax
  8006d3:	8a 00                	mov    (%eax),%al
  8006d5:	0f be c0             	movsbl %al,%eax
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	ff 75 0c             	pushl  0xc(%ebp)
  8006de:	50                   	push   %eax
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	ff d0                	call   *%eax
  8006e4:	83 c4 10             	add    $0x10,%esp
}
  8006e7:	90                   	nop
  8006e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006eb:	c9                   	leave  
  8006ec:	c3                   	ret    

008006ed <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f4:	7e 1c                	jle    800712 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 08             	lea    0x8(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 08             	sub    $0x8,%eax
  80070b:	8b 50 04             	mov    0x4(%eax),%edx
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	eb 40                	jmp    800752 <getuint+0x65>
	else if (lflag)
  800712:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800716:	74 1e                	je     800736 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 50 04             	lea    0x4(%eax),%edx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	83 e8 04             	sub    $0x4,%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	eb 1c                	jmp    800752 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8d 50 04             	lea    0x4(%eax),%edx
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	89 10                	mov    %edx,(%eax)
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	83 e8 04             	sub    $0x4,%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800752:	5d                   	pop    %ebp
  800753:	c3                   	ret    

00800754 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800757:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075b:	7e 1c                	jle    800779 <getint+0x25>
		return va_arg(*ap, long long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 08             	lea    0x8(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 08             	sub    $0x8,%eax
  800772:	8b 50 04             	mov    0x4(%eax),%edx
  800775:	8b 00                	mov    (%eax),%eax
  800777:	eb 38                	jmp    8007b1 <getint+0x5d>
	else if (lflag)
  800779:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077d:	74 1a                	je     800799 <getint+0x45>
		return va_arg(*ap, long);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	99                   	cltd   
  800797:	eb 18                	jmp    8007b1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	8d 50 04             	lea    0x4(%eax),%edx
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	89 10                	mov    %edx,(%eax)
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	83 e8 04             	sub    $0x4,%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	99                   	cltd   
}
  8007b1:	5d                   	pop    %ebp
  8007b2:	c3                   	ret    

008007b3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	56                   	push   %esi
  8007b7:	53                   	push   %ebx
  8007b8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bb:	eb 17                	jmp    8007d4 <vprintfmt+0x21>
			if (ch == '\0')
  8007bd:	85 db                	test   %ebx,%ebx
  8007bf:	0f 84 c1 03 00 00    	je     800b86 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	53                   	push   %ebx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	ff d0                	call   *%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	8d 50 01             	lea    0x1(%eax),%edx
  8007da:	89 55 10             	mov    %edx,0x10(%ebp)
  8007dd:	8a 00                	mov    (%eax),%al
  8007df:	0f b6 d8             	movzbl %al,%ebx
  8007e2:	83 fb 25             	cmp    $0x25,%ebx
  8007e5:	75 d6                	jne    8007bd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800800:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	8d 50 01             	lea    0x1(%eax),%edx
  80080d:	89 55 10             	mov    %edx,0x10(%ebp)
  800810:	8a 00                	mov    (%eax),%al
  800812:	0f b6 d8             	movzbl %al,%ebx
  800815:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800818:	83 f8 5b             	cmp    $0x5b,%eax
  80081b:	0f 87 3d 03 00 00    	ja     800b5e <vprintfmt+0x3ab>
  800821:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  800828:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082e:	eb d7                	jmp    800807 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800830:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800834:	eb d1                	jmp    800807 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800840:	89 d0                	mov    %edx,%eax
  800842:	c1 e0 02             	shl    $0x2,%eax
  800845:	01 d0                	add    %edx,%eax
  800847:	01 c0                	add    %eax,%eax
  800849:	01 d8                	add    %ebx,%eax
  80084b:	83 e8 30             	sub    $0x30,%eax
  80084e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800851:	8b 45 10             	mov    0x10(%ebp),%eax
  800854:	8a 00                	mov    (%eax),%al
  800856:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800859:	83 fb 2f             	cmp    $0x2f,%ebx
  80085c:	7e 3e                	jle    80089c <vprintfmt+0xe9>
  80085e:	83 fb 39             	cmp    $0x39,%ebx
  800861:	7f 39                	jg     80089c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800863:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800866:	eb d5                	jmp    80083d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	83 c0 04             	add    $0x4,%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	83 e8 04             	sub    $0x4,%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087c:	eb 1f                	jmp    80089d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800882:	79 83                	jns    800807 <vprintfmt+0x54>
				width = 0;
  800884:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088b:	e9 77 ff ff ff       	jmp    800807 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800890:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800897:	e9 6b ff ff ff       	jmp    800807 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a1:	0f 89 60 ff ff ff    	jns    800807 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b4:	e9 4e ff ff ff       	jmp    800807 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bc:	e9 46 ff ff ff       	jmp    800807 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	50                   	push   %eax
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	ff d0                	call   *%eax
  8008de:	83 c4 10             	add    $0x10,%esp
			break;
  8008e1:	e9 9b 02 00 00       	jmp    800b81 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	83 c0 04             	add    $0x4,%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	83 e8 04             	sub    $0x4,%eax
  8008f5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f7:	85 db                	test   %ebx,%ebx
  8008f9:	79 02                	jns    8008fd <vprintfmt+0x14a>
				err = -err;
  8008fb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fd:	83 fb 64             	cmp    $0x64,%ebx
  800900:	7f 0b                	jg     80090d <vprintfmt+0x15a>
  800902:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  800909:	85 f6                	test   %esi,%esi
  80090b:	75 19                	jne    800926 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090d:	53                   	push   %ebx
  80090e:	68 a5 21 80 00       	push   $0x8021a5
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	ff 75 08             	pushl  0x8(%ebp)
  800919:	e8 70 02 00 00       	call   800b8e <printfmt>
  80091e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800921:	e9 5b 02 00 00       	jmp    800b81 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800926:	56                   	push   %esi
  800927:	68 ae 21 80 00       	push   $0x8021ae
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	ff 75 08             	pushl  0x8(%ebp)
  800932:	e8 57 02 00 00       	call   800b8e <printfmt>
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 42 02 00 00       	jmp    800b81 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 30                	mov    (%eax),%esi
  800950:	85 f6                	test   %esi,%esi
  800952:	75 05                	jne    800959 <vprintfmt+0x1a6>
				p = "(null)";
  800954:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  800959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095d:	7e 6d                	jle    8009cc <vprintfmt+0x219>
  80095f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800963:	74 67                	je     8009cc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	50                   	push   %eax
  80096c:	56                   	push   %esi
  80096d:	e8 1e 03 00 00       	call   800c90 <strnlen>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800978:	eb 16                	jmp    800990 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	50                   	push   %eax
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800994:	7f e4                	jg     80097a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800996:	eb 34                	jmp    8009cc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800998:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099c:	74 1c                	je     8009ba <vprintfmt+0x207>
  80099e:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a1:	7e 05                	jle    8009a8 <vprintfmt+0x1f5>
  8009a3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a6:	7e 12                	jle    8009ba <vprintfmt+0x207>
					putch('?', putdat);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 0c             	pushl  0xc(%ebp)
  8009ae:	6a 3f                	push   $0x3f
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	eb 0f                	jmp    8009c9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	ff d0                	call   *%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cc:	89 f0                	mov    %esi,%eax
  8009ce:	8d 70 01             	lea    0x1(%eax),%esi
  8009d1:	8a 00                	mov    (%eax),%al
  8009d3:	0f be d8             	movsbl %al,%ebx
  8009d6:	85 db                	test   %ebx,%ebx
  8009d8:	74 24                	je     8009fe <vprintfmt+0x24b>
  8009da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009de:	78 b8                	js     800998 <vprintfmt+0x1e5>
  8009e0:	ff 4d e0             	decl   -0x20(%ebp)
  8009e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e7:	79 af                	jns    800998 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e9:	eb 13                	jmp    8009fe <vprintfmt+0x24b>
				putch(' ', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 20                	push   $0x20
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a02:	7f e7                	jg     8009eb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a04:	e9 78 01 00 00       	jmp    800b81 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a12:	50                   	push   %eax
  800a13:	e8 3c fd ff ff       	call   800754 <getint>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a27:	85 d2                	test   %edx,%edx
  800a29:	79 23                	jns    800a4e <vprintfmt+0x29b>
				putch('-', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 2d                	push   $0x2d
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a41:	f7 d8                	neg    %eax
  800a43:	83 d2 00             	adc    $0x0,%edx
  800a46:	f7 da                	neg    %edx
  800a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a55:	e9 bc 00 00 00       	jmp    800b16 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a60:	8d 45 14             	lea    0x14(%ebp),%eax
  800a63:	50                   	push   %eax
  800a64:	e8 84 fc ff ff       	call   8006ed <getuint>
  800a69:	83 c4 10             	add    $0x10,%esp
  800a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a72:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a79:	e9 98 00 00 00       	jmp    800b16 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 ce 00 00 00       	jmp    800b81 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 30                	push   $0x30
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 78                	push   $0x78
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 14             	mov    %eax,0x14(%ebp)
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	83 e8 04             	sub    $0x4,%eax
  800ae2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af5:	eb 1f                	jmp    800b16 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 e8             	pushl  -0x18(%ebp)
  800afd:	8d 45 14             	lea    0x14(%ebp),%eax
  800b00:	50                   	push   %eax
  800b01:	e8 e7 fb ff ff       	call   8006ed <getuint>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b0f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b16:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1d:	83 ec 04             	sub    $0x4,%esp
  800b20:	52                   	push   %edx
  800b21:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b24:	50                   	push   %eax
  800b25:	ff 75 f4             	pushl  -0xc(%ebp)
  800b28:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	ff 75 08             	pushl  0x8(%ebp)
  800b31:	e8 00 fb ff ff       	call   800636 <printnum>
  800b36:	83 c4 20             	add    $0x20,%esp
			break;
  800b39:	eb 46                	jmp    800b81 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	53                   	push   %ebx
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	ff d0                	call   *%eax
  800b47:	83 c4 10             	add    $0x10,%esp
			break;
  800b4a:	eb 35                	jmp    800b81 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b4c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b53:	eb 2c                	jmp    800b81 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b55:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b5c:	eb 23                	jmp    800b81 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	6a 25                	push   $0x25
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	ff d0                	call   *%eax
  800b6b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6e:	ff 4d 10             	decl   0x10(%ebp)
  800b71:	eb 03                	jmp    800b76 <vprintfmt+0x3c3>
  800b73:	ff 4d 10             	decl   0x10(%ebp)
  800b76:	8b 45 10             	mov    0x10(%ebp),%eax
  800b79:	48                   	dec    %eax
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	3c 25                	cmp    $0x25,%al
  800b7e:	75 f3                	jne    800b73 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b80:	90                   	nop
		}
	}
  800b81:	e9 35 fc ff ff       	jmp    8007bb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b86:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b94:	8d 45 10             	lea    0x10(%ebp),%eax
  800b97:	83 c0 04             	add    $0x4,%eax
  800b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba3:	50                   	push   %eax
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	ff 75 08             	pushl  0x8(%ebp)
  800baa:	e8 04 fc ff ff       	call   8007b3 <vprintfmt>
  800baf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb2:	90                   	nop
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	8b 40 08             	mov    0x8(%eax),%eax
  800bbe:	8d 50 01             	lea    0x1(%eax),%edx
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	8b 10                	mov    (%eax),%edx
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	8b 40 04             	mov    0x4(%eax),%eax
  800bd2:	39 c2                	cmp    %eax,%edx
  800bd4:	73 12                	jae    800be8 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	8d 48 01             	lea    0x1(%eax),%ecx
  800bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be1:	89 0a                	mov    %ecx,(%edx)
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	88 10                	mov    %dl,(%eax)
}
  800be8:	90                   	nop
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	01 d0                	add    %edx,%eax
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c10:	74 06                	je     800c18 <vsnprintf+0x2d>
  800c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c16:	7f 07                	jg     800c1f <vsnprintf+0x34>
		return -E_INVAL;
  800c18:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1d:	eb 20                	jmp    800c3f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1f:	ff 75 14             	pushl  0x14(%ebp)
  800c22:	ff 75 10             	pushl  0x10(%ebp)
  800c25:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c28:	50                   	push   %eax
  800c29:	68 b5 0b 80 00       	push   $0x800bb5
  800c2e:	e8 80 fb ff ff       	call   8007b3 <vprintfmt>
  800c33:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c39:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c47:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	ff 75 f4             	pushl  -0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	ff 75 08             	pushl  0x8(%ebp)
  800c5d:	e8 89 ff ff ff       	call   800beb <vsnprintf>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7a:	eb 06                	jmp    800c82 <strlen+0x15>
		n++;
  800c7c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7f:	ff 45 08             	incl   0x8(%ebp)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 f1                	jne    800c7c <strlen+0xf>
		n++;
	return n;
  800c8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9d:	eb 09                	jmp    800ca8 <strnlen+0x18>
		n++;
  800c9f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 4d 0c             	decl   0xc(%ebp)
  800ca8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cac:	74 09                	je     800cb7 <strnlen+0x27>
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	84 c0                	test   %al,%al
  800cb5:	75 e8                	jne    800c9f <strnlen+0xf>
		n++;
	return n;
  800cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc8:	90                   	nop
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8d 50 01             	lea    0x1(%eax),%edx
  800ccf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cdb:	8a 12                	mov    (%edx),%dl
  800cdd:	88 10                	mov    %dl,(%eax)
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 e4                	jne    800cc9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfd:	eb 1f                	jmp    800d1e <strncpy+0x34>
		*dst++ = *src;
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8d 50 01             	lea    0x1(%eax),%edx
  800d05:	89 55 08             	mov    %edx,0x8(%ebp)
  800d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0b:	8a 12                	mov    (%edx),%dl
  800d0d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	74 03                	je     800d1b <strncpy+0x31>
			src++;
  800d18:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d1b:	ff 45 fc             	incl   -0x4(%ebp)
  800d1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d21:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d24:	72 d9                	jb     800cff <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3b:	74 30                	je     800d6d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3d:	eb 16                	jmp    800d55 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	89 55 08             	mov    %edx,0x8(%ebp)
  800d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d51:	8a 12                	mov    (%edx),%dl
  800d53:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d55:	ff 4d 10             	decl   0x10(%ebp)
  800d58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5c:	74 09                	je     800d67 <strlcpy+0x3c>
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	84 c0                	test   %al,%al
  800d65:	75 d8                	jne    800d3f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d73:	29 c2                	sub    %eax,%edx
  800d75:	89 d0                	mov    %edx,%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7c:	eb 06                	jmp    800d84 <strcmp+0xb>
		p++, q++;
  800d7e:	ff 45 08             	incl   0x8(%ebp)
  800d81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	74 0e                	je     800d9b <strcmp+0x22>
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 10                	mov    (%eax),%dl
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	38 c2                	cmp    %al,%dl
  800d99:	74 e3                	je     800d7e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db4:	eb 09                	jmp    800dbf <strncmp+0xe>
		n--, p++, q++;
  800db6:	ff 4d 10             	decl   0x10(%ebp)
  800db9:	ff 45 08             	incl   0x8(%ebp)
  800dbc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc3:	74 17                	je     800ddc <strncmp+0x2b>
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	74 0e                	je     800ddc <strncmp+0x2b>
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 10                	mov    (%eax),%dl
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	38 c2                	cmp    %al,%dl
  800dda:	74 da                	je     800db6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ddc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de0:	75 07                	jne    800de9 <strncmp+0x38>
		return 0;
  800de2:	b8 00 00 00 00       	mov    $0x0,%eax
  800de7:	eb 14                	jmp    800dfd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d0             	movzbl %al,%edx
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	0f b6 c0             	movzbl %al,%eax
  800df9:	29 c2                	sub    %eax,%edx
  800dfb:	89 d0                	mov    %edx,%eax
}
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 04             	sub    $0x4,%esp
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e0b:	eb 12                	jmp    800e1f <strchr+0x20>
		if (*s == c)
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e15:	75 05                	jne    800e1c <strchr+0x1d>
			return (char *) s;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	eb 11                	jmp    800e2d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	75 e5                	jne    800e0d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 04             	sub    $0x4,%esp
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3b:	eb 0d                	jmp    800e4a <strfind+0x1b>
		if (*s == c)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e45:	74 0e                	je     800e55 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e47:	ff 45 08             	incl   0x8(%ebp)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	75 ea                	jne    800e3d <strfind+0xe>
  800e53:	eb 01                	jmp    800e56 <strfind+0x27>
		if (*s == c)
			break;
  800e55:	90                   	nop
	return (char *) s;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e67:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e6b:	76 63                	jbe    800ed0 <memset+0x75>
		uint64 data_block = c;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	99                   	cltd   
  800e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e74:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e81:	c1 e0 08             	shl    $0x8,%eax
  800e84:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e87:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e90:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e94:	c1 e0 10             	shl    $0x10,%eax
  800e97:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e9a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea3:	89 c2                	mov    %eax,%edx
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaa:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ead:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eb0:	eb 18                	jmp    800eca <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eb2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb5:	8d 41 08             	lea    0x8(%ecx),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec1:	89 01                	mov    %eax,(%ecx)
  800ec3:	89 51 04             	mov    %edx,0x4(%ecx)
  800ec6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ece:	77 e2                	ja     800eb2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ed0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed4:	74 23                	je     800ef9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800edc:	eb 0e                	jmp    800eec <memset+0x91>
			*p8++ = (uint8)c;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 e5                	jne    800ede <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f10:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f14:	76 24                	jbe    800f3a <memcpy+0x3c>
		while(n >= 8){
  800f16:	eb 1c                	jmp    800f34 <memcpy+0x36>
			*d64 = *s64;
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	8b 50 04             	mov    0x4(%eax),%edx
  800f1e:	8b 00                	mov    (%eax),%eax
  800f20:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f23:	89 01                	mov    %eax,(%ecx)
  800f25:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f28:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f2c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f30:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f34:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f38:	77 de                	ja     800f18 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3e:	74 31                	je     800f71 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f4c:	eb 16                	jmp    800f64 <memcpy+0x66>
			*d8++ = *s8++;
  800f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8e:	73 50                	jae    800fe0 <memmove+0x6a>
  800f90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 d0                	add    %edx,%eax
  800f98:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9b:	76 43                	jbe    800fe0 <memmove+0x6a>
		s += n;
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa9:	eb 10                	jmp    800fbb <memmove+0x45>
			*--d = *--s;
  800fab:	ff 4d f8             	decl   -0x8(%ebp)
  800fae:	ff 4d fc             	decl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	8a 10                	mov    (%eax),%dl
  800fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	75 e3                	jne    800fab <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc8:	eb 23                	jmp    800fed <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcd:	8d 50 01             	lea    0x1(%eax),%edx
  800fd0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fdc:	8a 12                	mov    (%edx),%dl
  800fde:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	75 dd                	jne    800fca <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801004:	eb 2a                	jmp    801030 <memcmp+0x3e>
		if (*s1 != *s2)
  801006:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801009:	8a 10                	mov    (%eax),%dl
  80100b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	38 c2                	cmp    %al,%dl
  801012:	74 16                	je     80102a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	0f b6 d0             	movzbl %al,%edx
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f b6 c0             	movzbl %al,%eax
  801024:	29 c2                	sub    %eax,%edx
  801026:	89 d0                	mov    %edx,%eax
  801028:	eb 18                	jmp    801042 <memcmp+0x50>
		s1++, s2++;
  80102a:	ff 45 fc             	incl   -0x4(%ebp)
  80102d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801030:	8b 45 10             	mov    0x10(%ebp),%eax
  801033:	8d 50 ff             	lea    -0x1(%eax),%edx
  801036:	89 55 10             	mov    %edx,0x10(%ebp)
  801039:	85 c0                	test   %eax,%eax
  80103b:	75 c9                	jne    801006 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80103d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80104a:	8b 55 08             	mov    0x8(%ebp),%edx
  80104d:	8b 45 10             	mov    0x10(%ebp),%eax
  801050:	01 d0                	add    %edx,%eax
  801052:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801055:	eb 15                	jmp    80106c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	0f b6 d0             	movzbl %al,%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	0f b6 c0             	movzbl %al,%eax
  801065:	39 c2                	cmp    %eax,%edx
  801067:	74 0d                	je     801076 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801069:	ff 45 08             	incl   0x8(%ebp)
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801072:	72 e3                	jb     801057 <memfind+0x13>
  801074:	eb 01                	jmp    801077 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801076:	90                   	nop
	return (void *) s;
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801089:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801090:	eb 03                	jmp    801095 <strtol+0x19>
		s++;
  801092:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 20                	cmp    $0x20,%al
  80109c:	74 f4                	je     801092 <strtol+0x16>
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 09                	cmp    $0x9,%al
  8010a5:	74 eb                	je     801092 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	3c 2b                	cmp    $0x2b,%al
  8010ae:	75 05                	jne    8010b5 <strtol+0x39>
		s++;
  8010b0:	ff 45 08             	incl   0x8(%ebp)
  8010b3:	eb 13                	jmp    8010c8 <strtol+0x4c>
	else if (*s == '-')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2d                	cmp    $0x2d,%al
  8010bc:	75 0a                	jne    8010c8 <strtol+0x4c>
		s++, neg = 1;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cc:	74 06                	je     8010d4 <strtol+0x58>
  8010ce:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d2:	75 20                	jne    8010f4 <strtol+0x78>
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	3c 30                	cmp    $0x30,%al
  8010db:	75 17                	jne    8010f4 <strtol+0x78>
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	40                   	inc    %eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3c 78                	cmp    $0x78,%al
  8010e5:	75 0d                	jne    8010f4 <strtol+0x78>
		s += 2, base = 16;
  8010e7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010eb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f2:	eb 28                	jmp    80111c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f8:	75 15                	jne    80110f <strtol+0x93>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	3c 30                	cmp    $0x30,%al
  801101:	75 0c                	jne    80110f <strtol+0x93>
		s++, base = 8;
  801103:	ff 45 08             	incl   0x8(%ebp)
  801106:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80110d:	eb 0d                	jmp    80111c <strtol+0xa0>
	else if (base == 0)
  80110f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801113:	75 07                	jne    80111c <strtol+0xa0>
		base = 10;
  801115:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 2f                	cmp    $0x2f,%al
  801123:	7e 19                	jle    80113e <strtol+0xc2>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 39                	cmp    $0x39,%al
  80112c:	7f 10                	jg     80113e <strtol+0xc2>
			dig = *s - '0';
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	0f be c0             	movsbl %al,%eax
  801136:	83 e8 30             	sub    $0x30,%eax
  801139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113c:	eb 42                	jmp    801180 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 60                	cmp    $0x60,%al
  801145:	7e 19                	jle    801160 <strtol+0xe4>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 7a                	cmp    $0x7a,%al
  80114e:	7f 10                	jg     801160 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f be c0             	movsbl %al,%eax
  801158:	83 e8 57             	sub    $0x57,%eax
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115e:	eb 20                	jmp    801180 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 40                	cmp    $0x40,%al
  801167:	7e 39                	jle    8011a2 <strtol+0x126>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 5a                	cmp    $0x5a,%al
  801170:	7f 30                	jg     8011a2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f be c0             	movsbl %al,%eax
  80117a:	83 e8 37             	sub    $0x37,%eax
  80117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801183:	3b 45 10             	cmp    0x10(%ebp),%eax
  801186:	7d 19                	jge    8011a1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801192:	89 c2                	mov    %eax,%edx
  801194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80119c:	e9 7b ff ff ff       	jmp    80111c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011a1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a6:	74 08                	je     8011b0 <strtol+0x134>
		*endptr = (char *) s;
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 07                	je     8011bd <strtol+0x141>
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	f7 d8                	neg    %eax
  8011bb:	eb 03                	jmp    8011c0 <strtol+0x144>
  8011bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    

008011c2 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	79 13                	jns    8011ef <ltostr+0x2d>
	{
		neg = 1;
  8011dc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011e9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011ec:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011f7:	99                   	cltd   
  8011f8:	f7 f9                	idiv   %ecx
  8011fa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801206:	89 c2                	mov    %eax,%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801210:	83 c2 30             	add    $0x30,%edx
  801213:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801215:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801218:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121d:	f7 e9                	imul   %ecx
  80121f:	c1 fa 02             	sar    $0x2,%edx
  801222:	89 c8                	mov    %ecx,%eax
  801224:	c1 f8 1f             	sar    $0x1f,%eax
  801227:	29 c2                	sub    %eax,%edx
  801229:	89 d0                	mov    %edx,%eax
  80122b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80122e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801232:	75 bb                	jne    8011ef <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80123b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123e:	48                   	dec    %eax
  80123f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801242:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801246:	74 3d                	je     801285 <ltostr+0xc3>
		start = 1 ;
  801248:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80124f:	eb 34                	jmp    801285 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80125e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c8                	add    %ecx,%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801272:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80127d:	88 02                	mov    %al,(%edx)
		start++ ;
  80127f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801282:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801288:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128b:	7c c4                	jl     801251 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80128d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	01 d0                	add    %edx,%eax
  801295:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801298:	90                   	nop
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a1:	ff 75 08             	pushl  0x8(%ebp)
  8012a4:	e8 c4 f9 ff ff       	call   800c6d <strlen>
  8012a9:	83 c4 04             	add    $0x4,%esp
  8012ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012af:	ff 75 0c             	pushl  0xc(%ebp)
  8012b2:	e8 b6 f9 ff ff       	call   800c6d <strlen>
  8012b7:	83 c4 04             	add    $0x4,%esp
  8012ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012cb:	eb 17                	jmp    8012e4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e1:	ff 45 fc             	incl   -0x4(%ebp)
  8012e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ea:	7c e1                	jl     8012cd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012fa:	eb 1f                	jmp    80131b <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ff:	8d 50 01             	lea    0x1(%eax),%edx
  801302:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801305:	89 c2                	mov    %eax,%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80130f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801312:	01 c8                	add    %ecx,%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801318:	ff 45 f8             	incl   -0x8(%ebp)
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801321:	7c d9                	jl     8012fc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801323:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801326:	8b 45 10             	mov    0x10(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	c6 00 00             	movb   $0x0,(%eax)
}
  80132e:	90                   	nop
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801334:	8b 45 14             	mov    0x14(%ebp),%eax
  801337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801354:	eb 0c                	jmp    801362 <strsplit+0x31>
			*string++ = 0;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8d 50 01             	lea    0x1(%eax),%edx
  80135c:	89 55 08             	mov    %edx,0x8(%ebp)
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	84 c0                	test   %al,%al
  801369:	74 18                	je     801383 <strsplit+0x52>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	0f be c0             	movsbl %al,%eax
  801373:	50                   	push   %eax
  801374:	ff 75 0c             	pushl  0xc(%ebp)
  801377:	e8 83 fa ff ff       	call   800dff <strchr>
  80137c:	83 c4 08             	add    $0x8,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	75 d3                	jne    801356 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	84 c0                	test   %al,%al
  80138a:	74 5a                	je     8013e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80138c:	8b 45 14             	mov    0x14(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	83 f8 0f             	cmp    $0xf,%eax
  801394:	75 07                	jne    80139d <strsplit+0x6c>
		{
			return 0;
  801396:	b8 00 00 00 00       	mov    $0x0,%eax
  80139b:	eb 66                	jmp    801403 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80139d:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a0:	8b 00                	mov    (%eax),%eax
  8013a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a8:	89 0a                	mov    %ecx,(%edx)
  8013aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	01 c2                	add    %eax,%edx
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013bb:	eb 03                	jmp    8013c0 <strsplit+0x8f>
			string++;
  8013bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	84 c0                	test   %al,%al
  8013c7:	74 8b                	je     801354 <strsplit+0x23>
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f be c0             	movsbl %al,%eax
  8013d1:	50                   	push   %eax
  8013d2:	ff 75 0c             	pushl  0xc(%ebp)
  8013d5:	e8 25 fa ff ff       	call   800dff <strchr>
  8013da:	83 c4 08             	add    $0x8,%esp
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 dc                	je     8013bd <strsplit+0x8c>
			string++;
	}
  8013e1:	e9 6e ff ff ff       	jmp    801354 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ea:	8b 00                	mov    (%eax),%eax
  8013ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	01 d0                	add    %edx,%eax
  8013f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801411:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801418:	eb 4a                	jmp    801464 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80141a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	01 c2                	add    %eax,%edx
  801422:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 c8                	add    %ecx,%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80142e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 d0                	add    %edx,%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	3c 40                	cmp    $0x40,%al
  80143a:	7e 25                	jle    801461 <str2lower+0x5c>
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 5a                	cmp    $0x5a,%al
  801448:	7f 17                	jg     801461 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801455:	8b 55 08             	mov    0x8(%ebp),%edx
  801458:	01 ca                	add    %ecx,%edx
  80145a:	8a 12                	mov    (%edx),%dl
  80145c:	83 c2 20             	add    $0x20,%edx
  80145f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801461:	ff 45 fc             	incl   -0x4(%ebp)
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	e8 01 f8 ff ff       	call   800c6d <strlen>
  80146c:	83 c4 04             	add    $0x4,%esp
  80146f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801472:	7f a6                	jg     80141a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	57                   	push   %edi
  80147d:	56                   	push   %esi
  80147e:	53                   	push   %ebx
  80147f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8b 55 0c             	mov    0xc(%ebp),%edx
  801488:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80148e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801491:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801494:	cd 30                	int    $0x30
  801496:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5f                   	pop    %edi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	6a 00                	push   $0x0
  8014bc:	51                   	push   %ecx
  8014bd:	52                   	push   %edx
  8014be:	ff 75 0c             	pushl  0xc(%ebp)
  8014c1:	50                   	push   %eax
  8014c2:	6a 00                	push   $0x0
  8014c4:	e8 b0 ff ff ff       	call   801479 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	90                   	nop
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 02                	push   $0x2
  8014de:	e8 96 ff ff ff       	call   801479 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 03                	push   $0x3
  8014f7:	e8 7d ff ff ff       	call   801479 <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	90                   	nop
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 04                	push   $0x4
  801511:	e8 63 ff ff ff       	call   801479 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	90                   	nop
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80151f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	52                   	push   %edx
  80152c:	50                   	push   %eax
  80152d:	6a 08                	push   $0x8
  80152f:	e8 45 ff ff ff       	call   801479 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	56                   	push   %esi
  80153d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80153e:	8b 75 18             	mov    0x18(%ebp),%esi
  801541:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801544:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	51                   	push   %ecx
  801550:	52                   	push   %edx
  801551:	50                   	push   %eax
  801552:	6a 09                	push   $0x9
  801554:	e8 20 ff ff ff       	call   801479 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	6a 0a                	push   $0xa
  801573:	e8 01 ff ff ff       	call   801479 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	6a 0b                	push   $0xb
  80158e:	e8 e6 fe ff ff       	call   801479 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 0c                	push   $0xc
  8015a7:	e8 cd fe ff ff       	call   801479 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 0d                	push   $0xd
  8015c0:	e8 b4 fe ff ff       	call   801479 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0e                	push   $0xe
  8015d9:	e8 9b fe ff ff       	call   801479 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 0f                	push   $0xf
  8015f2:	e8 82 fe ff ff       	call   801479 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	6a 10                	push   $0x10
  80160c:	e8 68 fe ff ff       	call   801479 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 11                	push   $0x11
  801625:	e8 4f fe ff ff       	call   801479 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	90                   	nop
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_cputc>:

void
sys_cputc(const char c)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80163c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	50                   	push   %eax
  801649:	6a 01                	push   $0x1
  80164b:	e8 29 fe ff ff       	call   801479 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	90                   	nop
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 14                	push   $0x14
  801665:	e8 0f fe ff ff       	call   801479 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	90                   	nop
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80167c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80167f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	51                   	push   %ecx
  801689:	52                   	push   %edx
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	50                   	push   %eax
  80168e:	6a 15                	push   $0x15
  801690:	e8 e4 fd ff ff       	call   801479 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	52                   	push   %edx
  8016aa:	50                   	push   %eax
  8016ab:	6a 16                	push   $0x16
  8016ad:	e8 c7 fd ff ff       	call   801479 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	51                   	push   %ecx
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 17                	push   $0x17
  8016cc:	e8 a8 fd ff ff       	call   801479 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	6a 18                	push   $0x18
  8016e9:	e8 8b fd ff ff       	call   801479 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	ff 75 14             	pushl  0x14(%ebp)
  8016fe:	ff 75 10             	pushl  0x10(%ebp)
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	50                   	push   %eax
  801705:	6a 19                	push   $0x19
  801707:	e8 6d fd ff ff       	call   801479 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	50                   	push   %eax
  801720:	6a 1a                	push   $0x1a
  801722:	e8 52 fd ff ff       	call   801479 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	90                   	nop
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	50                   	push   %eax
  80173c:	6a 1b                	push   $0x1b
  80173e:	e8 36 fd ff ff       	call   801479 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 05                	push   $0x5
  801757:	e8 1d fd ff ff       	call   801479 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 06                	push   $0x6
  801770:	e8 04 fd ff ff       	call   801479 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 07                	push   $0x7
  801789:	e8 eb fc ff ff       	call   801479 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_exit_env>:


void sys_exit_env(void)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 1c                	push   $0x1c
  8017a2:	e8 d2 fc ff ff       	call   801479 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	90                   	nop
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b6:	8d 50 04             	lea    0x4(%eax),%edx
  8017b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	52                   	push   %edx
  8017c3:	50                   	push   %eax
  8017c4:	6a 1d                	push   $0x1d
  8017c6:	e8 ae fc ff ff       	call   801479 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d7:	89 01                	mov    %eax,(%ecx)
  8017d9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	c9                   	leave  
  8017e0:	c2 04 00             	ret    $0x4

008017e3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 10             	pushl  0x10(%ebp)
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	6a 13                	push   $0x13
  8017f5:	e8 7f fc ff ff       	call   801479 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fd:	90                   	nop
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_rcr2>:
uint32 sys_rcr2()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 1e                	push   $0x1e
  80180f:	e8 65 fc ff ff       	call   801479 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801825:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	50                   	push   %eax
  801832:	6a 1f                	push   $0x1f
  801834:	e8 40 fc ff ff       	call   801479 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
	return ;
  80183c:	90                   	nop
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <rsttst>:
void rsttst()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 21                	push   $0x21
  80184e:	e8 26 fc ff ff       	call   801479 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	8b 45 14             	mov    0x14(%ebp),%eax
  801862:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801865:	8b 55 18             	mov    0x18(%ebp),%edx
  801868:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186c:	52                   	push   %edx
  80186d:	50                   	push   %eax
  80186e:	ff 75 10             	pushl  0x10(%ebp)
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	6a 20                	push   $0x20
  801879:	e8 fb fb ff ff       	call   801479 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
	return ;
  801881:	90                   	nop
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <chktst>:
void chktst(uint32 n)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	6a 22                	push   $0x22
  801894:	e8 e0 fb ff ff       	call   801479 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
	return ;
  80189c:	90                   	nop
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <inctst>:

void inctst()
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 23                	push   $0x23
  8018ae:	e8 c6 fb ff ff       	call   801479 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b6:	90                   	nop
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <gettst>:
uint32 gettst()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 24                	push   $0x24
  8018c8:	e8 ac fb ff ff       	call   801479 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 25                	push   $0x25
  8018e1:	e8 93 fb ff ff       	call   801479 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
  8018e9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018ee:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	ff 75 08             	pushl  0x8(%ebp)
  80190b:	6a 26                	push   $0x26
  80190d:	e8 67 fb ff ff       	call   801479 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
	return ;
  801915:	90                   	nop
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80191c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	53                   	push   %ebx
  80192b:	51                   	push   %ecx
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 27                	push   $0x27
  801930:	e8 44 fb ff ff       	call   801479 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 28                	push   $0x28
  801950:	e8 24 fb ff ff       	call   801479 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80195d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801960:	8b 55 0c             	mov    0xc(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	51                   	push   %ecx
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	52                   	push   %edx
  80196d:	50                   	push   %eax
  80196e:	6a 29                	push   $0x29
  801970:	e8 04 fb ff ff       	call   801479 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 10             	pushl  0x10(%ebp)
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 12                	push   $0x12
  80198c:	e8 e8 fa ff ff       	call   801479 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 2a                	push   $0x2a
  8019aa:	e8 ca fa ff ff       	call   801479 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 2b                	push   $0x2b
  8019c4:	e8 b0 fa ff ff       	call   801479 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 2d                	push   $0x2d
  8019df:	e8 95 fa ff ff       	call   801479 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	6a 2c                	push   $0x2c
  8019fb:	e8 79 fa ff ff       	call   801479 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
	return ;
  801a03:	90                   	nop
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	52                   	push   %edx
  801a16:	50                   	push   %eax
  801a17:	6a 2e                	push   $0x2e
  801a19:	e8 5b fa ff ff       	call   801479 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a21:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <__udivdi3>:
  801a24:	55                   	push   %ebp
  801a25:	57                   	push   %edi
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 1c             	sub    $0x1c,%esp
  801a2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3b:	89 ca                	mov    %ecx,%edx
  801a3d:	89 f8                	mov    %edi,%eax
  801a3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a43:	85 f6                	test   %esi,%esi
  801a45:	75 2d                	jne    801a74 <__udivdi3+0x50>
  801a47:	39 cf                	cmp    %ecx,%edi
  801a49:	77 65                	ja     801ab0 <__udivdi3+0x8c>
  801a4b:	89 fd                	mov    %edi,%ebp
  801a4d:	85 ff                	test   %edi,%edi
  801a4f:	75 0b                	jne    801a5c <__udivdi3+0x38>
  801a51:	b8 01 00 00 00       	mov    $0x1,%eax
  801a56:	31 d2                	xor    %edx,%edx
  801a58:	f7 f7                	div    %edi
  801a5a:	89 c5                	mov    %eax,%ebp
  801a5c:	31 d2                	xor    %edx,%edx
  801a5e:	89 c8                	mov    %ecx,%eax
  801a60:	f7 f5                	div    %ebp
  801a62:	89 c1                	mov    %eax,%ecx
  801a64:	89 d8                	mov    %ebx,%eax
  801a66:	f7 f5                	div    %ebp
  801a68:	89 cf                	mov    %ecx,%edi
  801a6a:	89 fa                	mov    %edi,%edx
  801a6c:	83 c4 1c             	add    $0x1c,%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5f                   	pop    %edi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    
  801a74:	39 ce                	cmp    %ecx,%esi
  801a76:	77 28                	ja     801aa0 <__udivdi3+0x7c>
  801a78:	0f bd fe             	bsr    %esi,%edi
  801a7b:	83 f7 1f             	xor    $0x1f,%edi
  801a7e:	75 40                	jne    801ac0 <__udivdi3+0x9c>
  801a80:	39 ce                	cmp    %ecx,%esi
  801a82:	72 0a                	jb     801a8e <__udivdi3+0x6a>
  801a84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a88:	0f 87 9e 00 00 00    	ja     801b2c <__udivdi3+0x108>
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a93:	89 fa                	mov    %edi,%edx
  801a95:	83 c4 1c             	add    $0x1c,%esp
  801a98:	5b                   	pop    %ebx
  801a99:	5e                   	pop    %esi
  801a9a:	5f                   	pop    %edi
  801a9b:	5d                   	pop    %ebp
  801a9c:	c3                   	ret    
  801a9d:	8d 76 00             	lea    0x0(%esi),%esi
  801aa0:	31 ff                	xor    %edi,%edi
  801aa2:	31 c0                	xor    %eax,%eax
  801aa4:	89 fa                	mov    %edi,%edx
  801aa6:	83 c4 1c             	add    $0x1c,%esp
  801aa9:	5b                   	pop    %ebx
  801aaa:	5e                   	pop    %esi
  801aab:	5f                   	pop    %edi
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    
  801aae:	66 90                	xchg   %ax,%ax
  801ab0:	89 d8                	mov    %ebx,%eax
  801ab2:	f7 f7                	div    %edi
  801ab4:	31 ff                	xor    %edi,%edi
  801ab6:	89 fa                	mov    %edi,%edx
  801ab8:	83 c4 1c             	add    $0x1c,%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5f                   	pop    %edi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
  801ac0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ac5:	89 eb                	mov    %ebp,%ebx
  801ac7:	29 fb                	sub    %edi,%ebx
  801ac9:	89 f9                	mov    %edi,%ecx
  801acb:	d3 e6                	shl    %cl,%esi
  801acd:	89 c5                	mov    %eax,%ebp
  801acf:	88 d9                	mov    %bl,%cl
  801ad1:	d3 ed                	shr    %cl,%ebp
  801ad3:	89 e9                	mov    %ebp,%ecx
  801ad5:	09 f1                	or     %esi,%ecx
  801ad7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801adb:	89 f9                	mov    %edi,%ecx
  801add:	d3 e0                	shl    %cl,%eax
  801adf:	89 c5                	mov    %eax,%ebp
  801ae1:	89 d6                	mov    %edx,%esi
  801ae3:	88 d9                	mov    %bl,%cl
  801ae5:	d3 ee                	shr    %cl,%esi
  801ae7:	89 f9                	mov    %edi,%ecx
  801ae9:	d3 e2                	shl    %cl,%edx
  801aeb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aef:	88 d9                	mov    %bl,%cl
  801af1:	d3 e8                	shr    %cl,%eax
  801af3:	09 c2                	or     %eax,%edx
  801af5:	89 d0                	mov    %edx,%eax
  801af7:	89 f2                	mov    %esi,%edx
  801af9:	f7 74 24 0c          	divl   0xc(%esp)
  801afd:	89 d6                	mov    %edx,%esi
  801aff:	89 c3                	mov    %eax,%ebx
  801b01:	f7 e5                	mul    %ebp
  801b03:	39 d6                	cmp    %edx,%esi
  801b05:	72 19                	jb     801b20 <__udivdi3+0xfc>
  801b07:	74 0b                	je     801b14 <__udivdi3+0xf0>
  801b09:	89 d8                	mov    %ebx,%eax
  801b0b:	31 ff                	xor    %edi,%edi
  801b0d:	e9 58 ff ff ff       	jmp    801a6a <__udivdi3+0x46>
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b18:	89 f9                	mov    %edi,%ecx
  801b1a:	d3 e2                	shl    %cl,%edx
  801b1c:	39 c2                	cmp    %eax,%edx
  801b1e:	73 e9                	jae    801b09 <__udivdi3+0xe5>
  801b20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b23:	31 ff                	xor    %edi,%edi
  801b25:	e9 40 ff ff ff       	jmp    801a6a <__udivdi3+0x46>
  801b2a:	66 90                	xchg   %ax,%ax
  801b2c:	31 c0                	xor    %eax,%eax
  801b2e:	e9 37 ff ff ff       	jmp    801a6a <__udivdi3+0x46>
  801b33:	90                   	nop

00801b34 <__umoddi3>:
  801b34:	55                   	push   %ebp
  801b35:	57                   	push   %edi
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	83 ec 1c             	sub    $0x1c,%esp
  801b3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b53:	89 f3                	mov    %esi,%ebx
  801b55:	89 fa                	mov    %edi,%edx
  801b57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b5b:	89 34 24             	mov    %esi,(%esp)
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	75 1a                	jne    801b7c <__umoddi3+0x48>
  801b62:	39 f7                	cmp    %esi,%edi
  801b64:	0f 86 a2 00 00 00    	jbe    801c0c <__umoddi3+0xd8>
  801b6a:	89 c8                	mov    %ecx,%eax
  801b6c:	89 f2                	mov    %esi,%edx
  801b6e:	f7 f7                	div    %edi
  801b70:	89 d0                	mov    %edx,%eax
  801b72:	31 d2                	xor    %edx,%edx
  801b74:	83 c4 1c             	add    $0x1c,%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5f                   	pop    %edi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    
  801b7c:	39 f0                	cmp    %esi,%eax
  801b7e:	0f 87 ac 00 00 00    	ja     801c30 <__umoddi3+0xfc>
  801b84:	0f bd e8             	bsr    %eax,%ebp
  801b87:	83 f5 1f             	xor    $0x1f,%ebp
  801b8a:	0f 84 ac 00 00 00    	je     801c3c <__umoddi3+0x108>
  801b90:	bf 20 00 00 00       	mov    $0x20,%edi
  801b95:	29 ef                	sub    %ebp,%edi
  801b97:	89 fe                	mov    %edi,%esi
  801b99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b9d:	89 e9                	mov    %ebp,%ecx
  801b9f:	d3 e0                	shl    %cl,%eax
  801ba1:	89 d7                	mov    %edx,%edi
  801ba3:	89 f1                	mov    %esi,%ecx
  801ba5:	d3 ef                	shr    %cl,%edi
  801ba7:	09 c7                	or     %eax,%edi
  801ba9:	89 e9                	mov    %ebp,%ecx
  801bab:	d3 e2                	shl    %cl,%edx
  801bad:	89 14 24             	mov    %edx,(%esp)
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	d3 e0                	shl    %cl,%eax
  801bb4:	89 c2                	mov    %eax,%edx
  801bb6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bba:	d3 e0                	shl    %cl,%eax
  801bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc4:	89 f1                	mov    %esi,%ecx
  801bc6:	d3 e8                	shr    %cl,%eax
  801bc8:	09 d0                	or     %edx,%eax
  801bca:	d3 eb                	shr    %cl,%ebx
  801bcc:	89 da                	mov    %ebx,%edx
  801bce:	f7 f7                	div    %edi
  801bd0:	89 d3                	mov    %edx,%ebx
  801bd2:	f7 24 24             	mull   (%esp)
  801bd5:	89 c6                	mov    %eax,%esi
  801bd7:	89 d1                	mov    %edx,%ecx
  801bd9:	39 d3                	cmp    %edx,%ebx
  801bdb:	0f 82 87 00 00 00    	jb     801c68 <__umoddi3+0x134>
  801be1:	0f 84 91 00 00 00    	je     801c78 <__umoddi3+0x144>
  801be7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801beb:	29 f2                	sub    %esi,%edx
  801bed:	19 cb                	sbb    %ecx,%ebx
  801bef:	89 d8                	mov    %ebx,%eax
  801bf1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bf5:	d3 e0                	shl    %cl,%eax
  801bf7:	89 e9                	mov    %ebp,%ecx
  801bf9:	d3 ea                	shr    %cl,%edx
  801bfb:	09 d0                	or     %edx,%eax
  801bfd:	89 e9                	mov    %ebp,%ecx
  801bff:	d3 eb                	shr    %cl,%ebx
  801c01:	89 da                	mov    %ebx,%edx
  801c03:	83 c4 1c             	add    $0x1c,%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5f                   	pop    %edi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    
  801c0b:	90                   	nop
  801c0c:	89 fd                	mov    %edi,%ebp
  801c0e:	85 ff                	test   %edi,%edi
  801c10:	75 0b                	jne    801c1d <__umoddi3+0xe9>
  801c12:	b8 01 00 00 00       	mov    $0x1,%eax
  801c17:	31 d2                	xor    %edx,%edx
  801c19:	f7 f7                	div    %edi
  801c1b:	89 c5                	mov    %eax,%ebp
  801c1d:	89 f0                	mov    %esi,%eax
  801c1f:	31 d2                	xor    %edx,%edx
  801c21:	f7 f5                	div    %ebp
  801c23:	89 c8                	mov    %ecx,%eax
  801c25:	f7 f5                	div    %ebp
  801c27:	89 d0                	mov    %edx,%eax
  801c29:	e9 44 ff ff ff       	jmp    801b72 <__umoddi3+0x3e>
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	89 c8                	mov    %ecx,%eax
  801c32:	89 f2                	mov    %esi,%edx
  801c34:	83 c4 1c             	add    $0x1c,%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5f                   	pop    %edi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    
  801c3c:	3b 04 24             	cmp    (%esp),%eax
  801c3f:	72 06                	jb     801c47 <__umoddi3+0x113>
  801c41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c45:	77 0f                	ja     801c56 <__umoddi3+0x122>
  801c47:	89 f2                	mov    %esi,%edx
  801c49:	29 f9                	sub    %edi,%ecx
  801c4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c4f:	89 14 24             	mov    %edx,(%esp)
  801c52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c56:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c5a:	8b 14 24             	mov    (%esp),%edx
  801c5d:	83 c4 1c             	add    $0x1c,%esp
  801c60:	5b                   	pop    %ebx
  801c61:	5e                   	pop    %esi
  801c62:	5f                   	pop    %edi
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    
  801c65:	8d 76 00             	lea    0x0(%esi),%esi
  801c68:	2b 04 24             	sub    (%esp),%eax
  801c6b:	19 fa                	sbb    %edi,%edx
  801c6d:	89 d1                	mov    %edx,%ecx
  801c6f:	89 c6                	mov    %eax,%esi
  801c71:	e9 71 ff ff ff       	jmp    801be7 <__umoddi3+0xb3>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c7c:	72 ea                	jb     801c68 <__umoddi3+0x134>
  801c7e:	89 d9                	mov    %ebx,%ecx
  801c80:	e9 62 ff ff ff       	jmp    801be7 <__umoddi3+0xb3>
