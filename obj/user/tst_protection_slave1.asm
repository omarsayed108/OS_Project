
obj/user/tst_protection_slave1:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 58 4e 00 00    	sub    $0x4e58,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800041:	a1 20 50 80 00       	mov    0x805020,%eax
  800046:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800057:	39 c2                	cmp    %eax,%edx
  800059:	72 14                	jb     80006f <_main+0x37>
			panic("Please increase the WS size");
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	68 00 37 80 00       	push   $0x803700
  800063:	6a 12                	push   $0x12
  800065:	68 1c 37 80 00       	push   $0x80371c
  80006a:	e8 79 02 00 00       	call   8002e8 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	{
		char initname[10] = "x";
  80006f:	c7 45 e6 78 00 00 00 	movl   $0x78,-0x1a(%ebp)
  800076:	c7 45 ea 00 00 00 00 	movl   $0x0,-0x16(%ebp)
  80007d:	66 c7 45 ee 00 00    	movw   $0x0,-0x12(%ebp)
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80008a:	eb 5d                	jmp    8000e9 <_main+0xb1>
		{
			char index[10];
			ltostr(s, index);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  800092:	50                   	push   %eax
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 69 11 00 00       	call   801204 <ltostr>
  80009b:	83 c4 10             	add    $0x10,%esp
			strcconcat(initname, index, name);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8000ac:	50                   	push   %eax
  8000ad:	e8 2b 12 00 00       	call   8012dd <strcconcat>
  8000b2:	83 c4 10             	add    $0x10,%esp
			vars[s] = smalloc(name, PAGE_SIZE, 1);
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	6a 01                	push   $0x1
  8000ba:	68 00 10 00 00       	push   $0x1000
  8000bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000c2:	50                   	push   %eax
  8000c3:	e8 f9 1d 00 00       	call   801ec1 <smalloc>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	89 c2                	mov    %eax,%edx
  8000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d0:	89 94 85 b0 b1 ff ff 	mov    %edx,-0x4e50(%ebp,%eax,4)
			*vars[s] = s;
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  8000e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e4:	89 10                	mov    %edx,(%eax)
	{
		char initname[10] = "x";
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
  8000f0:	7e 9a                	jle    80008c <_main+0x54>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f9:	eb 2c                	jmp    800127 <_main+0xef>
		{
			assert(*vars[s] == s);
  8000fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000fe:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  800105:	8b 10                	mov    (%eax),%edx
  800107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010a:	39 c2                	cmp    %eax,%edx
  80010c:	74 16                	je     800124 <_main+0xec>
  80010e:	68 39 37 80 00       	push   $0x803739
  800113:	68 47 37 80 00       	push   $0x803747
  800118:	6a 28                	push   $0x28
  80011a:	68 1c 37 80 00       	push   $0x80371c
  80011f:	e8 c4 01 00 00       	call   8002e8 <_panic>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800124:	ff 45 f0             	incl   -0x10(%ebp)
  800127:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
  80012e:	7e cb                	jle    8000fb <_main+0xc3>
		{
			assert(*vars[s] == s);
		}
	}

	inctst();
  800130:	e8 b4 24 00 00       	call   8025e9 <inctst>
}
  800135:	90                   	nop
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800141:	e8 65 23 00 00       	call   8024ab <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	01 c0                	add    %eax,%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	c1 e0 02             	shl    $0x2,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	c1 e0 02             	shl    $0x2,%eax
  80015a:	01 d0                	add    %edx,%eax
  80015c:	c1 e0 03             	shl    $0x3,%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	c1 e0 02             	shl    $0x2,%eax
  800164:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800169:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016e:	a1 20 50 80 00       	mov    0x805020,%eax
  800173:	8a 40 20             	mov    0x20(%eax),%al
  800176:	84 c0                	test   %al,%al
  800178:	74 0d                	je     800187 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80017a:	a1 20 50 80 00       	mov    0x805020,%eax
  80017f:	83 c0 20             	add    $0x20,%eax
  800182:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018b:	7e 0a                	jle    800197 <libmain+0x5f>
		binaryname = argv[0];
  80018d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	e8 93 fe ff ff       	call   800038 <_main>
  8001a5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a8:	a1 00 50 80 00       	mov    0x805000,%eax
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	0f 84 01 01 00 00    	je     8002b6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bb:	bb 54 38 80 00       	mov    $0x803854,%ebx
  8001c0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001cd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d5:	b0 00                	mov    $0x0,%al
  8001d7:	89 d7                	mov    %edx,%edi
  8001d9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	50                   	push   %eax
  8001e9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 ec 24 00 00       	call   8026e1 <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 35 20 00 00       	call   802232 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 74 37 80 00       	push   $0x803774
  800205:	e8 cc 03 00 00       	call   8005d6 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 e6 24 00 00       	call   8026ff <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 9c 37 80 00       	push   $0x80379c
  800222:	e8 af 03 00 00       	call   8005d6 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	eb 59                	jmp    800285 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022c:	a1 20 50 80 00       	mov    0x805020,%eax
  800231:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800237:	a1 20 50 80 00       	mov    0x805020,%eax
  80023c:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 c0 37 80 00       	push   $0x8037c0
  80024c:	e8 85 03 00 00       	call   8005d6 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800254:	a1 20 50 80 00       	mov    0x805020,%eax
  800259:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80026a:	a1 20 50 80 00       	mov    0x805020,%eax
  80026f:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800275:	51                   	push   %ecx
  800276:	52                   	push   %edx
  800277:	50                   	push   %eax
  800278:	68 e8 37 80 00       	push   $0x8037e8
  80027d:	e8 54 03 00 00       	call   8005d6 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 50 80 00       	mov    0x805020,%eax
  80028a:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 40 38 80 00       	push   $0x803840
  800299:	e8 38 03 00 00       	call   8005d6 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 74 37 80 00       	push   $0x803774
  8002a9:	e8 28 03 00 00       	call   8005d6 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 96 1f 00 00       	call   80224c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b6:	e8 1f 00 00 00       	call   8002da <exit>
}
  8002bb:	90                   	nop
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 a3 21 00 00       	call   802477 <sys_destroy_env>
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <exit>:

void
exit(void)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e0:	e8 f8 21 00 00       	call   8024dd <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f1:	83 c0 04             	add    $0x4,%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f7:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	74 16                	je     800316 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800300:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	50                   	push   %eax
  800309:	68 b8 38 80 00       	push   $0x8038b8
  80030e:	e8 c3 02 00 00       	call   8005d6 <cprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800316:	a1 04 50 80 00       	mov    0x805004,%eax
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	50                   	push   %eax
  800325:	68 c0 38 80 00       	push   $0x8038c0
  80032a:	6a 74                	push   $0x74
  80032c:	e8 d2 02 00 00       	call   800603 <cprintf_colored>
  800331:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	ff 75 f4             	pushl  -0xc(%ebp)
  80033d:	50                   	push   %eax
  80033e:	e8 24 02 00 00       	call   800567 <vcprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	6a 00                	push   $0x0
  80034b:	68 e8 38 80 00       	push   $0x8038e8
  800350:	e8 12 02 00 00       	call   800567 <vcprintf>
  800355:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800358:	e8 7d ff ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  80035d:	eb fe                	jmp    80035d <_panic+0x75>

0080035f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	53                   	push   %ebx
  800363:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800366:	a1 20 50 80 00       	mov    0x805020,%eax
  80036b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800371:	8b 45 0c             	mov    0xc(%ebp),%eax
  800374:	39 c2                	cmp    %eax,%edx
  800376:	74 14                	je     80038c <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 ec 38 80 00       	push   $0x8038ec
  800380:	6a 26                	push   $0x26
  800382:	68 38 39 80 00       	push   $0x803938
  800387:	e8 5c ff ff ff       	call   8002e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80038c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80039a:	e9 d9 00 00 00       	jmp    800478 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	01 d0                	add    %edx,%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	75 08                	jne    8003bc <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003b4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b7:	e9 b9 00 00 00       	jmp    800475 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ca:	eb 79                	jmp    800445 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d1:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003e7:	01 d8                	add    %ebx,%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	8a 40 04             	mov    0x4(%eax),%al
  8003f0:	84 c0                	test   %al,%al
  8003f2:	75 4e                	jne    800442 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f9:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800402:	89 d0                	mov    %edx,%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	01 d0                	add    %edx,%eax
  800408:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80040f:	01 d8                	add    %ebx,%eax
  800411:	01 d0                	add    %edx,%eax
  800413:	01 c8                	add    %ecx,%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80041a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800422:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800427:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	01 c8                	add    %ecx,%eax
  800433:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800435:	39 c2                	cmp    %eax,%edx
  800437:	75 09                	jne    800442 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800439:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800440:	eb 19                	jmp    80045b <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800442:	ff 45 e8             	incl   -0x18(%ebp)
  800445:	a1 20 50 80 00       	mov    0x805020,%eax
  80044a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800453:	39 c2                	cmp    %eax,%edx
  800455:	0f 87 71 ff ff ff    	ja     8003cc <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80045b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80045f:	75 14                	jne    800475 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800461:	83 ec 04             	sub    $0x4,%esp
  800464:	68 44 39 80 00       	push   $0x803944
  800469:	6a 3a                	push   $0x3a
  80046b:	68 38 39 80 00       	push   $0x803938
  800470:	e8 73 fe ff ff       	call   8002e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800475:	ff 45 f0             	incl   -0x10(%ebp)
  800478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80047e:	0f 8c 1b ff ff ff    	jl     80039f <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800484:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800492:	eb 2e                	jmp    8004c2 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80049f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a2:	89 d0                	mov    %edx,%eax
  8004a4:	01 c0                	add    %eax,%eax
  8004a6:	01 d0                	add    %edx,%eax
  8004a8:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004af:	01 d8                	add    %ebx,%eax
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	01 c8                	add    %ecx,%eax
  8004b5:	8a 40 04             	mov    0x4(%eax),%al
  8004b8:	3c 01                	cmp    $0x1,%al
  8004ba:	75 03                	jne    8004bf <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004bc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e0             	incl   -0x20(%ebp)
  8004c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d0:	39 c2                	cmp    %eax,%edx
  8004d2:	77 c0                	ja     800494 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004da:	74 14                	je     8004f0 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004dc:	83 ec 04             	sub    $0x4,%esp
  8004df:	68 98 39 80 00       	push   $0x803998
  8004e4:	6a 44                	push   $0x44
  8004e6:	68 38 39 80 00       	push   $0x803938
  8004eb:	e8 f8 fd ff ff       	call   8002e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f0:	90                   	nop
  8004f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    

008004f6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	8d 48 01             	lea    0x1(%eax),%ecx
  800505:	8b 55 0c             	mov    0xc(%ebp),%edx
  800508:	89 0a                	mov    %ecx,(%edx)
  80050a:	8b 55 08             	mov    0x8(%ebp),%edx
  80050d:	88 d1                	mov    %dl,%cl
  80050f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800512:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800516:	8b 45 0c             	mov    0xc(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800520:	75 30                	jne    800552 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800522:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800528:	a0 44 50 80 00       	mov    0x805044,%al
  80052d:	0f b6 c0             	movzbl %al,%eax
  800530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800533:	8b 09                	mov    (%ecx),%ecx
  800535:	89 cb                	mov    %ecx,%ebx
  800537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80053a:	83 c1 08             	add    $0x8,%ecx
  80053d:	52                   	push   %edx
  80053e:	50                   	push   %eax
  80053f:	53                   	push   %ebx
  800540:	51                   	push   %ecx
  800541:	e8 a8 1c 00 00       	call   8021ee <sys_cputs>
  800546:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800552:	8b 45 0c             	mov    0xc(%ebp),%eax
  800555:	8b 40 04             	mov    0x4(%eax),%eax
  800558:	8d 50 01             	lea    0x1(%eax),%edx
  80055b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800561:	90                   	nop
  800562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800570:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800577:	00 00 00 
	b.cnt = 0;
  80057a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800581:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	ff 75 08             	pushl  0x8(%ebp)
  80058a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800590:	50                   	push   %eax
  800591:	68 f6 04 80 00       	push   $0x8004f6
  800596:	e8 5a 02 00 00       	call   8007f5 <vprintfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80059e:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8005a4:	a0 44 50 80 00       	mov    0x805044,%al
  8005a9:	0f b6 c0             	movzbl %al,%eax
  8005ac:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005b2:	52                   	push   %edx
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bb:	83 c0 08             	add    $0x8,%eax
  8005be:	50                   	push   %eax
  8005bf:	e8 2a 1c 00 00       	call   8021ee <sys_cputs>
  8005c4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c7:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005dc:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f2:	50                   	push   %eax
  8005f3:	e8 6f ff ff ff       	call   800567 <vcprintf>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800609:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	c1 e0 08             	shl    $0x8,%eax
  800616:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  80061b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061e:	83 c0 04             	add    $0x4,%eax
  800621:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800624:	8b 45 0c             	mov    0xc(%ebp),%eax
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 f4             	pushl  -0xc(%ebp)
  80062d:	50                   	push   %eax
  80062e:	e8 34 ff ff ff       	call   800567 <vcprintf>
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800639:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800640:	07 00 00 

	return cnt;
  800643:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800646:	c9                   	leave  
  800647:	c3                   	ret    

00800648 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80064e:	e8 df 1b 00 00       	call   802232 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800653:	8d 45 0c             	lea    0xc(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	ff 75 f4             	pushl  -0xc(%ebp)
  800662:	50                   	push   %eax
  800663:	e8 ff fe ff ff       	call   800567 <vcprintf>
  800668:	83 c4 10             	add    $0x10,%esp
  80066b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80066e:	e8 d9 1b 00 00       	call   80224c <sys_unlock_cons>
	return cnt;
  800673:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800676:	c9                   	leave  
  800677:	c3                   	ret    

00800678 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	53                   	push   %ebx
  80067c:	83 ec 14             	sub    $0x14,%esp
  80067f:	8b 45 10             	mov    0x10(%ebp),%eax
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068b:	8b 45 18             	mov    0x18(%ebp),%eax
  80068e:	ba 00 00 00 00       	mov    $0x0,%edx
  800693:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800696:	77 55                	ja     8006ed <printnum+0x75>
  800698:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069b:	72 05                	jb     8006a2 <printnum+0x2a>
  80069d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a0:	77 4b                	ja     8006ed <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a8:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	52                   	push   %edx
  8006b1:	50                   	push   %eax
  8006b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b8:	e8 d3 2d 00 00       	call   803490 <__udivdi3>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	83 ec 04             	sub    $0x4,%esp
  8006c3:	ff 75 20             	pushl  0x20(%ebp)
  8006c6:	53                   	push   %ebx
  8006c7:	ff 75 18             	pushl  0x18(%ebp)
  8006ca:	52                   	push   %edx
  8006cb:	50                   	push   %eax
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 08             	pushl  0x8(%ebp)
  8006d2:	e8 a1 ff ff ff       	call   800678 <printnum>
  8006d7:	83 c4 20             	add    $0x20,%esp
  8006da:	eb 1a                	jmp    8006f6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	ff 75 20             	pushl  0x20(%ebp)
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	ff d0                	call   *%eax
  8006ea:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ed:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f4:	7f e6                	jg     8006dc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800704:	53                   	push   %ebx
  800705:	51                   	push   %ecx
  800706:	52                   	push   %edx
  800707:	50                   	push   %eax
  800708:	e8 93 2e 00 00       	call   8035a0 <__umoddi3>
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	05 14 3c 80 00       	add    $0x803c14,%eax
  800715:	8a 00                	mov    (%eax),%al
  800717:	0f be c0             	movsbl %al,%eax
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	50                   	push   %eax
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
}
  800729:	90                   	nop
  80072a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800732:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800736:	7e 1c                	jle    800754 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	8d 50 08             	lea    0x8(%eax),%edx
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	89 10                	mov    %edx,(%eax)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	83 e8 08             	sub    $0x8,%eax
  80074d:	8b 50 04             	mov    0x4(%eax),%edx
  800750:	8b 00                	mov    (%eax),%eax
  800752:	eb 40                	jmp    800794 <getuint+0x65>
	else if (lflag)
  800754:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800758:	74 1e                	je     800778 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	8d 50 04             	lea    0x4(%eax),%edx
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	89 10                	mov    %edx,(%eax)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	83 e8 04             	sub    $0x4,%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	ba 00 00 00 00       	mov    $0x0,%edx
  800776:	eb 1c                	jmp    800794 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	8d 50 04             	lea    0x4(%eax),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	89 10                	mov    %edx,(%eax)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	83 e8 04             	sub    $0x4,%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800799:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079d:	7e 1c                	jle    8007bb <getint+0x25>
		return va_arg(*ap, long long);
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	8d 50 08             	lea    0x8(%eax),%edx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 10                	mov    %edx,(%eax)
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	83 e8 08             	sub    $0x8,%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	eb 38                	jmp    8007f3 <getint+0x5d>
	else if (lflag)
  8007bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007bf:	74 1a                	je     8007db <getint+0x45>
		return va_arg(*ap, long);
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	8d 50 04             	lea    0x4(%eax),%edx
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	89 10                	mov    %edx,(%eax)
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	99                   	cltd   
  8007d9:	eb 18                	jmp    8007f3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 04             	sub    $0x4,%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	99                   	cltd   
}
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	56                   	push   %esi
  8007f9:	53                   	push   %ebx
  8007fa:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fd:	eb 17                	jmp    800816 <vprintfmt+0x21>
			if (ch == '\0')
  8007ff:	85 db                	test   %ebx,%ebx
  800801:	0f 84 c1 03 00 00    	je     800bc8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	53                   	push   %ebx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800816:	8b 45 10             	mov    0x10(%ebp),%eax
  800819:	8d 50 01             	lea    0x1(%eax),%edx
  80081c:	89 55 10             	mov    %edx,0x10(%ebp)
  80081f:	8a 00                	mov    (%eax),%al
  800821:	0f b6 d8             	movzbl %al,%ebx
  800824:	83 fb 25             	cmp    $0x25,%ebx
  800827:	75 d6                	jne    8007ff <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800829:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80082d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800834:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800842:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	8d 50 01             	lea    0x1(%eax),%edx
  80084f:	89 55 10             	mov    %edx,0x10(%ebp)
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f b6 d8             	movzbl %al,%ebx
  800857:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085a:	83 f8 5b             	cmp    $0x5b,%eax
  80085d:	0f 87 3d 03 00 00    	ja     800ba0 <vprintfmt+0x3ab>
  800863:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
  80086a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800870:	eb d7                	jmp    800849 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800872:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800876:	eb d1                	jmp    800849 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800878:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80087f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800882:	89 d0                	mov    %edx,%eax
  800884:	c1 e0 02             	shl    $0x2,%eax
  800887:	01 d0                	add    %edx,%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	01 d8                	add    %ebx,%eax
  80088d:	83 e8 30             	sub    $0x30,%eax
  800890:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800893:	8b 45 10             	mov    0x10(%ebp),%eax
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089b:	83 fb 2f             	cmp    $0x2f,%ebx
  80089e:	7e 3e                	jle    8008de <vprintfmt+0xe9>
  8008a0:	83 fb 39             	cmp    $0x39,%ebx
  8008a3:	7f 39                	jg     8008de <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a8:	eb d5                	jmp    80087f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008be:	eb 1f                	jmp    8008df <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c4:	79 83                	jns    800849 <vprintfmt+0x54>
				width = 0;
  8008c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008cd:	e9 77 ff ff ff       	jmp    800849 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d9:	e9 6b ff ff ff       	jmp    800849 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008de:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e3:	0f 89 60 ff ff ff    	jns    800849 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f6:	e9 4e ff ff ff       	jmp    800849 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008fe:	e9 46 ff ff ff       	jmp    800849 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	50                   	push   %eax
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			break;
  800923:	e9 9b 02 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	83 c0 04             	add    $0x4,%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	83 e8 04             	sub    $0x4,%eax
  800937:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800939:	85 db                	test   %ebx,%ebx
  80093b:	79 02                	jns    80093f <vprintfmt+0x14a>
				err = -err;
  80093d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80093f:	83 fb 64             	cmp    $0x64,%ebx
  800942:	7f 0b                	jg     80094f <vprintfmt+0x15a>
  800944:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  80094b:	85 f6                	test   %esi,%esi
  80094d:	75 19                	jne    800968 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80094f:	53                   	push   %ebx
  800950:	68 25 3c 80 00       	push   $0x803c25
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 70 02 00 00       	call   800bd0 <printfmt>
  800960:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800963:	e9 5b 02 00 00       	jmp    800bc3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800968:	56                   	push   %esi
  800969:	68 2e 3c 80 00       	push   $0x803c2e
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	ff 75 08             	pushl  0x8(%ebp)
  800974:	e8 57 02 00 00       	call   800bd0 <printfmt>
  800979:	83 c4 10             	add    $0x10,%esp
			break;
  80097c:	e9 42 02 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	83 c0 04             	add    $0x4,%eax
  800987:	89 45 14             	mov    %eax,0x14(%ebp)
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 e8 04             	sub    $0x4,%eax
  800990:	8b 30                	mov    (%eax),%esi
  800992:	85 f6                	test   %esi,%esi
  800994:	75 05                	jne    80099b <vprintfmt+0x1a6>
				p = "(null)";
  800996:	be 31 3c 80 00       	mov    $0x803c31,%esi
			if (width > 0 && padc != '-')
  80099b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099f:	7e 6d                	jle    800a0e <vprintfmt+0x219>
  8009a1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a5:	74 67                	je     800a0e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	50                   	push   %eax
  8009ae:	56                   	push   %esi
  8009af:	e8 1e 03 00 00       	call   800cd2 <strnlen>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009ba:	eb 16                	jmp    8009d2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	50                   	push   %eax
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d6:	7f e4                	jg     8009bc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d8:	eb 34                	jmp    800a0e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009de:	74 1c                	je     8009fc <vprintfmt+0x207>
  8009e0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e3:	7e 05                	jle    8009ea <vprintfmt+0x1f5>
  8009e5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e8:	7e 12                	jle    8009fc <vprintfmt+0x207>
					putch('?', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 3f                	push   $0x3f
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	eb 0f                	jmp    800a0b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	53                   	push   %ebx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	89 f0                	mov    %esi,%eax
  800a10:	8d 70 01             	lea    0x1(%eax),%esi
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	0f be d8             	movsbl %al,%ebx
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	74 24                	je     800a40 <vprintfmt+0x24b>
  800a1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a20:	78 b8                	js     8009da <vprintfmt+0x1e5>
  800a22:	ff 4d e0             	decl   -0x20(%ebp)
  800a25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a29:	79 af                	jns    8009da <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2b:	eb 13                	jmp    800a40 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 20                	push   $0x20
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a44:	7f e7                	jg     800a2d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a46:	e9 78 01 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a51:	8d 45 14             	lea    0x14(%ebp),%eax
  800a54:	50                   	push   %eax
  800a55:	e8 3c fd ff ff       	call   800796 <getint>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a69:	85 d2                	test   %edx,%edx
  800a6b:	79 23                	jns    800a90 <vprintfmt+0x29b>
				putch('-', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	6a 2d                	push   $0x2d
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a83:	f7 d8                	neg    %eax
  800a85:	83 d2 00             	adc    $0x0,%edx
  800a88:	f7 da                	neg    %edx
  800a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a90:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a97:	e9 bc 00 00 00       	jmp    800b58 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa2:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa5:	50                   	push   %eax
  800aa6:	e8 84 fc ff ff       	call   80072f <getuint>
  800aab:	83 c4 10             	add    $0x10,%esp
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abb:	e9 98 00 00 00       	jmp    800b58 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 58                	push   $0x58
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	6a 58                	push   $0x58
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	ff d0                	call   *%eax
  800aed:	83 c4 10             	add    $0x10,%esp
			break;
  800af0:	e9 ce 00 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 30                	push   $0x30
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	6a 78                	push   $0x78
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 c0 04             	add    $0x4,%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	83 e8 04             	sub    $0x4,%eax
  800b24:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b30:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b37:	eb 1f                	jmp    800b58 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b42:	50                   	push   %eax
  800b43:	e8 e7 fb ff ff       	call   80072f <getuint>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b58:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	52                   	push   %edx
  800b63:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b66:	50                   	push   %eax
  800b67:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	ff 75 08             	pushl  0x8(%ebp)
  800b73:	e8 00 fb ff ff       	call   800678 <printnum>
  800b78:	83 c4 20             	add    $0x20,%esp
			break;
  800b7b:	eb 46                	jmp    800bc3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			break;
  800b8c:	eb 35                	jmp    800bc3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b8e:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b95:	eb 2c                	jmp    800bc3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b97:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800b9e:	eb 23                	jmp    800bc3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	6a 25                	push   $0x25
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb0:	ff 4d 10             	decl   0x10(%ebp)
  800bb3:	eb 03                	jmp    800bb8 <vprintfmt+0x3c3>
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	48                   	dec    %eax
  800bbc:	8a 00                	mov    (%eax),%al
  800bbe:	3c 25                	cmp    $0x25,%al
  800bc0:	75 f3                	jne    800bb5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bc2:	90                   	nop
		}
	}
  800bc3:	e9 35 fc ff ff       	jmp    8007fd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 04 fc ff ff       	call   8007f5 <vprintfmt>
  800bf1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf4:	90                   	nop
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 40 08             	mov    0x8(%eax),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 10                	mov    (%eax),%edx
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 40 04             	mov    0x4(%eax),%eax
  800c14:	39 c2                	cmp    %eax,%edx
  800c16:	73 12                	jae    800c2a <sprintputch+0x33>
		*b->buf++ = ch;
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	8d 48 01             	lea    0x1(%eax),%ecx
  800c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c23:	89 0a                	mov    %ecx,(%edx)
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	88 10                	mov    %dl,(%eax)
}
  800c2a:	90                   	nop
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	01 d0                	add    %edx,%eax
  800c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c52:	74 06                	je     800c5a <vsnprintf+0x2d>
  800c54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c58:	7f 07                	jg     800c61 <vsnprintf+0x34>
		return -E_INVAL;
  800c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5f:	eb 20                	jmp    800c81 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c61:	ff 75 14             	pushl  0x14(%ebp)
  800c64:	ff 75 10             	pushl  0x10(%ebp)
  800c67:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6a:	50                   	push   %eax
  800c6b:	68 f7 0b 80 00       	push   $0x800bf7
  800c70:	e8 80 fb ff ff       	call   8007f5 <vprintfmt>
  800c75:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c89:	8d 45 10             	lea    0x10(%ebp),%eax
  800c8c:	83 c0 04             	add    $0x4,%eax
  800c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
  800c95:	ff 75 f4             	pushl  -0xc(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 0c             	pushl  0xc(%ebp)
  800c9c:	ff 75 08             	pushl  0x8(%ebp)
  800c9f:	e8 89 ff ff ff       	call   800c2d <vsnprintf>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbc:	eb 06                	jmp    800cc4 <strlen+0x15>
		n++;
  800cbe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc1:	ff 45 08             	incl   0x8(%ebp)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	75 f1                	jne    800cbe <strlen+0xf>
		n++;
	return n;
  800ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdf:	eb 09                	jmp    800cea <strnlen+0x18>
		n++;
  800ce1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	ff 4d 0c             	decl   0xc(%ebp)
  800cea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cee:	74 09                	je     800cf9 <strnlen+0x27>
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	84 c0                	test   %al,%al
  800cf7:	75 e8                	jne    800ce1 <strnlen+0xf>
		n++;
	return n;
  800cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0a:	90                   	nop
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8d 50 01             	lea    0x1(%eax),%edx
  800d11:	89 55 08             	mov    %edx,0x8(%ebp)
  800d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1d:	8a 12                	mov    (%edx),%dl
  800d1f:	88 10                	mov    %dl,(%eax)
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	75 e4                	jne    800d0b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 1f                	jmp    800d60 <strncpy+0x34>
		*dst++ = *src;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8d 50 01             	lea    0x1(%eax),%edx
  800d47:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4d:	8a 12                	mov    (%edx),%dl
  800d4f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	84 c0                	test   %al,%al
  800d58:	74 03                	je     800d5d <strncpy+0x31>
			src++;
  800d5a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d5d:	ff 45 fc             	incl   -0x4(%ebp)
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d63:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d66:	72 d9                	jb     800d41 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7d:	74 30                	je     800daf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d7f:	eb 16                	jmp    800d97 <strlcpy+0x2a>
			*dst++ = *src++;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d90:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d93:	8a 12                	mov    (%edx),%dl
  800d95:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d97:	ff 4d 10             	decl   0x10(%ebp)
  800d9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9e:	74 09                	je     800da9 <strlcpy+0x3c>
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	84 c0                	test   %al,%al
  800da7:	75 d8                	jne    800d81 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db5:	29 c2                	sub    %eax,%edx
  800db7:	89 d0                	mov    %edx,%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dbe:	eb 06                	jmp    800dc6 <strcmp+0xb>
		p++, q++;
  800dc0:	ff 45 08             	incl   0x8(%ebp)
  800dc3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	84 c0                	test   %al,%al
  800dcd:	74 0e                	je     800ddd <strcmp+0x22>
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 10                	mov    (%eax),%dl
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	38 c2                	cmp    %al,%dl
  800ddb:	74 e3                	je     800dc0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 d0             	movzbl %al,%edx
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 c0             	movzbl %al,%eax
  800ded:	29 c2                	sub    %eax,%edx
  800def:	89 d0                	mov    %edx,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800df6:	eb 09                	jmp    800e01 <strncmp+0xe>
		n--, p++, q++;
  800df8:	ff 4d 10             	decl   0x10(%ebp)
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e05:	74 17                	je     800e1e <strncmp+0x2b>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	84 c0                	test   %al,%al
  800e0e:	74 0e                	je     800e1e <strncmp+0x2b>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 10                	mov    (%eax),%dl
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	38 c2                	cmp    %al,%dl
  800e1c:	74 da                	je     800df8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	75 07                	jne    800e2b <strncmp+0x38>
		return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
  800e29:	eb 14                	jmp    800e3f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	0f b6 d0             	movzbl %al,%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 c0             	movzbl %al,%eax
  800e3b:	29 c2                	sub    %eax,%edx
  800e3d:	89 d0                	mov    %edx,%eax
}
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 04             	sub    $0x4,%esp
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e4d:	eb 12                	jmp    800e61 <strchr+0x20>
		if (*s == c)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e57:	75 05                	jne    800e5e <strchr+0x1d>
			return (char *) s;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	eb 11                	jmp    800e6f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e5e:	ff 45 08             	incl   0x8(%ebp)
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	75 e5                	jne    800e4f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e7d:	eb 0d                	jmp    800e8c <strfind+0x1b>
		if (*s == c)
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e87:	74 0e                	je     800e97 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	75 ea                	jne    800e7f <strfind+0xe>
  800e95:	eb 01                	jmp    800e98 <strfind+0x27>
		if (*s == c)
			break;
  800e97:	90                   	nop
	return (char *) s;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ea9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ead:	76 63                	jbe    800f12 <memset+0x75>
		uint64 data_block = c;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	99                   	cltd   
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebf:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ec3:	c1 e0 08             	shl    $0x8,%eax
  800ec6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ed6:	c1 e0 10             	shl    $0x10,%eax
  800ed9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eec:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eef:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ef2:	eb 18                	jmp    800f0c <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ef4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef7:	8d 41 08             	lea    0x8(%ecx),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f03:	89 01                	mov    %eax,(%ecx)
  800f05:	89 51 04             	mov    %edx,0x4(%ecx)
  800f08:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f0c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f10:	77 e2                	ja     800ef4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f16:	74 23                	je     800f3b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f1e:	eb 0e                	jmp    800f2e <memset+0x91>
			*p8++ = (uint8)c;
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f23:	8d 50 01             	lea    0x1(%eax),%edx
  800f26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 e5                	jne    800f20 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f52:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f56:	76 24                	jbe    800f7c <memcpy+0x3c>
		while(n >= 8){
  800f58:	eb 1c                	jmp    800f76 <memcpy+0x36>
			*d64 = *s64;
  800f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5d:	8b 50 04             	mov    0x4(%eax),%edx
  800f60:	8b 00                	mov    (%eax),%eax
  800f62:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f65:	89 01                	mov    %eax,(%ecx)
  800f67:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f6a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f6e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f72:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f76:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f7a:	77 de                	ja     800f5a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f80:	74 31                	je     800fb3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f8e:	eb 16                	jmp    800fa6 <memcpy+0x66>
			*d8++ = *s8++;
  800f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f93:	8d 50 01             	lea    0x1(%eax),%edx
  800f96:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fa2:	8a 12                	mov    (%edx),%dl
  800fa4:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fac:	89 55 10             	mov    %edx,0x10(%ebp)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	75 dd                	jne    800f90 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd0:	73 50                	jae    801022 <memmove+0x6a>
  800fd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fdd:	76 43                	jbe    801022 <memmove+0x6a>
		s += n;
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800feb:	eb 10                	jmp    800ffd <memmove+0x45>
			*--d = *--s;
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	ff 4d fc             	decl   -0x4(%ebp)
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8a 10                	mov    (%eax),%dl
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	8d 50 ff             	lea    -0x1(%eax),%edx
  801003:	89 55 10             	mov    %edx,0x10(%ebp)
  801006:	85 c0                	test   %eax,%eax
  801008:	75 e3                	jne    800fed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80100a:	eb 23                	jmp    80102f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80100c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100f:	8d 50 01             	lea    0x1(%eax),%edx
  801012:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801015:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801018:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80101e:	8a 12                	mov    (%edx),%dl
  801020:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	8d 50 ff             	lea    -0x1(%eax),%edx
  801028:	89 55 10             	mov    %edx,0x10(%ebp)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	75 dd                	jne    80100c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801046:	eb 2a                	jmp    801072 <memcmp+0x3e>
		if (*s1 != *s2)
  801048:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104b:	8a 10                	mov    (%eax),%dl
  80104d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	38 c2                	cmp    %al,%dl
  801054:	74 16                	je     80106c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	0f b6 d0             	movzbl %al,%edx
  80105e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	0f b6 c0             	movzbl %al,%eax
  801066:	29 c2                	sub    %eax,%edx
  801068:	89 d0                	mov    %edx,%eax
  80106a:	eb 18                	jmp    801084 <memcmp+0x50>
		s1++, s2++;
  80106c:	ff 45 fc             	incl   -0x4(%ebp)
  80106f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	8d 50 ff             	lea    -0x1(%eax),%edx
  801078:	89 55 10             	mov    %edx,0x10(%ebp)
  80107b:	85 c0                	test   %eax,%eax
  80107d:	75 c9                	jne    801048 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80107f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	8b 45 10             	mov    0x10(%ebp),%eax
  801092:	01 d0                	add    %edx,%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801097:	eb 15                	jmp    8010ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 d0             	movzbl %al,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	0f b6 c0             	movzbl %al,%eax
  8010a7:	39 c2                	cmp    %eax,%edx
  8010a9:	74 0d                	je     8010b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010ab:	ff 45 08             	incl   0x8(%ebp)
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010b4:	72 e3                	jb     801099 <memfind+0x13>
  8010b6:	eb 01                	jmp    8010b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010b8:	90                   	nop
	return (void *) s;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d2:	eb 03                	jmp    8010d7 <strtol+0x19>
		s++;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 20                	cmp    $0x20,%al
  8010de:	74 f4                	je     8010d4 <strtol+0x16>
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 09                	cmp    $0x9,%al
  8010e7:	74 eb                	je     8010d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 2b                	cmp    $0x2b,%al
  8010f0:	75 05                	jne    8010f7 <strtol+0x39>
		s++;
  8010f2:	ff 45 08             	incl   0x8(%ebp)
  8010f5:	eb 13                	jmp    80110a <strtol+0x4c>
	else if (*s == '-')
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 2d                	cmp    $0x2d,%al
  8010fe:	75 0a                	jne    80110a <strtol+0x4c>
		s++, neg = 1;
  801100:	ff 45 08             	incl   0x8(%ebp)
  801103:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	74 06                	je     801116 <strtol+0x58>
  801110:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801114:	75 20                	jne    801136 <strtol+0x78>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	3c 30                	cmp    $0x30,%al
  80111d:	75 17                	jne    801136 <strtol+0x78>
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	40                   	inc    %eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 78                	cmp    $0x78,%al
  801127:	75 0d                	jne    801136 <strtol+0x78>
		s += 2, base = 16;
  801129:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80112d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801134:	eb 28                	jmp    80115e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113a:	75 15                	jne    801151 <strtol+0x93>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 30                	cmp    $0x30,%al
  801143:	75 0c                	jne    801151 <strtol+0x93>
		s++, base = 8;
  801145:	ff 45 08             	incl   0x8(%ebp)
  801148:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80114f:	eb 0d                	jmp    80115e <strtol+0xa0>
	else if (base == 0)
  801151:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801155:	75 07                	jne    80115e <strtol+0xa0>
		base = 10;
  801157:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 2f                	cmp    $0x2f,%al
  801165:	7e 19                	jle    801180 <strtol+0xc2>
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	3c 39                	cmp    $0x39,%al
  80116e:	7f 10                	jg     801180 <strtol+0xc2>
			dig = *s - '0';
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be c0             	movsbl %al,%eax
  801178:	83 e8 30             	sub    $0x30,%eax
  80117b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117e:	eb 42                	jmp    8011c2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 60                	cmp    $0x60,%al
  801187:	7e 19                	jle    8011a2 <strtol+0xe4>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3c 7a                	cmp    $0x7a,%al
  801190:	7f 10                	jg     8011a2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f be c0             	movsbl %al,%eax
  80119a:	83 e8 57             	sub    $0x57,%eax
  80119d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a0:	eb 20                	jmp    8011c2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	3c 40                	cmp    $0x40,%al
  8011a9:	7e 39                	jle    8011e4 <strtol+0x126>
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	3c 5a                	cmp    $0x5a,%al
  8011b2:	7f 30                	jg     8011e4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f be c0             	movsbl %al,%eax
  8011bc:	83 e8 37             	sub    $0x37,%eax
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c8:	7d 19                	jge    8011e3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011d4:	89 c2                	mov    %eax,%edx
  8011d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011de:	e9 7b ff ff ff       	jmp    80115e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011e3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e8:	74 08                	je     8011f2 <strtol+0x134>
		*endptr = (char *) s;
  8011ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011f6:	74 07                	je     8011ff <strtol+0x141>
  8011f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fb:	f7 d8                	neg    %eax
  8011fd:	eb 03                	jmp    801202 <strtol+0x144>
  8011ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <ltostr>:

void
ltostr(long value, char *str)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80120a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801211:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121c:	79 13                	jns    801231 <ltostr+0x2d>
	{
		neg = 1;
  80121e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80122b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80122e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801239:	99                   	cltd   
  80123a:	f7 f9                	idiv   %ecx
  80123c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80123f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801242:	8d 50 01             	lea    0x1(%eax),%edx
  801245:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801248:	89 c2                	mov    %eax,%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801252:	83 c2 30             	add    $0x30,%edx
  801255:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80125f:	f7 e9                	imul   %ecx
  801261:	c1 fa 02             	sar    $0x2,%edx
  801264:	89 c8                	mov    %ecx,%eax
  801266:	c1 f8 1f             	sar    $0x1f,%eax
  801269:	29 c2                	sub    %eax,%edx
  80126b:	89 d0                	mov    %edx,%eax
  80126d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801274:	75 bb                	jne    801231 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	48                   	dec    %eax
  801281:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801284:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801288:	74 3d                	je     8012c7 <ltostr+0xc3>
		start = 1 ;
  80128a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801291:	eb 34                	jmp    8012c7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 c2                	add    %eax,%edx
  8012a8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 c8                	add    %ecx,%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012bf:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012cd:	7c c4                	jl     801293 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012da:	90                   	nop
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e3:	ff 75 08             	pushl  0x8(%ebp)
  8012e6:	e8 c4 f9 ff ff       	call   800caf <strlen>
  8012eb:	83 c4 04             	add    $0x4,%esp
  8012ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f1:	ff 75 0c             	pushl  0xc(%ebp)
  8012f4:	e8 b6 f9 ff ff       	call   800caf <strlen>
  8012f9:	83 c4 04             	add    $0x4,%esp
  8012fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130d:	eb 17                	jmp    801326 <strcconcat+0x49>
		final[s] = str1[s] ;
  80130f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 c2                	add    %eax,%edx
  801317:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	01 c8                	add    %ecx,%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801323:	ff 45 fc             	incl   -0x4(%ebp)
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801329:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132c:	7c e1                	jl     80130f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801335:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133c:	eb 1f                	jmp    80135d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8d 50 01             	lea    0x1(%eax),%edx
  801344:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801347:	89 c2                	mov    %eax,%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 c2                	add    %eax,%edx
  80134e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	01 c8                	add    %ecx,%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80135a:	ff 45 f8             	incl   -0x8(%ebp)
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801360:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801363:	7c d9                	jl     80133e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801365:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 d0                	add    %edx,%eax
  80136d:	c6 00 00             	movb   $0x0,(%eax)
}
  801370:	90                   	nop
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80137f:	8b 45 14             	mov    0x14(%ebp),%eax
  801382:	8b 00                	mov    (%eax),%eax
  801384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138b:	8b 45 10             	mov    0x10(%ebp),%eax
  80138e:	01 d0                	add    %edx,%eax
  801390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801396:	eb 0c                	jmp    8013a4 <strsplit+0x31>
			*string++ = 0;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8d 50 01             	lea    0x1(%eax),%edx
  80139e:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	84 c0                	test   %al,%al
  8013ab:	74 18                	je     8013c5 <strsplit+0x52>
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f be c0             	movsbl %al,%eax
  8013b5:	50                   	push   %eax
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	e8 83 fa ff ff       	call   800e41 <strchr>
  8013be:	83 c4 08             	add    $0x8,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	75 d3                	jne    801398 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	84 c0                	test   %al,%al
  8013cc:	74 5a                	je     801428 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	83 f8 0f             	cmp    $0xf,%eax
  8013d6:	75 07                	jne    8013df <strsplit+0x6c>
		{
			return 0;
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dd:	eb 66                	jmp    801445 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013df:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e2:	8b 00                	mov    (%eax),%eax
  8013e4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ea:	89 0a                	mov    %ecx,(%edx)
  8013ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	01 c2                	add    %eax,%edx
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fd:	eb 03                	jmp    801402 <strsplit+0x8f>
			string++;
  8013ff:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	84 c0                	test   %al,%al
  801409:	74 8b                	je     801396 <strsplit+0x23>
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f be c0             	movsbl %al,%eax
  801413:	50                   	push   %eax
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	e8 25 fa ff ff       	call   800e41 <strchr>
  80141c:	83 c4 08             	add    $0x8,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	74 dc                	je     8013ff <strsplit+0x8c>
			string++;
	}
  801423:	e9 6e ff ff ff       	jmp    801396 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801428:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801429:	8b 45 14             	mov    0x14(%ebp),%eax
  80142c:	8b 00                	mov    (%eax),%eax
  80142e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801440:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801453:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145a:	eb 4a                	jmp    8014a6 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80145c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	01 c2                	add    %eax,%edx
  801464:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 c8                	add    %ecx,%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801470:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3c 40                	cmp    $0x40,%al
  80147c:	7e 25                	jle    8014a3 <str2lower+0x5c>
  80147e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801481:	8b 45 0c             	mov    0xc(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	3c 5a                	cmp    $0x5a,%al
  80148a:	7f 17                	jg     8014a3 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80148c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801497:	8b 55 08             	mov    0x8(%ebp),%edx
  80149a:	01 ca                	add    %ecx,%edx
  80149c:	8a 12                	mov    (%edx),%dl
  80149e:	83 c2 20             	add    $0x20,%edx
  8014a1:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014a3:	ff 45 fc             	incl   -0x4(%ebp)
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	e8 01 f8 ff ff       	call   800caf <strlen>
  8014ae:	83 c4 04             	add    $0x4,%esp
  8014b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b4:	7f a6                	jg     80145c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	6a 10                	push   $0x10
  8014c6:	e8 b2 15 00 00       	call   802a7d <alloc_block>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8014d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014d5:	75 14                	jne    8014eb <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	68 a8 3d 80 00       	push   $0x803da8
  8014df:	6a 14                	push   $0x14
  8014e1:	68 d1 3d 80 00       	push   $0x803dd1
  8014e6:	e8 fd ed ff ff       	call   8002e8 <_panic>

	node->start = start;
  8014eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f1:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8014f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f9:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8014fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801503:	a1 24 50 80 00       	mov    0x805024,%eax
  801508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150b:	eb 18                	jmp    801525 <insert_page_alloc+0x6a>
		if (start < it->start)
  80150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801510:	8b 00                	mov    (%eax),%eax
  801512:	3b 45 08             	cmp    0x8(%ebp),%eax
  801515:	77 37                	ja     80154e <insert_page_alloc+0x93>
			break;
		prev = it;
  801517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80151d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801529:	74 08                	je     801533 <insert_page_alloc+0x78>
  80152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	eb 05                	jmp    801538 <insert_page_alloc+0x7d>
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
  801538:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80153d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801542:	85 c0                	test   %eax,%eax
  801544:	75 c7                	jne    80150d <insert_page_alloc+0x52>
  801546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80154a:	75 c1                	jne    80150d <insert_page_alloc+0x52>
  80154c:	eb 01                	jmp    80154f <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  80154e:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  80154f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801553:	75 64                	jne    8015b9 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801555:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801559:	75 14                	jne    80156f <insert_page_alloc+0xb4>
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	68 e0 3d 80 00       	push   $0x803de0
  801563:	6a 21                	push   $0x21
  801565:	68 d1 3d 80 00       	push   $0x803dd1
  80156a:	e8 79 ed ff ff       	call   8002e8 <_panic>
  80156f:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801578:	89 50 08             	mov    %edx,0x8(%eax)
  80157b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157e:	8b 40 08             	mov    0x8(%eax),%eax
  801581:	85 c0                	test   %eax,%eax
  801583:	74 0d                	je     801592 <insert_page_alloc+0xd7>
  801585:	a1 24 50 80 00       	mov    0x805024,%eax
  80158a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80158d:	89 50 0c             	mov    %edx,0xc(%eax)
  801590:	eb 08                	jmp    80159a <insert_page_alloc+0xdf>
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	a3 28 50 80 00       	mov    %eax,0x805028
  80159a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159d:	a3 24 50 80 00       	mov    %eax,0x805024
  8015a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8015ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8015b1:	40                   	inc    %eax
  8015b2:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8015b7:	eb 71                	jmp    80162a <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8015b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015bd:	74 06                	je     8015c5 <insert_page_alloc+0x10a>
  8015bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015c3:	75 14                	jne    8015d9 <insert_page_alloc+0x11e>
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	68 04 3e 80 00       	push   $0x803e04
  8015cd:	6a 23                	push   $0x23
  8015cf:	68 d1 3d 80 00       	push   $0x803dd1
  8015d4:	e8 0f ed ff ff       	call   8002e8 <_panic>
  8015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dc:	8b 50 08             	mov    0x8(%eax),%edx
  8015df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e2:	89 50 08             	mov    %edx,0x8(%eax)
  8015e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e8:	8b 40 08             	mov    0x8(%eax),%eax
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	74 0c                	je     8015fb <insert_page_alloc+0x140>
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	8b 40 08             	mov    0x8(%eax),%eax
  8015f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f8:	89 50 0c             	mov    %edx,0xc(%eax)
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801601:	89 50 08             	mov    %edx,0x8(%eax)
  801604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801607:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160a:	89 50 0c             	mov    %edx,0xc(%eax)
  80160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801610:	8b 40 08             	mov    0x8(%eax),%eax
  801613:	85 c0                	test   %eax,%eax
  801615:	75 08                	jne    80161f <insert_page_alloc+0x164>
  801617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161a:	a3 28 50 80 00       	mov    %eax,0x805028
  80161f:	a1 30 50 80 00       	mov    0x805030,%eax
  801624:	40                   	inc    %eax
  801625:	a3 30 50 80 00       	mov    %eax,0x805030
}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801633:	a1 24 50 80 00       	mov    0x805024,%eax
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 0c                	jne    801648 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80163c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801641:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801646:	eb 67                	jmp    8016af <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801648:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80164d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801650:	a1 24 50 80 00       	mov    0x805024,%eax
  801655:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801658:	eb 26                	jmp    801680 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	8b 10                	mov    (%eax),%edx
  80165f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801662:	8b 40 04             	mov    0x4(%eax),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801670:	76 06                	jbe    801678 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801675:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801678:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80167d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801680:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801684:	74 08                	je     80168e <recompute_page_alloc_break+0x61>
  801686:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801689:	8b 40 08             	mov    0x8(%eax),%eax
  80168c:	eb 05                	jmp    801693 <recompute_page_alloc_break+0x66>
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
  801693:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801698:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80169d:	85 c0                	test   %eax,%eax
  80169f:	75 b9                	jne    80165a <recompute_page_alloc_break+0x2d>
  8016a1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016a5:	75 b3                	jne    80165a <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8016a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016aa:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8016b7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8016be:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	48                   	dec    %eax
  8016c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d2:	f7 75 d8             	divl   -0x28(%ebp)
  8016d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016d8:	29 d0                	sub    %edx,%eax
  8016da:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8016dd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8016e1:	75 0a                	jne    8016ed <alloc_pages_custom_fit+0x3c>
		return NULL;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	e9 7e 01 00 00       	jmp    80186b <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8016ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8016f4:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  8016f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  8016ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801706:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80170b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80170e:	a1 24 50 80 00       	mov    0x805024,%eax
  801713:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801716:	eb 69                	jmp    801781 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801718:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171b:	8b 00                	mov    (%eax),%eax
  80171d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801720:	76 47                	jbe    801769 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801725:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172b:	8b 00                	mov    (%eax),%eax
  80172d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801730:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801733:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801736:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801739:	72 2e                	jb     801769 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  80173b:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80173f:	75 14                	jne    801755 <alloc_pages_custom_fit+0xa4>
  801741:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801744:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801747:	75 0c                	jne    801755 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801749:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80174c:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  80174f:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801753:	eb 14                	jmp    801769 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801755:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801758:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80175b:	76 0c                	jbe    801769 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  80175d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801760:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801763:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801766:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80176c:	8b 10                	mov    (%eax),%edx
  80176e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801771:	8b 40 04             	mov    0x4(%eax),%eax
  801774:	01 d0                	add    %edx,%eax
  801776:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801779:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80177e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801781:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801785:	74 08                	je     80178f <alloc_pages_custom_fit+0xde>
  801787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178a:	8b 40 08             	mov    0x8(%eax),%eax
  80178d:	eb 05                	jmp    801794 <alloc_pages_custom_fit+0xe3>
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801799:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	0f 85 72 ff ff ff    	jne    801718 <alloc_pages_custom_fit+0x67>
  8017a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017aa:	0f 85 68 ff ff ff    	jne    801718 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8017b0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017b5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017b8:	76 47                	jbe    801801 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8017ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017bd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8017c0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017c5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8017c8:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8017cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017d1:	72 2e                	jb     801801 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8017d3:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017d7:	75 14                	jne    8017ed <alloc_pages_custom_fit+0x13c>
  8017d9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017dc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017df:	75 0c                	jne    8017ed <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8017e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8017e7:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8017eb:	eb 14                	jmp    801801 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8017ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017f3:	76 0c                	jbe    801801 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8017f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  8017fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801808:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80180c:	74 08                	je     801816 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  80180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801811:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801814:	eb 40                	jmp    801856 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801816:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80181a:	74 08                	je     801824 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80181c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801822:	eb 32                	jmp    801856 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801824:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801829:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801833:	39 c2                	cmp    %eax,%edx
  801835:	73 07                	jae    80183e <alloc_pages_custom_fit+0x18d>
			return NULL;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
  80183c:	eb 2d                	jmp    80186b <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  80183e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801843:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801846:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80184c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801856:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 d0             	pushl  -0x30(%ebp)
  80185f:	50                   	push   %eax
  801860:	e8 56 fc ff ff       	call   8014bb <insert_page_alloc>
  801865:	83 c4 10             	add    $0x10,%esp

	return result;
  801868:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801879:	a1 24 50 80 00       	mov    0x805024,%eax
  80187e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801881:	eb 1a                	jmp    80189d <find_allocated_size+0x30>
		if (it->start == va)
  801883:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80188b:	75 08                	jne    801895 <find_allocated_size+0x28>
			return it->size;
  80188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801890:	8b 40 04             	mov    0x4(%eax),%eax
  801893:	eb 34                	jmp    8018c9 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801895:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80189a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80189d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a1:	74 08                	je     8018ab <find_allocated_size+0x3e>
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	8b 40 08             	mov    0x8(%eax),%eax
  8018a9:	eb 05                	jmp    8018b0 <find_allocated_size+0x43>
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	75 c5                	jne    801883 <find_allocated_size+0x16>
  8018be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c2:	75 bf                	jne    801883 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8018c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018df:	e9 e1 01 00 00       	jmp    801ac5 <free_pages+0x1fa>
		if (it->start == va) {
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8018ec:	0f 85 cb 01 00 00    	jne    801abd <free_pages+0x1f2>

			uint32 start = it->start;
  8018f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f5:	8b 00                	mov    (%eax),%eax
  8018f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	8b 40 04             	mov    0x4(%eax),%eax
  801900:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801906:	f7 d0                	not    %eax
  801908:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80190b:	73 1d                	jae    80192a <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	ff 75 e4             	pushl  -0x1c(%ebp)
  801913:	ff 75 e8             	pushl  -0x18(%ebp)
  801916:	68 38 3e 80 00       	push   $0x803e38
  80191b:	68 a5 00 00 00       	push   $0xa5
  801920:	68 d1 3d 80 00       	push   $0x803dd1
  801925:	e8 be e9 ff ff       	call   8002e8 <_panic>
			}

			uint32 start_end = start + size;
  80192a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80192d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801938:	85 c0                	test   %eax,%eax
  80193a:	79 19                	jns    801955 <free_pages+0x8a>
  80193c:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801943:	77 10                	ja     801955 <free_pages+0x8a>
  801945:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  80194c:	77 07                	ja     801955 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80194e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801951:	85 c0                	test   %eax,%eax
  801953:	78 2c                	js     801981 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801958:	83 ec 0c             	sub    $0xc,%esp
  80195b:	68 00 00 00 a0       	push   $0xa0000000
  801960:	ff 75 e0             	pushl  -0x20(%ebp)
  801963:	ff 75 e4             	pushl  -0x1c(%ebp)
  801966:	ff 75 e8             	pushl  -0x18(%ebp)
  801969:	ff 75 e4             	pushl  -0x1c(%ebp)
  80196c:	50                   	push   %eax
  80196d:	68 7c 3e 80 00       	push   $0x803e7c
  801972:	68 ad 00 00 00       	push   $0xad
  801977:	68 d1 3d 80 00       	push   $0x803dd1
  80197c:	e8 67 e9 ff ff       	call   8002e8 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801981:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801984:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801987:	e9 88 00 00 00       	jmp    801a14 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  80198c:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801993:	76 17                	jbe    8019ac <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801995:	ff 75 f0             	pushl  -0x10(%ebp)
  801998:	68 e0 3e 80 00       	push   $0x803ee0
  80199d:	68 b4 00 00 00       	push   $0xb4
  8019a2:	68 d1 3d 80 00       	push   $0x803dd1
  8019a7:	e8 3c e9 ff ff       	call   8002e8 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019af:	05 00 10 00 00       	add    $0x1000,%eax
  8019b4:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	79 2e                	jns    8019ec <free_pages+0x121>
  8019be:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8019c5:	77 25                	ja     8019ec <free_pages+0x121>
  8019c7:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8019ce:	77 1c                	ja     8019ec <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	68 00 10 00 00       	push   $0x1000
  8019d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019db:	e8 38 0d 00 00       	call   802718 <sys_free_user_mem>
  8019e0:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019e3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8019ea:	eb 28                	jmp    801a14 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8019ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ef:	68 00 00 00 a0       	push   $0xa0000000
  8019f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8019f7:	68 00 10 00 00       	push   $0x1000
  8019fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	68 20 3f 80 00       	push   $0x803f20
  801a05:	68 bd 00 00 00       	push   $0xbd
  801a0a:	68 d1 3d 80 00       	push   $0x803dd1
  801a0f:	e8 d4 e8 ff ff       	call   8002e8 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a1a:	0f 82 6c ff ff ff    	jb     80198c <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a24:	75 17                	jne    801a3d <free_pages+0x172>
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	68 82 3f 80 00       	push   $0x803f82
  801a2e:	68 c1 00 00 00       	push   $0xc1
  801a33:	68 d1 3d 80 00       	push   $0x803dd1
  801a38:	e8 ab e8 ff ff       	call   8002e8 <_panic>
  801a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a40:	8b 40 08             	mov    0x8(%eax),%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	74 11                	je     801a58 <free_pages+0x18d>
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	8b 40 08             	mov    0x8(%eax),%eax
  801a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a50:	8b 52 0c             	mov    0xc(%edx),%edx
  801a53:	89 50 0c             	mov    %edx,0xc(%eax)
  801a56:	eb 0b                	jmp    801a63 <free_pages+0x198>
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5e:	a3 28 50 80 00       	mov    %eax,0x805028
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	8b 40 0c             	mov    0xc(%eax),%eax
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	74 11                	je     801a7e <free_pages+0x1b3>
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a76:	8b 52 08             	mov    0x8(%edx),%edx
  801a79:	89 50 08             	mov    %edx,0x8(%eax)
  801a7c:	eb 0b                	jmp    801a89 <free_pages+0x1be>
  801a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a81:	8b 40 08             	mov    0x8(%eax),%eax
  801a84:	a3 24 50 80 00       	mov    %eax,0x805024
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a9d:	a1 30 50 80 00       	mov    0x805030,%eax
  801aa2:	48                   	dec    %eax
  801aa3:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801aa8:	83 ec 0c             	sub    $0xc,%esp
  801aab:	ff 75 f4             	pushl  -0xc(%ebp)
  801aae:	e8 24 15 00 00       	call   802fd7 <free_block>
  801ab3:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801ab6:	e8 72 fb ff ff       	call   80162d <recompute_page_alloc_break>

			return;
  801abb:	eb 37                	jmp    801af4 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801abd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac9:	74 08                	je     801ad3 <free_pages+0x208>
  801acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ace:	8b 40 08             	mov    0x8(%eax),%eax
  801ad1:	eb 05                	jmp    801ad8 <free_pages+0x20d>
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801add:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	0f 85 fa fd ff ff    	jne    8018e4 <free_pages+0x19>
  801aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aee:	0f 85 f0 fd ff ff    	jne    8018e4 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b06:	a1 08 50 80 00       	mov    0x805008,%eax
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	74 60                	je     801b6f <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	68 00 00 00 82       	push   $0x82000000
  801b17:	68 00 00 00 80       	push   $0x80000000
  801b1c:	e8 0d 0d 00 00       	call   80282e <initialize_dynamic_allocator>
  801b21:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b24:	e8 f3 0a 00 00       	call   80261c <sys_get_uheap_strategy>
  801b29:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b2e:	a1 40 50 80 00       	mov    0x805040,%eax
  801b33:	05 00 10 00 00       	add    $0x1000,%eax
  801b38:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b3d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b42:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801b47:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801b4e:	00 00 00 
  801b51:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801b58:	00 00 00 
  801b5b:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801b62:	00 00 00 

		__firstTimeFlag = 0;
  801b65:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801b6c:	00 00 00 
	}
}
  801b6f:	90                   	nop
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	68 06 04 00 00       	push   $0x406
  801b8e:	50                   	push   %eax
  801b8f:	e8 d2 06 00 00       	call   802266 <__sys_allocate_page>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b9e:	79 17                	jns    801bb7 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	68 a0 3f 80 00       	push   $0x803fa0
  801ba8:	68 ea 00 00 00       	push   $0xea
  801bad:	68 d1 3d 80 00       	push   $0x803dd1
  801bb2:	e8 31 e7 ff ff       	call   8002e8 <_panic>
	return 0;
  801bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	50                   	push   %eax
  801bd6:	e8 d2 06 00 00       	call   8022ad <__sys_unmap_frame>
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801be1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be5:	79 17                	jns    801bfe <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	68 dc 3f 80 00       	push   $0x803fdc
  801bef:	68 f5 00 00 00       	push   $0xf5
  801bf4:	68 d1 3d 80 00       	push   $0x803dd1
  801bf9:	e8 ea e6 ff ff       	call   8002e8 <_panic>
}
  801bfe:	90                   	nop
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c07:	e8 f4 fe ff ff       	call   801b00 <uheap_init>
	if (size == 0) return NULL ;
  801c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c10:	75 0a                	jne    801c1c <malloc+0x1b>
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
  801c17:	e9 67 01 00 00       	jmp    801d83 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801c23:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c2a:	77 16                	ja     801c42 <malloc+0x41>
		result = alloc_block(size);
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	e8 46 0e 00 00       	call   802a7d <alloc_block>
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3d:	e9 3e 01 00 00       	jmp    801d80 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801c42:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c49:	8b 55 08             	mov    0x8(%ebp),%edx
  801c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4f:	01 d0                	add    %edx,%eax
  801c51:	48                   	dec    %eax
  801c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c58:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5d:	f7 75 f0             	divl   -0x10(%ebp)
  801c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c63:	29 d0                	sub    %edx,%eax
  801c65:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801c68:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	75 0a                	jne    801c7b <malloc+0x7a>
			return NULL;
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	e9 08 01 00 00       	jmp    801d83 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801c7b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c80:	85 c0                	test   %eax,%eax
  801c82:	74 0f                	je     801c93 <malloc+0x92>
  801c84:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801c8a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c8f:	39 c2                	cmp    %eax,%edx
  801c91:	73 0a                	jae    801c9d <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801c93:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c98:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801c9d:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801ca2:	83 f8 05             	cmp    $0x5,%eax
  801ca5:	75 11                	jne    801cb8 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	ff 75 e8             	pushl  -0x18(%ebp)
  801cad:	e8 ff f9 ff ff       	call   8016b1 <alloc_pages_custom_fit>
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cbc:	0f 84 be 00 00 00    	je     801d80 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cce:	e8 9a fb ff ff       	call   80186d <find_allocated_size>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801cd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cdd:	75 17                	jne    801cf6 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce2:	68 1c 40 80 00       	push   $0x80401c
  801ce7:	68 24 01 00 00       	push   $0x124
  801cec:	68 d1 3d 80 00       	push   $0x803dd1
  801cf1:	e8 f2 e5 ff ff       	call   8002e8 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf9:	f7 d0                	not    %eax
  801cfb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cfe:	73 1d                	jae    801d1d <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	ff 75 e0             	pushl  -0x20(%ebp)
  801d06:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d09:	68 64 40 80 00       	push   $0x804064
  801d0e:	68 29 01 00 00       	push   $0x129
  801d13:	68 d1 3d 80 00       	push   $0x803dd1
  801d18:	e8 cb e5 ff ff       	call   8002e8 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801d1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	79 2c                	jns    801d5b <malloc+0x15a>
  801d2f:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d36:	77 23                	ja     801d5b <malloc+0x15a>
  801d38:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d3f:	77 1a                	ja     801d5b <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	79 13                	jns    801d5b <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801d48:	83 ec 08             	sub    $0x8,%esp
  801d4b:	ff 75 e0             	pushl  -0x20(%ebp)
  801d4e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d51:	e8 de 09 00 00       	call   802734 <sys_allocate_user_mem>
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	eb 25                	jmp    801d80 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801d5b:	68 00 00 00 a0       	push   $0xa0000000
  801d60:	ff 75 dc             	pushl  -0x24(%ebp)
  801d63:	ff 75 e0             	pushl  -0x20(%ebp)
  801d66:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d69:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6c:	68 a0 40 80 00       	push   $0x8040a0
  801d71:	68 33 01 00 00       	push   $0x133
  801d76:	68 d1 3d 80 00       	push   $0x803dd1
  801d7b:	e8 68 e5 ff ff       	call   8002e8 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801d8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d8f:	0f 84 26 01 00 00    	je     801ebb <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	79 1c                	jns    801dbe <free+0x39>
  801da2:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801da9:	77 13                	ja     801dbe <free+0x39>
		free_block(virtual_address);
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	e8 21 12 00 00       	call   802fd7 <free_block>
  801db6:	83 c4 10             	add    $0x10,%esp
		return;
  801db9:	e9 01 01 00 00       	jmp    801ebf <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801dbe:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dc3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801dc6:	0f 82 d8 00 00 00    	jb     801ea4 <free+0x11f>
  801dcc:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801dd3:	0f 87 cb 00 00 00    	ja     801ea4 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	25 ff 0f 00 00       	and    $0xfff,%eax
  801de1:	85 c0                	test   %eax,%eax
  801de3:	74 17                	je     801dfc <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801de5:	ff 75 08             	pushl  0x8(%ebp)
  801de8:	68 10 41 80 00       	push   $0x804110
  801ded:	68 57 01 00 00       	push   $0x157
  801df2:	68 d1 3d 80 00       	push   $0x803dd1
  801df7:	e8 ec e4 ff ff       	call   8002e8 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 66 fa ff ff       	call   80186d <find_allocated_size>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801e0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e11:	0f 84 a7 00 00 00    	je     801ebe <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1a:	f7 d0                	not    %eax
  801e1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e1f:	73 1d                	jae    801e3e <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	ff 75 f0             	pushl  -0x10(%ebp)
  801e27:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2a:	68 38 41 80 00       	push   $0x804138
  801e2f:	68 61 01 00 00       	push   $0x161
  801e34:	68 d1 3d 80 00       	push   $0x803dd1
  801e39:	e8 aa e4 ff ff       	call   8002e8 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e44:	01 d0                	add    %edx,%eax
  801e46:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	79 19                	jns    801e69 <free+0xe4>
  801e50:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801e57:	77 10                	ja     801e69 <free+0xe4>
  801e59:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801e60:	77 07                	ja     801e69 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 2b                	js     801e94 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	68 00 00 00 a0       	push   $0xa0000000
  801e71:	ff 75 ec             	pushl  -0x14(%ebp)
  801e74:	ff 75 f0             	pushl  -0x10(%ebp)
  801e77:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	68 74 41 80 00       	push   $0x804174
  801e85:	68 69 01 00 00       	push   $0x169
  801e8a:	68 d1 3d 80 00       	push   $0x803dd1
  801e8f:	e8 54 e4 ff ff       	call   8002e8 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	e8 2c fa ff ff       	call   8018cb <free_pages>
  801e9f:	83 c4 10             	add    $0x10,%esp
		return;
  801ea2:	eb 1b                	jmp    801ebf <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	68 d0 41 80 00       	push   $0x8041d0
  801eac:	68 70 01 00 00       	push   $0x170
  801eb1:	68 d1 3d 80 00       	push   $0x803dd1
  801eb6:	e8 2d e4 ff ff       	call   8002e8 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ebb:	90                   	nop
  801ebc:	eb 01                	jmp    801ebf <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801ebe:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 38             	sub    $0x38,%esp
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ecd:	e8 2e fc ff ff       	call   801b00 <uheap_init>
	if (size == 0) return NULL ;
  801ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed6:	75 0a                	jne    801ee2 <smalloc+0x21>
  801ed8:	b8 00 00 00 00       	mov    $0x0,%eax
  801edd:	e9 3d 01 00 00       	jmp    80201f <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eeb:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ef0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801ef3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ef7:	74 0e                	je     801f07 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801eff:	05 00 10 00 00       	add    $0x1000,%eax
  801f04:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	c1 e8 0c             	shr    $0xc,%eax
  801f0d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801f10:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f15:	85 c0                	test   %eax,%eax
  801f17:	75 0a                	jne    801f23 <smalloc+0x62>
		return NULL;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	e9 fc 00 00 00       	jmp    80201f <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801f23:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	74 0f                	je     801f3b <smalloc+0x7a>
  801f2c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f32:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f37:	39 c2                	cmp    %eax,%edx
  801f39:	73 0a                	jae    801f45 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f3b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f40:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801f45:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f4a:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f4f:	29 c2                	sub    %eax,%edx
  801f51:	89 d0                	mov    %edx,%eax
  801f53:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801f56:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f5c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f61:	29 c2                	sub    %eax,%edx
  801f63:	89 d0                	mov    %edx,%eax
  801f65:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f6e:	77 13                	ja     801f83 <smalloc+0xc2>
  801f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f73:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f76:	77 0b                	ja     801f83 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7b:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f7e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f81:	73 0a                	jae    801f8d <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	e9 92 00 00 00       	jmp    80201f <smalloc+0x15e>
	}

	void *va = NULL;
  801f8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801f94:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801f99:	83 f8 05             	cmp    $0x5,%eax
  801f9c:	75 11                	jne    801faf <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa4:	e8 08 f7 ff ff       	call   8016b1 <alloc_pages_custom_fit>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801faf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb3:	75 27                	jne    801fdc <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801fb5:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fbf:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801fc2:	89 c2                	mov    %eax,%edx
  801fc4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fc9:	39 c2                	cmp    %eax,%edx
  801fcb:	73 07                	jae    801fd4 <smalloc+0x113>
			return NULL;}
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	eb 4b                	jmp    80201f <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801fd4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801fdc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fe0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe3:	50                   	push   %eax
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	e8 cb 03 00 00       	call   8023ba <sys_create_shared_object>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801ff5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ff9:	79 07                	jns    802002 <smalloc+0x141>
		return NULL;
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  802000:	eb 1d                	jmp    80201f <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802002:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802007:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80200a:	75 10                	jne    80201c <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80200c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	01 d0                	add    %edx,%eax
  802017:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802027:	e8 d4 fa ff ff       	call   801b00 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80202c:	83 ec 08             	sub    $0x8,%esp
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	ff 75 08             	pushl  0x8(%ebp)
  802035:	e8 aa 03 00 00       	call   8023e4 <sys_size_of_shared_object>
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802040:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802044:	7f 0a                	jg     802050 <sget+0x2f>
		return NULL;
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	e9 32 01 00 00       	jmp    802182 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802053:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802059:	25 ff 0f 00 00       	and    $0xfff,%eax
  80205e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802061:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802065:	74 0e                	je     802075 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80206d:	05 00 10 00 00       	add    $0x1000,%eax
  802072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802075:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 0a                	jne    802088 <sget+0x67>
		return NULL;
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	e9 fa 00 00 00       	jmp    802182 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802088:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	74 0f                	je     8020a0 <sget+0x7f>
  802091:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802097:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80209c:	39 c2                	cmp    %eax,%edx
  80209e:	73 0a                	jae    8020aa <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8020a0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020a5:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020aa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020af:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020b4:	29 c2                	sub    %eax,%edx
  8020b6:	89 d0                	mov    %edx,%eax
  8020b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020bb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020c1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020c6:	29 c2                	sub    %eax,%edx
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020d3:	77 13                	ja     8020e8 <sget+0xc7>
  8020d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020db:	77 0b                	ja     8020e8 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8020dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e0:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020e6:	73 0a                	jae    8020f2 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ed:	e9 90 00 00 00       	jmp    802182 <sget+0x161>

	void *va = NULL;
  8020f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8020f9:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8020fe:	83 f8 05             	cmp    $0x5,%eax
  802101:	75 11                	jne    802114 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802103:	83 ec 0c             	sub    $0xc,%esp
  802106:	ff 75 f4             	pushl  -0xc(%ebp)
  802109:	e8 a3 f5 ff ff       	call   8016b1 <alloc_pages_custom_fit>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802114:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802118:	75 27                	jne    802141 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80211a:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802121:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802124:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802127:	89 c2                	mov    %eax,%edx
  802129:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80212e:	39 c2                	cmp    %eax,%edx
  802130:	73 07                	jae    802139 <sget+0x118>
			return NULL;
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	eb 49                	jmp    802182 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802139:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80213e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	ff 75 f0             	pushl  -0x10(%ebp)
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	e8 af 02 00 00       	call   802401 <sys_get_shared_object>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802158:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80215c:	79 07                	jns    802165 <sget+0x144>
		return NULL;
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	eb 1d                	jmp    802182 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802165:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80216a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80216d:	75 10                	jne    80217f <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80216f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	01 d0                	add    %edx,%eax
  80217a:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80218a:	e8 71 f9 ff ff       	call   801b00 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	68 f4 41 80 00       	push   $0x8041f4
  802197:	68 19 02 00 00       	push   $0x219
  80219c:	68 d1 3d 80 00       	push   $0x803dd1
  8021a1:	e8 42 e1 ff ff       	call   8002e8 <_panic>

008021a6 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	68 1c 42 80 00       	push   $0x80421c
  8021b4:	68 2b 02 00 00       	push   $0x22b
  8021b9:	68 d1 3d 80 00       	push   $0x803dd1
  8021be:	e8 25 e1 ff ff       	call   8002e8 <_panic>

008021c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	57                   	push   %edi
  8021c7:	56                   	push   %esi
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021db:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021de:	cd 30                	int    $0x30
  8021e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8021e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	5b                   	pop    %ebx
  8021ea:	5e                   	pop    %esi
  8021eb:	5f                   	pop    %edi
  8021ec:	5d                   	pop    %ebp
  8021ed:	c3                   	ret    

008021ee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8021fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	51                   	push   %ecx
  802207:	52                   	push   %edx
  802208:	ff 75 0c             	pushl  0xc(%ebp)
  80220b:	50                   	push   %eax
  80220c:	6a 00                	push   $0x0
  80220e:	e8 b0 ff ff ff       	call   8021c3 <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	90                   	nop
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_cgetc>:

int
sys_cgetc(void)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 02                	push   $0x2
  802228:	e8 96 ff ff ff       	call   8021c3 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 03                	push   $0x3
  802241:	e8 7d ff ff ff       	call   8021c3 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	90                   	nop
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 04                	push   $0x4
  80225b:	e8 63 ff ff ff       	call   8021c3 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	52                   	push   %edx
  802276:	50                   	push   %eax
  802277:	6a 08                	push   $0x8
  802279:	e8 45 ff ff ff       	call   8021c3 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802288:	8b 75 18             	mov    0x18(%ebp),%esi
  80228b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80228e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802291:	8b 55 0c             	mov    0xc(%ebp),%edx
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	56                   	push   %esi
  802298:	53                   	push   %ebx
  802299:	51                   	push   %ecx
  80229a:	52                   	push   %edx
  80229b:	50                   	push   %eax
  80229c:	6a 09                	push   $0x9
  80229e:	e8 20 ff ff ff       	call   8021c3 <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
}
  8022a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5d                   	pop    %ebp
  8022ac:	c3                   	ret    

008022ad <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	ff 75 08             	pushl  0x8(%ebp)
  8022bb:	6a 0a                	push   $0xa
  8022bd:	e8 01 ff ff ff       	call   8021c3 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	ff 75 0c             	pushl  0xc(%ebp)
  8022d3:	ff 75 08             	pushl  0x8(%ebp)
  8022d6:	6a 0b                	push   $0xb
  8022d8:	e8 e6 fe ff ff       	call   8021c3 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 0c                	push   $0xc
  8022f1:	e8 cd fe ff ff       	call   8021c3 <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 0d                	push   $0xd
  80230a:	e8 b4 fe ff ff       	call   8021c3 <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 0e                	push   $0xe
  802323:	e8 9b fe ff ff       	call   8021c3 <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 0f                	push   $0xf
  80233c:	e8 82 fe ff ff       	call   8021c3 <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	ff 75 08             	pushl  0x8(%ebp)
  802354:	6a 10                	push   $0x10
  802356:	e8 68 fe ff ff       	call   8021c3 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 11                	push   $0x11
  80236f:	e8 4f fe ff ff       	call   8021c3 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	90                   	nop
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_cputc>:

void
sys_cputc(const char c)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 04             	sub    $0x4,%esp
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802386:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	50                   	push   %eax
  802393:	6a 01                	push   $0x1
  802395:	e8 29 fe ff ff       	call   8021c3 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	90                   	nop
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 14                	push   $0x14
  8023af:	e8 0f fe ff ff       	call   8021c3 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
}
  8023b7:	90                   	nop
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 04             	sub    $0x4,%esp
  8023c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	6a 00                	push   $0x0
  8023d2:	51                   	push   %ecx
  8023d3:	52                   	push   %edx
  8023d4:	ff 75 0c             	pushl  0xc(%ebp)
  8023d7:	50                   	push   %eax
  8023d8:	6a 15                	push   $0x15
  8023da:	e8 e4 fd ff ff       	call   8021c3 <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	52                   	push   %edx
  8023f4:	50                   	push   %eax
  8023f5:	6a 16                	push   $0x16
  8023f7:	e8 c7 fd ff ff       	call   8021c3 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802404:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	51                   	push   %ecx
  802412:	52                   	push   %edx
  802413:	50                   	push   %eax
  802414:	6a 17                	push   $0x17
  802416:	e8 a8 fd ff ff       	call   8021c3 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802423:	8b 55 0c             	mov    0xc(%ebp),%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 18                	push   $0x18
  802433:	e8 8b fd ff ff       	call   8021c3 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	6a 00                	push   $0x0
  802445:	ff 75 14             	pushl  0x14(%ebp)
  802448:	ff 75 10             	pushl  0x10(%ebp)
  80244b:	ff 75 0c             	pushl  0xc(%ebp)
  80244e:	50                   	push   %eax
  80244f:	6a 19                	push   $0x19
  802451:	e8 6d fd ff ff       	call   8021c3 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	50                   	push   %eax
  80246a:	6a 1a                	push   $0x1a
  80246c:	e8 52 fd ff ff       	call   8021c3 <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	90                   	nop
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	50                   	push   %eax
  802486:	6a 1b                	push   $0x1b
  802488:	e8 36 fd ff ff       	call   8021c3 <syscall>
  80248d:	83 c4 18             	add    $0x18,%esp
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 05                	push   $0x5
  8024a1:	e8 1d fd ff ff       	call   8021c3 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 06                	push   $0x6
  8024ba:	e8 04 fd ff ff       	call   8021c3 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 07                	push   $0x7
  8024d3:	e8 eb fc ff ff       	call   8021c3 <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <sys_exit_env>:


void sys_exit_env(void)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 1c                	push   $0x1c
  8024ec:	e8 d2 fc ff ff       	call   8021c3 <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
}
  8024f4:	90                   	nop
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802500:	8d 50 04             	lea    0x4(%eax),%edx
  802503:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	52                   	push   %edx
  80250d:	50                   	push   %eax
  80250e:	6a 1d                	push   $0x1d
  802510:	e8 ae fc ff ff       	call   8021c3 <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
	return result;
  802518:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80251e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802521:	89 01                	mov    %eax,(%ecx)
  802523:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	c9                   	leave  
  80252a:	c2 04 00             	ret    $0x4

0080252d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	ff 75 10             	pushl  0x10(%ebp)
  802537:	ff 75 0c             	pushl  0xc(%ebp)
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	6a 13                	push   $0x13
  80253f:	e8 7f fc ff ff       	call   8021c3 <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
	return ;
  802547:	90                   	nop
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_rcr2>:
uint32 sys_rcr2()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 1e                	push   $0x1e
  802559:	e8 65 fc ff ff       	call   8021c3 <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80256f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	50                   	push   %eax
  80257c:	6a 1f                	push   $0x1f
  80257e:	e8 40 fc ff ff       	call   8021c3 <syscall>
  802583:	83 c4 18             	add    $0x18,%esp
	return ;
  802586:	90                   	nop
}
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <rsttst>:
void rsttst()
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 21                	push   $0x21
  802598:	e8 26 fc ff ff       	call   8021c3 <syscall>
  80259d:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a0:	90                   	nop
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 04             	sub    $0x4,%esp
  8025a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8025ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025af:	8b 55 18             	mov    0x18(%ebp),%edx
  8025b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025b6:	52                   	push   %edx
  8025b7:	50                   	push   %eax
  8025b8:	ff 75 10             	pushl  0x10(%ebp)
  8025bb:	ff 75 0c             	pushl  0xc(%ebp)
  8025be:	ff 75 08             	pushl  0x8(%ebp)
  8025c1:	6a 20                	push   $0x20
  8025c3:	e8 fb fb ff ff       	call   8021c3 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cb:	90                   	nop
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <chktst>:
void chktst(uint32 n)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	ff 75 08             	pushl  0x8(%ebp)
  8025dc:	6a 22                	push   $0x22
  8025de:	e8 e0 fb ff ff       	call   8021c3 <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e6:	90                   	nop
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <inctst>:

void inctst()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 23                	push   $0x23
  8025f8:	e8 c6 fb ff ff       	call   8021c3 <syscall>
  8025fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802600:	90                   	nop
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <gettst>:
uint32 gettst()
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 24                	push   $0x24
  802612:	e8 ac fb ff ff       	call   8021c3 <syscall>
  802617:	83 c4 18             	add    $0x18,%esp
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 25                	push   $0x25
  80262b:	e8 93 fb ff ff       	call   8021c3 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
  802633:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802638:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	ff 75 08             	pushl  0x8(%ebp)
  802655:	6a 26                	push   $0x26
  802657:	e8 67 fb ff ff       	call   8021c3 <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
	return ;
  80265f:	90                   	nop
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802666:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802669:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80266c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	6a 00                	push   $0x0
  802674:	53                   	push   %ebx
  802675:	51                   	push   %ecx
  802676:	52                   	push   %edx
  802677:	50                   	push   %eax
  802678:	6a 27                	push   $0x27
  80267a:	e8 44 fb ff ff       	call   8021c3 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
}
  802682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80268a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	52                   	push   %edx
  802697:	50                   	push   %eax
  802698:	6a 28                	push   $0x28
  80269a:	e8 24 fb ff ff       	call   8021c3 <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026a7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	6a 00                	push   $0x0
  8026b2:	51                   	push   %ecx
  8026b3:	ff 75 10             	pushl  0x10(%ebp)
  8026b6:	52                   	push   %edx
  8026b7:	50                   	push   %eax
  8026b8:	6a 29                	push   $0x29
  8026ba:	e8 04 fb ff ff       	call   8021c3 <syscall>
  8026bf:	83 c4 18             	add    $0x18,%esp
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	ff 75 10             	pushl  0x10(%ebp)
  8026ce:	ff 75 0c             	pushl  0xc(%ebp)
  8026d1:	ff 75 08             	pushl  0x8(%ebp)
  8026d4:	6a 12                	push   $0x12
  8026d6:	e8 e8 fa ff ff       	call   8021c3 <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
	return ;
  8026de:	90                   	nop
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	52                   	push   %edx
  8026f1:	50                   	push   %eax
  8026f2:	6a 2a                	push   $0x2a
  8026f4:	e8 ca fa ff ff       	call   8021c3 <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
	return;
  8026fc:	90                   	nop
}
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 2b                	push   $0x2b
  80270e:	e8 b0 fa ff ff       	call   8021c3 <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	ff 75 0c             	pushl  0xc(%ebp)
  802724:	ff 75 08             	pushl  0x8(%ebp)
  802727:	6a 2d                	push   $0x2d
  802729:	e8 95 fa ff ff       	call   8021c3 <syscall>
  80272e:	83 c4 18             	add    $0x18,%esp
	return;
  802731:	90                   	nop
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	ff 75 0c             	pushl  0xc(%ebp)
  802740:	ff 75 08             	pushl  0x8(%ebp)
  802743:	6a 2c                	push   $0x2c
  802745:	e8 79 fa ff ff       	call   8021c3 <syscall>
  80274a:	83 c4 18             	add    $0x18,%esp
	return ;
  80274d:	90                   	nop
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802753:	8b 55 0c             	mov    0xc(%ebp),%edx
  802756:	8b 45 08             	mov    0x8(%ebp),%eax
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	52                   	push   %edx
  802760:	50                   	push   %eax
  802761:	6a 2e                	push   $0x2e
  802763:	e8 5b fa ff ff       	call   8021c3 <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
	return ;
  80276b:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802774:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  80277b:	72 09                	jb     802786 <to_page_va+0x18>
  80277d:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802784:	72 14                	jb     80279a <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 40 42 80 00       	push   $0x804240
  80278e:	6a 15                	push   $0x15
  802790:	68 6b 42 80 00       	push   $0x80426b
  802795:	e8 4e db ff ff       	call   8002e8 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	ba 60 50 80 00       	mov    $0x805060,%edx
  8027a2:	29 d0                	sub    %edx,%eax
  8027a4:	c1 f8 02             	sar    $0x2,%eax
  8027a7:	89 c2                	mov    %eax,%edx
  8027a9:	89 d0                	mov    %edx,%eax
  8027ab:	c1 e0 02             	shl    $0x2,%eax
  8027ae:	01 d0                	add    %edx,%eax
  8027b0:	c1 e0 02             	shl    $0x2,%eax
  8027b3:	01 d0                	add    %edx,%eax
  8027b5:	c1 e0 02             	shl    $0x2,%eax
  8027b8:	01 d0                	add    %edx,%eax
  8027ba:	89 c1                	mov    %eax,%ecx
  8027bc:	c1 e1 08             	shl    $0x8,%ecx
  8027bf:	01 c8                	add    %ecx,%eax
  8027c1:	89 c1                	mov    %eax,%ecx
  8027c3:	c1 e1 10             	shl    $0x10,%ecx
  8027c6:	01 c8                	add    %ecx,%eax
  8027c8:	01 c0                	add    %eax,%eax
  8027ca:	01 d0                	add    %edx,%eax
  8027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	c1 e0 0c             	shl    $0xc,%eax
  8027d5:	89 c2                	mov    %eax,%edx
  8027d7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027dc:	01 d0                	add    %edx,%eax
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8027e6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ee:	29 c2                	sub    %eax,%edx
  8027f0:	89 d0                	mov    %edx,%eax
  8027f2:	c1 e8 0c             	shr    $0xc,%eax
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	78 09                	js     802807 <to_page_info+0x27>
  8027fe:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802805:	7e 14                	jle    80281b <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 84 42 80 00       	push   $0x804284
  80280f:	6a 22                	push   $0x22
  802811:	68 6b 42 80 00       	push   $0x80426b
  802816:	e8 cd da ff ff       	call   8002e8 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80281b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281e:	89 d0                	mov    %edx,%eax
  802820:	01 c0                	add    %eax,%eax
  802822:	01 d0                	add    %edx,%eax
  802824:	c1 e0 02             	shl    $0x2,%eax
  802827:	05 60 50 80 00       	add    $0x805060,%eax
}
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	05 00 00 00 02       	add    $0x2000000,%eax
  80283c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80283f:	73 16                	jae    802857 <initialize_dynamic_allocator+0x29>
  802841:	68 a8 42 80 00       	push   $0x8042a8
  802846:	68 ce 42 80 00       	push   $0x8042ce
  80284b:	6a 34                	push   $0x34
  80284d:	68 6b 42 80 00       	push   $0x80426b
  802852:	e8 91 da ff ff       	call   8002e8 <_panic>
		is_initialized = 1;
  802857:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  80285e:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286c:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802871:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802878:	00 00 00 
  80287b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802882:	00 00 00 
  802885:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  80288c:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  80288f:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80289d:	eb 36                	jmp    8028d5 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	c1 e0 04             	shl    $0x4,%eax
  8028a5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8028aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	c1 e0 04             	shl    $0x4,%eax
  8028b6:	05 84 d0 81 00       	add    $0x81d084,%eax
  8028bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	c1 e0 04             	shl    $0x4,%eax
  8028c7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8028cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8028d2:	ff 45 f4             	incl   -0xc(%ebp)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028db:	72 c2                	jb     80289f <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8028dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028e3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028e8:	29 c2                	sub    %eax,%edx
  8028ea:	89 d0                	mov    %edx,%eax
  8028ec:	c1 e8 0c             	shr    $0xc,%eax
  8028ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8028f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028f9:	e9 c8 00 00 00       	jmp    8029c6 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8028fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802901:	89 d0                	mov    %edx,%eax
  802903:	01 c0                	add    %eax,%eax
  802905:	01 d0                	add    %edx,%eax
  802907:	c1 e0 02             	shl    $0x2,%eax
  80290a:	05 68 50 80 00       	add    $0x805068,%eax
  80290f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802914:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802917:	89 d0                	mov    %edx,%eax
  802919:	01 c0                	add    %eax,%eax
  80291b:	01 d0                	add    %edx,%eax
  80291d:	c1 e0 02             	shl    $0x2,%eax
  802920:	05 6a 50 80 00       	add    $0x80506a,%eax
  802925:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80292a:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802930:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802933:	89 c8                	mov    %ecx,%eax
  802935:	01 c0                	add    %eax,%eax
  802937:	01 c8                	add    %ecx,%eax
  802939:	c1 e0 02             	shl    $0x2,%eax
  80293c:	05 64 50 80 00       	add    $0x805064,%eax
  802941:	89 10                	mov    %edx,(%eax)
  802943:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802946:	89 d0                	mov    %edx,%eax
  802948:	01 c0                	add    %eax,%eax
  80294a:	01 d0                	add    %edx,%eax
  80294c:	c1 e0 02             	shl    $0x2,%eax
  80294f:	05 64 50 80 00       	add    $0x805064,%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 1b                	je     802975 <initialize_dynamic_allocator+0x147>
  80295a:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802960:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802963:	89 c8                	mov    %ecx,%eax
  802965:	01 c0                	add    %eax,%eax
  802967:	01 c8                	add    %ecx,%eax
  802969:	c1 e0 02             	shl    $0x2,%eax
  80296c:	05 60 50 80 00       	add    $0x805060,%eax
  802971:	89 02                	mov    %eax,(%edx)
  802973:	eb 16                	jmp    80298b <initialize_dynamic_allocator+0x15d>
  802975:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802978:	89 d0                	mov    %edx,%eax
  80297a:	01 c0                	add    %eax,%eax
  80297c:	01 d0                	add    %edx,%eax
  80297e:	c1 e0 02             	shl    $0x2,%eax
  802981:	05 60 50 80 00       	add    $0x805060,%eax
  802986:	a3 48 50 80 00       	mov    %eax,0x805048
  80298b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298e:	89 d0                	mov    %edx,%eax
  802990:	01 c0                	add    %eax,%eax
  802992:	01 d0                	add    %edx,%eax
  802994:	c1 e0 02             	shl    $0x2,%eax
  802997:	05 60 50 80 00       	add    $0x805060,%eax
  80299c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a4:	89 d0                	mov    %edx,%eax
  8029a6:	01 c0                	add    %eax,%eax
  8029a8:	01 d0                	add    %edx,%eax
  8029aa:	c1 e0 02             	shl    $0x2,%eax
  8029ad:	05 60 50 80 00       	add    $0x805060,%eax
  8029b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b8:	a1 54 50 80 00       	mov    0x805054,%eax
  8029bd:	40                   	inc    %eax
  8029be:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8029c3:	ff 45 f0             	incl   -0x10(%ebp)
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029cc:	0f 82 2c ff ff ff    	jb     8028fe <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8029d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029d8:	eb 2f                	jmp    802a09 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8029da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029dd:	89 d0                	mov    %edx,%eax
  8029df:	01 c0                	add    %eax,%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	c1 e0 02             	shl    $0x2,%eax
  8029e6:	05 68 50 80 00       	add    $0x805068,%eax
  8029eb:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8029f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f3:	89 d0                	mov    %edx,%eax
  8029f5:	01 c0                	add    %eax,%eax
  8029f7:	01 d0                	add    %edx,%eax
  8029f9:	c1 e0 02             	shl    $0x2,%eax
  8029fc:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a01:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a06:	ff 45 ec             	incl   -0x14(%ebp)
  802a09:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802a10:	76 c8                	jbe    8029da <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802a12:	90                   	nop
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a23:	29 c2                	sub    %eax,%edx
  802a25:	89 d0                	mov    %edx,%eax
  802a27:	c1 e8 0c             	shr    $0xc,%eax
  802a2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802a2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a30:	89 d0                	mov    %edx,%eax
  802a32:	01 c0                	add    %eax,%eax
  802a34:	01 d0                	add    %edx,%eax
  802a36:	c1 e0 02             	shl    $0x2,%eax
  802a39:	05 68 50 80 00       	add    $0x805068,%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    

00802a45 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
  802a48:	83 ec 14             	sub    $0x14,%esp
  802a4b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802a4e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802a52:	77 07                	ja     802a5b <nearest_pow2_ceil.1513+0x16>
  802a54:	b8 01 00 00 00       	mov    $0x1,%eax
  802a59:	eb 20                	jmp    802a7b <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802a5b:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802a62:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802a65:	eb 08                	jmp    802a6f <nearest_pow2_ceil.1513+0x2a>
  802a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a6a:	01 c0                	add    %eax,%eax
  802a6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a6f:	d1 6d 08             	shrl   0x8(%ebp)
  802a72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a76:	75 ef                	jne    802a67 <nearest_pow2_ceil.1513+0x22>
        return power;
  802a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802a7b:	c9                   	leave  
  802a7c:	c3                   	ret    

00802a7d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802a7d:	55                   	push   %ebp
  802a7e:	89 e5                	mov    %esp,%ebp
  802a80:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802a83:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802a8a:	76 16                	jbe    802aa2 <alloc_block+0x25>
  802a8c:	68 e4 42 80 00       	push   $0x8042e4
  802a91:	68 ce 42 80 00       	push   $0x8042ce
  802a96:	6a 72                	push   $0x72
  802a98:	68 6b 42 80 00       	push   $0x80426b
  802a9d:	e8 46 d8 ff ff       	call   8002e8 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802aa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa6:	75 0a                	jne    802ab2 <alloc_block+0x35>
  802aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  802aad:	e9 bd 04 00 00       	jmp    802f6f <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802ab2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802abf:	73 06                	jae    802ac7 <alloc_block+0x4a>
        size = min_block_size;
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802ac7:	83 ec 0c             	sub    $0xc,%esp
  802aca:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802acd:	ff 75 08             	pushl  0x8(%ebp)
  802ad0:	89 c1                	mov    %eax,%ecx
  802ad2:	e8 6e ff ff ff       	call   802a45 <nearest_pow2_ceil.1513>
  802ad7:	83 c4 10             	add    $0x10,%esp
  802ada:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802add:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ae0:	83 ec 0c             	sub    $0xc,%esp
  802ae3:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802ae6:	52                   	push   %edx
  802ae7:	89 c1                	mov    %eax,%ecx
  802ae9:	e8 83 04 00 00       	call   802f71 <log2_ceil.1520>
  802aee:	83 c4 10             	add    $0x10,%esp
  802af1:	83 e8 03             	sub    $0x3,%eax
  802af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802afa:	c1 e0 04             	shl    $0x4,%eax
  802afd:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	0f 84 d8 00 00 00    	je     802be4 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0f:	c1 e0 04             	shl    $0x4,%eax
  802b12:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b20:	75 17                	jne    802b39 <alloc_block+0xbc>
  802b22:	83 ec 04             	sub    $0x4,%esp
  802b25:	68 05 43 80 00       	push   $0x804305
  802b2a:	68 98 00 00 00       	push   $0x98
  802b2f:	68 6b 42 80 00       	push   $0x80426b
  802b34:	e8 af d7 ff ff       	call   8002e8 <_panic>
  802b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 10                	je     802b52 <alloc_block+0xd5>
  802b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b4a:	8b 52 04             	mov    0x4(%edx),%edx
  802b4d:	89 50 04             	mov    %edx,0x4(%eax)
  802b50:	eb 14                	jmp    802b66 <alloc_block+0xe9>
  802b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b5b:	c1 e2 04             	shl    $0x4,%edx
  802b5e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802b64:	89 02                	mov    %eax,(%edx)
  802b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 0f                	je     802b7f <alloc_block+0x102>
  802b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b79:	8b 12                	mov    (%edx),%edx
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	eb 13                	jmp    802b92 <alloc_block+0x115>
  802b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b87:	c1 e2 04             	shl    $0x4,%edx
  802b8a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802b90:	89 02                	mov    %eax,(%edx)
  802b92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba8:	c1 e0 04             	shl    $0x4,%eax
  802bab:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  802bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb8:	c1 e0 04             	shl    $0x4,%eax
  802bbb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bc0:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc5:	83 ec 0c             	sub    $0xc,%esp
  802bc8:	50                   	push   %eax
  802bc9:	e8 12 fc ff ff       	call   8027e0 <to_page_info>
  802bce:	83 c4 10             	add    $0x10,%esp
  802bd1:	89 c2                	mov    %eax,%edx
  802bd3:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802bd7:	48                   	dec    %eax
  802bd8:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802bdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdf:	e9 8b 03 00 00       	jmp    802f6f <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802be4:	a1 48 50 80 00       	mov    0x805048,%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	0f 84 64 02 00 00    	je     802e55 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802bf1:	a1 48 50 80 00       	mov    0x805048,%eax
  802bf6:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802bf9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bfd:	75 17                	jne    802c16 <alloc_block+0x199>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 05 43 80 00       	push   $0x804305
  802c07:	68 a0 00 00 00       	push   $0xa0
  802c0c:	68 6b 42 80 00       	push   $0x80426b
  802c11:	e8 d2 d6 ff ff       	call   8002e8 <_panic>
  802c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 10                	je     802c2f <alloc_block+0x1b2>
  802c1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c27:	8b 52 04             	mov    0x4(%edx),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	eb 0b                	jmp    802c3a <alloc_block+0x1bd>
  802c2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0f                	je     802c53 <alloc_block+0x1d6>
  802c44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c4d:	8b 12                	mov    (%edx),%edx
  802c4f:	89 10                	mov    %edx,(%eax)
  802c51:	eb 0a                	jmp    802c5d <alloc_block+0x1e0>
  802c53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	a3 48 50 80 00       	mov    %eax,0x805048
  802c5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c70:	a1 54 50 80 00       	mov    0x805054,%eax
  802c75:	48                   	dec    %eax
  802c76:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c81:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802c85:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c8a:	99                   	cltd   
  802c8b:	f7 7d e8             	idivl  -0x18(%ebp)
  802c8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c91:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802c95:	83 ec 0c             	sub    $0xc,%esp
  802c98:	ff 75 dc             	pushl  -0x24(%ebp)
  802c9b:	e8 ce fa ff ff       	call   80276e <to_page_va>
  802ca0:	83 c4 10             	add    $0x10,%esp
  802ca3:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802ca6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ca9:	83 ec 0c             	sub    $0xc,%esp
  802cac:	50                   	push   %eax
  802cad:	e8 c0 ee ff ff       	call   801b72 <get_page>
  802cb2:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802cb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cbc:	e9 aa 00 00 00       	jmp    802d6b <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802cc8:	89 c2                	mov    %eax,%edx
  802cca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ccd:	01 d0                	add    %edx,%eax
  802ccf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802cd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802cd6:	75 17                	jne    802cef <alloc_block+0x272>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 24 43 80 00       	push   $0x804324
  802ce0:	68 aa 00 00 00       	push   $0xaa
  802ce5:	68 6b 42 80 00       	push   $0x80426b
  802cea:	e8 f9 d5 ff ff       	call   8002e8 <_panic>
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	c1 e0 04             	shl    $0x4,%eax
  802cf5:	05 84 d0 81 00       	add    $0x81d084,%eax
  802cfa:	8b 10                	mov    (%eax),%edx
  802cfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cff:	89 50 04             	mov    %edx,0x4(%eax)
  802d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d05:	8b 40 04             	mov    0x4(%eax),%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	74 14                	je     802d20 <alloc_block+0x2a3>
  802d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0f:	c1 e0 04             	shl    $0x4,%eax
  802d12:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d1c:	89 10                	mov    %edx,(%eax)
  802d1e:	eb 11                	jmp    802d31 <alloc_block+0x2b4>
  802d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d23:	c1 e0 04             	shl    $0x4,%eax
  802d26:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802d2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d2f:	89 02                	mov    %eax,(%edx)
  802d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d34:	c1 e0 04             	shl    $0x4,%eax
  802d37:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d40:	89 02                	mov    %eax,(%edx)
  802d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4e:	c1 e0 04             	shl    $0x4,%eax
  802d51:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	8d 50 01             	lea    0x1(%eax),%edx
  802d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5e:	c1 e0 04             	shl    $0x4,%eax
  802d61:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d66:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d68:	ff 45 f4             	incl   -0xc(%ebp)
  802d6b:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d70:	99                   	cltd   
  802d71:	f7 7d e8             	idivl  -0x18(%ebp)
  802d74:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d77:	0f 8f 44 ff ff ff    	jg     802cc1 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d80:	c1 e0 04             	shl    $0x4,%eax
  802d83:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802d8d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802d91:	75 17                	jne    802daa <alloc_block+0x32d>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 05 43 80 00       	push   $0x804305
  802d9b:	68 ae 00 00 00       	push   $0xae
  802da0:	68 6b 42 80 00       	push   $0x80426b
  802da5:	e8 3e d5 ff ff       	call   8002e8 <_panic>
  802daa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 10                	je     802dc3 <alloc_block+0x346>
  802db3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dbb:	8b 52 04             	mov    0x4(%edx),%edx
  802dbe:	89 50 04             	mov    %edx,0x4(%eax)
  802dc1:	eb 14                	jmp    802dd7 <alloc_block+0x35a>
  802dc3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dcc:	c1 e2 04             	shl    $0x4,%edx
  802dcf:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802dd5:	89 02                	mov    %eax,(%edx)
  802dd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0f                	je     802df0 <alloc_block+0x373>
  802de1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dea:	8b 12                	mov    (%edx),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	eb 13                	jmp    802e03 <alloc_block+0x386>
  802df0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802df8:	c1 e2 04             	shl    $0x4,%edx
  802dfb:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e01:	89 02                	mov    %eax,(%edx)
  802e03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e19:	c1 e0 04             	shl    $0x4,%eax
  802e1c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e29:	c1 e0 04             	shl    $0x4,%eax
  802e2c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e31:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e33:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	50                   	push   %eax
  802e3a:	e8 a1 f9 ff ff       	call   8027e0 <to_page_info>
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	89 c2                	mov    %eax,%edx
  802e44:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e48:	48                   	dec    %eax
  802e49:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802e4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e50:	e9 1a 01 00 00       	jmp    802f6f <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e58:	40                   	inc    %eax
  802e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e5c:	e9 ed 00 00 00       	jmp    802f4e <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	c1 e0 04             	shl    $0x4,%eax
  802e67:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	0f 84 d5 00 00 00    	je     802f4b <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	c1 e0 04             	shl    $0x4,%eax
  802e7c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802e86:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e8a:	75 17                	jne    802ea3 <alloc_block+0x426>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 05 43 80 00       	push   $0x804305
  802e94:	68 b8 00 00 00       	push   $0xb8
  802e99:	68 6b 42 80 00       	push   $0x80426b
  802e9e:	e8 45 d4 ff ff       	call   8002e8 <_panic>
  802ea3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	74 10                	je     802ebc <alloc_block+0x43f>
  802eac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eb4:	8b 52 04             	mov    0x4(%edx),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 14                	jmp    802ed0 <alloc_block+0x453>
  802ebc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec5:	c1 e2 04             	shl    $0x4,%edx
  802ec8:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ece:	89 02                	mov    %eax,(%edx)
  802ed0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 0f                	je     802ee9 <alloc_block+0x46c>
  802eda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ee3:	8b 12                	mov    (%edx),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 13                	jmp    802efc <alloc_block+0x47f>
  802ee9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef1:	c1 e2 04             	shl    $0x4,%edx
  802ef4:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802efa:	89 02                	mov    %eax,(%edx)
  802efc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	c1 e0 04             	shl    $0x4,%eax
  802f15:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	c1 e0 04             	shl    $0x4,%eax
  802f25:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f2a:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802f2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f2f:	83 ec 0c             	sub    $0xc,%esp
  802f32:	50                   	push   %eax
  802f33:	e8 a8 f8 ff ff       	call   8027e0 <to_page_info>
  802f38:	83 c4 10             	add    $0x10,%esp
  802f3b:	89 c2                	mov    %eax,%edx
  802f3d:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f41:	48                   	dec    %eax
  802f42:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802f46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f49:	eb 24                	jmp    802f6f <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f4b:	ff 45 f0             	incl   -0x10(%ebp)
  802f4e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802f52:	0f 8e 09 ff ff ff    	jle    802e61 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802f58:	83 ec 04             	sub    $0x4,%esp
  802f5b:	68 47 43 80 00       	push   $0x804347
  802f60:	68 bf 00 00 00       	push   $0xbf
  802f65:	68 6b 42 80 00       	push   $0x80426b
  802f6a:	e8 79 d3 ff ff       	call   8002e8 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802f6f:	c9                   	leave  
  802f70:	c3                   	ret    

00802f71 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
  802f74:	83 ec 14             	sub    $0x14,%esp
  802f77:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802f7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7e:	75 07                	jne    802f87 <log2_ceil.1520+0x16>
  802f80:	b8 00 00 00 00       	mov    $0x0,%eax
  802f85:	eb 1b                	jmp    802fa2 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802f8e:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802f91:	eb 06                	jmp    802f99 <log2_ceil.1520+0x28>
            x >>= 1;
  802f93:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802f96:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802f99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9d:	75 f4                	jne    802f93 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802fa2:	c9                   	leave  
  802fa3:	c3                   	ret    

00802fa4 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802fa4:	55                   	push   %ebp
  802fa5:	89 e5                	mov    %esp,%ebp
  802fa7:	83 ec 14             	sub    $0x14,%esp
  802faa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb1:	75 07                	jne    802fba <log2_ceil.1547+0x16>
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	eb 1b                	jmp    802fd5 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802fba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802fc1:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802fc4:	eb 06                	jmp    802fcc <log2_ceil.1547+0x28>
			x >>= 1;
  802fc6:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802fc9:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802fcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd0:	75 f4                	jne    802fc6 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
  802fda:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fe5:	39 c2                	cmp    %eax,%edx
  802fe7:	72 0c                	jb     802ff5 <free_block+0x1e>
  802fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fec:	a1 40 50 80 00       	mov    0x805040,%eax
  802ff1:	39 c2                	cmp    %eax,%edx
  802ff3:	72 19                	jb     80300e <free_block+0x37>
  802ff5:	68 4c 43 80 00       	push   $0x80434c
  802ffa:	68 ce 42 80 00       	push   $0x8042ce
  802fff:	68 d0 00 00 00       	push   $0xd0
  803004:	68 6b 42 80 00       	push   $0x80426b
  803009:	e8 da d2 ff ff       	call   8002e8 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80300e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803012:	0f 84 42 03 00 00    	je     80335a <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803018:	8b 55 08             	mov    0x8(%ebp),%edx
  80301b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803020:	39 c2                	cmp    %eax,%edx
  803022:	72 0c                	jb     803030 <free_block+0x59>
  803024:	8b 55 08             	mov    0x8(%ebp),%edx
  803027:	a1 40 50 80 00       	mov    0x805040,%eax
  80302c:	39 c2                	cmp    %eax,%edx
  80302e:	72 17                	jb     803047 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 84 43 80 00       	push   $0x804384
  803038:	68 e6 00 00 00       	push   $0xe6
  80303d:	68 6b 42 80 00       	push   $0x80426b
  803042:	e8 a1 d2 ff ff       	call   8002e8 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803047:	8b 55 08             	mov    0x8(%ebp),%edx
  80304a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80304f:	29 c2                	sub    %eax,%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	83 e0 07             	and    $0x7,%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 17                	je     803071 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80305a:	83 ec 04             	sub    $0x4,%esp
  80305d:	68 b8 43 80 00       	push   $0x8043b8
  803062:	68 ea 00 00 00       	push   $0xea
  803067:	68 6b 42 80 00       	push   $0x80426b
  80306c:	e8 77 d2 ff ff       	call   8002e8 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	83 ec 0c             	sub    $0xc,%esp
  803077:	50                   	push   %eax
  803078:	e8 63 f7 ff ff       	call   8027e0 <to_page_info>
  80307d:	83 c4 10             	add    $0x10,%esp
  803080:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803083:	83 ec 0c             	sub    $0xc,%esp
  803086:	ff 75 08             	pushl  0x8(%ebp)
  803089:	e8 87 f9 ff ff       	call   802a15 <get_block_size>
  80308e:	83 c4 10             	add    $0x10,%esp
  803091:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803094:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803098:	75 17                	jne    8030b1 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 e4 43 80 00       	push   $0x8043e4
  8030a2:	68 f1 00 00 00       	push   $0xf1
  8030a7:	68 6b 42 80 00       	push   $0x80426b
  8030ac:	e8 37 d2 ff ff       	call   8002e8 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8030b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b4:	83 ec 0c             	sub    $0xc,%esp
  8030b7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8030ba:	52                   	push   %edx
  8030bb:	89 c1                	mov    %eax,%ecx
  8030bd:	e8 e2 fe ff ff       	call   802fa4 <log2_ceil.1547>
  8030c2:	83 c4 10             	add    $0x10,%esp
  8030c5:	83 e8 03             	sub    $0x3,%eax
  8030c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8030d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030d5:	75 17                	jne    8030ee <free_block+0x117>
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	68 30 44 80 00       	push   $0x804430
  8030df:	68 f6 00 00 00       	push   $0xf6
  8030e4:	68 6b 42 80 00       	push   $0x80426b
  8030e9:	e8 fa d1 ff ff       	call   8002e8 <_panic>
  8030ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f1:	c1 e0 04             	shl    $0x4,%eax
  8030f4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030f9:	8b 10                	mov    (%eax),%edx
  8030fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 15                	je     80311e <free_block+0x147>
  803109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310c:	c1 e0 04             	shl    $0x4,%eax
  80310f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803119:	89 50 04             	mov    %edx,0x4(%eax)
  80311c:	eb 11                	jmp    80312f <free_block+0x158>
  80311e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803121:	c1 e0 04             	shl    $0x4,%eax
  803124:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80312a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80312d:	89 02                	mov    %eax,(%edx)
  80312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803132:	c1 e0 04             	shl    $0x4,%eax
  803135:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80313b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313e:	89 02                	mov    %eax,(%edx)
  803140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314d:	c1 e0 04             	shl    $0x4,%eax
  803150:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	8d 50 01             	lea    0x1(%eax),%edx
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	c1 e0 04             	shl    $0x4,%eax
  803160:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803165:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80316e:	40                   	inc    %eax
  80316f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803172:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803176:	8b 55 08             	mov    0x8(%ebp),%edx
  803179:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80317e:	29 c2                	sub    %eax,%edx
  803180:	89 d0                	mov    %edx,%eax
  803182:	c1 e8 0c             	shr    $0xc,%eax
  803185:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80318f:	0f b7 c8             	movzwl %ax,%ecx
  803192:	b8 00 10 00 00       	mov    $0x1000,%eax
  803197:	99                   	cltd   
  803198:	f7 7d e8             	idivl  -0x18(%ebp)
  80319b:	39 c1                	cmp    %eax,%ecx
  80319d:	0f 85 b8 01 00 00    	jne    80335b <free_block+0x384>
    	uint32 blocks_removed = 0;
  8031a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8031aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ad:	c1 e0 04             	shl    $0x4,%eax
  8031b0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8031ba:	e9 d5 00 00 00       	jmp    803294 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8031c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ca:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031cf:	29 c2                	sub    %eax,%edx
  8031d1:	89 d0                	mov    %edx,%eax
  8031d3:	c1 e8 0c             	shr    $0xc,%eax
  8031d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8031d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031dc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8031df:	0f 85 a9 00 00 00    	jne    80328e <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8031e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e9:	75 17                	jne    803202 <free_block+0x22b>
  8031eb:	83 ec 04             	sub    $0x4,%esp
  8031ee:	68 05 43 80 00       	push   $0x804305
  8031f3:	68 04 01 00 00       	push   $0x104
  8031f8:	68 6b 42 80 00       	push   $0x80426b
  8031fd:	e8 e6 d0 ff ff       	call   8002e8 <_panic>
  803202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803205:	8b 00                	mov    (%eax),%eax
  803207:	85 c0                	test   %eax,%eax
  803209:	74 10                	je     80321b <free_block+0x244>
  80320b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803213:	8b 52 04             	mov    0x4(%edx),%edx
  803216:	89 50 04             	mov    %edx,0x4(%eax)
  803219:	eb 14                	jmp    80322f <free_block+0x258>
  80321b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321e:	8b 40 04             	mov    0x4(%eax),%eax
  803221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803224:	c1 e2 04             	shl    $0x4,%edx
  803227:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80322d:	89 02                	mov    %eax,(%edx)
  80322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803232:	8b 40 04             	mov    0x4(%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 0f                	je     803248 <free_block+0x271>
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803242:	8b 12                	mov    (%edx),%edx
  803244:	89 10                	mov    %edx,(%eax)
  803246:	eb 13                	jmp    80325b <free_block+0x284>
  803248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803250:	c1 e2 04             	shl    $0x4,%edx
  803253:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803259:	89 02                	mov    %eax,(%edx)
  80325b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803271:	c1 e0 04             	shl    $0x4,%eax
  803274:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80327e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803281:	c1 e0 04             	shl    $0x4,%eax
  803284:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803289:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80328b:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80328e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803291:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803298:	0f 85 21 ff ff ff    	jne    8031bf <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80329e:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032a3:	99                   	cltd   
  8032a4:	f7 7d e8             	idivl  -0x18(%ebp)
  8032a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032aa:	74 17                	je     8032c3 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 54 44 80 00       	push   $0x804454
  8032b4:	68 0c 01 00 00       	push   $0x10c
  8032b9:	68 6b 42 80 00       	push   $0x80426b
  8032be:	e8 25 d0 ff ff       	call   8002e8 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8032cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cf:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8032d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032d9:	75 17                	jne    8032f2 <free_block+0x31b>
  8032db:	83 ec 04             	sub    $0x4,%esp
  8032de:	68 24 43 80 00       	push   $0x804324
  8032e3:	68 11 01 00 00       	push   $0x111
  8032e8:	68 6b 42 80 00       	push   $0x80426b
  8032ed:	e8 f6 cf ff ff       	call   8002e8 <_panic>
  8032f2:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fb:	89 50 04             	mov    %edx,0x4(%eax)
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 0c                	je     803314 <free_block+0x33d>
  803308:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80330d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803310:	89 10                	mov    %edx,(%eax)
  803312:	eb 08                	jmp    80331c <free_block+0x345>
  803314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803317:	a3 48 50 80 00       	mov    %eax,0x805048
  80331c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803324:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332d:	a1 54 50 80 00       	mov    0x805054,%eax
  803332:	40                   	inc    %eax
  803333:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803338:	83 ec 0c             	sub    $0xc,%esp
  80333b:	ff 75 ec             	pushl  -0x14(%ebp)
  80333e:	e8 2b f4 ff ff       	call   80276e <to_page_va>
  803343:	83 c4 10             	add    $0x10,%esp
  803346:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803349:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80334c:	83 ec 0c             	sub    $0xc,%esp
  80334f:	50                   	push   %eax
  803350:	e8 69 e8 ff ff       	call   801bbe <return_page>
  803355:	83 c4 10             	add    $0x10,%esp
  803358:	eb 01                	jmp    80335b <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80335a:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
  803360:	83 ec 14             	sub    $0x14,%esp
  803363:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803366:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80336a:	77 07                	ja     803373 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80336c:	b8 01 00 00 00       	mov    $0x1,%eax
  803371:	eb 20                	jmp    803393 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803373:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80337a:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  80337d:	eb 08                	jmp    803387 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  80337f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803382:	01 c0                	add    %eax,%eax
  803384:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803387:	d1 6d 08             	shrl   0x8(%ebp)
  80338a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338e:	75 ef                	jne    80337f <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803393:	c9                   	leave  
  803394:	c3                   	ret    

00803395 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803395:	55                   	push   %ebp
  803396:	89 e5                	mov    %esp,%ebp
  803398:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80339b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339f:	75 13                	jne    8033b4 <realloc_block+0x1f>
    return alloc_block(new_size);
  8033a1:	83 ec 0c             	sub    $0xc,%esp
  8033a4:	ff 75 0c             	pushl  0xc(%ebp)
  8033a7:	e8 d1 f6 ff ff       	call   802a7d <alloc_block>
  8033ac:	83 c4 10             	add    $0x10,%esp
  8033af:	e9 d9 00 00 00       	jmp    80348d <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8033b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b8:	75 18                	jne    8033d2 <realloc_block+0x3d>
    free_block(va);
  8033ba:	83 ec 0c             	sub    $0xc,%esp
  8033bd:	ff 75 08             	pushl  0x8(%ebp)
  8033c0:	e8 12 fc ff ff       	call   802fd7 <free_block>
  8033c5:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8033c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cd:	e9 bb 00 00 00       	jmp    80348d <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8033d2:	83 ec 0c             	sub    $0xc,%esp
  8033d5:	ff 75 08             	pushl  0x8(%ebp)
  8033d8:	e8 38 f6 ff ff       	call   802a15 <get_block_size>
  8033dd:	83 c4 10             	add    $0x10,%esp
  8033e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8033e3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8033ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8033f0:	73 06                	jae    8033f8 <realloc_block+0x63>
    new_size = min_block_size;
  8033f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f5:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8033f8:	83 ec 0c             	sub    $0xc,%esp
  8033fb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8033fe:	ff 75 0c             	pushl  0xc(%ebp)
  803401:	89 c1                	mov    %eax,%ecx
  803403:	e8 55 ff ff ff       	call   80335d <nearest_pow2_ceil.1572>
  803408:	83 c4 10             	add    $0x10,%esp
  80340b:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803414:	75 05                	jne    80341b <realloc_block+0x86>
    return va;
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	eb 72                	jmp    80348d <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80341b:	83 ec 0c             	sub    $0xc,%esp
  80341e:	ff 75 0c             	pushl  0xc(%ebp)
  803421:	e8 57 f6 ff ff       	call   802a7d <alloc_block>
  803426:	83 c4 10             	add    $0x10,%esp
  803429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80342c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803430:	75 07                	jne    803439 <realloc_block+0xa4>
    return NULL;
  803432:	b8 00 00 00 00       	mov    $0x0,%eax
  803437:	eb 54                	jmp    80348d <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803439:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80343c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343f:	39 d0                	cmp    %edx,%eax
  803441:	76 02                	jbe    803445 <realloc_block+0xb0>
  803443:	89 d0                	mov    %edx,%eax
  803445:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80345b:	eb 17                	jmp    803474 <realloc_block+0xdf>
    dst[i] = src[i];
  80345d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803463:	01 c2                	add    %eax,%edx
  803465:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	01 c8                	add    %ecx,%eax
  80346d:	8a 00                	mov    (%eax),%al
  80346f:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803471:	ff 45 f4             	incl   -0xc(%ebp)
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80347a:	72 e1                	jb     80345d <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	ff 75 08             	pushl  0x8(%ebp)
  803482:	e8 50 fb ff ff       	call   802fd7 <free_block>
  803487:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80348a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80348d:	c9                   	leave  
  80348e:	c3                   	ret    
  80348f:	90                   	nop

00803490 <__udivdi3>:
  803490:	55                   	push   %ebp
  803491:	57                   	push   %edi
  803492:	56                   	push   %esi
  803493:	53                   	push   %ebx
  803494:	83 ec 1c             	sub    $0x1c,%esp
  803497:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80349b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80349f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a7:	89 ca                	mov    %ecx,%edx
  8034a9:	89 f8                	mov    %edi,%eax
  8034ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034af:	85 f6                	test   %esi,%esi
  8034b1:	75 2d                	jne    8034e0 <__udivdi3+0x50>
  8034b3:	39 cf                	cmp    %ecx,%edi
  8034b5:	77 65                	ja     80351c <__udivdi3+0x8c>
  8034b7:	89 fd                	mov    %edi,%ebp
  8034b9:	85 ff                	test   %edi,%edi
  8034bb:	75 0b                	jne    8034c8 <__udivdi3+0x38>
  8034bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c2:	31 d2                	xor    %edx,%edx
  8034c4:	f7 f7                	div    %edi
  8034c6:	89 c5                	mov    %eax,%ebp
  8034c8:	31 d2                	xor    %edx,%edx
  8034ca:	89 c8                	mov    %ecx,%eax
  8034cc:	f7 f5                	div    %ebp
  8034ce:	89 c1                	mov    %eax,%ecx
  8034d0:	89 d8                	mov    %ebx,%eax
  8034d2:	f7 f5                	div    %ebp
  8034d4:	89 cf                	mov    %ecx,%edi
  8034d6:	89 fa                	mov    %edi,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	39 ce                	cmp    %ecx,%esi
  8034e2:	77 28                	ja     80350c <__udivdi3+0x7c>
  8034e4:	0f bd fe             	bsr    %esi,%edi
  8034e7:	83 f7 1f             	xor    $0x1f,%edi
  8034ea:	75 40                	jne    80352c <__udivdi3+0x9c>
  8034ec:	39 ce                	cmp    %ecx,%esi
  8034ee:	72 0a                	jb     8034fa <__udivdi3+0x6a>
  8034f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034f4:	0f 87 9e 00 00 00    	ja     803598 <__udivdi3+0x108>
  8034fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ff:	89 fa                	mov    %edi,%edx
  803501:	83 c4 1c             	add    $0x1c,%esp
  803504:	5b                   	pop    %ebx
  803505:	5e                   	pop    %esi
  803506:	5f                   	pop    %edi
  803507:	5d                   	pop    %ebp
  803508:	c3                   	ret    
  803509:	8d 76 00             	lea    0x0(%esi),%esi
  80350c:	31 ff                	xor    %edi,%edi
  80350e:	31 c0                	xor    %eax,%eax
  803510:	89 fa                	mov    %edi,%edx
  803512:	83 c4 1c             	add    $0x1c,%esp
  803515:	5b                   	pop    %ebx
  803516:	5e                   	pop    %esi
  803517:	5f                   	pop    %edi
  803518:	5d                   	pop    %ebp
  803519:	c3                   	ret    
  80351a:	66 90                	xchg   %ax,%ax
  80351c:	89 d8                	mov    %ebx,%eax
  80351e:	f7 f7                	div    %edi
  803520:	31 ff                	xor    %edi,%edi
  803522:	89 fa                	mov    %edi,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803531:	89 eb                	mov    %ebp,%ebx
  803533:	29 fb                	sub    %edi,%ebx
  803535:	89 f9                	mov    %edi,%ecx
  803537:	d3 e6                	shl    %cl,%esi
  803539:	89 c5                	mov    %eax,%ebp
  80353b:	88 d9                	mov    %bl,%cl
  80353d:	d3 ed                	shr    %cl,%ebp
  80353f:	89 e9                	mov    %ebp,%ecx
  803541:	09 f1                	or     %esi,%ecx
  803543:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803547:	89 f9                	mov    %edi,%ecx
  803549:	d3 e0                	shl    %cl,%eax
  80354b:	89 c5                	mov    %eax,%ebp
  80354d:	89 d6                	mov    %edx,%esi
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 ee                	shr    %cl,%esi
  803553:	89 f9                	mov    %edi,%ecx
  803555:	d3 e2                	shl    %cl,%edx
  803557:	8b 44 24 08          	mov    0x8(%esp),%eax
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 e8                	shr    %cl,%eax
  80355f:	09 c2                	or     %eax,%edx
  803561:	89 d0                	mov    %edx,%eax
  803563:	89 f2                	mov    %esi,%edx
  803565:	f7 74 24 0c          	divl   0xc(%esp)
  803569:	89 d6                	mov    %edx,%esi
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	f7 e5                	mul    %ebp
  80356f:	39 d6                	cmp    %edx,%esi
  803571:	72 19                	jb     80358c <__udivdi3+0xfc>
  803573:	74 0b                	je     803580 <__udivdi3+0xf0>
  803575:	89 d8                	mov    %ebx,%eax
  803577:	31 ff                	xor    %edi,%edi
  803579:	e9 58 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	8b 54 24 08          	mov    0x8(%esp),%edx
  803584:	89 f9                	mov    %edi,%ecx
  803586:	d3 e2                	shl    %cl,%edx
  803588:	39 c2                	cmp    %eax,%edx
  80358a:	73 e9                	jae    803575 <__udivdi3+0xe5>
  80358c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80358f:	31 ff                	xor    %edi,%edi
  803591:	e9 40 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  803596:	66 90                	xchg   %ax,%ax
  803598:	31 c0                	xor    %eax,%eax
  80359a:	e9 37 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  80359f:	90                   	nop

008035a0 <__umoddi3>:
  8035a0:	55                   	push   %ebp
  8035a1:	57                   	push   %edi
  8035a2:	56                   	push   %esi
  8035a3:	53                   	push   %ebx
  8035a4:	83 ec 1c             	sub    $0x1c,%esp
  8035a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035bf:	89 f3                	mov    %esi,%ebx
  8035c1:	89 fa                	mov    %edi,%edx
  8035c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035c7:	89 34 24             	mov    %esi,(%esp)
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	75 1a                	jne    8035e8 <__umoddi3+0x48>
  8035ce:	39 f7                	cmp    %esi,%edi
  8035d0:	0f 86 a2 00 00 00    	jbe    803678 <__umoddi3+0xd8>
  8035d6:	89 c8                	mov    %ecx,%eax
  8035d8:	89 f2                	mov    %esi,%edx
  8035da:	f7 f7                	div    %edi
  8035dc:	89 d0                	mov    %edx,%eax
  8035de:	31 d2                	xor    %edx,%edx
  8035e0:	83 c4 1c             	add    $0x1c,%esp
  8035e3:	5b                   	pop    %ebx
  8035e4:	5e                   	pop    %esi
  8035e5:	5f                   	pop    %edi
  8035e6:	5d                   	pop    %ebp
  8035e7:	c3                   	ret    
  8035e8:	39 f0                	cmp    %esi,%eax
  8035ea:	0f 87 ac 00 00 00    	ja     80369c <__umoddi3+0xfc>
  8035f0:	0f bd e8             	bsr    %eax,%ebp
  8035f3:	83 f5 1f             	xor    $0x1f,%ebp
  8035f6:	0f 84 ac 00 00 00    	je     8036a8 <__umoddi3+0x108>
  8035fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803601:	29 ef                	sub    %ebp,%edi
  803603:	89 fe                	mov    %edi,%esi
  803605:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 e0                	shl    %cl,%eax
  80360d:	89 d7                	mov    %edx,%edi
  80360f:	89 f1                	mov    %esi,%ecx
  803611:	d3 ef                	shr    %cl,%edi
  803613:	09 c7                	or     %eax,%edi
  803615:	89 e9                	mov    %ebp,%ecx
  803617:	d3 e2                	shl    %cl,%edx
  803619:	89 14 24             	mov    %edx,(%esp)
  80361c:	89 d8                	mov    %ebx,%eax
  80361e:	d3 e0                	shl    %cl,%eax
  803620:	89 c2                	mov    %eax,%edx
  803622:	8b 44 24 08          	mov    0x8(%esp),%eax
  803626:	d3 e0                	shl    %cl,%eax
  803628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80362c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803630:	89 f1                	mov    %esi,%ecx
  803632:	d3 e8                	shr    %cl,%eax
  803634:	09 d0                	or     %edx,%eax
  803636:	d3 eb                	shr    %cl,%ebx
  803638:	89 da                	mov    %ebx,%edx
  80363a:	f7 f7                	div    %edi
  80363c:	89 d3                	mov    %edx,%ebx
  80363e:	f7 24 24             	mull   (%esp)
  803641:	89 c6                	mov    %eax,%esi
  803643:	89 d1                	mov    %edx,%ecx
  803645:	39 d3                	cmp    %edx,%ebx
  803647:	0f 82 87 00 00 00    	jb     8036d4 <__umoddi3+0x134>
  80364d:	0f 84 91 00 00 00    	je     8036e4 <__umoddi3+0x144>
  803653:	8b 54 24 04          	mov    0x4(%esp),%edx
  803657:	29 f2                	sub    %esi,%edx
  803659:	19 cb                	sbb    %ecx,%ebx
  80365b:	89 d8                	mov    %ebx,%eax
  80365d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803661:	d3 e0                	shl    %cl,%eax
  803663:	89 e9                	mov    %ebp,%ecx
  803665:	d3 ea                	shr    %cl,%edx
  803667:	09 d0                	or     %edx,%eax
  803669:	89 e9                	mov    %ebp,%ecx
  80366b:	d3 eb                	shr    %cl,%ebx
  80366d:	89 da                	mov    %ebx,%edx
  80366f:	83 c4 1c             	add    $0x1c,%esp
  803672:	5b                   	pop    %ebx
  803673:	5e                   	pop    %esi
  803674:	5f                   	pop    %edi
  803675:	5d                   	pop    %ebp
  803676:	c3                   	ret    
  803677:	90                   	nop
  803678:	89 fd                	mov    %edi,%ebp
  80367a:	85 ff                	test   %edi,%edi
  80367c:	75 0b                	jne    803689 <__umoddi3+0xe9>
  80367e:	b8 01 00 00 00       	mov    $0x1,%eax
  803683:	31 d2                	xor    %edx,%edx
  803685:	f7 f7                	div    %edi
  803687:	89 c5                	mov    %eax,%ebp
  803689:	89 f0                	mov    %esi,%eax
  80368b:	31 d2                	xor    %edx,%edx
  80368d:	f7 f5                	div    %ebp
  80368f:	89 c8                	mov    %ecx,%eax
  803691:	f7 f5                	div    %ebp
  803693:	89 d0                	mov    %edx,%eax
  803695:	e9 44 ff ff ff       	jmp    8035de <__umoddi3+0x3e>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	89 c8                	mov    %ecx,%eax
  80369e:	89 f2                	mov    %esi,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	3b 04 24             	cmp    (%esp),%eax
  8036ab:	72 06                	jb     8036b3 <__umoddi3+0x113>
  8036ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036b1:	77 0f                	ja     8036c2 <__umoddi3+0x122>
  8036b3:	89 f2                	mov    %esi,%edx
  8036b5:	29 f9                	sub    %edi,%ecx
  8036b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036bb:	89 14 24             	mov    %edx,(%esp)
  8036be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036c6:	8b 14 24             	mov    (%esp),%edx
  8036c9:	83 c4 1c             	add    $0x1c,%esp
  8036cc:	5b                   	pop    %ebx
  8036cd:	5e                   	pop    %esi
  8036ce:	5f                   	pop    %edi
  8036cf:	5d                   	pop    %ebp
  8036d0:	c3                   	ret    
  8036d1:	8d 76 00             	lea    0x0(%esi),%esi
  8036d4:	2b 04 24             	sub    (%esp),%eax
  8036d7:	19 fa                	sbb    %edi,%edx
  8036d9:	89 d1                	mov    %edx,%ecx
  8036db:	89 c6                	mov    %eax,%esi
  8036dd:	e9 71 ff ff ff       	jmp    803653 <__umoddi3+0xb3>
  8036e2:	66 90                	xchg   %ax,%ax
  8036e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e8:	72 ea                	jb     8036d4 <__umoddi3+0x134>
  8036ea:	89 d9                	mov    %ebx,%ecx
  8036ec:	e9 62 ff ff ff       	jmp    803653 <__umoddi3+0xb3>
