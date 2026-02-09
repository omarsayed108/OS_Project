
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	char *str ;
	sys_create_shared_object("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 40 1d 80 00       	push   $0x801d40
  80004e:	e8 56 16 00 00       	call   8016a9 <sys_create_shared_object>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 40 1d 80 00       	push   $0x801d40
  800063:	50                   	push   %eax
  800064:	e8 f4 19 00 00       	call   801a5d <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 45 1d 80 00       	push   $0x801d45
  800079:	50                   	push   %eax
  80007a:	e8 de 19 00 00       	call   801a5d <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 30 80 00       	mov    0x803020,%eax
  800087:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  80008d:	a1 20 30 80 00       	mov    0x803020,%eax
  800092:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 20 30 80 00       	mov    0x803020,%eax
  80009f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 4d 1d 80 00       	push   $0x801d4d
  8000ad:	e8 7a 16 00 00       	call   80172c <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000bd:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8000c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c8:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 51 1d 80 00       	push   $0x801d51
  8000e3:	e8 44 16 00 00       	call   80172c <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 55 1d 80 00       	push   $0x801d55
  800102:	6a 11                	push   $0x11
  800104:	68 6a 1d 80 00       	push   $0x801d6a
  800109:	e8 d1 01 00 00       	call   8002df <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 30 16 00 00       	call   80174a <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 21 16 00 00       	call   80174a <sys_run_env>
  800129:	83 c4 10             	add    $0x10,%esp

	return;
  80012c:	90                   	nop
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800138:	e8 5d 16 00 00       	call   80179a <sys_getenvindex>
  80013d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800143:	89 d0                	mov    %edx,%eax
  800145:	01 c0                	add    %eax,%eax
  800147:	01 d0                	add    %edx,%eax
  800149:	c1 e0 02             	shl    $0x2,%eax
  80014c:	01 d0                	add    %edx,%eax
  80014e:	c1 e0 02             	shl    $0x2,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c1 e0 03             	shl    $0x3,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	c1 e0 02             	shl    $0x2,%eax
  80015b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800160:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800165:	a1 20 30 80 00       	mov    0x803020,%eax
  80016a:	8a 40 20             	mov    0x20(%eax),%al
  80016d:	84 c0                	test   %al,%al
  80016f:	74 0d                	je     80017e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800171:	a1 20 30 80 00       	mov    0x803020,%eax
  800176:	83 c0 20             	add    $0x20,%eax
  800179:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800182:	7e 0a                	jle    80018e <libmain+0x5f>
		binaryname = argv[0];
  800184:	8b 45 0c             	mov    0xc(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	ff 75 0c             	pushl  0xc(%ebp)
  800194:	ff 75 08             	pushl  0x8(%ebp)
  800197:	e8 9c fe ff ff       	call   800038 <_main>
  80019c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80019f:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	0f 84 01 01 00 00    	je     8002ad <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ac:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b2:	bb 7c 1e 80 00       	mov    $0x801e7c,%ebx
  8001b7:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	89 de                	mov    %ebx,%esi
  8001c0:	89 d1                	mov    %edx,%ecx
  8001c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001c4:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001c7:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001cc:	b0 00                	mov    $0x0,%al
  8001ce:	89 d7                	mov    %edx,%edi
  8001d0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 e4 17 00 00       	call   8019d0 <sys_utilities>
  8001ec:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001ef:	e8 2d 13 00 00       	call   801521 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 9c 1d 80 00       	push   $0x801d9c
  8001fc:	e8 cc 03 00 00       	call   8005cd <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800207:	85 c0                	test   %eax,%eax
  800209:	74 18                	je     800223 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80020b:	e8 de 17 00 00       	call   8019ee <sys_get_optimal_num_faults>
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	50                   	push   %eax
  800214:	68 c4 1d 80 00       	push   $0x801dc4
  800219:	e8 af 03 00 00       	call   8005cd <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb 59                	jmp    80027c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 e8 1d 80 00       	push   $0x801de8
  800243:	e8 85 03 00 00       	call   8005cd <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80024b:	a1 20 30 80 00       	mov    0x803020,%eax
  800250:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800261:	a1 20 30 80 00       	mov    0x803020,%eax
  800266:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80026c:	51                   	push   %ecx
  80026d:	52                   	push   %edx
  80026e:	50                   	push   %eax
  80026f:	68 10 1e 80 00       	push   $0x801e10
  800274:	e8 54 03 00 00       	call   8005cd <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80027c:	a1 20 30 80 00       	mov    0x803020,%eax
  800281:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	50                   	push   %eax
  80028b:	68 68 1e 80 00       	push   $0x801e68
  800290:	e8 38 03 00 00       	call   8005cd <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 9c 1d 80 00       	push   $0x801d9c
  8002a0:	e8 28 03 00 00       	call   8005cd <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002a8:	e8 8e 12 00 00       	call   80153b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ad:	e8 1f 00 00 00       	call   8002d1 <exit>
}
  8002b2:	90                   	nop
  8002b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b6:	5b                   	pop    %ebx
  8002b7:	5e                   	pop    %esi
  8002b8:	5f                   	pop    %edi
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 00                	push   $0x0
  8002c6:	e8 9b 14 00 00       	call   801766 <sys_destroy_env>
  8002cb:	83 c4 10             	add    $0x10,%esp
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <exit>:

void
exit(void)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002d7:	e8 f0 14 00 00       	call   8017cc <sys_exit_env>
}
  8002dc:	90                   	nop
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002e5:	8d 45 10             	lea    0x10(%ebp),%eax
  8002e8:	83 c0 04             	add    $0x4,%eax
  8002eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ee:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002f3:	85 c0                	test   %eax,%eax
  8002f5:	74 16                	je     80030d <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002f7:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	50                   	push   %eax
  800300:	68 e0 1e 80 00       	push   $0x801ee0
  800305:	e8 c3 02 00 00       	call   8005cd <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80030d:	a1 04 30 80 00       	mov    0x803004,%eax
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	50                   	push   %eax
  80031c:	68 e8 1e 80 00       	push   $0x801ee8
  800321:	6a 74                	push   $0x74
  800323:	e8 d2 02 00 00       	call   8005fa <cprintf_colored>
  800328:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80032b:	8b 45 10             	mov    0x10(%ebp),%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 f4             	pushl  -0xc(%ebp)
  800334:	50                   	push   %eax
  800335:	e8 24 02 00 00       	call   80055e <vcprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 10 1f 80 00       	push   $0x801f10
  800347:	e8 12 02 00 00       	call   80055e <vcprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80034f:	e8 7d ff ff ff       	call   8002d1 <exit>

	// should not return here
	while (1) ;
  800354:	eb fe                	jmp    800354 <_panic+0x75>

00800356 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	53                   	push   %ebx
  80035a:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80035d:	a1 20 30 80 00       	mov    0x803020,%eax
  800362:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036b:	39 c2                	cmp    %eax,%edx
  80036d:	74 14                	je     800383 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	68 14 1f 80 00       	push   $0x801f14
  800377:	6a 26                	push   $0x26
  800379:	68 60 1f 80 00       	push   $0x801f60
  80037e:	e8 5c ff ff ff       	call   8002df <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800391:	e9 d9 00 00 00       	jmp    80046f <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	75 08                	jne    8003b3 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003ab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ae:	e9 b9 00 00 00       	jmp    80046c <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c1:	eb 79                	jmp    80043c <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	01 c0                	add    %eax,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003de:	01 d8                	add    %ebx,%eax
  8003e0:	01 d0                	add    %edx,%eax
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	8a 40 04             	mov    0x4(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	75 4e                	jne    800439 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	01 c0                	add    %eax,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800406:	01 d8                	add    %ebx,%eax
  800408:	01 d0                	add    %edx,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800411:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800414:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800419:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	01 c8                	add    %ecx,%eax
  80042a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042c:	39 c2                	cmp    %eax,%edx
  80042e:	75 09                	jne    800439 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800430:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800437:	eb 19                	jmp    800452 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	ff 45 e8             	incl   -0x18(%ebp)
  80043c:	a1 20 30 80 00       	mov    0x803020,%eax
  800441:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	39 c2                	cmp    %eax,%edx
  80044c:	0f 87 71 ff ff ff    	ja     8003c3 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800452:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800456:	75 14                	jne    80046c <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	68 6c 1f 80 00       	push   $0x801f6c
  800460:	6a 3a                	push   $0x3a
  800462:	68 60 1f 80 00       	push   $0x801f60
  800467:	e8 73 fe ff ff       	call   8002df <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046c:	ff 45 f0             	incl   -0x10(%ebp)
  80046f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800472:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800475:	0f 8c 1b ff ff ff    	jl     800396 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800482:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800489:	eb 2e                	jmp    8004b9 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800496:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004a6:	01 d8                	add    %ebx,%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	01 c8                	add    %ecx,%eax
  8004ac:	8a 40 04             	mov    0x4(%eax),%al
  8004af:	3c 01                	cmp    $0x1,%al
  8004b1:	75 03                	jne    8004b6 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004b3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b6:	ff 45 e0             	incl   -0x20(%ebp)
  8004b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004be:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	77 c0                	ja     80048b <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004d1:	74 14                	je     8004e7 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004d3:	83 ec 04             	sub    $0x4,%esp
  8004d6:	68 c0 1f 80 00       	push   $0x801fc0
  8004db:	6a 44                	push   $0x44
  8004dd:	68 60 1f 80 00       	push   $0x801f60
  8004e2:	e8 f8 fd ff ff       	call   8002df <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e7:	90                   	nop
  8004e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	89 0a                	mov    %ecx,(%edx)
  800501:	8b 55 08             	mov    0x8(%ebp),%edx
  800504:	88 d1                	mov    %dl,%cl
  800506:	8b 55 0c             	mov    0xc(%ebp),%edx
  800509:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80050d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	3d ff 00 00 00       	cmp    $0xff,%eax
  800517:	75 30                	jne    800549 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800519:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80051f:	a0 44 30 80 00       	mov    0x803044,%al
  800524:	0f b6 c0             	movzbl %al,%eax
  800527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052a:	8b 09                	mov    (%ecx),%ecx
  80052c:	89 cb                	mov    %ecx,%ebx
  80052e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800531:	83 c1 08             	add    $0x8,%ecx
  800534:	52                   	push   %edx
  800535:	50                   	push   %eax
  800536:	53                   	push   %ebx
  800537:	51                   	push   %ecx
  800538:	e8 a0 0f 00 00       	call   8014dd <sys_cputs>
  80053d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800540:	8b 45 0c             	mov    0xc(%ebp),%eax
  800543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054c:	8b 40 04             	mov    0x4(%eax),%eax
  80054f:	8d 50 01             	lea    0x1(%eax),%edx
  800552:	8b 45 0c             	mov    0xc(%ebp),%eax
  800555:	89 50 04             	mov    %edx,0x4(%eax)
}
  800558:	90                   	nop
  800559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 ed 04 80 00       	push   $0x8004ed
  80058d:	e8 5a 02 00 00       	call   8007ec <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800595:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80059b:	a0 44 30 80 00       	mov    0x803044,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005a9:	52                   	push   %edx
  8005aa:	50                   	push   %eax
  8005ab:	51                   	push   %ecx
  8005ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b2:	83 c0 08             	add    $0x8,%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 22 0f 00 00       	call   8014dd <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005be:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cb:	c9                   	leave  
  8005cc:	c3                   	ret    

008005cd <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 6f ff ff ff       	call   80055e <vcprintf>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800600:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	c1 e0 08             	shl    $0x8,%eax
  80060d:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	83 c0 04             	add    $0x4,%eax
  800618:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 f4             	pushl  -0xc(%ebp)
  800624:	50                   	push   %eax
  800625:	e8 34 ff ff ff       	call   80055e <vcprintf>
  80062a:	83 c4 10             	add    $0x10,%esp
  80062d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800630:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800637:	07 00 00 

	return cnt;
  80063a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800645:	e8 d7 0e 00 00       	call   801521 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80064a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80064d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	ff 75 f4             	pushl  -0xc(%ebp)
  800659:	50                   	push   %eax
  80065a:	e8 ff fe ff ff       	call   80055e <vcprintf>
  80065f:	83 c4 10             	add    $0x10,%esp
  800662:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800665:	e8 d1 0e 00 00       	call   80153b <sys_unlock_cons>
	return cnt;
  80066a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	53                   	push   %ebx
  800673:	83 ec 14             	sub    $0x14,%esp
  800676:	8b 45 10             	mov    0x10(%ebp),%eax
  800679:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800682:	8b 45 18             	mov    0x18(%ebp),%eax
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80068d:	77 55                	ja     8006e4 <printnum+0x75>
  80068f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800692:	72 05                	jb     800699 <printnum+0x2a>
  800694:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800697:	77 4b                	ja     8006e4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800699:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80069c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80069f:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	52                   	push   %edx
  8006a8:	50                   	push   %eax
  8006a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8006af:	e8 1c 14 00 00       	call   801ad0 <__udivdi3>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	83 ec 04             	sub    $0x4,%esp
  8006ba:	ff 75 20             	pushl  0x20(%ebp)
  8006bd:	53                   	push   %ebx
  8006be:	ff 75 18             	pushl  0x18(%ebp)
  8006c1:	52                   	push   %edx
  8006c2:	50                   	push   %eax
  8006c3:	ff 75 0c             	pushl  0xc(%ebp)
  8006c6:	ff 75 08             	pushl  0x8(%ebp)
  8006c9:	e8 a1 ff ff ff       	call   80066f <printnum>
  8006ce:	83 c4 20             	add    $0x20,%esp
  8006d1:	eb 1a                	jmp    8006ed <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 0c             	pushl  0xc(%ebp)
  8006d9:	ff 75 20             	pushl  0x20(%ebp)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	ff d0                	call   *%eax
  8006e1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006e7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006eb:	7f e6                	jg     8006d3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ed:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006fb:	53                   	push   %ebx
  8006fc:	51                   	push   %ecx
  8006fd:	52                   	push   %edx
  8006fe:	50                   	push   %eax
  8006ff:	e8 dc 14 00 00       	call   801be0 <__umoddi3>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	05 34 22 80 00       	add    $0x802234,%eax
  80070c:	8a 00                	mov    (%eax),%al
  80070e:	0f be c0             	movsbl %al,%eax
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	50                   	push   %eax
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
}
  800720:	90                   	nop
  800721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800729:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80072d:	7e 1c                	jle    80074b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	8d 50 08             	lea    0x8(%eax),%edx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	89 10                	mov    %edx,(%eax)
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	83 e8 08             	sub    $0x8,%eax
  800744:	8b 50 04             	mov    0x4(%eax),%edx
  800747:	8b 00                	mov    (%eax),%eax
  800749:	eb 40                	jmp    80078b <getuint+0x65>
	else if (lflag)
  80074b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074f:	74 1e                	je     80076f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	8d 50 04             	lea    0x4(%eax),%edx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	89 10                	mov    %edx,(%eax)
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	83 e8 04             	sub    $0x4,%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	ba 00 00 00 00       	mov    $0x0,%edx
  80076d:	eb 1c                	jmp    80078b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800790:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800794:	7e 1c                	jle    8007b2 <getint+0x25>
		return va_arg(*ap, long long);
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	8d 50 08             	lea    0x8(%eax),%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	89 10                	mov    %edx,(%eax)
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	83 e8 08             	sub    $0x8,%eax
  8007ab:	8b 50 04             	mov    0x4(%eax),%edx
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	eb 38                	jmp    8007ea <getint+0x5d>
	else if (lflag)
  8007b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b6:	74 1a                	je     8007d2 <getint+0x45>
		return va_arg(*ap, long);
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	8d 50 04             	lea    0x4(%eax),%edx
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	89 10                	mov    %edx,(%eax)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	83 e8 04             	sub    $0x4,%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	99                   	cltd   
  8007d0:	eb 18                	jmp    8007ea <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	8d 50 04             	lea    0x4(%eax),%edx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	89 10                	mov    %edx,(%eax)
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	83 e8 04             	sub    $0x4,%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	99                   	cltd   
}
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	56                   	push   %esi
  8007f0:	53                   	push   %ebx
  8007f1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f4:	eb 17                	jmp    80080d <vprintfmt+0x21>
			if (ch == '\0')
  8007f6:	85 db                	test   %ebx,%ebx
  8007f8:	0f 84 c1 03 00 00    	je     800bbf <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	53                   	push   %ebx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	8d 50 01             	lea    0x1(%eax),%edx
  800813:	89 55 10             	mov    %edx,0x10(%ebp)
  800816:	8a 00                	mov    (%eax),%al
  800818:	0f b6 d8             	movzbl %al,%ebx
  80081b:	83 fb 25             	cmp    $0x25,%ebx
  80081e:	75 d6                	jne    8007f6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800820:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800824:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80082b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800832:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800839:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800840:	8b 45 10             	mov    0x10(%ebp),%eax
  800843:	8d 50 01             	lea    0x1(%eax),%edx
  800846:	89 55 10             	mov    %edx,0x10(%ebp)
  800849:	8a 00                	mov    (%eax),%al
  80084b:	0f b6 d8             	movzbl %al,%ebx
  80084e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800851:	83 f8 5b             	cmp    $0x5b,%eax
  800854:	0f 87 3d 03 00 00    	ja     800b97 <vprintfmt+0x3ab>
  80085a:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  800861:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800863:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800867:	eb d7                	jmp    800840 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800869:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80086d:	eb d1                	jmp    800840 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80086f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800876:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800879:	89 d0                	mov    %edx,%eax
  80087b:	c1 e0 02             	shl    $0x2,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	01 c0                	add    %eax,%eax
  800882:	01 d8                	add    %ebx,%eax
  800884:	83 e8 30             	sub    $0x30,%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80088a:	8b 45 10             	mov    0x10(%ebp),%eax
  80088d:	8a 00                	mov    (%eax),%al
  80088f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800892:	83 fb 2f             	cmp    $0x2f,%ebx
  800895:	7e 3e                	jle    8008d5 <vprintfmt+0xe9>
  800897:	83 fb 39             	cmp    $0x39,%ebx
  80089a:	7f 39                	jg     8008d5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80089f:	eb d5                	jmp    800876 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 c0 04             	add    $0x4,%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 e8 04             	sub    $0x4,%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b5:	eb 1f                	jmp    8008d6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bb:	79 83                	jns    800840 <vprintfmt+0x54>
				width = 0;
  8008bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c4:	e9 77 ff ff ff       	jmp    800840 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008c9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d0:	e9 6b ff ff ff       	jmp    800840 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008da:	0f 89 60 ff ff ff    	jns    800840 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ed:	e9 4e ff ff ff       	jmp    800840 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f5:	e9 46 ff ff ff       	jmp    800840 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	83 c0 04             	add    $0x4,%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 e8 04             	sub    $0x4,%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
			break;
  80091a:	e9 9b 02 00 00       	jmp    800bba <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	83 c0 04             	add    $0x4,%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	83 e8 04             	sub    $0x4,%eax
  80092e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800930:	85 db                	test   %ebx,%ebx
  800932:	79 02                	jns    800936 <vprintfmt+0x14a>
				err = -err;
  800934:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800936:	83 fb 64             	cmp    $0x64,%ebx
  800939:	7f 0b                	jg     800946 <vprintfmt+0x15a>
  80093b:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  800942:	85 f6                	test   %esi,%esi
  800944:	75 19                	jne    80095f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800946:	53                   	push   %ebx
  800947:	68 45 22 80 00       	push   $0x802245
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	ff 75 08             	pushl  0x8(%ebp)
  800952:	e8 70 02 00 00       	call   800bc7 <printfmt>
  800957:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80095a:	e9 5b 02 00 00       	jmp    800bba <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80095f:	56                   	push   %esi
  800960:	68 4e 22 80 00       	push   $0x80224e
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	ff 75 08             	pushl  0x8(%ebp)
  80096b:	e8 57 02 00 00       	call   800bc7 <printfmt>
  800970:	83 c4 10             	add    $0x10,%esp
			break;
  800973:	e9 42 02 00 00       	jmp    800bba <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	83 c0 04             	add    $0x4,%eax
  80097e:	89 45 14             	mov    %eax,0x14(%ebp)
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	83 e8 04             	sub    $0x4,%eax
  800987:	8b 30                	mov    (%eax),%esi
  800989:	85 f6                	test   %esi,%esi
  80098b:	75 05                	jne    800992 <vprintfmt+0x1a6>
				p = "(null)";
  80098d:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  800992:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800996:	7e 6d                	jle    800a05 <vprintfmt+0x219>
  800998:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80099c:	74 67                	je     800a05 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	50                   	push   %eax
  8009a5:	56                   	push   %esi
  8009a6:	e8 1e 03 00 00       	call   800cc9 <strnlen>
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b1:	eb 16                	jmp    8009c9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	50                   	push   %eax
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cd:	7f e4                	jg     8009b3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cf:	eb 34                	jmp    800a05 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d5:	74 1c                	je     8009f3 <vprintfmt+0x207>
  8009d7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009da:	7e 05                	jle    8009e1 <vprintfmt+0x1f5>
  8009dc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009df:	7e 12                	jle    8009f3 <vprintfmt+0x207>
					putch('?', putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	6a 3f                	push   $0x3f
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	eb 0f                	jmp    800a02 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	53                   	push   %ebx
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	ff d0                	call   *%eax
  8009ff:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a02:	ff 4d e4             	decl   -0x1c(%ebp)
  800a05:	89 f0                	mov    %esi,%eax
  800a07:	8d 70 01             	lea    0x1(%eax),%esi
  800a0a:	8a 00                	mov    (%eax),%al
  800a0c:	0f be d8             	movsbl %al,%ebx
  800a0f:	85 db                	test   %ebx,%ebx
  800a11:	74 24                	je     800a37 <vprintfmt+0x24b>
  800a13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a17:	78 b8                	js     8009d1 <vprintfmt+0x1e5>
  800a19:	ff 4d e0             	decl   -0x20(%ebp)
  800a1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a20:	79 af                	jns    8009d1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a22:	eb 13                	jmp    800a37 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 20                	push   $0x20
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3b:	7f e7                	jg     800a24 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a3d:	e9 78 01 00 00       	jmp    800bba <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 e8             	pushl  -0x18(%ebp)
  800a48:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4b:	50                   	push   %eax
  800a4c:	e8 3c fd ff ff       	call   80078d <getint>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a60:	85 d2                	test   %edx,%edx
  800a62:	79 23                	jns    800a87 <vprintfmt+0x29b>
				putch('-', putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	6a 2d                	push   $0x2d
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	ff d0                	call   *%eax
  800a71:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7a:	f7 d8                	neg    %eax
  800a7c:	83 d2 00             	adc    $0x0,%edx
  800a7f:	f7 da                	neg    %edx
  800a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a87:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a8e:	e9 bc 00 00 00       	jmp    800b4f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 e8             	pushl  -0x18(%ebp)
  800a99:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	e8 84 fc ff ff       	call   800726 <getuint>
  800aa2:	83 c4 10             	add    $0x10,%esp
  800aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab2:	e9 98 00 00 00       	jmp    800b4f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 58                	push   $0x58
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			break;
  800ae7:	e9 ce 00 00 00       	jmp    800bba <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	6a 30                	push   $0x30
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	ff d0                	call   *%eax
  800af9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 78                	push   $0x78
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b27:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b2e:	eb 1f                	jmp    800b4f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b30:	83 ec 08             	sub    $0x8,%esp
  800b33:	ff 75 e8             	pushl  -0x18(%ebp)
  800b36:	8d 45 14             	lea    0x14(%ebp),%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 e7 fb ff ff       	call   800726 <getuint>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b4f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b56:	83 ec 04             	sub    $0x4,%esp
  800b59:	52                   	push   %edx
  800b5a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b5d:	50                   	push   %eax
  800b5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b61:	ff 75 f0             	pushl  -0x10(%ebp)
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	ff 75 08             	pushl  0x8(%ebp)
  800b6a:	e8 00 fb ff ff       	call   80066f <printnum>
  800b6f:	83 c4 20             	add    $0x20,%esp
			break;
  800b72:	eb 46                	jmp    800bba <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	53                   	push   %ebx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
			break;
  800b83:	eb 35                	jmp    800bba <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b85:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b8c:	eb 2c                	jmp    800bba <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b8e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b95:	eb 23                	jmp    800bba <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	6a 25                	push   $0x25
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	ff d0                	call   *%eax
  800ba4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba7:	ff 4d 10             	decl   0x10(%ebp)
  800baa:	eb 03                	jmp    800baf <vprintfmt+0x3c3>
  800bac:	ff 4d 10             	decl   0x10(%ebp)
  800baf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb2:	48                   	dec    %eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	3c 25                	cmp    $0x25,%al
  800bb7:	75 f3                	jne    800bac <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bb9:	90                   	nop
		}
	}
  800bba:	e9 35 fc ff ff       	jmp    8007f4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 04 fc ff ff       	call   8007ec <vprintfmt>
  800be8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800beb:	90                   	nop
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf4:	8b 40 08             	mov    0x8(%eax),%eax
  800bf7:	8d 50 01             	lea    0x1(%eax),%edx
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c03:	8b 10                	mov    (%eax),%edx
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8b 40 04             	mov    0x4(%eax),%eax
  800c0b:	39 c2                	cmp    %eax,%edx
  800c0d:	73 12                	jae    800c21 <sprintputch+0x33>
		*b->buf++ = ch;
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 48 01             	lea    0x1(%eax),%ecx
  800c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1a:	89 0a                	mov    %ecx,(%edx)
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	88 10                	mov    %dl,(%eax)
}
  800c21:	90                   	nop
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c49:	74 06                	je     800c51 <vsnprintf+0x2d>
  800c4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4f:	7f 07                	jg     800c58 <vsnprintf+0x34>
		return -E_INVAL;
  800c51:	b8 03 00 00 00       	mov    $0x3,%eax
  800c56:	eb 20                	jmp    800c78 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c58:	ff 75 14             	pushl  0x14(%ebp)
  800c5b:	ff 75 10             	pushl  0x10(%ebp)
  800c5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c61:	50                   	push   %eax
  800c62:	68 ee 0b 80 00       	push   $0x800bee
  800c67:	e8 80 fb ff ff       	call   8007ec <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c72:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c80:	8d 45 10             	lea    0x10(%ebp),%eax
  800c83:	83 c0 04             	add    $0x4,%eax
  800c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c89:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8f:	50                   	push   %eax
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	ff 75 08             	pushl  0x8(%ebp)
  800c96:	e8 89 ff ff ff       	call   800c24 <vsnprintf>
  800c9b:	83 c4 10             	add    $0x10,%esp
  800c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb3:	eb 06                	jmp    800cbb <strlen+0x15>
		n++;
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 f1                	jne    800cb5 <strlen+0xf>
		n++;
	return n;
  800cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd6:	eb 09                	jmp    800ce1 <strnlen+0x18>
		n++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdb:	ff 45 08             	incl   0x8(%ebp)
  800cde:	ff 4d 0c             	decl   0xc(%ebp)
  800ce1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce5:	74 09                	je     800cf0 <strnlen+0x27>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	84 c0                	test   %al,%al
  800cee:	75 e8                	jne    800cd8 <strnlen+0xf>
		n++;
	return n;
  800cf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d01:	90                   	nop
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8d 50 01             	lea    0x1(%eax),%edx
  800d08:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d14:	8a 12                	mov    (%edx),%dl
  800d16:	88 10                	mov    %dl,(%eax)
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	84 c0                	test   %al,%al
  800d1c:	75 e4                	jne    800d02 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d36:	eb 1f                	jmp    800d57 <strncpy+0x34>
		*dst++ = *src;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8d 50 01             	lea    0x1(%eax),%edx
  800d3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d44:	8a 12                	mov    (%edx),%dl
  800d46:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	74 03                	je     800d54 <strncpy+0x31>
			src++;
  800d51:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d54:	ff 45 fc             	incl   -0x4(%ebp)
  800d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5d:	72 d9                	jb     800d38 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d74:	74 30                	je     800da6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d76:	eb 16                	jmp    800d8e <strlcpy+0x2a>
			*dst++ = *src++;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8d 50 01             	lea    0x1(%eax),%edx
  800d7e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d87:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d8a:	8a 12                	mov    (%edx),%dl
  800d8c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8e:	ff 4d 10             	decl   0x10(%ebp)
  800d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d95:	74 09                	je     800da0 <strlcpy+0x3c>
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	84 c0                	test   %al,%al
  800d9e:	75 d8                	jne    800d78 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	29 c2                	sub    %eax,%edx
  800dae:	89 d0                	mov    %edx,%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db5:	eb 06                	jmp    800dbd <strcmp+0xb>
		p++, q++;
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	84 c0                	test   %al,%al
  800dc4:	74 0e                	je     800dd4 <strcmp+0x22>
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 e3                	je     800db7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
}
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ded:	eb 09                	jmp    800df8 <strncmp+0xe>
		n--, p++, q++;
  800def:	ff 4d 10             	decl   0x10(%ebp)
  800df2:	ff 45 08             	incl   0x8(%ebp)
  800df5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfc:	74 17                	je     800e15 <strncmp+0x2b>
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	84 c0                	test   %al,%al
  800e05:	74 0e                	je     800e15 <strncmp+0x2b>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 10                	mov    (%eax),%dl
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	38 c2                	cmp    %al,%dl
  800e13:	74 da                	je     800def <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	75 07                	jne    800e22 <strncmp+0x38>
		return 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e20:	eb 14                	jmp    800e36 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	0f b6 d0             	movzbl %al,%edx
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	0f b6 c0             	movzbl %al,%eax
  800e32:	29 c2                	sub    %eax,%edx
  800e34:	89 d0                	mov    %edx,%eax
}
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    

00800e38 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 04             	sub    $0x4,%esp
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e44:	eb 12                	jmp    800e58 <strchr+0x20>
		if (*s == c)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4e:	75 05                	jne    800e55 <strchr+0x1d>
			return (char *) s;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	eb 11                	jmp    800e66 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 e5                	jne    800e46 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 04             	sub    $0x4,%esp
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e74:	eb 0d                	jmp    800e83 <strfind+0x1b>
		if (*s == c)
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7e:	74 0e                	je     800e8e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e80:	ff 45 08             	incl   0x8(%ebp)
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	84 c0                	test   %al,%al
  800e8a:	75 ea                	jne    800e76 <strfind+0xe>
  800e8c:	eb 01                	jmp    800e8f <strfind+0x27>
		if (*s == c)
			break;
  800e8e:	90                   	nop
	return (char *) s;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e92:	c9                   	leave  
  800e93:	c3                   	ret    

00800e94 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ea0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea4:	76 63                	jbe    800f09 <memset+0x75>
		uint64 data_block = c;
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	99                   	cltd   
  800eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ead:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eba:	c1 e0 08             	shl    $0x8,%eax
  800ebd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ecd:	c1 e0 10             	shl    $0x10,%eax
  800ed0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edc:	89 c2                	mov    %eax,%edx
  800ede:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ee9:	eb 18                	jmp    800f03 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eeb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eee:	8d 41 08             	lea    0x8(%ecx),%eax
  800ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efa:	89 01                	mov    %eax,(%ecx)
  800efc:	89 51 04             	mov    %edx,0x4(%ecx)
  800eff:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f03:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f07:	77 e2                	ja     800eeb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0d:	74 23                	je     800f32 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f15:	eb 0e                	jmp    800f25 <memset+0x91>
			*p8++ = (uint8)c;
  800f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1a:	8d 50 01             	lea    0x1(%eax),%edx
  800f1d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	75 e5                	jne    800f17 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f49:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4d:	76 24                	jbe    800f73 <memcpy+0x3c>
		while(n >= 8){
  800f4f:	eb 1c                	jmp    800f6d <memcpy+0x36>
			*d64 = *s64;
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	8b 50 04             	mov    0x4(%eax),%edx
  800f57:	8b 00                	mov    (%eax),%eax
  800f59:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f5c:	89 01                	mov    %eax,(%ecx)
  800f5e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f61:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f65:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f69:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f6d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f71:	77 de                	ja     800f51 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f77:	74 31                	je     800faa <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f85:	eb 16                	jmp    800f9d <memcpy+0x66>
			*d8++ = *s8++;
  800f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8a:	8d 50 01             	lea    0x1(%eax),%edx
  800f8d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f96:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f99:	8a 12                	mov    (%edx),%dl
  800f9b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	75 dd                	jne    800f87 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc7:	73 50                	jae    801019 <memmove+0x6a>
  800fc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd4:	76 43                	jbe    801019 <memmove+0x6a>
		s += n;
  800fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe2:	eb 10                	jmp    800ff4 <memmove+0x45>
			*--d = *--s;
  800fe4:	ff 4d f8             	decl   -0x8(%ebp)
  800fe7:	ff 4d fc             	decl   -0x4(%ebp)
  800fea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fed:	8a 10                	mov    (%eax),%dl
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 e3                	jne    800fe4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801001:	eb 23                	jmp    801026 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801006:	8d 50 01             	lea    0x1(%eax),%edx
  801009:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801012:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801015:	8a 12                	mov    (%edx),%dl
  801017:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 dd                	jne    801003 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80103d:	eb 2a                	jmp    801069 <memcmp+0x3e>
		if (*s1 != *s2)
  80103f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801042:	8a 10                	mov    (%eax),%dl
  801044:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	38 c2                	cmp    %al,%dl
  80104b:	74 16                	je     801063 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80104d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	0f b6 d0             	movzbl %al,%edx
  801055:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f b6 c0             	movzbl %al,%eax
  80105d:	29 c2                	sub    %eax,%edx
  80105f:	89 d0                	mov    %edx,%eax
  801061:	eb 18                	jmp    80107b <memcmp+0x50>
		s1++, s2++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
  801066:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106f:	89 55 10             	mov    %edx,0x10(%ebp)
  801072:	85 c0                	test   %eax,%eax
  801074:	75 c9                	jne    80103f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	8b 45 10             	mov    0x10(%ebp),%eax
  801089:	01 d0                	add    %edx,%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80108e:	eb 15                	jmp    8010a5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f b6 d0             	movzbl %al,%edx
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	0f b6 c0             	movzbl %al,%eax
  80109e:	39 c2                	cmp    %eax,%edx
  8010a0:	74 0d                	je     8010af <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a2:	ff 45 08             	incl   0x8(%ebp)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ab:	72 e3                	jb     801090 <memfind+0x13>
  8010ad:	eb 01                	jmp    8010b0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010af:	90                   	nop
	return (void *) s;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c9:	eb 03                	jmp    8010ce <strtol+0x19>
		s++;
  8010cb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	3c 20                	cmp    $0x20,%al
  8010d5:	74 f4                	je     8010cb <strtol+0x16>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 09                	cmp    $0x9,%al
  8010de:	74 eb                	je     8010cb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 2b                	cmp    $0x2b,%al
  8010e7:	75 05                	jne    8010ee <strtol+0x39>
		s++;
  8010e9:	ff 45 08             	incl   0x8(%ebp)
  8010ec:	eb 13                	jmp    801101 <strtol+0x4c>
	else if (*s == '-')
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3c 2d                	cmp    $0x2d,%al
  8010f5:	75 0a                	jne    801101 <strtol+0x4c>
		s++, neg = 1;
  8010f7:	ff 45 08             	incl   0x8(%ebp)
  8010fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801105:	74 06                	je     80110d <strtol+0x58>
  801107:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80110b:	75 20                	jne    80112d <strtol+0x78>
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 30                	cmp    $0x30,%al
  801114:	75 17                	jne    80112d <strtol+0x78>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	40                   	inc    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 78                	cmp    $0x78,%al
  80111e:	75 0d                	jne    80112d <strtol+0x78>
		s += 2, base = 16;
  801120:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801124:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80112b:	eb 28                	jmp    801155 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80112d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801131:	75 15                	jne    801148 <strtol+0x93>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 30                	cmp    $0x30,%al
  80113a:	75 0c                	jne    801148 <strtol+0x93>
		s++, base = 8;
  80113c:	ff 45 08             	incl   0x8(%ebp)
  80113f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801146:	eb 0d                	jmp    801155 <strtol+0xa0>
	else if (base == 0)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	75 07                	jne    801155 <strtol+0xa0>
		base = 10;
  80114e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 2f                	cmp    $0x2f,%al
  80115c:	7e 19                	jle    801177 <strtol+0xc2>
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 39                	cmp    $0x39,%al
  801165:	7f 10                	jg     801177 <strtol+0xc2>
			dig = *s - '0';
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f be c0             	movsbl %al,%eax
  80116f:	83 e8 30             	sub    $0x30,%eax
  801172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801175:	eb 42                	jmp    8011b9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 60                	cmp    $0x60,%al
  80117e:	7e 19                	jle    801199 <strtol+0xe4>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 7a                	cmp    $0x7a,%al
  801187:	7f 10                	jg     801199 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f be c0             	movsbl %al,%eax
  801191:	83 e8 57             	sub    $0x57,%eax
  801194:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801197:	eb 20                	jmp    8011b9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	3c 40                	cmp    $0x40,%al
  8011a0:	7e 39                	jle    8011db <strtol+0x126>
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	3c 5a                	cmp    $0x5a,%al
  8011a9:	7f 30                	jg     8011db <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	0f be c0             	movsbl %al,%eax
  8011b3:	83 e8 37             	sub    $0x37,%eax
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011bf:	7d 19                	jge    8011da <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011c1:	ff 45 08             	incl   0x8(%ebp)
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011cb:	89 c2                	mov    %eax,%edx
  8011cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d0:	01 d0                	add    %edx,%eax
  8011d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d5:	e9 7b ff ff ff       	jmp    801155 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011da:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011df:	74 08                	je     8011e9 <strtol+0x134>
		*endptr = (char *) s;
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 07                	je     8011f6 <strtol+0x141>
  8011ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f2:	f7 d8                	neg    %eax
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x144>
  8011f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <ltostr>:

void
ltostr(long value, char *str)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801201:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801208:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80120f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801213:	79 13                	jns    801228 <ltostr+0x2d>
	{
		neg = 1;
  801215:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801222:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801225:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801230:	99                   	cltd   
  801231:	f7 f9                	idiv   %ecx
  801233:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801236:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801239:	8d 50 01             	lea    0x1(%eax),%edx
  80123c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80123f:	89 c2                	mov    %eax,%edx
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801249:	83 c2 30             	add    $0x30,%edx
  80124c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80124e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801251:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801256:	f7 e9                	imul   %ecx
  801258:	c1 fa 02             	sar    $0x2,%edx
  80125b:	89 c8                	mov    %ecx,%eax
  80125d:	c1 f8 1f             	sar    $0x1f,%eax
  801260:	29 c2                	sub    %eax,%edx
  801262:	89 d0                	mov    %edx,%eax
  801264:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801267:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126b:	75 bb                	jne    801228 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80126d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801274:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801277:	48                   	dec    %eax
  801278:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80127b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127f:	74 3d                	je     8012be <ltostr+0xc3>
		start = 1 ;
  801281:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801288:	eb 34                	jmp    8012be <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 d0                	add    %edx,%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	01 c2                	add    %eax,%edx
  80129f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c8                	add    %ecx,%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b6:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012bb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c c4                	jl     80128a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	e8 c4 f9 ff ff       	call   800ca6 <strlen>
  8012e2:	83 c4 04             	add    $0x4,%esp
  8012e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	e8 b6 f9 ff ff       	call   800ca6 <strlen>
  8012f0:	83 c4 04             	add    $0x4,%esp
  8012f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801304:	eb 17                	jmp    80131d <strcconcat+0x49>
		final[s] = str1[s] ;
  801306:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801309:	8b 45 10             	mov    0x10(%ebp),%eax
  80130c:	01 c2                	add    %eax,%edx
  80130e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	01 c8                	add    %ecx,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80131a:	ff 45 fc             	incl   -0x4(%ebp)
  80131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801320:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801323:	7c e1                	jl     801306 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801325:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80132c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801333:	eb 1f                	jmp    801354 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801335:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801338:	8d 50 01             	lea    0x1(%eax),%edx
  80133b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133e:	89 c2                	mov    %eax,%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 c8                	add    %ecx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801351:	ff 45 f8             	incl   -0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135a:	7c d9                	jl     801335 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80135c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	01 d0                	add    %edx,%eax
  801364:	c6 00 00             	movb   $0x0,(%eax)
}
  801367:	90                   	nop
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80136d:	8b 45 14             	mov    0x14(%ebp),%eax
  801370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138d:	eb 0c                	jmp    80139b <strsplit+0x31>
			*string++ = 0;
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8d 50 01             	lea    0x1(%eax),%edx
  801395:	89 55 08             	mov    %edx,0x8(%ebp)
  801398:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	84 c0                	test   %al,%al
  8013a2:	74 18                	je     8013bc <strsplit+0x52>
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	0f be c0             	movsbl %al,%eax
  8013ac:	50                   	push   %eax
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	e8 83 fa ff ff       	call   800e38 <strchr>
  8013b5:	83 c4 08             	add    $0x8,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	75 d3                	jne    80138f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	84 c0                	test   %al,%al
  8013c3:	74 5a                	je     80141f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c8:	8b 00                	mov    (%eax),%eax
  8013ca:	83 f8 0f             	cmp    $0xf,%eax
  8013cd:	75 07                	jne    8013d6 <strsplit+0x6c>
		{
			return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d4:	eb 66                	jmp    80143c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	8d 48 01             	lea    0x1(%eax),%ecx
  8013de:	8b 55 14             	mov    0x14(%ebp),%edx
  8013e1:	89 0a                	mov    %ecx,(%edx)
  8013e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ed:	01 c2                	add    %eax,%edx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f4:	eb 03                	jmp    8013f9 <strsplit+0x8f>
			string++;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	84 c0                	test   %al,%al
  801400:	74 8b                	je     80138d <strsplit+0x23>
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	0f be c0             	movsbl %al,%eax
  80140a:	50                   	push   %eax
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	e8 25 fa ff ff       	call   800e38 <strchr>
  801413:	83 c4 08             	add    $0x8,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	74 dc                	je     8013f6 <strsplit+0x8c>
			string++;
	}
  80141a:	e9 6e ff ff ff       	jmp    80138d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801420:	8b 45 14             	mov    0x14(%ebp),%eax
  801423:	8b 00                	mov    (%eax),%eax
  801425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801437:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80144a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801451:	eb 4a                	jmp    80149d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	01 c2                	add    %eax,%edx
  80145b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801461:	01 c8                	add    %ecx,%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801467:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	3c 40                	cmp    $0x40,%al
  801473:	7e 25                	jle    80149a <str2lower+0x5c>
  801475:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	3c 5a                	cmp    $0x5a,%al
  801481:	7f 17                	jg     80149a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801483:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	01 d0                	add    %edx,%eax
  80148b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148e:	8b 55 08             	mov    0x8(%ebp),%edx
  801491:	01 ca                	add    %ecx,%edx
  801493:	8a 12                	mov    (%edx),%dl
  801495:	83 c2 20             	add    $0x20,%edx
  801498:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80149a:	ff 45 fc             	incl   -0x4(%ebp)
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	e8 01 f8 ff ff       	call   800ca6 <strlen>
  8014a5:	83 c4 04             	add    $0x4,%esp
  8014a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ab:	7f a6                	jg     801453 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	57                   	push   %edi
  8014b6:	56                   	push   %esi
  8014b7:	53                   	push   %ebx
  8014b8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ca:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014cd:	cd 30                	int    $0x30
  8014cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	5b                   	pop    %ebx
  8014d9:	5e                   	pop    %esi
  8014da:	5f                   	pop    %edi
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    

008014dd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	6a 00                	push   $0x0
  8014f5:	51                   	push   %ecx
  8014f6:	52                   	push   %edx
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	50                   	push   %eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	e8 b0 ff ff ff       	call   8014b2 <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_cgetc>:

int
sys_cgetc(void)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 02                	push   $0x2
  801517:	e8 96 ff ff ff       	call   8014b2 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 03                	push   $0x3
  801530:	e8 7d ff ff ff       	call   8014b2 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	90                   	nop
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 04                	push   $0x4
  80154a:	e8 63 ff ff ff       	call   8014b2 <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	90                   	nop
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	52                   	push   %edx
  801565:	50                   	push   %eax
  801566:	6a 08                	push   $0x8
  801568:	e8 45 ff ff ff       	call   8014b2 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	56                   	push   %esi
  801576:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801577:	8b 75 18             	mov    0x18(%ebp),%esi
  80157a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80157d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801580:	8b 55 0c             	mov    0xc(%ebp),%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	51                   	push   %ecx
  801589:	52                   	push   %edx
  80158a:	50                   	push   %eax
  80158b:	6a 09                	push   $0x9
  80158d:	e8 20 ff ff ff       	call   8014b2 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801598:	5b                   	pop    %ebx
  801599:	5e                   	pop    %esi
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	ff 75 08             	pushl  0x8(%ebp)
  8015aa:	6a 0a                	push   $0xa
  8015ac:	e8 01 ff ff ff       	call   8014b2 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	6a 0b                	push   $0xb
  8015c7:	e8 e6 fe ff ff       	call   8014b2 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 0c                	push   $0xc
  8015e0:	e8 cd fe ff ff       	call   8014b2 <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 0d                	push   $0xd
  8015f9:	e8 b4 fe ff ff       	call   8014b2 <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 0e                	push   $0xe
  801612:	e8 9b fe ff ff       	call   8014b2 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 0f                	push   $0xf
  80162b:	e8 82 fe ff ff       	call   8014b2 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	ff 75 08             	pushl  0x8(%ebp)
  801643:	6a 10                	push   $0x10
  801645:	e8 68 fe ff ff       	call   8014b2 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 11                	push   $0x11
  80165e:	e8 4f fe ff ff       	call   8014b2 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_cputc>:

void
sys_cputc(const char c)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801675:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	50                   	push   %eax
  801682:	6a 01                	push   $0x1
  801684:	e8 29 fe ff ff       	call   8014b2 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	90                   	nop
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 14                	push   $0x14
  80169e:	e8 0f fe ff ff       	call   8014b2 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016b5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	51                   	push   %ecx
  8016c2:	52                   	push   %edx
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	50                   	push   %eax
  8016c7:	6a 15                	push   $0x15
  8016c9:	e8 e4 fd ff ff       	call   8014b2 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	6a 16                	push   $0x16
  8016e6:	e8 c7 fd ff ff       	call   8014b2 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	51                   	push   %ecx
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 17                	push   $0x17
  801705:	e8 a8 fd ff ff       	call   8014b2 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	52                   	push   %edx
  80171f:	50                   	push   %eax
  801720:	6a 18                	push   $0x18
  801722:	e8 8b fd ff ff       	call   8014b2 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	ff 75 14             	pushl  0x14(%ebp)
  801737:	ff 75 10             	pushl  0x10(%ebp)
  80173a:	ff 75 0c             	pushl  0xc(%ebp)
  80173d:	50                   	push   %eax
  80173e:	6a 19                	push   $0x19
  801740:	e8 6d fd ff ff       	call   8014b2 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	50                   	push   %eax
  801759:	6a 1a                	push   $0x1a
  80175b:	e8 52 fd ff ff       	call   8014b2 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	90                   	nop
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	50                   	push   %eax
  801775:	6a 1b                	push   $0x1b
  801777:	e8 36 fd ff ff       	call   8014b2 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 05                	push   $0x5
  801790:	e8 1d fd ff ff       	call   8014b2 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 06                	push   $0x6
  8017a9:	e8 04 fd ff ff       	call   8014b2 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 07                	push   $0x7
  8017c2:	e8 eb fc ff ff       	call   8014b2 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_exit_env>:


void sys_exit_env(void)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 1c                	push   $0x1c
  8017db:	e8 d2 fc ff ff       	call   8014b2 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ef:	8d 50 04             	lea    0x4(%eax),%edx
  8017f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	52                   	push   %edx
  8017fc:	50                   	push   %eax
  8017fd:	6a 1d                	push   $0x1d
  8017ff:	e8 ae fc ff ff       	call   8014b2 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
	return result;
  801807:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801810:	89 01                	mov    %eax,(%ecx)
  801812:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	c9                   	leave  
  801819:	c2 04 00             	ret    $0x4

0080181c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	ff 75 10             	pushl  0x10(%ebp)
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	6a 13                	push   $0x13
  80182e:	e8 7f fc ff ff       	call   8014b2 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
	return ;
  801836:	90                   	nop
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_rcr2>:
uint32 sys_rcr2()
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 1e                	push   $0x1e
  801848:	e8 65 fc ff ff       	call   8014b2 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80185e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	50                   	push   %eax
  80186b:	6a 1f                	push   $0x1f
  80186d:	e8 40 fc ff ff       	call   8014b2 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
	return ;
  801875:	90                   	nop
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <rsttst>:
void rsttst()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 21                	push   $0x21
  801887:	e8 26 fc ff ff       	call   8014b2 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
	return ;
  80188f:	90                   	nop
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	8b 45 14             	mov    0x14(%ebp),%eax
  80189b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80189e:	8b 55 18             	mov    0x18(%ebp),%edx
  8018a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	ff 75 10             	pushl  0x10(%ebp)
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	ff 75 08             	pushl  0x8(%ebp)
  8018b0:	6a 20                	push   $0x20
  8018b2:	e8 fb fb ff ff       	call   8014b2 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ba:	90                   	nop
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <chktst>:
void chktst(uint32 n)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 22                	push   $0x22
  8018cd:	e8 e0 fb ff ff       	call   8014b2 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <inctst>:

void inctst()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 23                	push   $0x23
  8018e7:	e8 c6 fb ff ff       	call   8014b2 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ef:	90                   	nop
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <gettst>:
uint32 gettst()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 24                	push   $0x24
  801901:	e8 ac fb ff ff       	call   8014b2 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 25                	push   $0x25
  80191a:	e8 93 fb ff ff       	call   8014b2 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
  801922:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801927:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	ff 75 08             	pushl  0x8(%ebp)
  801944:	6a 26                	push   $0x26
  801946:	e8 67 fb ff ff       	call   8014b2 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
	return ;
  80194e:	90                   	nop
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801955:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801958:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	6a 00                	push   $0x0
  801963:	53                   	push   %ebx
  801964:	51                   	push   %ecx
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 27                	push   $0x27
  801969:	e8 44 fb ff ff       	call   8014b2 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 28                	push   $0x28
  801989:	e8 24 fb ff ff       	call   8014b2 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801996:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	51                   	push   %ecx
  8019a2:	ff 75 10             	pushl  0x10(%ebp)
  8019a5:	52                   	push   %edx
  8019a6:	50                   	push   %eax
  8019a7:	6a 29                	push   $0x29
  8019a9:	e8 04 fb ff ff       	call   8014b2 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	ff 75 10             	pushl  0x10(%ebp)
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	ff 75 08             	pushl  0x8(%ebp)
  8019c3:	6a 12                	push   $0x12
  8019c5:	e8 e8 fa ff ff       	call   8014b2 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cd:	90                   	nop
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	52                   	push   %edx
  8019e0:	50                   	push   %eax
  8019e1:	6a 2a                	push   $0x2a
  8019e3:	e8 ca fa ff ff       	call   8014b2 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 2b                	push   $0x2b
  8019fd:	e8 b0 fa ff ff       	call   8014b2 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	6a 2d                	push   $0x2d
  801a18:	e8 95 fa ff ff       	call   8014b2 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	6a 2c                	push   $0x2c
  801a34:	e8 79 fa ff ff       	call   8014b2 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3c:	90                   	nop
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	52                   	push   %edx
  801a4f:	50                   	push   %eax
  801a50:	6a 2e                	push   $0x2e
  801a52:	e8 5b fa ff ff       	call   8014b2 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	68 c8 23 80 00       	push   $0x8023c8
  801a6b:	6a 07                	push   $0x7
  801a6d:	68 f7 23 80 00       	push   $0x8023f7
  801a72:	e8 68 e8 ff ff       	call   8002df <_panic>

00801a77 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	68 08 24 80 00       	push   $0x802408
  801a85:	6a 0b                	push   $0xb
  801a87:	68 f7 23 80 00       	push   $0x8023f7
  801a8c:	e8 4e e8 ff ff       	call   8002df <_panic>

00801a91 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 34 24 80 00       	push   $0x802434
  801a9f:	6a 10                	push   $0x10
  801aa1:	68 f7 23 80 00       	push   $0x8023f7
  801aa6:	e8 34 e8 ff ff       	call   8002df <_panic>

00801aab <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	68 64 24 80 00       	push   $0x802464
  801ab9:	6a 15                	push   $0x15
  801abb:	68 f7 23 80 00       	push   $0x8023f7
  801ac0:	e8 1a e8 ff ff       	call   8002df <_panic>

00801ac5 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    

00801ad0 <__udivdi3>:
  801ad0:	55                   	push   %ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801adb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801adf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ae3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ae7:	89 ca                	mov    %ecx,%edx
  801ae9:	89 f8                	mov    %edi,%eax
  801aeb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aef:	85 f6                	test   %esi,%esi
  801af1:	75 2d                	jne    801b20 <__udivdi3+0x50>
  801af3:	39 cf                	cmp    %ecx,%edi
  801af5:	77 65                	ja     801b5c <__udivdi3+0x8c>
  801af7:	89 fd                	mov    %edi,%ebp
  801af9:	85 ff                	test   %edi,%edi
  801afb:	75 0b                	jne    801b08 <__udivdi3+0x38>
  801afd:	b8 01 00 00 00       	mov    $0x1,%eax
  801b02:	31 d2                	xor    %edx,%edx
  801b04:	f7 f7                	div    %edi
  801b06:	89 c5                	mov    %eax,%ebp
  801b08:	31 d2                	xor    %edx,%edx
  801b0a:	89 c8                	mov    %ecx,%eax
  801b0c:	f7 f5                	div    %ebp
  801b0e:	89 c1                	mov    %eax,%ecx
  801b10:	89 d8                	mov    %ebx,%eax
  801b12:	f7 f5                	div    %ebp
  801b14:	89 cf                	mov    %ecx,%edi
  801b16:	89 fa                	mov    %edi,%edx
  801b18:	83 c4 1c             	add    $0x1c,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5f                   	pop    %edi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
  801b20:	39 ce                	cmp    %ecx,%esi
  801b22:	77 28                	ja     801b4c <__udivdi3+0x7c>
  801b24:	0f bd fe             	bsr    %esi,%edi
  801b27:	83 f7 1f             	xor    $0x1f,%edi
  801b2a:	75 40                	jne    801b6c <__udivdi3+0x9c>
  801b2c:	39 ce                	cmp    %ecx,%esi
  801b2e:	72 0a                	jb     801b3a <__udivdi3+0x6a>
  801b30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b34:	0f 87 9e 00 00 00    	ja     801bd8 <__udivdi3+0x108>
  801b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3f:	89 fa                	mov    %edi,%edx
  801b41:	83 c4 1c             	add    $0x1c,%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5e                   	pop    %esi
  801b46:	5f                   	pop    %edi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    
  801b49:	8d 76 00             	lea    0x0(%esi),%esi
  801b4c:	31 ff                	xor    %edi,%edi
  801b4e:	31 c0                	xor    %eax,%eax
  801b50:	89 fa                	mov    %edi,%edx
  801b52:	83 c4 1c             	add    $0x1c,%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    
  801b5a:	66 90                	xchg   %ax,%ax
  801b5c:	89 d8                	mov    %ebx,%eax
  801b5e:	f7 f7                	div    %edi
  801b60:	31 ff                	xor    %edi,%edi
  801b62:	89 fa                	mov    %edi,%edx
  801b64:	83 c4 1c             	add    $0x1c,%esp
  801b67:	5b                   	pop    %ebx
  801b68:	5e                   	pop    %esi
  801b69:	5f                   	pop    %edi
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    
  801b6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b71:	89 eb                	mov    %ebp,%ebx
  801b73:	29 fb                	sub    %edi,%ebx
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	d3 e6                	shl    %cl,%esi
  801b79:	89 c5                	mov    %eax,%ebp
  801b7b:	88 d9                	mov    %bl,%cl
  801b7d:	d3 ed                	shr    %cl,%ebp
  801b7f:	89 e9                	mov    %ebp,%ecx
  801b81:	09 f1                	or     %esi,%ecx
  801b83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b87:	89 f9                	mov    %edi,%ecx
  801b89:	d3 e0                	shl    %cl,%eax
  801b8b:	89 c5                	mov    %eax,%ebp
  801b8d:	89 d6                	mov    %edx,%esi
  801b8f:	88 d9                	mov    %bl,%cl
  801b91:	d3 ee                	shr    %cl,%esi
  801b93:	89 f9                	mov    %edi,%ecx
  801b95:	d3 e2                	shl    %cl,%edx
  801b97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9b:	88 d9                	mov    %bl,%cl
  801b9d:	d3 e8                	shr    %cl,%eax
  801b9f:	09 c2                	or     %eax,%edx
  801ba1:	89 d0                	mov    %edx,%eax
  801ba3:	89 f2                	mov    %esi,%edx
  801ba5:	f7 74 24 0c          	divl   0xc(%esp)
  801ba9:	89 d6                	mov    %edx,%esi
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	f7 e5                	mul    %ebp
  801baf:	39 d6                	cmp    %edx,%esi
  801bb1:	72 19                	jb     801bcc <__udivdi3+0xfc>
  801bb3:	74 0b                	je     801bc0 <__udivdi3+0xf0>
  801bb5:	89 d8                	mov    %ebx,%eax
  801bb7:	31 ff                	xor    %edi,%edi
  801bb9:	e9 58 ff ff ff       	jmp    801b16 <__udivdi3+0x46>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bc4:	89 f9                	mov    %edi,%ecx
  801bc6:	d3 e2                	shl    %cl,%edx
  801bc8:	39 c2                	cmp    %eax,%edx
  801bca:	73 e9                	jae    801bb5 <__udivdi3+0xe5>
  801bcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bcf:	31 ff                	xor    %edi,%edi
  801bd1:	e9 40 ff ff ff       	jmp    801b16 <__udivdi3+0x46>
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	31 c0                	xor    %eax,%eax
  801bda:	e9 37 ff ff ff       	jmp    801b16 <__udivdi3+0x46>
  801bdf:	90                   	nop

00801be0 <__umoddi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801beb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bff:	89 f3                	mov    %esi,%ebx
  801c01:	89 fa                	mov    %edi,%edx
  801c03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c07:	89 34 24             	mov    %esi,(%esp)
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	75 1a                	jne    801c28 <__umoddi3+0x48>
  801c0e:	39 f7                	cmp    %esi,%edi
  801c10:	0f 86 a2 00 00 00    	jbe    801cb8 <__umoddi3+0xd8>
  801c16:	89 c8                	mov    %ecx,%eax
  801c18:	89 f2                	mov    %esi,%edx
  801c1a:	f7 f7                	div    %edi
  801c1c:	89 d0                	mov    %edx,%eax
  801c1e:	31 d2                	xor    %edx,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	39 f0                	cmp    %esi,%eax
  801c2a:	0f 87 ac 00 00 00    	ja     801cdc <__umoddi3+0xfc>
  801c30:	0f bd e8             	bsr    %eax,%ebp
  801c33:	83 f5 1f             	xor    $0x1f,%ebp
  801c36:	0f 84 ac 00 00 00    	je     801ce8 <__umoddi3+0x108>
  801c3c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c41:	29 ef                	sub    %ebp,%edi
  801c43:	89 fe                	mov    %edi,%esi
  801c45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c49:	89 e9                	mov    %ebp,%ecx
  801c4b:	d3 e0                	shl    %cl,%eax
  801c4d:	89 d7                	mov    %edx,%edi
  801c4f:	89 f1                	mov    %esi,%ecx
  801c51:	d3 ef                	shr    %cl,%edi
  801c53:	09 c7                	or     %eax,%edi
  801c55:	89 e9                	mov    %ebp,%ecx
  801c57:	d3 e2                	shl    %cl,%edx
  801c59:	89 14 24             	mov    %edx,(%esp)
  801c5c:	89 d8                	mov    %ebx,%eax
  801c5e:	d3 e0                	shl    %cl,%eax
  801c60:	89 c2                	mov    %eax,%edx
  801c62:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c66:	d3 e0                	shl    %cl,%eax
  801c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c70:	89 f1                	mov    %esi,%ecx
  801c72:	d3 e8                	shr    %cl,%eax
  801c74:	09 d0                	or     %edx,%eax
  801c76:	d3 eb                	shr    %cl,%ebx
  801c78:	89 da                	mov    %ebx,%edx
  801c7a:	f7 f7                	div    %edi
  801c7c:	89 d3                	mov    %edx,%ebx
  801c7e:	f7 24 24             	mull   (%esp)
  801c81:	89 c6                	mov    %eax,%esi
  801c83:	89 d1                	mov    %edx,%ecx
  801c85:	39 d3                	cmp    %edx,%ebx
  801c87:	0f 82 87 00 00 00    	jb     801d14 <__umoddi3+0x134>
  801c8d:	0f 84 91 00 00 00    	je     801d24 <__umoddi3+0x144>
  801c93:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c97:	29 f2                	sub    %esi,%edx
  801c99:	19 cb                	sbb    %ecx,%ebx
  801c9b:	89 d8                	mov    %ebx,%eax
  801c9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ca1:	d3 e0                	shl    %cl,%eax
  801ca3:	89 e9                	mov    %ebp,%ecx
  801ca5:	d3 ea                	shr    %cl,%edx
  801ca7:	09 d0                	or     %edx,%eax
  801ca9:	89 e9                	mov    %ebp,%ecx
  801cab:	d3 eb                	shr    %cl,%ebx
  801cad:	89 da                	mov    %ebx,%edx
  801caf:	83 c4 1c             	add    $0x1c,%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
  801cb7:	90                   	nop
  801cb8:	89 fd                	mov    %edi,%ebp
  801cba:	85 ff                	test   %edi,%edi
  801cbc:	75 0b                	jne    801cc9 <__umoddi3+0xe9>
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	31 d2                	xor    %edx,%edx
  801cc5:	f7 f7                	div    %edi
  801cc7:	89 c5                	mov    %eax,%ebp
  801cc9:	89 f0                	mov    %esi,%eax
  801ccb:	31 d2                	xor    %edx,%edx
  801ccd:	f7 f5                	div    %ebp
  801ccf:	89 c8                	mov    %ecx,%eax
  801cd1:	f7 f5                	div    %ebp
  801cd3:	89 d0                	mov    %edx,%eax
  801cd5:	e9 44 ff ff ff       	jmp    801c1e <__umoddi3+0x3e>
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	89 c8                	mov    %ecx,%eax
  801cde:	89 f2                	mov    %esi,%edx
  801ce0:	83 c4 1c             	add    $0x1c,%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5f                   	pop    %edi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    
  801ce8:	3b 04 24             	cmp    (%esp),%eax
  801ceb:	72 06                	jb     801cf3 <__umoddi3+0x113>
  801ced:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cf1:	77 0f                	ja     801d02 <__umoddi3+0x122>
  801cf3:	89 f2                	mov    %esi,%edx
  801cf5:	29 f9                	sub    %edi,%ecx
  801cf7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cfb:	89 14 24             	mov    %edx,(%esp)
  801cfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d02:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d06:	8b 14 24             	mov    (%esp),%edx
  801d09:	83 c4 1c             	add    $0x1c,%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	5f                   	pop    %edi
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    
  801d11:	8d 76 00             	lea    0x0(%esi),%esi
  801d14:	2b 04 24             	sub    (%esp),%eax
  801d17:	19 fa                	sbb    %edi,%edx
  801d19:	89 d1                	mov    %edx,%ecx
  801d1b:	89 c6                	mov    %eax,%esi
  801d1d:	e9 71 ff ff ff       	jmp    801c93 <__umoddi3+0xb3>
  801d22:	66 90                	xchg   %ax,%ax
  801d24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d28:	72 ea                	jb     801d14 <__umoddi3+0x134>
  801d2a:	89 d9                	mov    %ebx,%ecx
  801d2c:	e9 62 ff ff ff       	jmp    801c93 <__umoddi3+0xb3>
