
obj/user/priRR_fib_create:     file format elf32-i386


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
  800031:	e8 23 01 00 00       	call   800159 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int32 envIdFib1 = sys_create_env("priRR_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800049:	a1 20 30 80 00       	mov    0x803020,%eax
  80004e:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800054:	89 c1                	mov    %eax,%ecx
  800056:	a1 20 30 80 00       	mov    0x803020,%eax
  80005b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800061:	52                   	push   %edx
  800062:	51                   	push   %ecx
  800063:	50                   	push   %eax
  800064:	68 00 1d 80 00       	push   $0x801d00
  800069:	e8 e8 16 00 00       	call   801756 <sys_create_env>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (envIdFib1 == E_ENV_CREATION_ERROR)
  800074:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  800078:	75 14                	jne    80008e <_main+0x56>
		panic("Loading programs failed\n");
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	68 0a 1d 80 00       	push   $0x801d0a
  800082:	6a 0b                	push   $0xb
  800084:	68 23 1d 80 00       	push   $0x801d23
  800089:	e8 7b 02 00 00       	call   800309 <_panic>

	int32 envIdFib2 = sys_create_env("priRR_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80008e:	a1 20 30 80 00       	mov    0x803020,%eax
  800093:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000a4:	89 c1                	mov    %eax,%ecx
  8000a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ab:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b1:	52                   	push   %edx
  8000b2:	51                   	push   %ecx
  8000b3:	50                   	push   %eax
  8000b4:	68 00 1d 80 00       	push   $0x801d00
  8000b9:	e8 98 16 00 00       	call   801756 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (envIdFib2 == E_ENV_CREATION_ERROR)
  8000c4:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000c8:	75 14                	jne    8000de <_main+0xa6>
		panic("Loading programs failed\n");
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	68 0a 1d 80 00       	push   $0x801d0a
  8000d2:	6a 0f                	push   $0xf
  8000d4:	68 23 1d 80 00       	push   $0x801d23
  8000d9:	e8 2b 02 00 00       	call   800309 <_panic>

	sys_run_env(envIdFib1);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e4:	e8 8b 16 00 00       	call   801774 <sys_run_env>
  8000e9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdFib2);
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f2:	e8 7d 16 00 00       	call   801774 <sys_run_env>
  8000f7:	83 c4 10             	add    $0x10,%esp

	int priority = 2;
  8000fa:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
	cprintf("process %d will be added to ready queue at priority %d\n", envIdFib1, priority);
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	ff 75 f4             	pushl  -0xc(%ebp)
  80010a:	68 3c 1d 80 00       	push   $0x801d3c
  80010f:	e8 e3 04 00 00       	call   8005f7 <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
	sys_env_set_priority(envIdFib1, priority);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	ff 75 ec             	pushl  -0x14(%ebp)
  80011d:	ff 75 f4             	pushl  -0xc(%ebp)
  800120:	e8 44 19 00 00       	call   801a69 <sys_env_set_priority>
  800125:	83 c4 10             	add    $0x10,%esp

	priority = 9;
  800128:	c7 45 ec 09 00 00 00 	movl   $0x9,-0x14(%ebp)
	cprintf("process %d will be added to ready queue at priority %d\n", envIdFib2, priority);
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	ff 75 f0             	pushl  -0x10(%ebp)
  800138:	68 3c 1d 80 00       	push   $0x801d3c
  80013d:	e8 b5 04 00 00       	call   8005f7 <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
	sys_env_set_priority(envIdFib2, priority);
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 ec             	pushl  -0x14(%ebp)
  80014b:	ff 75 f0             	pushl  -0x10(%ebp)
  80014e:	e8 16 19 00 00       	call   801a69 <sys_env_set_priority>
  800153:	83 c4 10             	add    $0x10,%esp
return;
  800156:	90                   	nop
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	57                   	push   %edi
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800162:	e8 5d 16 00 00       	call   8017c4 <sys_getenvindex>
  800167:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80016a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80016d:	89 d0                	mov    %edx,%eax
  80016f:	01 c0                	add    %eax,%eax
  800171:	01 d0                	add    %edx,%eax
  800173:	c1 e0 02             	shl    $0x2,%eax
  800176:	01 d0                	add    %edx,%eax
  800178:	c1 e0 02             	shl    $0x2,%eax
  80017b:	01 d0                	add    %edx,%eax
  80017d:	c1 e0 03             	shl    $0x3,%eax
  800180:	01 d0                	add    %edx,%eax
  800182:	c1 e0 02             	shl    $0x2,%eax
  800185:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80018a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8a 40 20             	mov    0x20(%eax),%al
  800197:	84 c0                	test   %al,%al
  800199:	74 0d                	je     8001a8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80019b:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a0:	83 c0 20             	add    $0x20,%eax
  8001a3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ac:	7e 0a                	jle    8001b8 <libmain+0x5f>
		binaryname = argv[0];
  8001ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b1:	8b 00                	mov    (%eax),%eax
  8001b3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 0c             	pushl  0xc(%ebp)
  8001be:	ff 75 08             	pushl  0x8(%ebp)
  8001c1:	e8 72 fe ff ff       	call   800038 <_main>
  8001c6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001c9:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	0f 84 01 01 00 00    	je     8002d7 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001d6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001dc:	bb 6c 1e 80 00       	mov    $0x801e6c,%ebx
  8001e1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001e6:	89 c7                	mov    %eax,%edi
  8001e8:	89 de                	mov    %ebx,%esi
  8001ea:	89 d1                	mov    %edx,%ecx
  8001ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001ee:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001f1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001f6:	b0 00                	mov    $0x0,%al
  8001f8:	89 d7                	mov    %edx,%edi
  8001fa:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800203:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	50                   	push   %eax
  80020a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	e8 e4 17 00 00       	call   8019fa <sys_utilities>
  800216:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800219:	e8 2d 13 00 00       	call   80154b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	68 8c 1d 80 00       	push   $0x801d8c
  800226:	e8 cc 03 00 00       	call   8005f7 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80022e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 18                	je     80024d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800235:	e8 de 17 00 00       	call   801a18 <sys_get_optimal_num_faults>
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	50                   	push   %eax
  80023e:	68 b4 1d 80 00       	push   $0x801db4
  800243:	e8 af 03 00 00       	call   8005f7 <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	eb 59                	jmp    8002a6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024d:	a1 20 30 80 00       	mov    0x803020,%eax
  800252:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	68 d8 1d 80 00       	push   $0x801dd8
  80026d:	e8 85 03 00 00       	call   8005f7 <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800275:	a1 20 30 80 00       	mov    0x803020,%eax
  80027a:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800280:	a1 20 30 80 00       	mov    0x803020,%eax
  800285:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80028b:	a1 20 30 80 00       	mov    0x803020,%eax
  800290:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800296:	51                   	push   %ecx
  800297:	52                   	push   %edx
  800298:	50                   	push   %eax
  800299:	68 00 1e 80 00       	push   $0x801e00
  80029e:	e8 54 03 00 00       	call   8005f7 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ab:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	50                   	push   %eax
  8002b5:	68 58 1e 80 00       	push   $0x801e58
  8002ba:	e8 38 03 00 00       	call   8005f7 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	68 8c 1d 80 00       	push   $0x801d8c
  8002ca:	e8 28 03 00 00       	call   8005f7 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002d2:	e8 8e 12 00 00       	call   801565 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002d7:	e8 1f 00 00 00       	call   8002fb <exit>
}
  8002dc:	90                   	nop
  8002dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	6a 00                	push   $0x0
  8002f0:	e8 9b 14 00 00       	call   801790 <sys_destroy_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
}
  8002f8:	90                   	nop
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <exit>:

void
exit(void)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800301:	e8 f0 14 00 00       	call   8017f6 <sys_exit_env>
}
  800306:	90                   	nop
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80030f:	8d 45 10             	lea    0x10(%ebp),%eax
  800312:	83 c0 04             	add    $0x4,%eax
  800315:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800318:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	74 16                	je     800337 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800321:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	50                   	push   %eax
  80032a:	68 d0 1e 80 00       	push   $0x801ed0
  80032f:	e8 c3 02 00 00       	call   8005f7 <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800337:	a1 04 30 80 00       	mov    0x803004,%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	ff 75 0c             	pushl  0xc(%ebp)
  800342:	ff 75 08             	pushl  0x8(%ebp)
  800345:	50                   	push   %eax
  800346:	68 d8 1e 80 00       	push   $0x801ed8
  80034b:	6a 74                	push   $0x74
  80034d:	e8 d2 02 00 00       	call   800624 <cprintf_colored>
  800352:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800355:	8b 45 10             	mov    0x10(%ebp),%eax
  800358:	83 ec 08             	sub    $0x8,%esp
  80035b:	ff 75 f4             	pushl  -0xc(%ebp)
  80035e:	50                   	push   %eax
  80035f:	e8 24 02 00 00       	call   800588 <vcprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	6a 00                	push   $0x0
  80036c:	68 00 1f 80 00       	push   $0x801f00
  800371:	e8 12 02 00 00       	call   800588 <vcprintf>
  800376:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800379:	e8 7d ff ff ff       	call   8002fb <exit>

	// should not return here
	while (1) ;
  80037e:	eb fe                	jmp    80037e <_panic+0x75>

00800380 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	53                   	push   %ebx
  800384:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800387:	a1 20 30 80 00       	mov    0x803020,%eax
  80038c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800392:	8b 45 0c             	mov    0xc(%ebp),%eax
  800395:	39 c2                	cmp    %eax,%edx
  800397:	74 14                	je     8003ad <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 04 1f 80 00       	push   $0x801f04
  8003a1:	6a 26                	push   $0x26
  8003a3:	68 50 1f 80 00       	push   $0x801f50
  8003a8:	e8 5c ff ff ff       	call   800309 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003bb:	e9 d9 00 00 00       	jmp    800499 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	85 c0                	test   %eax,%eax
  8003d3:	75 08                	jne    8003dd <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003d8:	e9 b9 00 00 00       	jmp    800496 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003eb:	eb 79                	jmp    800466 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fb:	89 d0                	mov    %edx,%eax
  8003fd:	01 c0                	add    %eax,%eax
  8003ff:	01 d0                	add    %edx,%eax
  800401:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800408:	01 d8                	add    %ebx,%eax
  80040a:	01 d0                	add    %edx,%eax
  80040c:	01 c8                	add    %ecx,%eax
  80040e:	8a 40 04             	mov    0x4(%eax),%al
  800411:	84 c0                	test   %al,%al
  800413:	75 4e                	jne    800463 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800415:	a1 20 30 80 00       	mov    0x803020,%eax
  80041a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800420:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800430:	01 d8                	add    %ebx,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c8                	add    %ecx,%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800443:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800448:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	01 c8                	add    %ecx,%eax
  800454:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800456:	39 c2                	cmp    %eax,%edx
  800458:	75 09                	jne    800463 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80045a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800461:	eb 19                	jmp    80047c <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800463:	ff 45 e8             	incl   -0x18(%ebp)
  800466:	a1 20 30 80 00       	mov    0x803020,%eax
  80046b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800474:	39 c2                	cmp    %eax,%edx
  800476:	0f 87 71 ff ff ff    	ja     8003ed <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80047c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800480:	75 14                	jne    800496 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800482:	83 ec 04             	sub    $0x4,%esp
  800485:	68 5c 1f 80 00       	push   $0x801f5c
  80048a:	6a 3a                	push   $0x3a
  80048c:	68 50 1f 80 00       	push   $0x801f50
  800491:	e8 73 fe ff ff       	call   800309 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800496:	ff 45 f0             	incl   -0x10(%ebp)
  800499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049f:	0f 8c 1b ff ff ff    	jl     8003c0 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b3:	eb 2e                	jmp    8004e3 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ba:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c3:	89 d0                	mov    %edx,%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	01 d0                	add    %edx,%eax
  8004c9:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004d0:	01 d8                	add    %ebx,%eax
  8004d2:	01 d0                	add    %edx,%eax
  8004d4:	01 c8                	add    %ecx,%eax
  8004d6:	8a 40 04             	mov    0x4(%eax),%al
  8004d9:	3c 01                	cmp    $0x1,%al
  8004db:	75 03                	jne    8004e0 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004dd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e0:	ff 45 e0             	incl   -0x20(%ebp)
  8004e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f1:	39 c2                	cmp    %eax,%edx
  8004f3:	77 c0                	ja     8004b5 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fb:	74 14                	je     800511 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 b0 1f 80 00       	push   $0x801fb0
  800505:	6a 44                	push   $0x44
  800507:	68 50 1f 80 00       	push   $0x801f50
  80050c:	e8 f8 fd ff ff       	call   800309 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800511:	90                   	nop
  800512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	53                   	push   %ebx
  80051b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	8d 48 01             	lea    0x1(%eax),%ecx
  800526:	8b 55 0c             	mov    0xc(%ebp),%edx
  800529:	89 0a                	mov    %ecx,(%edx)
  80052b:	8b 55 08             	mov    0x8(%ebp),%edx
  80052e:	88 d1                	mov    %dl,%cl
  800530:	8b 55 0c             	mov    0xc(%ebp),%edx
  800533:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800541:	75 30                	jne    800573 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800543:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800549:	a0 44 30 80 00       	mov    0x803044,%al
  80054e:	0f b6 c0             	movzbl %al,%eax
  800551:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800554:	8b 09                	mov    (%ecx),%ecx
  800556:	89 cb                	mov    %ecx,%ebx
  800558:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80055b:	83 c1 08             	add    $0x8,%ecx
  80055e:	52                   	push   %edx
  80055f:	50                   	push   %eax
  800560:	53                   	push   %ebx
  800561:	51                   	push   %ecx
  800562:	e8 a0 0f 00 00       	call   801507 <sys_cputs>
  800567:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800573:	8b 45 0c             	mov    0xc(%ebp),%eax
  800576:	8b 40 04             	mov    0x4(%eax),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800582:	90                   	nop
  800583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800591:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800598:	00 00 00 
	b.cnt = 0;
  80059b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005a2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005a5:	ff 75 0c             	pushl  0xc(%ebp)
  8005a8:	ff 75 08             	pushl  0x8(%ebp)
  8005ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b1:	50                   	push   %eax
  8005b2:	68 17 05 80 00       	push   $0x800517
  8005b7:	e8 5a 02 00 00       	call   800816 <vprintfmt>
  8005bc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005bf:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005c5:	a0 44 30 80 00       	mov    0x803044,%al
  8005ca:	0f b6 c0             	movzbl %al,%eax
  8005cd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005d3:	52                   	push   %edx
  8005d4:	50                   	push   %eax
  8005d5:	51                   	push   %ecx
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	83 c0 08             	add    $0x8,%eax
  8005df:	50                   	push   %eax
  8005e0:	e8 22 0f 00 00       	call   801507 <sys_cputs>
  8005e5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005e8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005fd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800604:	8d 45 0c             	lea    0xc(%ebp),%eax
  800607:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	ff 75 f4             	pushl  -0xc(%ebp)
  800613:	50                   	push   %eax
  800614:	e8 6f ff ff ff       	call   800588 <vcprintf>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80061f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800622:	c9                   	leave  
  800623:	c3                   	ret    

00800624 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80062a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	c1 e0 08             	shl    $0x8,%eax
  800637:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80063c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80063f:	83 c0 04             	add    $0x4,%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 34 ff ff ff       	call   800588 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80065a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800661:	07 00 00 

	return cnt;
  800664:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80066f:	e8 d7 0e 00 00       	call   80154b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800674:	8d 45 0c             	lea    0xc(%ebp),%eax
  800677:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	50                   	push   %eax
  800684:	e8 ff fe ff ff       	call   800588 <vcprintf>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80068f:	e8 d1 0e 00 00       	call   801565 <sys_unlock_cons>
	return cnt;
  800694:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
  80069c:	53                   	push   %ebx
  80069d:	83 ec 14             	sub    $0x14,%esp
  8006a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8006af:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b7:	77 55                	ja     80070e <printnum+0x75>
  8006b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bc:	72 05                	jb     8006c3 <printnum+0x2a>
  8006be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c1:	77 4b                	ja     80070e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8006cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8006d9:	e8 aa 13 00 00       	call   801a88 <__udivdi3>
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	83 ec 04             	sub    $0x4,%esp
  8006e4:	ff 75 20             	pushl  0x20(%ebp)
  8006e7:	53                   	push   %ebx
  8006e8:	ff 75 18             	pushl  0x18(%ebp)
  8006eb:	52                   	push   %edx
  8006ec:	50                   	push   %eax
  8006ed:	ff 75 0c             	pushl  0xc(%ebp)
  8006f0:	ff 75 08             	pushl  0x8(%ebp)
  8006f3:	e8 a1 ff ff ff       	call   800699 <printnum>
  8006f8:	83 c4 20             	add    $0x20,%esp
  8006fb:	eb 1a                	jmp    800717 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 0c             	pushl  0xc(%ebp)
  800703:	ff 75 20             	pushl  0x20(%ebp)
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	ff d0                	call   *%eax
  80070b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80070e:	ff 4d 1c             	decl   0x1c(%ebp)
  800711:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800715:	7f e6                	jg     8006fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800717:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80071a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800725:	53                   	push   %ebx
  800726:	51                   	push   %ecx
  800727:	52                   	push   %edx
  800728:	50                   	push   %eax
  800729:	e8 6a 14 00 00       	call   801b98 <__umoddi3>
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	05 14 22 80 00       	add    $0x802214,%eax
  800736:	8a 00                	mov    (%eax),%al
  800738:	0f be c0             	movsbl %al,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 0c             	pushl  0xc(%ebp)
  800741:	50                   	push   %eax
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	ff d0                	call   *%eax
  800747:	83 c4 10             	add    $0x10,%esp
}
  80074a:	90                   	nop
  80074b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800753:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800757:	7e 1c                	jle    800775 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800773:	eb 40                	jmp    8007b5 <getuint+0x65>
	else if (lflag)
  800775:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800779:	74 1e                	je     800799 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
  800797:	eb 1c                	jmp    8007b5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	8d 50 04             	lea    0x4(%eax),%edx
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	89 10                	mov    %edx,(%eax)
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	83 e8 04             	sub    $0x4,%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007be:	7e 1c                	jle    8007dc <getint+0x25>
		return va_arg(*ap, long long);
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	8d 50 08             	lea    0x8(%eax),%edx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	89 10                	mov    %edx,(%eax)
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	83 e8 08             	sub    $0x8,%eax
  8007d5:	8b 50 04             	mov    0x4(%eax),%edx
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	eb 38                	jmp    800814 <getint+0x5d>
	else if (lflag)
  8007dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e0:	74 1a                	je     8007fc <getint+0x45>
		return va_arg(*ap, long);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
  8007fa:	eb 18                	jmp    800814 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	89 10                	mov    %edx,(%eax)
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	83 e8 04             	sub    $0x4,%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	99                   	cltd   
}
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	56                   	push   %esi
  80081a:	53                   	push   %ebx
  80081b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081e:	eb 17                	jmp    800837 <vprintfmt+0x21>
			if (ch == '\0')
  800820:	85 db                	test   %ebx,%ebx
  800822:	0f 84 c1 03 00 00    	je     800be9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	53                   	push   %ebx
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800837:	8b 45 10             	mov    0x10(%ebp),%eax
  80083a:	8d 50 01             	lea    0x1(%eax),%edx
  80083d:	89 55 10             	mov    %edx,0x10(%ebp)
  800840:	8a 00                	mov    (%eax),%al
  800842:	0f b6 d8             	movzbl %al,%ebx
  800845:	83 fb 25             	cmp    $0x25,%ebx
  800848:	75 d6                	jne    800820 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80084a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80084e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800855:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80085c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800863:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086a:	8b 45 10             	mov    0x10(%ebp),%eax
  80086d:	8d 50 01             	lea    0x1(%eax),%edx
  800870:	89 55 10             	mov    %edx,0x10(%ebp)
  800873:	8a 00                	mov    (%eax),%al
  800875:	0f b6 d8             	movzbl %al,%ebx
  800878:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80087b:	83 f8 5b             	cmp    $0x5b,%eax
  80087e:	0f 87 3d 03 00 00    	ja     800bc1 <vprintfmt+0x3ab>
  800884:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  80088b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80088d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800891:	eb d7                	jmp    80086a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800893:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800897:	eb d1                	jmp    80086a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800899:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a3:	89 d0                	mov    %edx,%eax
  8008a5:	c1 e0 02             	shl    $0x2,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	01 c0                	add    %eax,%eax
  8008ac:	01 d8                	add    %ebx,%eax
  8008ae:	83 e8 30             	sub    $0x30,%eax
  8008b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b7:	8a 00                	mov    (%eax),%al
  8008b9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008bc:	83 fb 2f             	cmp    $0x2f,%ebx
  8008bf:	7e 3e                	jle    8008ff <vprintfmt+0xe9>
  8008c1:	83 fb 39             	cmp    $0x39,%ebx
  8008c4:	7f 39                	jg     8008ff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008c9:	eb d5                	jmp    8008a0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 c0 04             	add    $0x4,%eax
  8008d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	83 e8 04             	sub    $0x4,%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008df:	eb 1f                	jmp    800900 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e5:	79 83                	jns    80086a <vprintfmt+0x54>
				width = 0;
  8008e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ee:	e9 77 ff ff ff       	jmp    80086a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008f3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008fa:	e9 6b ff ff ff       	jmp    80086a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800900:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800904:	0f 89 60 ff ff ff    	jns    80086a <vprintfmt+0x54>
				width = precision, precision = -1;
  80090a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800910:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800917:	e9 4e ff ff ff       	jmp    80086a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80091f:	e9 46 ff ff ff       	jmp    80086a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 14             	mov    %eax,0x14(%ebp)
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	83 e8 04             	sub    $0x4,%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	50                   	push   %eax
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			break;
  800944:	e9 9b 02 00 00       	jmp    800be4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 c0 04             	add    $0x4,%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	83 e8 04             	sub    $0x4,%eax
  800958:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80095a:	85 db                	test   %ebx,%ebx
  80095c:	79 02                	jns    800960 <vprintfmt+0x14a>
				err = -err;
  80095e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800960:	83 fb 64             	cmp    $0x64,%ebx
  800963:	7f 0b                	jg     800970 <vprintfmt+0x15a>
  800965:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  80096c:	85 f6                	test   %esi,%esi
  80096e:	75 19                	jne    800989 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800970:	53                   	push   %ebx
  800971:	68 25 22 80 00       	push   $0x802225
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	ff 75 08             	pushl  0x8(%ebp)
  80097c:	e8 70 02 00 00       	call   800bf1 <printfmt>
  800981:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800984:	e9 5b 02 00 00       	jmp    800be4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800989:	56                   	push   %esi
  80098a:	68 2e 22 80 00       	push   $0x80222e
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	ff 75 08             	pushl  0x8(%ebp)
  800995:	e8 57 02 00 00       	call   800bf1 <printfmt>
  80099a:	83 c4 10             	add    $0x10,%esp
			break;
  80099d:	e9 42 02 00 00       	jmp    800be4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	83 c0 04             	add    $0x4,%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	83 e8 04             	sub    $0x4,%eax
  8009b1:	8b 30                	mov    (%eax),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 05                	jne    8009bc <vprintfmt+0x1a6>
				p = "(null)";
  8009b7:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  8009bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c0:	7e 6d                	jle    800a2f <vprintfmt+0x219>
  8009c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009c6:	74 67                	je     800a2f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	50                   	push   %eax
  8009cf:	56                   	push   %esi
  8009d0:	e8 1e 03 00 00       	call   800cf3 <strnlen>
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009db:	eb 16                	jmp    8009f3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009dd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f7:	7f e4                	jg     8009dd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f9:	eb 34                	jmp    800a2f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ff:	74 1c                	je     800a1d <vprintfmt+0x207>
  800a01:	83 fb 1f             	cmp    $0x1f,%ebx
  800a04:	7e 05                	jle    800a0b <vprintfmt+0x1f5>
  800a06:	83 fb 7e             	cmp    $0x7e,%ebx
  800a09:	7e 12                	jle    800a1d <vprintfmt+0x207>
					putch('?', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 3f                	push   $0x3f
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	eb 0f                	jmp    800a2c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	53                   	push   %ebx
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2f:	89 f0                	mov    %esi,%eax
  800a31:	8d 70 01             	lea    0x1(%eax),%esi
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	0f be d8             	movsbl %al,%ebx
  800a39:	85 db                	test   %ebx,%ebx
  800a3b:	74 24                	je     800a61 <vprintfmt+0x24b>
  800a3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a41:	78 b8                	js     8009fb <vprintfmt+0x1e5>
  800a43:	ff 4d e0             	decl   -0x20(%ebp)
  800a46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4a:	79 af                	jns    8009fb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4c:	eb 13                	jmp    800a61 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	6a 20                	push   $0x20
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a65:	7f e7                	jg     800a4e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a67:	e9 78 01 00 00       	jmp    800be4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a72:	8d 45 14             	lea    0x14(%ebp),%eax
  800a75:	50                   	push   %eax
  800a76:	e8 3c fd ff ff       	call   8007b7 <getint>
  800a7b:	83 c4 10             	add    $0x10,%esp
  800a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	85 d2                	test   %edx,%edx
  800a8c:	79 23                	jns    800ab1 <vprintfmt+0x29b>
				putch('-', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 2d                	push   $0x2d
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa4:	f7 d8                	neg    %eax
  800aa6:	83 d2 00             	adc    $0x0,%edx
  800aa9:	f7 da                	neg    %edx
  800aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab8:	e9 bc 00 00 00       	jmp    800b79 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac6:	50                   	push   %eax
  800ac7:	e8 84 fc ff ff       	call   800750 <getuint>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ad5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800adc:	e9 98 00 00 00       	jmp    800b79 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	6a 58                	push   $0x58
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	6a 58                	push   $0x58
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	6a 58                	push   $0x58
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 ce 00 00 00       	jmp    800be4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 30                	push   $0x30
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	6a 78                	push   $0x78
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	83 c0 04             	add    $0x4,%eax
  800b3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	83 e8 04             	sub    $0x4,%eax
  800b45:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b58:	eb 1f                	jmp    800b79 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b60:	8d 45 14             	lea    0x14(%ebp),%eax
  800b63:	50                   	push   %eax
  800b64:	e8 e7 fb ff ff       	call   800750 <getuint>
  800b69:	83 c4 10             	add    $0x10,%esp
  800b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b79:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	52                   	push   %edx
  800b84:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b87:	50                   	push   %eax
  800b88:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	ff 75 08             	pushl  0x8(%ebp)
  800b94:	e8 00 fb ff ff       	call   800699 <printnum>
  800b99:	83 c4 20             	add    $0x20,%esp
			break;
  800b9c:	eb 46                	jmp    800be4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	53                   	push   %ebx
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	ff d0                	call   *%eax
  800baa:	83 c4 10             	add    $0x10,%esp
			break;
  800bad:	eb 35                	jmp    800be4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800baf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800bb6:	eb 2c                	jmp    800be4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bb8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800bbf:	eb 23                	jmp    800be4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 25                	push   $0x25
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd1:	ff 4d 10             	decl   0x10(%ebp)
  800bd4:	eb 03                	jmp    800bd9 <vprintfmt+0x3c3>
  800bd6:	ff 4d 10             	decl   0x10(%ebp)
  800bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdc:	48                   	dec    %eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	3c 25                	cmp    $0x25,%al
  800be1:	75 f3                	jne    800bd6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800be3:	90                   	nop
		}
	}
  800be4:	e9 35 fc ff ff       	jmp    80081e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800be9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bf7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfa:	83 c0 04             	add    $0x4,%eax
  800bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	ff 75 f4             	pushl  -0xc(%ebp)
  800c06:	50                   	push   %eax
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	ff 75 08             	pushl  0x8(%ebp)
  800c0d:	e8 04 fc ff ff       	call   800816 <vprintfmt>
  800c12:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c15:	90                   	nop
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	8b 40 08             	mov    0x8(%eax),%eax
  800c21:	8d 50 01             	lea    0x1(%eax),%edx
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8b 10                	mov    (%eax),%edx
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 40 04             	mov    0x4(%eax),%eax
  800c35:	39 c2                	cmp    %eax,%edx
  800c37:	73 12                	jae    800c4b <sprintputch+0x33>
		*b->buf++ = ch;
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	89 0a                	mov    %ecx,(%edx)
  800c46:	8b 55 08             	mov    0x8(%ebp),%edx
  800c49:	88 10                	mov    %dl,(%eax)
}
  800c4b:	90                   	nop
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	01 d0                	add    %edx,%eax
  800c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c73:	74 06                	je     800c7b <vsnprintf+0x2d>
  800c75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c79:	7f 07                	jg     800c82 <vsnprintf+0x34>
		return -E_INVAL;
  800c7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c80:	eb 20                	jmp    800ca2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c82:	ff 75 14             	pushl  0x14(%ebp)
  800c85:	ff 75 10             	pushl  0x10(%ebp)
  800c88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8b:	50                   	push   %eax
  800c8c:	68 18 0c 80 00       	push   $0x800c18
  800c91:	e8 80 fb ff ff       	call   800816 <vprintfmt>
  800c96:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800caa:	8d 45 10             	lea    0x10(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb9:	50                   	push   %eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 89 ff ff ff       	call   800c4e <vsnprintf>
  800cc5:	83 c4 10             	add    $0x10,%esp
  800cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdd:	eb 06                	jmp    800ce5 <strlen+0x15>
		n++;
  800cdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce2:	ff 45 08             	incl   0x8(%ebp)
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 f1                	jne    800cdf <strlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d00:	eb 09                	jmp    800d0b <strnlen+0x18>
		n++;
  800d02:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d05:	ff 45 08             	incl   0x8(%ebp)
  800d08:	ff 4d 0c             	decl   0xc(%ebp)
  800d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0f:	74 09                	je     800d1a <strnlen+0x27>
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	84 c0                	test   %al,%al
  800d18:	75 e8                	jne    800d02 <strnlen+0xf>
		n++;
	return n;
  800d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2b:	90                   	nop
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8d 50 01             	lea    0x1(%eax),%edx
  800d32:	89 55 08             	mov    %edx,0x8(%ebp)
  800d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 e4                	jne    800d2c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d60:	eb 1f                	jmp    800d81 <strncpy+0x34>
		*dst++ = *src;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6e:	8a 12                	mov    (%edx),%dl
  800d70:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	84 c0                	test   %al,%al
  800d79:	74 03                	je     800d7e <strncpy+0x31>
			src++;
  800d7b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d7e:	ff 45 fc             	incl   -0x4(%ebp)
  800d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d84:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d87:	72 d9                	jb     800d62 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9e:	74 30                	je     800dd0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da0:	eb 16                	jmp    800db8 <strlcpy+0x2a>
			*dst++ = *src++;
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 08             	mov    %edx,0x8(%ebp)
  800dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db4:	8a 12                	mov    (%edx),%dl
  800db6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800db8:	ff 4d 10             	decl   0x10(%ebp)
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	74 09                	je     800dca <strlcpy+0x3c>
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	75 d8                	jne    800da2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd6:	29 c2                	sub    %eax,%edx
  800dd8:	89 d0                	mov    %edx,%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ddf:	eb 06                	jmp    800de7 <strcmp+0xb>
		p++, q++;
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	74 0e                	je     800dfe <strcmp+0x22>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 10                	mov    (%eax),%dl
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	38 c2                	cmp    %al,%dl
  800dfc:	74 e3                	je     800de1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f b6 d0             	movzbl %al,%edx
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	0f b6 c0             	movzbl %al,%eax
  800e0e:	29 c2                	sub    %eax,%edx
  800e10:	89 d0                	mov    %edx,%eax
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e17:	eb 09                	jmp    800e22 <strncmp+0xe>
		n--, p++, q++;
  800e19:	ff 4d 10             	decl   0x10(%ebp)
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e26:	74 17                	je     800e3f <strncmp+0x2b>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	74 0e                	je     800e3f <strncmp+0x2b>
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 10                	mov    (%eax),%dl
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	38 c2                	cmp    %al,%dl
  800e3d:	74 da                	je     800e19 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e43:	75 07                	jne    800e4c <strncmp+0x38>
		return 0;
  800e45:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4a:	eb 14                	jmp    800e60 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	0f b6 d0             	movzbl %al,%edx
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f b6 c0             	movzbl %al,%eax
  800e5c:	29 c2                	sub    %eax,%edx
  800e5e:	89 d0                	mov    %edx,%eax
}
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 12                	jmp    800e82 <strchr+0x20>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	75 05                	jne    800e7f <strchr+0x1d>
			return (char *) s;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	eb 11                	jmp    800e90 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e7f:	ff 45 08             	incl   0x8(%ebp)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	75 e5                	jne    800e70 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 04             	sub    $0x4,%esp
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e9e:	eb 0d                	jmp    800ead <strfind+0x1b>
		if (*s == c)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ea8:	74 0e                	je     800eb8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eaa:	ff 45 08             	incl   0x8(%ebp)
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	84 c0                	test   %al,%al
  800eb4:	75 ea                	jne    800ea0 <strfind+0xe>
  800eb6:	eb 01                	jmp    800eb9 <strfind+0x27>
		if (*s == c)
			break;
  800eb8:	90                   	nop
	return (char *) s;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800eca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ece:	76 63                	jbe    800f33 <memset+0x75>
		uint64 data_block = c;
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	99                   	cltd   
  800ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ee4:	c1 e0 08             	shl    $0x8,%eax
  800ee7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ef7:	c1 e0 10             	shl    $0x10,%eax
  800efa:	09 45 f0             	or     %eax,-0x10(%ebp)
  800efd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f06:	89 c2                	mov    %eax,%edx
  800f08:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f10:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f13:	eb 18                	jmp    800f2d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f18:	8d 41 08             	lea    0x8(%ecx),%eax
  800f1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f24:	89 01                	mov    %eax,(%ecx)
  800f26:	89 51 04             	mov    %edx,0x4(%ecx)
  800f29:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f2d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f31:	77 e2                	ja     800f15 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f37:	74 23                	je     800f5c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f3f:	eb 0e                	jmp    800f4f <memset+0x91>
			*p8++ = (uint8)c;
  800f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f55:	89 55 10             	mov    %edx,0x10(%ebp)
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	75 e5                	jne    800f41 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f73:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f77:	76 24                	jbe    800f9d <memcpy+0x3c>
		while(n >= 8){
  800f79:	eb 1c                	jmp    800f97 <memcpy+0x36>
			*d64 = *s64;
  800f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7e:	8b 50 04             	mov    0x4(%eax),%edx
  800f81:	8b 00                	mov    (%eax),%eax
  800f83:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f86:	89 01                	mov    %eax,(%ecx)
  800f88:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f8b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f8f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f93:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f97:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f9b:	77 de                	ja     800f7b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	74 31                	je     800fd4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800faf:	eb 16                	jmp    800fc7 <memcpy+0x66>
			*d8++ = *s8++;
  800fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb4:	8d 50 01             	lea    0x1(%eax),%edx
  800fb7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fc3:	8a 12                	mov    (%edx),%dl
  800fc5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	75 dd                	jne    800fb1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff1:	73 50                	jae    801043 <memmove+0x6a>
  800ff3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	01 d0                	add    %edx,%eax
  800ffb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ffe:	76 43                	jbe    801043 <memmove+0x6a>
		s += n;
  801000:	8b 45 10             	mov    0x10(%ebp),%eax
  801003:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80100c:	eb 10                	jmp    80101e <memmove+0x45>
			*--d = *--s;
  80100e:	ff 4d f8             	decl   -0x8(%ebp)
  801011:	ff 4d fc             	decl   -0x4(%ebp)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	8d 50 ff             	lea    -0x1(%eax),%edx
  801024:	89 55 10             	mov    %edx,0x10(%ebp)
  801027:	85 c0                	test   %eax,%eax
  801029:	75 e3                	jne    80100e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80102b:	eb 23                	jmp    801050 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801036:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801039:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80103f:	8a 12                	mov    (%edx),%dl
  801041:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	8d 50 ff             	lea    -0x1(%eax),%edx
  801049:	89 55 10             	mov    %edx,0x10(%ebp)
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 dd                	jne    80102d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801061:	8b 45 0c             	mov    0xc(%ebp),%eax
  801064:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801067:	eb 2a                	jmp    801093 <memcmp+0x3e>
		if (*s1 != *s2)
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	8a 10                	mov    (%eax),%dl
  80106e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	38 c2                	cmp    %al,%dl
  801075:	74 16                	je     80108d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801077:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	0f b6 d0             	movzbl %al,%edx
  80107f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f b6 c0             	movzbl %al,%eax
  801087:	29 c2                	sub    %eax,%edx
  801089:	89 d0                	mov    %edx,%eax
  80108b:	eb 18                	jmp    8010a5 <memcmp+0x50>
		s1++, s2++;
  80108d:	ff 45 fc             	incl   -0x4(%ebp)
  801090:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 c9                	jne    801069 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	01 d0                	add    %edx,%eax
  8010b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010b8:	eb 15                	jmp    8010cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	0f b6 d0             	movzbl %al,%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	0f b6 c0             	movzbl %al,%eax
  8010c8:	39 c2                	cmp    %eax,%edx
  8010ca:	74 0d                	je     8010d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010d5:	72 e3                	jb     8010ba <memfind+0x13>
  8010d7:	eb 01                	jmp    8010da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010d9:	90                   	nop
	return (void *) s;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f3:	eb 03                	jmp    8010f8 <strtol+0x19>
		s++;
  8010f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 20                	cmp    $0x20,%al
  8010ff:	74 f4                	je     8010f5 <strtol+0x16>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 09                	cmp    $0x9,%al
  801108:	74 eb                	je     8010f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 2b                	cmp    $0x2b,%al
  801111:	75 05                	jne    801118 <strtol+0x39>
		s++;
  801113:	ff 45 08             	incl   0x8(%ebp)
  801116:	eb 13                	jmp    80112b <strtol+0x4c>
	else if (*s == '-')
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 2d                	cmp    $0x2d,%al
  80111f:	75 0a                	jne    80112b <strtol+0x4c>
		s++, neg = 1;
  801121:	ff 45 08             	incl   0x8(%ebp)
  801124:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	74 06                	je     801137 <strtol+0x58>
  801131:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801135:	75 20                	jne    801157 <strtol+0x78>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	3c 30                	cmp    $0x30,%al
  80113e:	75 17                	jne    801157 <strtol+0x78>
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	40                   	inc    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 78                	cmp    $0x78,%al
  801148:	75 0d                	jne    801157 <strtol+0x78>
		s += 2, base = 16;
  80114a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80114e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801155:	eb 28                	jmp    80117f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	75 15                	jne    801172 <strtol+0x93>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 30                	cmp    $0x30,%al
  801164:	75 0c                	jne    801172 <strtol+0x93>
		s++, base = 8;
  801166:	ff 45 08             	incl   0x8(%ebp)
  801169:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801170:	eb 0d                	jmp    80117f <strtol+0xa0>
	else if (base == 0)
  801172:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801176:	75 07                	jne    80117f <strtol+0xa0>
		base = 10;
  801178:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 2f                	cmp    $0x2f,%al
  801186:	7e 19                	jle    8011a1 <strtol+0xc2>
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	3c 39                	cmp    $0x39,%al
  80118f:	7f 10                	jg     8011a1 <strtol+0xc2>
			dig = *s - '0';
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	0f be c0             	movsbl %al,%eax
  801199:	83 e8 30             	sub    $0x30,%eax
  80119c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80119f:	eb 42                	jmp    8011e3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 60                	cmp    $0x60,%al
  8011a8:	7e 19                	jle    8011c3 <strtol+0xe4>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 7a                	cmp    $0x7a,%al
  8011b1:	7f 10                	jg     8011c3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be c0             	movsbl %al,%eax
  8011bb:	83 e8 57             	sub    $0x57,%eax
  8011be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c1:	eb 20                	jmp    8011e3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	3c 40                	cmp    $0x40,%al
  8011ca:	7e 39                	jle    801205 <strtol+0x126>
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	3c 5a                	cmp    $0x5a,%al
  8011d3:	7f 30                	jg     801205 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f be c0             	movsbl %al,%eax
  8011dd:	83 e8 37             	sub    $0x37,%eax
  8011e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e9:	7d 19                	jge    801204 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011eb:	ff 45 08             	incl   0x8(%ebp)
  8011ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ff:	e9 7b ff ff ff       	jmp    80117f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801204:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801205:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801209:	74 08                	je     801213 <strtol+0x134>
		*endptr = (char *) s;
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	8b 55 08             	mov    0x8(%ebp),%edx
  801211:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801213:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801217:	74 07                	je     801220 <strtol+0x141>
  801219:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121c:	f7 d8                	neg    %eax
  80121e:	eb 03                	jmp    801223 <strtol+0x144>
  801220:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <ltostr>:

void
ltostr(long value, char *str)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801232:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123d:	79 13                	jns    801252 <ltostr+0x2d>
	{
		neg = 1;
  80123f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80124c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80124f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80125a:	99                   	cltd   
  80125b:	f7 f9                	idiv   %ecx
  80125d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801269:	89 c2                	mov    %eax,%edx
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801273:	83 c2 30             	add    $0x30,%edx
  801276:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801278:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801280:	f7 e9                	imul   %ecx
  801282:	c1 fa 02             	sar    $0x2,%edx
  801285:	89 c8                	mov    %ecx,%eax
  801287:	c1 f8 1f             	sar    $0x1f,%eax
  80128a:	29 c2                	sub    %eax,%edx
  80128c:	89 d0                	mov    %edx,%eax
  80128e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801291:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801295:	75 bb                	jne    801252 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a1:	48                   	dec    %eax
  8012a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a9:	74 3d                	je     8012e8 <ltostr+0xc3>
		start = 1 ;
  8012ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012b2:	eb 34                	jmp    8012e8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	01 c8                	add    %ecx,%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ee:	7c c4                	jl     8012b4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	01 d0                	add    %edx,%eax
  8012f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801304:	ff 75 08             	pushl  0x8(%ebp)
  801307:	e8 c4 f9 ff ff       	call   800cd0 <strlen>
  80130c:	83 c4 04             	add    $0x4,%esp
  80130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	e8 b6 f9 ff ff       	call   800cd0 <strlen>
  80131a:	83 c4 04             	add    $0x4,%esp
  80131d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801320:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801327:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80132e:	eb 17                	jmp    801347 <strcconcat+0x49>
		final[s] = str1[s] ;
  801330:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801344:	ff 45 fc             	incl   -0x4(%ebp)
  801347:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80134d:	7c e1                	jl     801330 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80134f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80135d:	eb 1f                	jmp    80137e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801368:	89 c2                	mov    %eax,%edx
  80136a:	8b 45 10             	mov    0x10(%ebp),%eax
  80136d:	01 c2                	add    %eax,%edx
  80136f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	01 c8                	add    %ecx,%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80137b:	ff 45 f8             	incl   -0x8(%ebp)
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801384:	7c d9                	jl     80135f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	c6 00 00             	movb   $0x0,(%eax)
}
  801391:	90                   	nop
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801397:	8b 45 14             	mov    0x14(%ebp),%eax
  80139a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8013af:	01 d0                	add    %edx,%eax
  8013b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b7:	eb 0c                	jmp    8013c5 <strsplit+0x31>
			*string++ = 0;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	84 c0                	test   %al,%al
  8013cc:	74 18                	je     8013e6 <strsplit+0x52>
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	0f be c0             	movsbl %al,%eax
  8013d6:	50                   	push   %eax
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	e8 83 fa ff ff       	call   800e62 <strchr>
  8013df:	83 c4 08             	add    $0x8,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	75 d3                	jne    8013b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 5a                	je     801449 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	83 f8 0f             	cmp    $0xf,%eax
  8013f7:	75 07                	jne    801400 <strsplit+0x6c>
		{
			return 0;
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fe:	eb 66                	jmp    801466 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801400:	8b 45 14             	mov    0x14(%ebp),%eax
  801403:	8b 00                	mov    (%eax),%eax
  801405:	8d 48 01             	lea    0x1(%eax),%ecx
  801408:	8b 55 14             	mov    0x14(%ebp),%edx
  80140b:	89 0a                	mov    %ecx,(%edx)
  80140d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	01 c2                	add    %eax,%edx
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80141e:	eb 03                	jmp    801423 <strsplit+0x8f>
			string++;
  801420:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	84 c0                	test   %al,%al
  80142a:	74 8b                	je     8013b7 <strsplit+0x23>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	0f be c0             	movsbl %al,%eax
  801434:	50                   	push   %eax
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	e8 25 fa ff ff       	call   800e62 <strchr>
  80143d:	83 c4 08             	add    $0x8,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	74 dc                	je     801420 <strsplit+0x8c>
			string++;
	}
  801444:	e9 6e ff ff ff       	jmp    8013b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801449:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80144a:	8b 45 14             	mov    0x14(%ebp),%eax
  80144d:	8b 00                	mov    (%eax),%eax
  80144f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801461:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 4a                	jmp    8014c7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	01 c2                	add    %eax,%edx
  801485:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148b:	01 c8                	add    %ecx,%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801491:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801494:	8b 45 0c             	mov    0xc(%ebp),%eax
  801497:	01 d0                	add    %edx,%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	3c 40                	cmp    $0x40,%al
  80149d:	7e 25                	jle    8014c4 <str2lower+0x5c>
  80149f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	01 d0                	add    %edx,%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	3c 5a                	cmp    $0x5a,%al
  8014ab:	7f 17                	jg     8014c4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	01 d0                	add    %edx,%eax
  8014b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bb:	01 ca                	add    %ecx,%edx
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	83 c2 20             	add    $0x20,%edx
  8014c2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014c4:	ff 45 fc             	incl   -0x4(%ebp)
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	e8 01 f8 ff ff       	call   800cd0 <strlen>
  8014cf:	83 c4 04             	add    $0x4,%esp
  8014d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014d5:	7f a6                	jg     80147d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014f1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014f4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014f7:	cd 30                	int    $0x30
  8014f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	5b                   	pop    %ebx
  801503:	5e                   	pop    %esi
  801504:	5f                   	pop    %edi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	8b 45 10             	mov    0x10(%ebp),%eax
  801510:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801513:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801516:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	6a 00                	push   $0x0
  80151f:	51                   	push   %ecx
  801520:	52                   	push   %edx
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	50                   	push   %eax
  801525:	6a 00                	push   $0x0
  801527:	e8 b0 ff ff ff       	call   8014dc <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	90                   	nop
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_cgetc>:

int
sys_cgetc(void)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 02                	push   $0x2
  801541:	e8 96 ff ff ff       	call   8014dc <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 03                	push   $0x3
  80155a:	e8 7d ff ff ff       	call   8014dc <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	90                   	nop
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 04                	push   $0x4
  801574:	e8 63 ff ff ff       	call   8014dc <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	90                   	nop
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801582:	8b 55 0c             	mov    0xc(%ebp),%edx
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	52                   	push   %edx
  80158f:	50                   	push   %eax
  801590:	6a 08                	push   $0x8
  801592:	e8 45 ff ff ff       	call   8014dc <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8015a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	56                   	push   %esi
  8015b1:	53                   	push   %ebx
  8015b2:	51                   	push   %ecx
  8015b3:	52                   	push   %edx
  8015b4:	50                   	push   %eax
  8015b5:	6a 09                	push   $0x9
  8015b7:	e8 20 ff ff ff       	call   8014dc <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c2:	5b                   	pop    %ebx
  8015c3:	5e                   	pop    %esi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	ff 75 08             	pushl  0x8(%ebp)
  8015d4:	6a 0a                	push   $0xa
  8015d6:	e8 01 ff ff ff       	call   8014dc <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	ff 75 08             	pushl  0x8(%ebp)
  8015ef:	6a 0b                	push   $0xb
  8015f1:	e8 e6 fe ff ff       	call   8014dc <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 0c                	push   $0xc
  80160a:	e8 cd fe ff ff       	call   8014dc <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 0d                	push   $0xd
  801623:	e8 b4 fe ff ff       	call   8014dc <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 0e                	push   $0xe
  80163c:	e8 9b fe ff ff       	call   8014dc <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 0f                	push   $0xf
  801655:	e8 82 fe ff ff       	call   8014dc <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	6a 10                	push   $0x10
  80166f:	e8 68 fe ff ff       	call   8014dc <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 11                	push   $0x11
  801688:	e8 4f fe ff ff       	call   8014dc <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_cputc>:

void
sys_cputc(const char c)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80169f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	50                   	push   %eax
  8016ac:	6a 01                	push   $0x1
  8016ae:	e8 29 fe ff ff       	call   8014dc <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 14                	push   $0x14
  8016c8:	e8 0f fe ff ff       	call   8014dc <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	6a 00                	push   $0x0
  8016eb:	51                   	push   %ecx
  8016ec:	52                   	push   %edx
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	50                   	push   %eax
  8016f1:	6a 15                	push   $0x15
  8016f3:	e8 e4 fd ff ff       	call   8014dc <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 16                	push   $0x16
  801710:	e8 c7 fd ff ff       	call   8014dc <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80171d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801720:	8b 55 0c             	mov    0xc(%ebp),%edx
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	51                   	push   %ecx
  80172b:	52                   	push   %edx
  80172c:	50                   	push   %eax
  80172d:	6a 17                	push   $0x17
  80172f:	e8 a8 fd ff ff       	call   8014dc <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	52                   	push   %edx
  801749:	50                   	push   %eax
  80174a:	6a 18                	push   $0x18
  80174c:	e8 8b fd ff ff       	call   8014dc <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	ff 75 14             	pushl  0x14(%ebp)
  801761:	ff 75 10             	pushl  0x10(%ebp)
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	50                   	push   %eax
  801768:	6a 19                	push   $0x19
  80176a:	e8 6d fd ff ff       	call   8014dc <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	50                   	push   %eax
  801783:	6a 1a                	push   $0x1a
  801785:	e8 52 fd ff ff       	call   8014dc <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	50                   	push   %eax
  80179f:	6a 1b                	push   $0x1b
  8017a1:	e8 36 fd ff ff       	call   8014dc <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 05                	push   $0x5
  8017ba:	e8 1d fd ff ff       	call   8014dc <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 06                	push   $0x6
  8017d3:	e8 04 fd ff ff       	call   8014dc <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 07                	push   $0x7
  8017ec:	e8 eb fc ff ff       	call   8014dc <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 1c                	push   $0x1c
  801805:	e8 d2 fc ff ff       	call   8014dc <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	90                   	nop
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801816:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801819:	8d 50 04             	lea    0x4(%eax),%edx
  80181c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	52                   	push   %edx
  801826:	50                   	push   %eax
  801827:	6a 1d                	push   $0x1d
  801829:	e8 ae fc ff ff       	call   8014dc <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
	return result;
  801831:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801834:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801837:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183a:	89 01                	mov    %eax,(%ecx)
  80183c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	c9                   	leave  
  801843:	c2 04 00             	ret    $0x4

00801846 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	ff 75 10             	pushl  0x10(%ebp)
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	6a 13                	push   $0x13
  801858:	e8 7f fc ff ff       	call   8014dc <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return ;
  801860:	90                   	nop
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_rcr2>:
uint32 sys_rcr2()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 1e                	push   $0x1e
  801872:	e8 65 fc ff ff       	call   8014dc <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801888:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	50                   	push   %eax
  801895:	6a 1f                	push   $0x1f
  801897:	e8 40 fc ff ff       	call   8014dc <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
	return ;
  80189f:	90                   	nop
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <rsttst>:
void rsttst()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 21                	push   $0x21
  8018b1:	e8 26 fc ff ff       	call   8014dc <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8018cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	ff 75 10             	pushl  0x10(%ebp)
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	6a 20                	push   $0x20
  8018dc:	e8 fb fb ff ff       	call   8014dc <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e4:	90                   	nop
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <chktst>:
void chktst(uint32 n)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	6a 22                	push   $0x22
  8018f7:	e8 e0 fb ff ff       	call   8014dc <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ff:	90                   	nop
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <inctst>:

void inctst()
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 23                	push   $0x23
  801911:	e8 c6 fb ff ff       	call   8014dc <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
	return ;
  801919:	90                   	nop
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <gettst>:
uint32 gettst()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 24                	push   $0x24
  80192b:	e8 ac fb ff ff       	call   8014dc <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 25                	push   $0x25
  801944:	e8 93 fb ff ff       	call   8014dc <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
  80194c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801951:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 26                	push   $0x26
  801970:	e8 67 fb ff ff       	call   8014dc <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80197f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801982:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	53                   	push   %ebx
  80198e:	51                   	push   %ecx
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 27                	push   $0x27
  801993:	e8 44 fb ff ff       	call   8014dc <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 28                	push   $0x28
  8019b3:	e8 24 fb ff ff       	call   8014dc <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	51                   	push   %ecx
  8019cc:	ff 75 10             	pushl  0x10(%ebp)
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	6a 29                	push   $0x29
  8019d3:	e8 04 fb ff ff       	call   8014dc <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 10             	pushl  0x10(%ebp)
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	6a 12                	push   $0x12
  8019ef:	e8 e8 fa ff ff       	call   8014dc <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f7:	90                   	nop
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 2a                	push   $0x2a
  801a0d:	e8 ca fa ff ff       	call   8014dc <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return;
  801a15:	90                   	nop
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 2b                	push   $0x2b
  801a27:	e8 b0 fa ff ff       	call   8014dc <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	6a 2d                	push   $0x2d
  801a42:	e8 95 fa ff ff       	call   8014dc <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
	return;
  801a4a:	90                   	nop
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	6a 2c                	push   $0x2c
  801a5e:	e8 79 fa ff ff       	call   8014dc <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return ;
  801a66:	90                   	nop
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 2e                	push   $0x2e
  801a7c:	e8 5b fa ff ff       	call   8014dc <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
	return ;
  801a84:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    
  801a87:	90                   	nop

00801a88 <__udivdi3>:
  801a88:	55                   	push   %ebp
  801a89:	57                   	push   %edi
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 1c             	sub    $0x1c,%esp
  801a8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a9f:	89 ca                	mov    %ecx,%edx
  801aa1:	89 f8                	mov    %edi,%eax
  801aa3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aa7:	85 f6                	test   %esi,%esi
  801aa9:	75 2d                	jne    801ad8 <__udivdi3+0x50>
  801aab:	39 cf                	cmp    %ecx,%edi
  801aad:	77 65                	ja     801b14 <__udivdi3+0x8c>
  801aaf:	89 fd                	mov    %edi,%ebp
  801ab1:	85 ff                	test   %edi,%edi
  801ab3:	75 0b                	jne    801ac0 <__udivdi3+0x38>
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
  801aba:	31 d2                	xor    %edx,%edx
  801abc:	f7 f7                	div    %edi
  801abe:	89 c5                	mov    %eax,%ebp
  801ac0:	31 d2                	xor    %edx,%edx
  801ac2:	89 c8                	mov    %ecx,%eax
  801ac4:	f7 f5                	div    %ebp
  801ac6:	89 c1                	mov    %eax,%ecx
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	f7 f5                	div    %ebp
  801acc:	89 cf                	mov    %ecx,%edi
  801ace:	89 fa                	mov    %edi,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	39 ce                	cmp    %ecx,%esi
  801ada:	77 28                	ja     801b04 <__udivdi3+0x7c>
  801adc:	0f bd fe             	bsr    %esi,%edi
  801adf:	83 f7 1f             	xor    $0x1f,%edi
  801ae2:	75 40                	jne    801b24 <__udivdi3+0x9c>
  801ae4:	39 ce                	cmp    %ecx,%esi
  801ae6:	72 0a                	jb     801af2 <__udivdi3+0x6a>
  801ae8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aec:	0f 87 9e 00 00 00    	ja     801b90 <__udivdi3+0x108>
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	89 fa                	mov    %edi,%edx
  801af9:	83 c4 1c             	add    $0x1c,%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5f                   	pop    %edi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    
  801b01:	8d 76 00             	lea    0x0(%esi),%esi
  801b04:	31 ff                	xor    %edi,%edi
  801b06:	31 c0                	xor    %eax,%eax
  801b08:	89 fa                	mov    %edi,%edx
  801b0a:	83 c4 1c             	add    $0x1c,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5e                   	pop    %esi
  801b0f:	5f                   	pop    %edi
  801b10:	5d                   	pop    %ebp
  801b11:	c3                   	ret    
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	89 d8                	mov    %ebx,%eax
  801b16:	f7 f7                	div    %edi
  801b18:	31 ff                	xor    %edi,%edi
  801b1a:	89 fa                	mov    %edi,%edx
  801b1c:	83 c4 1c             	add    $0x1c,%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    
  801b24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b29:	89 eb                	mov    %ebp,%ebx
  801b2b:	29 fb                	sub    %edi,%ebx
  801b2d:	89 f9                	mov    %edi,%ecx
  801b2f:	d3 e6                	shl    %cl,%esi
  801b31:	89 c5                	mov    %eax,%ebp
  801b33:	88 d9                	mov    %bl,%cl
  801b35:	d3 ed                	shr    %cl,%ebp
  801b37:	89 e9                	mov    %ebp,%ecx
  801b39:	09 f1                	or     %esi,%ecx
  801b3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b3f:	89 f9                	mov    %edi,%ecx
  801b41:	d3 e0                	shl    %cl,%eax
  801b43:	89 c5                	mov    %eax,%ebp
  801b45:	89 d6                	mov    %edx,%esi
  801b47:	88 d9                	mov    %bl,%cl
  801b49:	d3 ee                	shr    %cl,%esi
  801b4b:	89 f9                	mov    %edi,%ecx
  801b4d:	d3 e2                	shl    %cl,%edx
  801b4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b53:	88 d9                	mov    %bl,%cl
  801b55:	d3 e8                	shr    %cl,%eax
  801b57:	09 c2                	or     %eax,%edx
  801b59:	89 d0                	mov    %edx,%eax
  801b5b:	89 f2                	mov    %esi,%edx
  801b5d:	f7 74 24 0c          	divl   0xc(%esp)
  801b61:	89 d6                	mov    %edx,%esi
  801b63:	89 c3                	mov    %eax,%ebx
  801b65:	f7 e5                	mul    %ebp
  801b67:	39 d6                	cmp    %edx,%esi
  801b69:	72 19                	jb     801b84 <__udivdi3+0xfc>
  801b6b:	74 0b                	je     801b78 <__udivdi3+0xf0>
  801b6d:	89 d8                	mov    %ebx,%eax
  801b6f:	31 ff                	xor    %edi,%edi
  801b71:	e9 58 ff ff ff       	jmp    801ace <__udivdi3+0x46>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b7c:	89 f9                	mov    %edi,%ecx
  801b7e:	d3 e2                	shl    %cl,%edx
  801b80:	39 c2                	cmp    %eax,%edx
  801b82:	73 e9                	jae    801b6d <__udivdi3+0xe5>
  801b84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b87:	31 ff                	xor    %edi,%edi
  801b89:	e9 40 ff ff ff       	jmp    801ace <__udivdi3+0x46>
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	31 c0                	xor    %eax,%eax
  801b92:	e9 37 ff ff ff       	jmp    801ace <__udivdi3+0x46>
  801b97:	90                   	nop

00801b98 <__umoddi3>:
  801b98:	55                   	push   %ebp
  801b99:	57                   	push   %edi
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 1c             	sub    $0x1c,%esp
  801b9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ba3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ba7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801baf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bb7:	89 f3                	mov    %esi,%ebx
  801bb9:	89 fa                	mov    %edi,%edx
  801bbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bbf:	89 34 24             	mov    %esi,(%esp)
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	75 1a                	jne    801be0 <__umoddi3+0x48>
  801bc6:	39 f7                	cmp    %esi,%edi
  801bc8:	0f 86 a2 00 00 00    	jbe    801c70 <__umoddi3+0xd8>
  801bce:	89 c8                	mov    %ecx,%eax
  801bd0:	89 f2                	mov    %esi,%edx
  801bd2:	f7 f7                	div    %edi
  801bd4:	89 d0                	mov    %edx,%eax
  801bd6:	31 d2                	xor    %edx,%edx
  801bd8:	83 c4 1c             	add    $0x1c,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5f                   	pop    %edi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    
  801be0:	39 f0                	cmp    %esi,%eax
  801be2:	0f 87 ac 00 00 00    	ja     801c94 <__umoddi3+0xfc>
  801be8:	0f bd e8             	bsr    %eax,%ebp
  801beb:	83 f5 1f             	xor    $0x1f,%ebp
  801bee:	0f 84 ac 00 00 00    	je     801ca0 <__umoddi3+0x108>
  801bf4:	bf 20 00 00 00       	mov    $0x20,%edi
  801bf9:	29 ef                	sub    %ebp,%edi
  801bfb:	89 fe                	mov    %edi,%esi
  801bfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c01:	89 e9                	mov    %ebp,%ecx
  801c03:	d3 e0                	shl    %cl,%eax
  801c05:	89 d7                	mov    %edx,%edi
  801c07:	89 f1                	mov    %esi,%ecx
  801c09:	d3 ef                	shr    %cl,%edi
  801c0b:	09 c7                	or     %eax,%edi
  801c0d:	89 e9                	mov    %ebp,%ecx
  801c0f:	d3 e2                	shl    %cl,%edx
  801c11:	89 14 24             	mov    %edx,(%esp)
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	d3 e0                	shl    %cl,%eax
  801c18:	89 c2                	mov    %eax,%edx
  801c1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1e:	d3 e0                	shl    %cl,%eax
  801c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c28:	89 f1                	mov    %esi,%ecx
  801c2a:	d3 e8                	shr    %cl,%eax
  801c2c:	09 d0                	or     %edx,%eax
  801c2e:	d3 eb                	shr    %cl,%ebx
  801c30:	89 da                	mov    %ebx,%edx
  801c32:	f7 f7                	div    %edi
  801c34:	89 d3                	mov    %edx,%ebx
  801c36:	f7 24 24             	mull   (%esp)
  801c39:	89 c6                	mov    %eax,%esi
  801c3b:	89 d1                	mov    %edx,%ecx
  801c3d:	39 d3                	cmp    %edx,%ebx
  801c3f:	0f 82 87 00 00 00    	jb     801ccc <__umoddi3+0x134>
  801c45:	0f 84 91 00 00 00    	je     801cdc <__umoddi3+0x144>
  801c4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c4f:	29 f2                	sub    %esi,%edx
  801c51:	19 cb                	sbb    %ecx,%ebx
  801c53:	89 d8                	mov    %ebx,%eax
  801c55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c59:	d3 e0                	shl    %cl,%eax
  801c5b:	89 e9                	mov    %ebp,%ecx
  801c5d:	d3 ea                	shr    %cl,%edx
  801c5f:	09 d0                	or     %edx,%eax
  801c61:	89 e9                	mov    %ebp,%ecx
  801c63:	d3 eb                	shr    %cl,%ebx
  801c65:	89 da                	mov    %ebx,%edx
  801c67:	83 c4 1c             	add    $0x1c,%esp
  801c6a:	5b                   	pop    %ebx
  801c6b:	5e                   	pop    %esi
  801c6c:	5f                   	pop    %edi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    
  801c6f:	90                   	nop
  801c70:	89 fd                	mov    %edi,%ebp
  801c72:	85 ff                	test   %edi,%edi
  801c74:	75 0b                	jne    801c81 <__umoddi3+0xe9>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	31 d2                	xor    %edx,%edx
  801c7d:	f7 f7                	div    %edi
  801c7f:	89 c5                	mov    %eax,%ebp
  801c81:	89 f0                	mov    %esi,%eax
  801c83:	31 d2                	xor    %edx,%edx
  801c85:	f7 f5                	div    %ebp
  801c87:	89 c8                	mov    %ecx,%eax
  801c89:	f7 f5                	div    %ebp
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	e9 44 ff ff ff       	jmp    801bd6 <__umoddi3+0x3e>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	89 c8                	mov    %ecx,%eax
  801c96:	89 f2                	mov    %esi,%edx
  801c98:	83 c4 1c             	add    $0x1c,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
  801ca0:	3b 04 24             	cmp    (%esp),%eax
  801ca3:	72 06                	jb     801cab <__umoddi3+0x113>
  801ca5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ca9:	77 0f                	ja     801cba <__umoddi3+0x122>
  801cab:	89 f2                	mov    %esi,%edx
  801cad:	29 f9                	sub    %edi,%ecx
  801caf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cb3:	89 14 24             	mov    %edx,(%esp)
  801cb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cbe:	8b 14 24             	mov    (%esp),%edx
  801cc1:	83 c4 1c             	add    $0x1c,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
  801cc9:	8d 76 00             	lea    0x0(%esi),%esi
  801ccc:	2b 04 24             	sub    (%esp),%eax
  801ccf:	19 fa                	sbb    %edi,%edx
  801cd1:	89 d1                	mov    %edx,%ecx
  801cd3:	89 c6                	mov    %eax,%esi
  801cd5:	e9 71 ff ff ff       	jmp    801c4b <__umoddi3+0xb3>
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ce0:	72 ea                	jb     801ccc <__umoddi3+0x134>
  801ce2:	89 d9                	mov    %ebx,%ecx
  801ce4:	e9 62 ff ff ff       	jmp    801c4b <__umoddi3+0xb3>
