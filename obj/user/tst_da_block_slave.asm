
obj/user/tst_da_block_slave:     file format elf32-i386


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
  800031:	e8 1c 00 00 00       	call   800052 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	panic("UPDATE IS REQUIRED");
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	68 00 1c 80 00       	push   $0x801c00
  800046:	6a 08                	push   $0x8
  800048:	68 13 1c 80 00       	push   $0x801c13
  80004d:	e8 b0 01 00 00       	call   800202 <_panic>

00800052 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005b:	e8 5d 16 00 00       	call   8016bd <sys_getenvindex>
  800060:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800063:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800066:	89 d0                	mov    %edx,%eax
  800068:	01 c0                	add    %eax,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	c1 e0 02             	shl    $0x2,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 02             	shl    $0x2,%eax
  800074:	01 d0                	add    %edx,%eax
  800076:	c1 e0 03             	shl    $0x3,%eax
  800079:	01 d0                	add    %edx,%eax
  80007b:	c1 e0 02             	shl    $0x2,%eax
  80007e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800083:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800088:	a1 20 30 80 00       	mov    0x803020,%eax
  80008d:	8a 40 20             	mov    0x20(%eax),%al
  800090:	84 c0                	test   %al,%al
  800092:	74 0d                	je     8000a1 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800094:	a1 20 30 80 00       	mov    0x803020,%eax
  800099:	83 c0 20             	add    $0x20,%eax
  80009c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a5:	7e 0a                	jle    8000b1 <libmain+0x5f>
		binaryname = argv[0];
  8000a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000aa:	8b 00                	mov    (%eax),%eax
  8000ac:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	ff 75 0c             	pushl  0xc(%ebp)
  8000b7:	ff 75 08             	pushl  0x8(%ebp)
  8000ba:	e8 79 ff ff ff       	call   800038 <_main>
  8000bf:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	0f 84 01 01 00 00    	je     8001d0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000cf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000d5:	bb 28 1d 80 00       	mov    $0x801d28,%ebx
  8000da:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	89 de                	mov    %ebx,%esi
  8000e3:	89 d1                	mov    %edx,%ecx
  8000e5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000e7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ea:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000ef:	b0 00                	mov    $0x0,%al
  8000f1:	89 d7                	mov    %edx,%edi
  8000f3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8000fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	50                   	push   %eax
  800103:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800109:	50                   	push   %eax
  80010a:	e8 e4 17 00 00       	call   8018f3 <sys_utilities>
  80010f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800112:	e8 2d 13 00 00       	call   801444 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	68 48 1c 80 00       	push   $0x801c48
  80011f:	e8 cc 03 00 00       	call   8004f0 <cprintf>
  800124:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	85 c0                	test   %eax,%eax
  80012c:	74 18                	je     800146 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80012e:	e8 de 17 00 00       	call   801911 <sys_get_optimal_num_faults>
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	50                   	push   %eax
  800137:	68 70 1c 80 00       	push   $0x801c70
  80013c:	e8 af 03 00 00       	call   8004f0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	eb 59                	jmp    80019f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	68 94 1c 80 00       	push   $0x801c94
  800166:	e8 85 03 00 00       	call   8004f0 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016e:	a1 20 30 80 00       	mov    0x803020,%eax
  800173:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800179:	a1 20 30 80 00       	mov    0x803020,%eax
  80017e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800184:	a1 20 30 80 00       	mov    0x803020,%eax
  800189:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80018f:	51                   	push   %ecx
  800190:	52                   	push   %edx
  800191:	50                   	push   %eax
  800192:	68 bc 1c 80 00       	push   $0x801cbc
  800197:	e8 54 03 00 00       	call   8004f0 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019f:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a4:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	68 14 1d 80 00       	push   $0x801d14
  8001b3:	e8 38 03 00 00       	call   8004f0 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 48 1c 80 00       	push   $0x801c48
  8001c3:	e8 28 03 00 00       	call   8004f0 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001cb:	e8 8e 12 00 00       	call   80145e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d0:	e8 1f 00 00 00       	call   8001f4 <exit>
}
  8001d5:	90                   	nop
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    

008001de <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	6a 00                	push   $0x0
  8001e9:	e8 9b 14 00 00       	call   801689 <sys_destroy_env>
  8001ee:	83 c4 10             	add    $0x10,%esp
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <exit>:

void
exit(void)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fa:	e8 f0 14 00 00       	call   8016ef <sys_exit_env>
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800208:	8d 45 10             	lea    0x10(%ebp),%eax
  80020b:	83 c0 04             	add    $0x4,%eax
  80020e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800211:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800216:	85 c0                	test   %eax,%eax
  800218:	74 16                	je     800230 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80021a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 8c 1d 80 00       	push   $0x801d8c
  800228:	e8 c3 02 00 00       	call   8004f0 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800230:	a1 04 30 80 00       	mov    0x803004,%eax
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	50                   	push   %eax
  80023f:	68 94 1d 80 00       	push   $0x801d94
  800244:	6a 74                	push   $0x74
  800246:	e8 d2 02 00 00       	call   80051d <cprintf_colored>
  80024b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80024e:	8b 45 10             	mov    0x10(%ebp),%eax
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	ff 75 f4             	pushl  -0xc(%ebp)
  800257:	50                   	push   %eax
  800258:	e8 24 02 00 00       	call   800481 <vcprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	6a 00                	push   $0x0
  800265:	68 bc 1d 80 00       	push   $0x801dbc
  80026a:	e8 12 02 00 00       	call   800481 <vcprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800272:	e8 7d ff ff ff       	call   8001f4 <exit>

	// should not return here
	while (1) ;
  800277:	eb fe                	jmp    800277 <_panic+0x75>

00800279 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	53                   	push   %ebx
  80027d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800280:	a1 20 30 80 00       	mov    0x803020,%eax
  800285:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028e:	39 c2                	cmp    %eax,%edx
  800290:	74 14                	je     8002a6 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 c0 1d 80 00       	push   $0x801dc0
  80029a:	6a 26                	push   $0x26
  80029c:	68 0c 1e 80 00       	push   $0x801e0c
  8002a1:	e8 5c ff ff ff       	call   800202 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b4:	e9 d9 00 00 00       	jmp    800392 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8002b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	75 08                	jne    8002d6 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8002ce:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002d1:	e9 b9 00 00 00       	jmp    80038f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8002d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002e4:	eb 79                	jmp    80035f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002eb:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8002f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f4:	89 d0                	mov    %edx,%eax
  8002f6:	01 c0                	add    %eax,%eax
  8002f8:	01 d0                	add    %edx,%eax
  8002fa:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800301:	01 d8                	add    %ebx,%eax
  800303:	01 d0                	add    %edx,%eax
  800305:	01 c8                	add    %ecx,%eax
  800307:	8a 40 04             	mov    0x4(%eax),%al
  80030a:	84 c0                	test   %al,%al
  80030c:	75 4e                	jne    80035c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031c:	89 d0                	mov    %edx,%eax
  80031e:	01 c0                	add    %eax,%eax
  800320:	01 d0                	add    %edx,%eax
  800322:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800329:	01 d8                	add    %ebx,%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800334:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800337:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80033c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 c8                	add    %ecx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80034f:	39 c2                	cmp    %eax,%edx
  800351:	75 09                	jne    80035c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800353:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80035a:	eb 19                	jmp    800375 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035c:	ff 45 e8             	incl   -0x18(%ebp)
  80035f:	a1 20 30 80 00       	mov    0x803020,%eax
  800364:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80036a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80036d:	39 c2                	cmp    %eax,%edx
  80036f:	0f 87 71 ff ff ff    	ja     8002e6 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800375:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800379:	75 14                	jne    80038f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 18 1e 80 00       	push   $0x801e18
  800383:	6a 3a                	push   $0x3a
  800385:	68 0c 1e 80 00       	push   $0x801e0c
  80038a:	e8 73 fe ff ff       	call   800202 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80038f:	ff 45 f0             	incl   -0x10(%ebp)
  800392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800395:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800398:	0f 8c 1b ff ff ff    	jl     8002b9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80039e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ac:	eb 2e                	jmp    8003dc <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003bc:	89 d0                	mov    %edx,%eax
  8003be:	01 c0                	add    %eax,%eax
  8003c0:	01 d0                	add    %edx,%eax
  8003c2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003c9:	01 d8                	add    %ebx,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	01 c8                	add    %ecx,%eax
  8003cf:	8a 40 04             	mov    0x4(%eax),%al
  8003d2:	3c 01                	cmp    $0x1,%al
  8003d4:	75 03                	jne    8003d9 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8003d6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d9:	ff 45 e0             	incl   -0x20(%ebp)
  8003dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	77 c0                	ja     8003ae <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003f4:	74 14                	je     80040a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	68 6c 1e 80 00       	push   $0x801e6c
  8003fe:	6a 44                	push   $0x44
  800400:	68 0c 1e 80 00       	push   $0x801e0c
  800405:	e8 f8 fd ff ff       	call   800202 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80040a:	90                   	nop
  80040b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	53                   	push   %ebx
  800414:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	8d 48 01             	lea    0x1(%eax),%ecx
  80041f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800422:	89 0a                	mov    %ecx,(%edx)
  800424:	8b 55 08             	mov    0x8(%ebp),%edx
  800427:	88 d1                	mov    %dl,%cl
  800429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	3d ff 00 00 00       	cmp    $0xff,%eax
  80043a:	75 30                	jne    80046c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80043c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800442:	a0 44 30 80 00       	mov    0x803044,%al
  800447:	0f b6 c0             	movzbl %al,%eax
  80044a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044d:	8b 09                	mov    (%ecx),%ecx
  80044f:	89 cb                	mov    %ecx,%ebx
  800451:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800454:	83 c1 08             	add    $0x8,%ecx
  800457:	52                   	push   %edx
  800458:	50                   	push   %eax
  800459:	53                   	push   %ebx
  80045a:	51                   	push   %ecx
  80045b:	e8 a0 0f 00 00       	call   801400 <sys_cputs>
  800460:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	8b 40 04             	mov    0x4(%eax),%eax
  800472:	8d 50 01             	lea    0x1(%eax),%edx
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	89 50 04             	mov    %edx,0x4(%eax)
}
  80047b:	90                   	nop
  80047c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80048a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800491:	00 00 00 
	b.cnt = 0;
  800494:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80049e:	ff 75 0c             	pushl  0xc(%ebp)
  8004a1:	ff 75 08             	pushl  0x8(%ebp)
  8004a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004aa:	50                   	push   %eax
  8004ab:	68 10 04 80 00       	push   $0x800410
  8004b0:	e8 5a 02 00 00       	call   80070f <vprintfmt>
  8004b5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004b8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004be:	a0 44 30 80 00       	mov    0x803044,%al
  8004c3:	0f b6 c0             	movzbl %al,%eax
  8004c6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004cc:	52                   	push   %edx
  8004cd:	50                   	push   %eax
  8004ce:	51                   	push   %ecx
  8004cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d5:	83 c0 08             	add    $0x8,%eax
  8004d8:	50                   	push   %eax
  8004d9:	e8 22 0f 00 00       	call   801400 <sys_cputs>
  8004de:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004e1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004f6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800500:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	ff 75 f4             	pushl  -0xc(%ebp)
  80050c:	50                   	push   %eax
  80050d:	e8 6f ff ff ff       	call   800481 <vcprintf>
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800518:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800523:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	c1 e0 08             	shl    $0x8,%eax
  800530:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800535:	8d 45 0c             	lea    0xc(%ebp),%eax
  800538:	83 c0 04             	add    $0x4,%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 34 ff ff ff       	call   800481 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800553:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80055a:	07 00 00 

	return cnt;
  80055d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800568:	e8 d7 0e 00 00       	call   801444 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80056d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800570:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 f4             	pushl  -0xc(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 ff fe ff ff       	call   800481 <vcprintf>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800588:	e8 d1 0e 00 00       	call   80145e <sys_unlock_cons>
	return cnt;
  80058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	53                   	push   %ebx
  800596:	83 ec 14             	sub    $0x14,%esp
  800599:	8b 45 10             	mov    0x10(%ebp),%eax
  80059c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b0:	77 55                	ja     800607 <printnum+0x75>
  8005b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b5:	72 05                	jb     8005bc <printnum+0x2a>
  8005b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ba:	77 4b                	ja     800607 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ca:	52                   	push   %edx
  8005cb:	50                   	push   %eax
  8005cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d2:	e8 a9 13 00 00       	call   801980 <__udivdi3>
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	ff 75 20             	pushl  0x20(%ebp)
  8005e0:	53                   	push   %ebx
  8005e1:	ff 75 18             	pushl  0x18(%ebp)
  8005e4:	52                   	push   %edx
  8005e5:	50                   	push   %eax
  8005e6:	ff 75 0c             	pushl  0xc(%ebp)
  8005e9:	ff 75 08             	pushl  0x8(%ebp)
  8005ec:	e8 a1 ff ff ff       	call   800592 <printnum>
  8005f1:	83 c4 20             	add    $0x20,%esp
  8005f4:	eb 1a                	jmp    800610 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 0c             	pushl  0xc(%ebp)
  8005fc:	ff 75 20             	pushl  0x20(%ebp)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	ff d0                	call   *%eax
  800604:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800607:	ff 4d 1c             	decl   0x1c(%ebp)
  80060a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060e:	7f e6                	jg     8005f6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800610:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800613:	bb 00 00 00 00       	mov    $0x0,%ebx
  800618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061e:	53                   	push   %ebx
  80061f:	51                   	push   %ecx
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	e8 69 14 00 00       	call   801a90 <__umoddi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	05 d4 20 80 00       	add    $0x8020d4,%eax
  80062f:	8a 00                	mov    (%eax),%al
  800631:	0f be c0             	movsbl %al,%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 0c             	pushl  0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
}
  800643:	90                   	nop
  800644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800647:	c9                   	leave  
  800648:	c3                   	ret    

00800649 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800650:	7e 1c                	jle    80066e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	8d 50 08             	lea    0x8(%eax),%edx
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	89 10                	mov    %edx,(%eax)
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	83 e8 08             	sub    $0x8,%eax
  800667:	8b 50 04             	mov    0x4(%eax),%edx
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	eb 40                	jmp    8006ae <getuint+0x65>
	else if (lflag)
  80066e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800672:	74 1e                	je     800692 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	8d 50 04             	lea    0x4(%eax),%edx
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	89 10                	mov    %edx,(%eax)
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	83 e8 04             	sub    $0x4,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	eb 1c                	jmp    8006ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	8d 50 04             	lea    0x4(%eax),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	83 e8 04             	sub    $0x4,%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ae:	5d                   	pop    %ebp
  8006af:	c3                   	ret    

008006b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b7:	7e 1c                	jle    8006d5 <getint+0x25>
		return va_arg(*ap, long long);
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8d 50 08             	lea    0x8(%eax),%edx
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	89 10                	mov    %edx,(%eax)
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	83 e8 08             	sub    $0x8,%eax
  8006ce:	8b 50 04             	mov    0x4(%eax),%edx
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	eb 38                	jmp    80070d <getint+0x5d>
	else if (lflag)
  8006d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d9:	74 1a                	je     8006f5 <getint+0x45>
		return va_arg(*ap, long);
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	8d 50 04             	lea    0x4(%eax),%edx
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	89 10                	mov    %edx,(%eax)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	99                   	cltd   
  8006f3:	eb 18                	jmp    80070d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 04             	lea    0x4(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 04             	sub    $0x4,%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	99                   	cltd   
}
  80070d:	5d                   	pop    %ebp
  80070e:	c3                   	ret    

0080070f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	56                   	push   %esi
  800713:	53                   	push   %ebx
  800714:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800717:	eb 17                	jmp    800730 <vprintfmt+0x21>
			if (ch == '\0')
  800719:	85 db                	test   %ebx,%ebx
  80071b:	0f 84 c1 03 00 00    	je     800ae2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	53                   	push   %ebx
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800730:	8b 45 10             	mov    0x10(%ebp),%eax
  800733:	8d 50 01             	lea    0x1(%eax),%edx
  800736:	89 55 10             	mov    %edx,0x10(%ebp)
  800739:	8a 00                	mov    (%eax),%al
  80073b:	0f b6 d8             	movzbl %al,%ebx
  80073e:	83 fb 25             	cmp    $0x25,%ebx
  800741:	75 d6                	jne    800719 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800743:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800747:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800755:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	89 55 10             	mov    %edx,0x10(%ebp)
  80076c:	8a 00                	mov    (%eax),%al
  80076e:	0f b6 d8             	movzbl %al,%ebx
  800771:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800774:	83 f8 5b             	cmp    $0x5b,%eax
  800777:	0f 87 3d 03 00 00    	ja     800aba <vprintfmt+0x3ab>
  80077d:	8b 04 85 f8 20 80 00 	mov    0x8020f8(,%eax,4),%eax
  800784:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800786:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078a:	eb d7                	jmp    800763 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800790:	eb d1                	jmp    800763 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800792:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800799:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	c1 e0 02             	shl    $0x2,%eax
  8007a1:	01 d0                	add    %edx,%eax
  8007a3:	01 c0                	add    %eax,%eax
  8007a5:	01 d8                	add    %ebx,%eax
  8007a7:	83 e8 30             	sub    $0x30,%eax
  8007aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b0:	8a 00                	mov    (%eax),%al
  8007b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b8:	7e 3e                	jle    8007f8 <vprintfmt+0xe9>
  8007ba:	83 fb 39             	cmp    $0x39,%ebx
  8007bd:	7f 39                	jg     8007f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c2:	eb d5                	jmp    800799 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	83 c0 04             	add    $0x4,%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	83 e8 04             	sub    $0x4,%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d8:	eb 1f                	jmp    8007f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	79 83                	jns    800763 <vprintfmt+0x54>
				width = 0;
  8007e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e7:	e9 77 ff ff ff       	jmp    800763 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f3:	e9 6b ff ff ff       	jmp    800763 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fd:	0f 89 60 ff ff ff    	jns    800763 <vprintfmt+0x54>
				width = precision, precision = -1;
  800803:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800809:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800810:	e9 4e ff ff ff       	jmp    800763 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800815:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800818:	e9 46 ff ff ff       	jmp    800763 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 c0 04             	add    $0x4,%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	83 e8 04             	sub    $0x4,%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	50                   	push   %eax
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			break;
  80083d:	e9 9b 02 00 00       	jmp    800add <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800853:	85 db                	test   %ebx,%ebx
  800855:	79 02                	jns    800859 <vprintfmt+0x14a>
				err = -err;
  800857:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800859:	83 fb 64             	cmp    $0x64,%ebx
  80085c:	7f 0b                	jg     800869 <vprintfmt+0x15a>
  80085e:	8b 34 9d 40 1f 80 00 	mov    0x801f40(,%ebx,4),%esi
  800865:	85 f6                	test   %esi,%esi
  800867:	75 19                	jne    800882 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800869:	53                   	push   %ebx
  80086a:	68 e5 20 80 00       	push   $0x8020e5
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	e8 70 02 00 00       	call   800aea <printfmt>
  80087a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087d:	e9 5b 02 00 00       	jmp    800add <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800882:	56                   	push   %esi
  800883:	68 ee 20 80 00       	push   $0x8020ee
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	e8 57 02 00 00       	call   800aea <printfmt>
  800893:	83 c4 10             	add    $0x10,%esp
			break;
  800896:	e9 42 02 00 00       	jmp    800add <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 c0 04             	add    $0x4,%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 e8 04             	sub    $0x4,%eax
  8008aa:	8b 30                	mov    (%eax),%esi
  8008ac:	85 f6                	test   %esi,%esi
  8008ae:	75 05                	jne    8008b5 <vprintfmt+0x1a6>
				p = "(null)";
  8008b0:	be f1 20 80 00       	mov    $0x8020f1,%esi
			if (width > 0 && padc != '-')
  8008b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b9:	7e 6d                	jle    800928 <vprintfmt+0x219>
  8008bb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bf:	74 67                	je     800928 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	50                   	push   %eax
  8008c8:	56                   	push   %esi
  8008c9:	e8 1e 03 00 00       	call   800bec <strnlen>
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d4:	eb 16                	jmp    8008ec <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	50                   	push   %eax
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	ff d0                	call   *%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f0:	7f e4                	jg     8008d6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f2:	eb 34                	jmp    800928 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f8:	74 1c                	je     800916 <vprintfmt+0x207>
  8008fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fd:	7e 05                	jle    800904 <vprintfmt+0x1f5>
  8008ff:	83 fb 7e             	cmp    $0x7e,%ebx
  800902:	7e 12                	jle    800916 <vprintfmt+0x207>
					putch('?', putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	6a 3f                	push   $0x3f
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	eb 0f                	jmp    800925 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	53                   	push   %ebx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	89 f0                	mov    %esi,%eax
  80092a:	8d 70 01             	lea    0x1(%eax),%esi
  80092d:	8a 00                	mov    (%eax),%al
  80092f:	0f be d8             	movsbl %al,%ebx
  800932:	85 db                	test   %ebx,%ebx
  800934:	74 24                	je     80095a <vprintfmt+0x24b>
  800936:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093a:	78 b8                	js     8008f4 <vprintfmt+0x1e5>
  80093c:	ff 4d e0             	decl   -0x20(%ebp)
  80093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800943:	79 af                	jns    8008f4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800945:	eb 13                	jmp    80095a <vprintfmt+0x24b>
				putch(' ', putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	6a 20                	push   $0x20
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	ff d0                	call   *%eax
  800954:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800957:	ff 4d e4             	decl   -0x1c(%ebp)
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7f e7                	jg     800947 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800960:	e9 78 01 00 00       	jmp    800add <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	ff 75 e8             	pushl  -0x18(%ebp)
  80096b:	8d 45 14             	lea    0x14(%ebp),%eax
  80096e:	50                   	push   %eax
  80096f:	e8 3c fd ff ff       	call   8006b0 <getint>
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800983:	85 d2                	test   %edx,%edx
  800985:	79 23                	jns    8009aa <vprintfmt+0x29b>
				putch('-', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	6a 2d                	push   $0x2d
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099d:	f7 d8                	neg    %eax
  80099f:	83 d2 00             	adc    $0x0,%edx
  8009a2:	f7 da                	neg    %edx
  8009a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b1:	e9 bc 00 00 00       	jmp    800a72 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bf:	50                   	push   %eax
  8009c0:	e8 84 fc ff ff       	call   800649 <getuint>
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d5:	e9 98 00 00 00       	jmp    800a72 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			break;
  800a0a:	e9 ce 00 00 00       	jmp    800add <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 30                	push   $0x30
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 78                	push   $0x78
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	83 c0 04             	add    $0x4,%eax
  800a35:	89 45 14             	mov    %eax,0x14(%ebp)
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	83 e8 04             	sub    $0x4,%eax
  800a3e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a51:	eb 1f                	jmp    800a72 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 e8             	pushl  -0x18(%ebp)
  800a59:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5c:	50                   	push   %eax
  800a5d:	e8 e7 fb ff ff       	call   800649 <getuint>
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a72:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a79:	83 ec 04             	sub    $0x4,%esp
  800a7c:	52                   	push   %edx
  800a7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a80:	50                   	push   %eax
  800a81:	ff 75 f4             	pushl  -0xc(%ebp)
  800a84:	ff 75 f0             	pushl  -0x10(%ebp)
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 00 fb ff ff       	call   800592 <printnum>
  800a92:	83 c4 20             	add    $0x20,%esp
			break;
  800a95:	eb 46                	jmp    800add <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	53                   	push   %ebx
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			break;
  800aa6:	eb 35                	jmp    800add <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aaf:	eb 2c                	jmp    800add <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ab1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ab8:	eb 23                	jmp    800add <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 25                	push   $0x25
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aca:	ff 4d 10             	decl   0x10(%ebp)
  800acd:	eb 03                	jmp    800ad2 <vprintfmt+0x3c3>
  800acf:	ff 4d 10             	decl   0x10(%ebp)
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	48                   	dec    %eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	3c 25                	cmp    $0x25,%al
  800ada:	75 f3                	jne    800acf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800adc:	90                   	nop
		}
	}
  800add:	e9 35 fc ff ff       	jmp    800717 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af0:	8d 45 10             	lea    0x10(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af9:	8b 45 10             	mov    0x10(%ebp),%eax
  800afc:	ff 75 f4             	pushl  -0xc(%ebp)
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 04 fc ff ff       	call   80070f <vprintfmt>
  800b0b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0e:	90                   	nop
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 08             	mov    0x8(%eax),%eax
  800b1a:	8d 50 01             	lea    0x1(%eax),%edx
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8b 10                	mov    (%eax),%edx
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	8b 40 04             	mov    0x4(%eax),%eax
  800b2e:	39 c2                	cmp    %eax,%edx
  800b30:	73 12                	jae    800b44 <sprintputch+0x33>
		*b->buf++ = ch;
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3d:	89 0a                	mov    %ecx,(%edx)
  800b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b42:	88 10                	mov    %dl,(%eax)
}
  800b44:	90                   	nop
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	01 d0                	add    %edx,%eax
  800b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6c:	74 06                	je     800b74 <vsnprintf+0x2d>
  800b6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b72:	7f 07                	jg     800b7b <vsnprintf+0x34>
		return -E_INVAL;
  800b74:	b8 03 00 00 00       	mov    $0x3,%eax
  800b79:	eb 20                	jmp    800b9b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7b:	ff 75 14             	pushl  0x14(%ebp)
  800b7e:	ff 75 10             	pushl  0x10(%ebp)
  800b81:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b84:	50                   	push   %eax
  800b85:	68 11 0b 80 00       	push   $0x800b11
  800b8a:	e8 80 fb ff ff       	call   80070f <vprintfmt>
  800b8f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba6:	83 c0 04             	add    $0x4,%eax
  800ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
  800baf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb2:	50                   	push   %eax
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	ff 75 08             	pushl  0x8(%ebp)
  800bb9:	e8 89 ff ff ff       	call   800b47 <vsnprintf>
  800bbe:	83 c4 10             	add    $0x10,%esp
  800bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd6:	eb 06                	jmp    800bde <strlen+0x15>
		n++;
  800bd8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdb:	ff 45 08             	incl   0x8(%ebp)
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8a 00                	mov    (%eax),%al
  800be3:	84 c0                	test   %al,%al
  800be5:	75 f1                	jne    800bd8 <strlen+0xf>
		n++;
	return n;
  800be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 09                	jmp    800c04 <strnlen+0x18>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	ff 4d 0c             	decl   0xc(%ebp)
  800c04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c08:	74 09                	je     800c13 <strnlen+0x27>
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	84 c0                	test   %al,%al
  800c11:	75 e8                	jne    800bfb <strnlen+0xf>
		n++;
	return n;
  800c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c24:	90                   	nop
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8d 50 01             	lea    0x1(%eax),%edx
  800c2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c34:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c37:	8a 12                	mov    (%edx),%dl
  800c39:	88 10                	mov    %dl,(%eax)
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	84 c0                	test   %al,%al
  800c3f:	75 e4                	jne    800c25 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c59:	eb 1f                	jmp    800c7a <strncpy+0x34>
		*dst++ = *src;
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8d 50 01             	lea    0x1(%eax),%edx
  800c61:	89 55 08             	mov    %edx,0x8(%ebp)
  800c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c67:	8a 12                	mov    (%edx),%dl
  800c69:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	84 c0                	test   %al,%al
  800c72:	74 03                	je     800c77 <strncpy+0x31>
			src++;
  800c74:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c77:	ff 45 fc             	incl   -0x4(%ebp)
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c80:	72 d9                	jb     800c5b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c82:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c97:	74 30                	je     800cc9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c99:	eb 16                	jmp    800cb1 <strlcpy+0x2a>
			*dst++ = *src++;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ca1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800caa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cad:	8a 12                	mov    (%edx),%dl
  800caf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb1:	ff 4d 10             	decl   0x10(%ebp)
  800cb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb8:	74 09                	je     800cc3 <strlcpy+0x3c>
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 d8                	jne    800c9b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	c9                   	leave  
  800cd4:	c3                   	ret    

00800cd5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd8:	eb 06                	jmp    800ce0 <strcmp+0xb>
		p++, q++;
  800cda:	ff 45 08             	incl   0x8(%ebp)
  800cdd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	84 c0                	test   %al,%al
  800ce7:	74 0e                	je     800cf7 <strcmp+0x22>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 10                	mov    (%eax),%dl
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	38 c2                	cmp    %al,%dl
  800cf5:	74 e3                	je     800cda <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	0f b6 d0             	movzbl %al,%edx
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	0f b6 c0             	movzbl %al,%eax
  800d07:	29 c2                	sub    %eax,%edx
  800d09:	89 d0                	mov    %edx,%eax
}
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d10:	eb 09                	jmp    800d1b <strncmp+0xe>
		n--, p++, q++;
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1f:	74 17                	je     800d38 <strncmp+0x2b>
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	84 c0                	test   %al,%al
  800d28:	74 0e                	je     800d38 <strncmp+0x2b>
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 10                	mov    (%eax),%dl
  800d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	38 c2                	cmp    %al,%dl
  800d36:	74 da                	je     800d12 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3c:	75 07                	jne    800d45 <strncmp+0x38>
		return 0;
  800d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d43:	eb 14                	jmp    800d59 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	0f b6 d0             	movzbl %al,%edx
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 c0             	movzbl %al,%eax
  800d55:	29 c2                	sub    %eax,%edx
  800d57:	89 d0                	mov    %edx,%eax
}
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 04             	sub    $0x4,%esp
  800d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d64:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d67:	eb 12                	jmp    800d7b <strchr+0x20>
		if (*s == c)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d71:	75 05                	jne    800d78 <strchr+0x1d>
			return (char *) s;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	eb 11                	jmp    800d89 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d78:	ff 45 08             	incl   0x8(%ebp)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	75 e5                	jne    800d69 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d89:	c9                   	leave  
  800d8a:	c3                   	ret    

00800d8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d97:	eb 0d                	jmp    800da6 <strfind+0x1b>
		if (*s == c)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da1:	74 0e                	je     800db1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da3:	ff 45 08             	incl   0x8(%ebp)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	75 ea                	jne    800d99 <strfind+0xe>
  800daf:	eb 01                	jmp    800db2 <strfind+0x27>
		if (*s == c)
			break;
  800db1:	90                   	nop
	return (char *) s;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dc3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dc7:	76 63                	jbe    800e2c <memset+0x75>
		uint64 data_block = c;
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	99                   	cltd   
  800dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ddd:	c1 e0 08             	shl    $0x8,%eax
  800de0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800de3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dec:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800df0:	c1 e0 10             	shl    $0x10,%eax
  800df3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
  800e06:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e09:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e0c:	eb 18                	jmp    800e26 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e0e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e11:	8d 41 08             	lea    0x8(%ecx),%eax
  800e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1d:	89 01                	mov    %eax,(%ecx)
  800e1f:	89 51 04             	mov    %edx,0x4(%ecx)
  800e22:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e26:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e2a:	77 e2                	ja     800e0e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e30:	74 23                	je     800e55 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e38:	eb 0e                	jmp    800e48 <memset+0x91>
			*p8++ = (uint8)c;
  800e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3d:	8d 50 01             	lea    0x1(%eax),%edx
  800e40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e46:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e48:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	75 e5                	jne    800e3a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e6c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e70:	76 24                	jbe    800e96 <memcpy+0x3c>
		while(n >= 8){
  800e72:	eb 1c                	jmp    800e90 <memcpy+0x36>
			*d64 = *s64;
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e77:	8b 50 04             	mov    0x4(%eax),%edx
  800e7a:	8b 00                	mov    (%eax),%eax
  800e7c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e7f:	89 01                	mov    %eax,(%ecx)
  800e81:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e84:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e88:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e8c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e90:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e94:	77 de                	ja     800e74 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9a:	74 31                	je     800ecd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ea8:	eb 16                	jmp    800ec0 <memcpy+0x66>
			*d8++ = *s8++;
  800eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ead:	8d 50 01             	lea    0x1(%eax),%edx
  800eb0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ebc:	8a 12                	mov    (%edx),%dl
  800ebe:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	75 dd                	jne    800eaa <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	73 50                	jae    800f3c <memmove+0x6a>
  800eec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef2:	01 d0                	add    %edx,%eax
  800ef4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef7:	76 43                	jbe    800f3c <memmove+0x6a>
		s += n;
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f05:	eb 10                	jmp    800f17 <memmove+0x45>
			*--d = *--s;
  800f07:	ff 4d f8             	decl   -0x8(%ebp)
  800f0a:	ff 4d fc             	decl   -0x4(%ebp)
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	8a 10                	mov    (%eax),%dl
  800f12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f15:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	75 e3                	jne    800f07 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f24:	eb 23                	jmp    800f49 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f38:	8a 12                	mov    (%edx),%dl
  800f3a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f42:	89 55 10             	mov    %edx,0x10(%ebp)
  800f45:	85 c0                	test   %eax,%eax
  800f47:	75 dd                	jne    800f26 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f60:	eb 2a                	jmp    800f8c <memcmp+0x3e>
		if (*s1 != *s2)
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	8a 10                	mov    (%eax),%dl
  800f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	38 c2                	cmp    %al,%dl
  800f6e:	74 16                	je     800f86 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f b6 d0             	movzbl %al,%edx
  800f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	0f b6 c0             	movzbl %al,%eax
  800f80:	29 c2                	sub    %eax,%edx
  800f82:	89 d0                	mov    %edx,%eax
  800f84:	eb 18                	jmp    800f9e <memcmp+0x50>
		s1++, s2++;
  800f86:	ff 45 fc             	incl   -0x4(%ebp)
  800f89:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f92:	89 55 10             	mov    %edx,0x10(%ebp)
  800f95:	85 c0                	test   %eax,%eax
  800f97:	75 c9                	jne    800f62 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fb1:	eb 15                	jmp    800fc8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 d0             	movzbl %al,%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	0f b6 c0             	movzbl %al,%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	74 0d                	je     800fd2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fc5:	ff 45 08             	incl   0x8(%ebp)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fce:	72 e3                	jb     800fb3 <memfind+0x13>
  800fd0:	eb 01                	jmp    800fd3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fd2:	90                   	nop
	return (void *) s;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd6:	c9                   	leave  
  800fd7:	c3                   	ret    

00800fd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fe5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fec:	eb 03                	jmp    800ff1 <strtol+0x19>
		s++;
  800fee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 20                	cmp    $0x20,%al
  800ff8:	74 f4                	je     800fee <strtol+0x16>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 09                	cmp    $0x9,%al
  801001:	74 eb                	je     800fee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 2b                	cmp    $0x2b,%al
  80100a:	75 05                	jne    801011 <strtol+0x39>
		s++;
  80100c:	ff 45 08             	incl   0x8(%ebp)
  80100f:	eb 13                	jmp    801024 <strtol+0x4c>
	else if (*s == '-')
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 2d                	cmp    $0x2d,%al
  801018:	75 0a                	jne    801024 <strtol+0x4c>
		s++, neg = 1;
  80101a:	ff 45 08             	incl   0x8(%ebp)
  80101d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801028:	74 06                	je     801030 <strtol+0x58>
  80102a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80102e:	75 20                	jne    801050 <strtol+0x78>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 30                	cmp    $0x30,%al
  801037:	75 17                	jne    801050 <strtol+0x78>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	40                   	inc    %eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 78                	cmp    $0x78,%al
  801041:	75 0d                	jne    801050 <strtol+0x78>
		s += 2, base = 16;
  801043:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801047:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80104e:	eb 28                	jmp    801078 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	75 15                	jne    80106b <strtol+0x93>
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	3c 30                	cmp    $0x30,%al
  80105d:	75 0c                	jne    80106b <strtol+0x93>
		s++, base = 8;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801069:	eb 0d                	jmp    801078 <strtol+0xa0>
	else if (base == 0)
  80106b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106f:	75 07                	jne    801078 <strtol+0xa0>
		base = 10;
  801071:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	3c 2f                	cmp    $0x2f,%al
  80107f:	7e 19                	jle    80109a <strtol+0xc2>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	3c 39                	cmp    $0x39,%al
  801088:	7f 10                	jg     80109a <strtol+0xc2>
			dig = *s - '0';
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	0f be c0             	movsbl %al,%eax
  801092:	83 e8 30             	sub    $0x30,%eax
  801095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801098:	eb 42                	jmp    8010dc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3c 60                	cmp    $0x60,%al
  8010a1:	7e 19                	jle    8010bc <strtol+0xe4>
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 7a                	cmp    $0x7a,%al
  8010aa:	7f 10                	jg     8010bc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	0f be c0             	movsbl %al,%eax
  8010b4:	83 e8 57             	sub    $0x57,%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ba:	eb 20                	jmp    8010dc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	3c 40                	cmp    $0x40,%al
  8010c3:	7e 39                	jle    8010fe <strtol+0x126>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 5a                	cmp    $0x5a,%al
  8010cc:	7f 30                	jg     8010fe <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	0f be c0             	movsbl %al,%eax
  8010d6:	83 e8 37             	sub    $0x37,%eax
  8010d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010df:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e2:	7d 19                	jge    8010fd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ea:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f8:	e9 7b ff ff ff       	jmp    801078 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010fd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 08                	je     80110c <strtol+0x134>
		*endptr = (char *) s;
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80110c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801110:	74 07                	je     801119 <strtol+0x141>
  801112:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801115:	f7 d8                	neg    %eax
  801117:	eb 03                	jmp    80111c <strtol+0x144>
  801119:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <ltostr>:

void
ltostr(long value, char *str)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80112b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801136:	79 13                	jns    80114b <ltostr+0x2d>
	{
		neg = 1;
  801138:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801145:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801148:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801153:	99                   	cltd   
  801154:	f7 f9                	idiv   %ecx
  801156:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801159:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801162:	89 c2                	mov    %eax,%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80116c:	83 c2 30             	add    $0x30,%edx
  80116f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801174:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801179:	f7 e9                	imul   %ecx
  80117b:	c1 fa 02             	sar    $0x2,%edx
  80117e:	89 c8                	mov    %ecx,%eax
  801180:	c1 f8 1f             	sar    $0x1f,%eax
  801183:	29 c2                	sub    %eax,%edx
  801185:	89 d0                	mov    %edx,%eax
  801187:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80118a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118e:	75 bb                	jne    80114b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801190:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	48                   	dec    %eax
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80119e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a2:	74 3d                	je     8011e1 <ltostr+0xc3>
		start = 1 ;
  8011a4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ab:	eb 34                	jmp    8011e1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	01 c2                	add    %eax,%edx
  8011c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	01 c8                	add    %ecx,%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	01 c2                	add    %eax,%edx
  8011d6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d9:	88 02                	mov    %al,(%edx)
		start++ ;
  8011db:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011de:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e7:	7c c4                	jl     8011ad <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	01 d0                	add    %edx,%eax
  8011f1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f4:	90                   	nop
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	e8 c4 f9 ff ff       	call   800bc9 <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	e8 b6 f9 ff ff       	call   800bc9 <strlen>
  801213:	83 c4 04             	add    $0x4,%esp
  801216:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801219:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801220:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801227:	eb 17                	jmp    801240 <strcconcat+0x49>
		final[s] = str1[s] ;
  801229:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122c:	8b 45 10             	mov    0x10(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	01 c8                	add    %ecx,%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80123d:	ff 45 fc             	incl   -0x4(%ebp)
  801240:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801243:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801246:	7c e1                	jl     801229 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801248:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80124f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801256:	eb 1f                	jmp    801277 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801258:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125b:	8d 50 01             	lea    0x1(%eax),%edx
  80125e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801261:	89 c2                	mov    %eax,%edx
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	01 c2                	add    %eax,%edx
  801268:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	01 c8                	add    %ecx,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801274:	ff 45 f8             	incl   -0x8(%ebp)
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127d:	7c d9                	jl     801258 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80127f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	c6 00 00             	movb   $0x0,(%eax)
}
  80128a:	90                   	nop
  80128b:	c9                   	leave  
  80128c:	c3                   	ret    

0080128d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801290:	8b 45 14             	mov    0x14(%ebp),%eax
  801293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801299:	8b 45 14             	mov    0x14(%ebp),%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	eb 0c                	jmp    8012be <strsplit+0x31>
			*string++ = 0;
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8d 50 01             	lea    0x1(%eax),%edx
  8012b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	84 c0                	test   %al,%al
  8012c5:	74 18                	je     8012df <strsplit+0x52>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	0f be c0             	movsbl %al,%eax
  8012cf:	50                   	push   %eax
  8012d0:	ff 75 0c             	pushl  0xc(%ebp)
  8012d3:	e8 83 fa ff ff       	call   800d5b <strchr>
  8012d8:	83 c4 08             	add    $0x8,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	75 d3                	jne    8012b2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	84 c0                	test   %al,%al
  8012e6:	74 5a                	je     801342 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012eb:	8b 00                	mov    (%eax),%eax
  8012ed:	83 f8 0f             	cmp    $0xf,%eax
  8012f0:	75 07                	jne    8012f9 <strsplit+0x6c>
		{
			return 0;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f7:	eb 66                	jmp    80135f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fc:	8b 00                	mov    (%eax),%eax
  8012fe:	8d 48 01             	lea    0x1(%eax),%ecx
  801301:	8b 55 14             	mov    0x14(%ebp),%edx
  801304:	89 0a                	mov    %ecx,(%edx)
  801306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 c2                	add    %eax,%edx
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801317:	eb 03                	jmp    80131c <strsplit+0x8f>
			string++;
  801319:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	84 c0                	test   %al,%al
  801323:	74 8b                	je     8012b0 <strsplit+0x23>
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f be c0             	movsbl %al,%eax
  80132d:	50                   	push   %eax
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	e8 25 fa ff ff       	call   800d5b <strchr>
  801336:	83 c4 08             	add    $0x8,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	74 dc                	je     801319 <strsplit+0x8c>
			string++;
	}
  80133d:	e9 6e ff ff ff       	jmp    8012b0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801342:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	01 d0                	add    %edx,%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80136d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801374:	eb 4a                	jmp    8013c0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801376:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	01 c2                	add    %eax,%edx
  80137e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	01 c8                	add    %ecx,%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80138a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	3c 40                	cmp    $0x40,%al
  801396:	7e 25                	jle    8013bd <str2lower+0x5c>
  801398:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	3c 5a                	cmp    $0x5a,%al
  8013a4:	7f 17                	jg     8013bd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b4:	01 ca                	add    %ecx,%edx
  8013b6:	8a 12                	mov    (%edx),%dl
  8013b8:	83 c2 20             	add    $0x20,%edx
  8013bb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013bd:	ff 45 fc             	incl   -0x4(%ebp)
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	e8 01 f8 ff ff       	call   800bc9 <strlen>
  8013c8:	83 c4 04             	add    $0x4,%esp
  8013cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013ce:	7f a6                	jg     801376 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	57                   	push   %edi
  8013d9:	56                   	push   %esi
  8013da:	53                   	push   %ebx
  8013db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013f0:	cd 30                	int    $0x30
  8013f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	5b                   	pop    %ebx
  8013fc:	5e                   	pop    %esi
  8013fd:	5f                   	pop    %edi
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80140c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	6a 00                	push   $0x0
  801418:	51                   	push   %ecx
  801419:	52                   	push   %edx
  80141a:	ff 75 0c             	pushl  0xc(%ebp)
  80141d:	50                   	push   %eax
  80141e:	6a 00                	push   $0x0
  801420:	e8 b0 ff ff ff       	call   8013d5 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_cgetc>:

int
sys_cgetc(void)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 02                	push   $0x2
  80143a:	e8 96 ff ff ff       	call   8013d5 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 03                	push   $0x3
  801453:	e8 7d ff ff ff       	call   8013d5 <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	90                   	nop
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 04                	push   $0x4
  80146d:	e8 63 ff ff ff       	call   8013d5 <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	90                   	nop
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	52                   	push   %edx
  801488:	50                   	push   %eax
  801489:	6a 08                	push   $0x8
  80148b:	e8 45 ff ff ff       	call   8013d5 <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	56                   	push   %esi
  801499:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80149a:	8b 75 18             	mov    0x18(%ebp),%esi
  80149d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	56                   	push   %esi
  8014aa:	53                   	push   %ebx
  8014ab:	51                   	push   %ecx
  8014ac:	52                   	push   %edx
  8014ad:	50                   	push   %eax
  8014ae:	6a 09                	push   $0x9
  8014b0:	e8 20 ff ff ff       	call   8013d5 <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    

008014bf <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	ff 75 08             	pushl  0x8(%ebp)
  8014cd:	6a 0a                	push   $0xa
  8014cf:	e8 01 ff ff ff       	call   8013d5 <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	ff 75 0c             	pushl  0xc(%ebp)
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	6a 0b                	push   $0xb
  8014ea:	e8 e6 fe ff ff       	call   8013d5 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 0c                	push   $0xc
  801503:	e8 cd fe ff ff       	call   8013d5 <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 0d                	push   $0xd
  80151c:	e8 b4 fe ff ff       	call   8013d5 <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 0e                	push   $0xe
  801535:	e8 9b fe ff ff       	call   8013d5 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 0f                	push   $0xf
  80154e:	e8 82 fe ff ff       	call   8013d5 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	ff 75 08             	pushl  0x8(%ebp)
  801566:	6a 10                	push   $0x10
  801568:	e8 68 fe ff ff       	call   8013d5 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 11                	push   $0x11
  801581:	e8 4f fe ff ff       	call   8013d5 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
}
  801589:	90                   	nop
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_cputc>:

void
sys_cputc(const char c)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 04             	sub    $0x4,%esp
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801598:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	50                   	push   %eax
  8015a5:	6a 01                	push   $0x1
  8015a7:	e8 29 fe ff ff       	call   8013d5 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	90                   	nop
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 14                	push   $0x14
  8015c1:	e8 0f fe ff ff       	call   8013d5 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	90                   	nop
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	51                   	push   %ecx
  8015e5:	52                   	push   %edx
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	50                   	push   %eax
  8015ea:	6a 15                	push   $0x15
  8015ec:	e8 e4 fd ff ff       	call   8013d5 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	52                   	push   %edx
  801606:	50                   	push   %eax
  801607:	6a 16                	push   $0x16
  801609:	e8 c7 fd ff ff       	call   8013d5 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801616:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	51                   	push   %ecx
  801624:	52                   	push   %edx
  801625:	50                   	push   %eax
  801626:	6a 17                	push   $0x17
  801628:	e8 a8 fd ff ff       	call   8013d5 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	52                   	push   %edx
  801642:	50                   	push   %eax
  801643:	6a 18                	push   $0x18
  801645:	e8 8b fd ff ff       	call   8013d5 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	6a 00                	push   $0x0
  801657:	ff 75 14             	pushl  0x14(%ebp)
  80165a:	ff 75 10             	pushl  0x10(%ebp)
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	50                   	push   %eax
  801661:	6a 19                	push   $0x19
  801663:	e8 6d fd ff ff       	call   8013d5 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	50                   	push   %eax
  80167c:	6a 1a                	push   $0x1a
  80167e:	e8 52 fd ff ff       	call   8013d5 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	50                   	push   %eax
  801698:	6a 1b                	push   $0x1b
  80169a:	e8 36 fd ff ff       	call   8013d5 <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 05                	push   $0x5
  8016b3:	e8 1d fd ff ff       	call   8013d5 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 06                	push   $0x6
  8016cc:	e8 04 fd ff ff       	call   8013d5 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 07                	push   $0x7
  8016e5:	e8 eb fc ff ff       	call   8013d5 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_exit_env>:


void sys_exit_env(void)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 1c                	push   $0x1c
  8016fe:	e8 d2 fc ff ff       	call   8013d5 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	90                   	nop
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80170f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801712:	8d 50 04             	lea    0x4(%eax),%edx
  801715:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	52                   	push   %edx
  80171f:	50                   	push   %eax
  801720:	6a 1d                	push   $0x1d
  801722:	e8 ae fc ff ff       	call   8013d5 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
	return result;
  80172a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801730:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801733:	89 01                	mov    %eax,(%ecx)
  801735:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	c9                   	leave  
  80173c:	c2 04 00             	ret    $0x4

0080173f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	ff 75 10             	pushl  0x10(%ebp)
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	6a 13                	push   $0x13
  801751:	e8 7f fc ff ff       	call   8013d5 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
	return ;
  801759:	90                   	nop
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_rcr2>:
uint32 sys_rcr2()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 1e                	push   $0x1e
  80176b:	e8 65 fc ff ff       	call   8013d5 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801781:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	50                   	push   %eax
  80178e:	6a 1f                	push   $0x1f
  801790:	e8 40 fc ff ff       	call   8013d5 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
	return ;
  801798:	90                   	nop
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <rsttst>:
void rsttst()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 21                	push   $0x21
  8017aa:	e8 26 fc ff ff       	call   8013d5 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b2:	90                   	nop
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8017c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 10             	pushl  0x10(%ebp)
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 20                	push   $0x20
  8017d5:	e8 fb fb ff ff       	call   8013d5 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <chktst>:
void chktst(uint32 n)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	ff 75 08             	pushl  0x8(%ebp)
  8017ee:	6a 22                	push   $0x22
  8017f0:	e8 e0 fb ff ff       	call   8013d5 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f8:	90                   	nop
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <inctst>:

void inctst()
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 23                	push   $0x23
  80180a:	e8 c6 fb ff ff       	call   8013d5 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <gettst>:
uint32 gettst()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 24                	push   $0x24
  801824:	e8 ac fb ff ff       	call   8013d5 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 25                	push   $0x25
  80183d:	e8 93 fb ff ff       	call   8013d5 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
  801845:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80184a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	ff 75 08             	pushl  0x8(%ebp)
  801867:	6a 26                	push   $0x26
  801869:	e8 67 fb ff ff       	call   8013d5 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
	return ;
  801871:	90                   	nop
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801878:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	53                   	push   %ebx
  801887:	51                   	push   %ecx
  801888:	52                   	push   %edx
  801889:	50                   	push   %eax
  80188a:	6a 27                	push   $0x27
  80188c:	e8 44 fb ff ff       	call   8013d5 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 28                	push   $0x28
  8018ac:	e8 24 fb ff ff       	call   8013d5 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	51                   	push   %ecx
  8018c5:	ff 75 10             	pushl  0x10(%ebp)
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 29                	push   $0x29
  8018cc:	e8 04 fb ff ff       	call   8013d5 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	ff 75 10             	pushl  0x10(%ebp)
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	ff 75 08             	pushl  0x8(%ebp)
  8018e6:	6a 12                	push   $0x12
  8018e8:	e8 e8 fa ff ff       	call   8013d5 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 2a                	push   $0x2a
  801906:	e8 ca fa ff ff       	call   8013d5 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
	return;
  80190e:	90                   	nop
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 2b                	push   $0x2b
  801920:	e8 b0 fa ff ff       	call   8013d5 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 2d                	push   $0x2d
  80193b:	e8 95 fa ff ff       	call   8013d5 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	ff 75 08             	pushl  0x8(%ebp)
  801955:	6a 2c                	push   $0x2c
  801957:	e8 79 fa ff ff       	call   8013d5 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801965:	8b 55 0c             	mov    0xc(%ebp),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 2e                	push   $0x2e
  801975:	e8 5b fa ff ff       	call   8013d5 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <__udivdi3>:
  801980:	55                   	push   %ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80198b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80198f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801993:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801997:	89 ca                	mov    %ecx,%edx
  801999:	89 f8                	mov    %edi,%eax
  80199b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80199f:	85 f6                	test   %esi,%esi
  8019a1:	75 2d                	jne    8019d0 <__udivdi3+0x50>
  8019a3:	39 cf                	cmp    %ecx,%edi
  8019a5:	77 65                	ja     801a0c <__udivdi3+0x8c>
  8019a7:	89 fd                	mov    %edi,%ebp
  8019a9:	85 ff                	test   %edi,%edi
  8019ab:	75 0b                	jne    8019b8 <__udivdi3+0x38>
  8019ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b2:	31 d2                	xor    %edx,%edx
  8019b4:	f7 f7                	div    %edi
  8019b6:	89 c5                	mov    %eax,%ebp
  8019b8:	31 d2                	xor    %edx,%edx
  8019ba:	89 c8                	mov    %ecx,%eax
  8019bc:	f7 f5                	div    %ebp
  8019be:	89 c1                	mov    %eax,%ecx
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	f7 f5                	div    %ebp
  8019c4:	89 cf                	mov    %ecx,%edi
  8019c6:	89 fa                	mov    %edi,%edx
  8019c8:	83 c4 1c             	add    $0x1c,%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5f                   	pop    %edi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	77 28                	ja     8019fc <__udivdi3+0x7c>
  8019d4:	0f bd fe             	bsr    %esi,%edi
  8019d7:	83 f7 1f             	xor    $0x1f,%edi
  8019da:	75 40                	jne    801a1c <__udivdi3+0x9c>
  8019dc:	39 ce                	cmp    %ecx,%esi
  8019de:	72 0a                	jb     8019ea <__udivdi3+0x6a>
  8019e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019e4:	0f 87 9e 00 00 00    	ja     801a88 <__udivdi3+0x108>
  8019ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ef:	89 fa                	mov    %edi,%edx
  8019f1:	83 c4 1c             	add    $0x1c,%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5f                   	pop    %edi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
  8019f9:	8d 76 00             	lea    0x0(%esi),%esi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	31 c0                	xor    %eax,%eax
  801a00:	89 fa                	mov    %edi,%edx
  801a02:	83 c4 1c             	add    $0x1c,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5f                   	pop    %edi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	f7 f7                	div    %edi
  801a10:	31 ff                	xor    %edi,%edi
  801a12:	89 fa                	mov    %edi,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a21:	89 eb                	mov    %ebp,%ebx
  801a23:	29 fb                	sub    %edi,%ebx
  801a25:	89 f9                	mov    %edi,%ecx
  801a27:	d3 e6                	shl    %cl,%esi
  801a29:	89 c5                	mov    %eax,%ebp
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ed                	shr    %cl,%ebp
  801a2f:	89 e9                	mov    %ebp,%ecx
  801a31:	09 f1                	or     %esi,%ecx
  801a33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e0                	shl    %cl,%eax
  801a3b:	89 c5                	mov    %eax,%ebp
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 ee                	shr    %cl,%esi
  801a43:	89 f9                	mov    %edi,%ecx
  801a45:	d3 e2                	shl    %cl,%edx
  801a47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 e8                	shr    %cl,%eax
  801a4f:	09 c2                	or     %eax,%edx
  801a51:	89 d0                	mov    %edx,%eax
  801a53:	89 f2                	mov    %esi,%edx
  801a55:	f7 74 24 0c          	divl   0xc(%esp)
  801a59:	89 d6                	mov    %edx,%esi
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	f7 e5                	mul    %ebp
  801a5f:	39 d6                	cmp    %edx,%esi
  801a61:	72 19                	jb     801a7c <__udivdi3+0xfc>
  801a63:	74 0b                	je     801a70 <__udivdi3+0xf0>
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	31 ff                	xor    %edi,%edi
  801a69:	e9 58 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a74:	89 f9                	mov    %edi,%ecx
  801a76:	d3 e2                	shl    %cl,%edx
  801a78:	39 c2                	cmp    %eax,%edx
  801a7a:	73 e9                	jae    801a65 <__udivdi3+0xe5>
  801a7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a7f:	31 ff                	xor    %edi,%edi
  801a81:	e9 40 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	31 c0                	xor    %eax,%eax
  801a8a:	e9 37 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a8f:	90                   	nop

00801a90 <__umoddi3>:
  801a90:	55                   	push   %ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aaf:	89 f3                	mov    %esi,%ebx
  801ab1:	89 fa                	mov    %edi,%edx
  801ab3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab7:	89 34 24             	mov    %esi,(%esp)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	75 1a                	jne    801ad8 <__umoddi3+0x48>
  801abe:	39 f7                	cmp    %esi,%edi
  801ac0:	0f 86 a2 00 00 00    	jbe    801b68 <__umoddi3+0xd8>
  801ac6:	89 c8                	mov    %ecx,%eax
  801ac8:	89 f2                	mov    %esi,%edx
  801aca:	f7 f7                	div    %edi
  801acc:	89 d0                	mov    %edx,%eax
  801ace:	31 d2                	xor    %edx,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	39 f0                	cmp    %esi,%eax
  801ada:	0f 87 ac 00 00 00    	ja     801b8c <__umoddi3+0xfc>
  801ae0:	0f bd e8             	bsr    %eax,%ebp
  801ae3:	83 f5 1f             	xor    $0x1f,%ebp
  801ae6:	0f 84 ac 00 00 00    	je     801b98 <__umoddi3+0x108>
  801aec:	bf 20 00 00 00       	mov    $0x20,%edi
  801af1:	29 ef                	sub    %ebp,%edi
  801af3:	89 fe                	mov    %edi,%esi
  801af5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e0                	shl    %cl,%eax
  801afd:	89 d7                	mov    %edx,%edi
  801aff:	89 f1                	mov    %esi,%ecx
  801b01:	d3 ef                	shr    %cl,%edi
  801b03:	09 c7                	or     %eax,%edi
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 e2                	shl    %cl,%edx
  801b09:	89 14 24             	mov    %edx,(%esp)
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b16:	d3 e0                	shl    %cl,%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b20:	89 f1                	mov    %esi,%ecx
  801b22:	d3 e8                	shr    %cl,%eax
  801b24:	09 d0                	or     %edx,%eax
  801b26:	d3 eb                	shr    %cl,%ebx
  801b28:	89 da                	mov    %ebx,%edx
  801b2a:	f7 f7                	div    %edi
  801b2c:	89 d3                	mov    %edx,%ebx
  801b2e:	f7 24 24             	mull   (%esp)
  801b31:	89 c6                	mov    %eax,%esi
  801b33:	89 d1                	mov    %edx,%ecx
  801b35:	39 d3                	cmp    %edx,%ebx
  801b37:	0f 82 87 00 00 00    	jb     801bc4 <__umoddi3+0x134>
  801b3d:	0f 84 91 00 00 00    	je     801bd4 <__umoddi3+0x144>
  801b43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b47:	29 f2                	sub    %esi,%edx
  801b49:	19 cb                	sbb    %ecx,%ebx
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b51:	d3 e0                	shl    %cl,%eax
  801b53:	89 e9                	mov    %ebp,%ecx
  801b55:	d3 ea                	shr    %cl,%edx
  801b57:	09 d0                	or     %edx,%eax
  801b59:	89 e9                	mov    %ebp,%ecx
  801b5b:	d3 eb                	shr    %cl,%ebx
  801b5d:	89 da                	mov    %ebx,%edx
  801b5f:	83 c4 1c             	add    $0x1c,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    
  801b67:	90                   	nop
  801b68:	89 fd                	mov    %edi,%ebp
  801b6a:	85 ff                	test   %edi,%edi
  801b6c:	75 0b                	jne    801b79 <__umoddi3+0xe9>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f7                	div    %edi
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	89 f0                	mov    %esi,%eax
  801b7b:	31 d2                	xor    %edx,%edx
  801b7d:	f7 f5                	div    %ebp
  801b7f:	89 c8                	mov    %ecx,%eax
  801b81:	f7 f5                	div    %ebp
  801b83:	89 d0                	mov    %edx,%eax
  801b85:	e9 44 ff ff ff       	jmp    801ace <__umoddi3+0x3e>
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	89 c8                	mov    %ecx,%eax
  801b8e:	89 f2                	mov    %esi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	3b 04 24             	cmp    (%esp),%eax
  801b9b:	72 06                	jb     801ba3 <__umoddi3+0x113>
  801b9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ba1:	77 0f                	ja     801bb2 <__umoddi3+0x122>
  801ba3:	89 f2                	mov    %esi,%edx
  801ba5:	29 f9                	sub    %edi,%ecx
  801ba7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bab:	89 14 24             	mov    %edx,(%esp)
  801bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bb6:	8b 14 24             	mov    (%esp),%edx
  801bb9:	83 c4 1c             	add    $0x1c,%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    
  801bc1:	8d 76 00             	lea    0x0(%esi),%esi
  801bc4:	2b 04 24             	sub    (%esp),%eax
  801bc7:	19 fa                	sbb    %edi,%edx
  801bc9:	89 d1                	mov    %edx,%ecx
  801bcb:	89 c6                	mov    %eax,%esi
  801bcd:	e9 71 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd8:	72 ea                	jb     801bc4 <__umoddi3+0x134>
  801bda:	89 d9                	mov    %ebx,%ecx
  801bdc:	e9 62 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
