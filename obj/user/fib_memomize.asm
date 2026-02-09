
obj/user/fib_memomize:     file format elf32-i386


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
  800031:	e8 7f 01 00 00       	call   8001b5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int index=0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 39 80 00       	push   $0x8039c0
  800057:	e8 c1 0b 00 00       	call   800c1d <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 c3 10 00 00       	call   801135 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 f0 1b 00 00       	call   801c78 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (int i = 0; i <= index; ++i)
  80008e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800095:	eb 1f                	jmp    8000b6 <_main+0x7e>
	{
		memo[i] = 0;
  800097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80009a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8000ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
	index = strtol(buff1, NULL, 10);

	int64 *memo = malloc((index+1) * sizeof(int64));
	for (int i = 0; i <= index; ++i)
  8000b3:	ff 45 f4             	incl   -0xc(%ebp)
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000bc:	7e d9                	jle    800097 <_main+0x5f>
	{
		memo[i] = 0;
	}
	int64 res = fibonacci(index, memo) ;
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c7:	e8 35 00 00 00       	call   800101 <fibonacci>
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	free(memo);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000db:	e8 1c 1d 00 00       	call   801dfc <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 de 39 80 00       	push   $0x8039de
  8000f1:	e8 c1 03 00 00       	call   8004b7 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 62 25 00 00       	call   802660 <inctst>
	return;
  8000fe:	90                   	nop
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 0c             	sub    $0xc,%esp
	if (memo[n]!=0)	return memo[n];
  80010a:	8b 45 08             	mov    0x8(%ebp),%eax
  80010d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	8b 50 04             	mov    0x4(%eax),%edx
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	09 d0                	or     %edx,%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	74 16                	je     80013a <fibonacci+0x39>
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	01 d0                	add    %edx,%eax
  800133:	8b 50 04             	mov    0x4(%eax),%edx
  800136:	8b 00                	mov    (%eax),%eax
  800138:	eb 73                	jmp    8001ad <fibonacci+0xac>
	if (n <= 1)
  80013a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80013e:	7f 23                	jg     800163 <fibonacci+0x62>
		return memo[n] = 1 ;
  800140:	8b 45 08             	mov    0x8(%ebp),%eax
  800143:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  800155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80015c:	8b 50 04             	mov    0x4(%eax),%edx
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	eb 4a                	jmp    8001ad <fibonacci+0xac>
	return (memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)) ;
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	8d 3c 02             	lea    (%edx,%eax,1),%edi
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	50                   	push   %eax
  80017e:	e8 7e ff ff ff       	call   800101 <fibonacci>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 c3                	mov    %eax,%ebx
  800188:	89 d6                	mov    %edx,%esi
  80018a:	8b 45 08             	mov    0x8(%ebp),%eax
  80018d:	83 e8 02             	sub    $0x2,%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 0c             	pushl  0xc(%ebp)
  800196:	50                   	push   %eax
  800197:	e8 65 ff ff ff       	call   800101 <fibonacci>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	01 d8                	add    %ebx,%eax
  8001a1:	11 f2                	adc    %esi,%edx
  8001a3:	89 07                	mov    %eax,(%edi)
  8001a5:	89 57 04             	mov    %edx,0x4(%edi)
  8001a8:	8b 07                	mov    (%edi),%eax
  8001aa:	8b 57 04             	mov    0x4(%edi),%edx
}
  8001ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b0:	5b                   	pop    %ebx
  8001b1:	5e                   	pop    %esi
  8001b2:	5f                   	pop    %edi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    

008001b5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	57                   	push   %edi
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001be:	e8 5f 23 00 00       	call   802522 <sys_getenvindex>
  8001c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001c9:	89 d0                	mov    %edx,%eax
  8001cb:	01 c0                	add    %eax,%eax
  8001cd:	01 d0                	add    %edx,%eax
  8001cf:	c1 e0 02             	shl    $0x2,%eax
  8001d2:	01 d0                	add    %edx,%eax
  8001d4:	c1 e0 02             	shl    $0x2,%eax
  8001d7:	01 d0                	add    %edx,%eax
  8001d9:	c1 e0 03             	shl    $0x3,%eax
  8001dc:	01 d0                	add    %edx,%eax
  8001de:	c1 e0 02             	shl    $0x2,%eax
  8001e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f0:	8a 40 20             	mov    0x20(%eax),%al
  8001f3:	84 c0                	test   %al,%al
  8001f5:	74 0d                	je     800204 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fc:	83 c0 20             	add    $0x20,%eax
  8001ff:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800208:	7e 0a                	jle    800214 <libmain+0x5f>
		binaryname = argv[0];
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 16 fe ff ff       	call   800038 <_main>
  800222:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800225:	a1 00 50 80 00       	mov    0x805000,%eax
  80022a:	85 c0                	test   %eax,%eax
  80022c:	0f 84 01 01 00 00    	je     800333 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800232:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800238:	bb ec 3a 80 00       	mov    $0x803aec,%ebx
  80023d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800242:	89 c7                	mov    %eax,%edi
  800244:	89 de                	mov    %ebx,%esi
  800246:	89 d1                	mov    %edx,%ecx
  800248:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80024a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80024d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800252:	b0 00                	mov    $0x0,%al
  800254:	89 d7                	mov    %edx,%edi
  800256:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800258:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80025f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	50                   	push   %eax
  800266:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	e8 e6 24 00 00       	call   802758 <sys_utilities>
  800272:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800275:	e8 2f 20 00 00       	call   8022a9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80027a:	83 ec 0c             	sub    $0xc,%esp
  80027d:	68 0c 3a 80 00       	push   $0x803a0c
  800282:	e8 be 01 00 00       	call   800445 <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80028a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028d:	85 c0                	test   %eax,%eax
  80028f:	74 18                	je     8002a9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800291:	e8 e0 24 00 00       	call   802776 <sys_get_optimal_num_faults>
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	50                   	push   %eax
  80029a:	68 34 3a 80 00       	push   $0x803a34
  80029f:	e8 a1 01 00 00       	call   800445 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 59                	jmp    800302 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ae:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8002b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b9:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	52                   	push   %edx
  8002c3:	50                   	push   %eax
  8002c4:	68 58 3a 80 00       	push   $0x803a58
  8002c9:	e8 77 01 00 00       	call   800445 <cprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d6:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8002dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e1:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8002f2:	51                   	push   %ecx
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 80 3a 80 00       	push   $0x803a80
  8002fa:	e8 46 01 00 00       	call   800445 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800302:	a1 20 50 80 00       	mov    0x805020,%eax
  800307:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	50                   	push   %eax
  800311:	68 d8 3a 80 00       	push   $0x803ad8
  800316:	e8 2a 01 00 00       	call   800445 <cprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	68 0c 3a 80 00       	push   $0x803a0c
  800326:	e8 1a 01 00 00       	call   800445 <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80032e:	e8 90 1f 00 00       	call   8022c3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800333:	e8 1f 00 00 00       	call   800357 <exit>
}
  800338:	90                   	nop
  800339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033c:	5b                   	pop    %ebx
  80033d:	5e                   	pop    %esi
  80033e:	5f                   	pop    %edi
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	6a 00                	push   $0x0
  80034c:	e8 9d 21 00 00       	call   8024ee <sys_destroy_env>
  800351:	83 c4 10             	add    $0x10,%esp
}
  800354:	90                   	nop
  800355:	c9                   	leave  
  800356:	c3                   	ret    

00800357 <exit>:

void
exit(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80035d:	e8 f2 21 00 00       	call   802554 <sys_exit_env>
}
  800362:	90                   	nop
  800363:	c9                   	leave  
  800364:	c3                   	ret    

00800365 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	53                   	push   %ebx
  800369:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	8d 48 01             	lea    0x1(%eax),%ecx
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx
  800377:	89 0a                	mov    %ecx,(%edx)
  800379:	8b 55 08             	mov    0x8(%ebp),%edx
  80037c:	88 d1                	mov    %dl,%cl
  80037e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800381:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038f:	75 30                	jne    8003c1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800391:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800397:	a0 44 50 80 00       	mov    0x805044,%al
  80039c:	0f b6 c0             	movzbl %al,%eax
  80039f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a2:	8b 09                	mov    (%ecx),%ecx
  8003a4:	89 cb                	mov    %ecx,%ebx
  8003a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a9:	83 c1 08             	add    $0x8,%ecx
  8003ac:	52                   	push   %edx
  8003ad:	50                   	push   %eax
  8003ae:	53                   	push   %ebx
  8003af:	51                   	push   %ecx
  8003b0:	e8 b0 1e 00 00       	call   802265 <sys_cputs>
  8003b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 40 04             	mov    0x4(%eax),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003d0:	90                   	nop
  8003d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e6:	00 00 00 
	b.cnt = 0;
  8003e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	ff 75 08             	pushl  0x8(%ebp)
  8003f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ff:	50                   	push   %eax
  800400:	68 65 03 80 00       	push   $0x800365
  800405:	e8 5a 02 00 00       	call   800664 <vprintfmt>
  80040a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80040d:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800413:	a0 44 50 80 00       	mov    0x805044,%al
  800418:	0f b6 c0             	movzbl %al,%eax
  80041b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	51                   	push   %ecx
  800424:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042a:	83 c0 08             	add    $0x8,%eax
  80042d:	50                   	push   %eax
  80042e:	e8 32 1e 00 00       	call   802265 <sys_cputs>
  800433:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800436:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80043d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80044b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800452:	8d 45 0c             	lea    0xc(%ebp),%eax
  800455:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 f4             	pushl  -0xc(%ebp)
  800461:	50                   	push   %eax
  800462:	e8 6f ff ff ff       	call   8003d6 <vcprintf>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800470:	c9                   	leave  
  800471:	c3                   	ret    

00800472 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800478:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	c1 e0 08             	shl    $0x8,%eax
  800485:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048d:	83 c0 04             	add    $0x4,%eax
  800490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 f4             	pushl  -0xc(%ebp)
  80049c:	50                   	push   %eax
  80049d:	e8 34 ff ff ff       	call   8003d6 <vcprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8004a8:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  8004af:	07 00 00 

	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004bd:	e8 e7 1d 00 00       	call   8022a9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d1:	50                   	push   %eax
  8004d2:	e8 ff fe ff ff       	call   8003d6 <vcprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004dd:	e8 e1 1d 00 00       	call   8022c3 <sys_unlock_cons>
	return cnt;
  8004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 14             	sub    $0x14,%esp
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800502:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800505:	77 55                	ja     80055c <printnum+0x75>
  800507:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80050a:	72 05                	jb     800511 <printnum+0x2a>
  80050c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80050f:	77 4b                	ja     80055c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800511:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800514:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800517:	8b 45 18             	mov    0x18(%ebp),%eax
  80051a:	ba 00 00 00 00       	mov    $0x0,%edx
  80051f:	52                   	push   %edx
  800520:	50                   	push   %eax
  800521:	ff 75 f4             	pushl  -0xc(%ebp)
  800524:	ff 75 f0             	pushl  -0x10(%ebp)
  800527:	e8 24 32 00 00       	call   803750 <__udivdi3>
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	ff 75 20             	pushl  0x20(%ebp)
  800535:	53                   	push   %ebx
  800536:	ff 75 18             	pushl  0x18(%ebp)
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	ff 75 08             	pushl  0x8(%ebp)
  800541:	e8 a1 ff ff ff       	call   8004e7 <printnum>
  800546:	83 c4 20             	add    $0x20,%esp
  800549:	eb 1a                	jmp    800565 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	ff 75 20             	pushl  0x20(%ebp)
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	ff d0                	call   *%eax
  800559:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80055c:	ff 4d 1c             	decl   0x1c(%ebp)
  80055f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800563:	7f e6                	jg     80054b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800565:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800568:	bb 00 00 00 00       	mov    $0x0,%ebx
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800573:	53                   	push   %ebx
  800574:	51                   	push   %ecx
  800575:	52                   	push   %edx
  800576:	50                   	push   %eax
  800577:	e8 e4 32 00 00       	call   803860 <__umoddi3>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	05 74 3d 80 00       	add    $0x803d74,%eax
  800584:	8a 00                	mov    (%eax),%al
  800586:	0f be c0             	movsbl %al,%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	ff d0                	call   *%eax
  800595:	83 c4 10             	add    $0x10,%esp
}
  800598:	90                   	nop
  800599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a5:	7e 1c                	jle    8005c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	8d 50 08             	lea    0x8(%eax),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 10                	mov    %edx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	83 e8 08             	sub    $0x8,%eax
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	eb 40                	jmp    800603 <getuint+0x65>
	else if (lflag)
  8005c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c7:	74 1e                	je     8005e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	89 10                	mov    %edx,(%eax)
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	eb 1c                	jmp    800603 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8d 50 04             	lea    0x4(%eax),%edx
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	89 10                	mov    %edx,(%eax)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 e8 04             	sub    $0x4,%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800603:	5d                   	pop    %ebp
  800604:	c3                   	ret    

00800605 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800605:	55                   	push   %ebp
  800606:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800608:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80060c:	7e 1c                	jle    80062a <getint+0x25>
		return va_arg(*ap, long long);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	8d 50 08             	lea    0x8(%eax),%edx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 10                	mov    %edx,(%eax)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	83 e8 08             	sub    $0x8,%eax
  800623:	8b 50 04             	mov    0x4(%eax),%edx
  800626:	8b 00                	mov    (%eax),%eax
  800628:	eb 38                	jmp    800662 <getint+0x5d>
	else if (lflag)
  80062a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80062e:	74 1a                	je     80064a <getint+0x45>
		return va_arg(*ap, long);
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	8d 50 04             	lea    0x4(%eax),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	89 10                	mov    %edx,(%eax)
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	99                   	cltd   
  800648:	eb 18                	jmp    800662 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	8d 50 04             	lea    0x4(%eax),%edx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	89 10                	mov    %edx,(%eax)
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	83 e8 04             	sub    $0x4,%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	99                   	cltd   
}
  800662:	5d                   	pop    %ebp
  800663:	c3                   	ret    

00800664 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	56                   	push   %esi
  800668:	53                   	push   %ebx
  800669:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066c:	eb 17                	jmp    800685 <vprintfmt+0x21>
			if (ch == '\0')
  80066e:	85 db                	test   %ebx,%ebx
  800670:	0f 84 c1 03 00 00    	je     800a37 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	53                   	push   %ebx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	ff d0                	call   *%eax
  800682:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8d 50 01             	lea    0x1(%eax),%edx
  80068b:	89 55 10             	mov    %edx,0x10(%ebp)
  80068e:	8a 00                	mov    (%eax),%al
  800690:	0f b6 d8             	movzbl %al,%ebx
  800693:	83 fb 25             	cmp    $0x25,%ebx
  800696:	75 d6                	jne    80066e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800698:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80069c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bb:	8d 50 01             	lea    0x1(%eax),%edx
  8006be:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c1:	8a 00                	mov    (%eax),%al
  8006c3:	0f b6 d8             	movzbl %al,%ebx
  8006c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006c9:	83 f8 5b             	cmp    $0x5b,%eax
  8006cc:	0f 87 3d 03 00 00    	ja     800a0f <vprintfmt+0x3ab>
  8006d2:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  8006d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006df:	eb d7                	jmp    8006b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006e5:	eb d1                	jmp    8006b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f1:	89 d0                	mov    %edx,%eax
  8006f3:	c1 e0 02             	shl    $0x2,%eax
  8006f6:	01 d0                	add    %edx,%eax
  8006f8:	01 c0                	add    %eax,%eax
  8006fa:	01 d8                	add    %ebx,%eax
  8006fc:	83 e8 30             	sub    $0x30,%eax
  8006ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	8a 00                	mov    (%eax),%al
  800707:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80070a:	83 fb 2f             	cmp    $0x2f,%ebx
  80070d:	7e 3e                	jle    80074d <vprintfmt+0xe9>
  80070f:	83 fb 39             	cmp    $0x39,%ebx
  800712:	7f 39                	jg     80074d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800714:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800717:	eb d5                	jmp    8006ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	83 c0 04             	add    $0x4,%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	83 e8 04             	sub    $0x4,%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80072d:	eb 1f                	jmp    80074e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800733:	79 83                	jns    8006b8 <vprintfmt+0x54>
				width = 0;
  800735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80073c:	e9 77 ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800741:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800748:	e9 6b ff ff ff       	jmp    8006b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80074d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80074e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800752:	0f 89 60 ff ff ff    	jns    8006b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800765:	e9 4e ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80076d:	e9 46 ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	83 c0 04             	add    $0x4,%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	83 e8 04             	sub    $0x4,%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	50                   	push   %eax
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			break;
  800792:	e9 9b 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007a8:	85 db                	test   %ebx,%ebx
  8007aa:	79 02                	jns    8007ae <vprintfmt+0x14a>
				err = -err;
  8007ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007ae:	83 fb 64             	cmp    $0x64,%ebx
  8007b1:	7f 0b                	jg     8007be <vprintfmt+0x15a>
  8007b3:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  8007ba:	85 f6                	test   %esi,%esi
  8007bc:	75 19                	jne    8007d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007be:	53                   	push   %ebx
  8007bf:	68 85 3d 80 00       	push   $0x803d85
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 70 02 00 00       	call   800a3f <printfmt>
  8007cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007d2:	e9 5b 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007d7:	56                   	push   %esi
  8007d8:	68 8e 3d 80 00       	push   $0x803d8e
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	ff 75 08             	pushl  0x8(%ebp)
  8007e3:	e8 57 02 00 00       	call   800a3f <printfmt>
  8007e8:	83 c4 10             	add    $0x10,%esp
			break;
  8007eb:	e9 42 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	83 c0 04             	add    $0x4,%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 30                	mov    (%eax),%esi
  800801:	85 f6                	test   %esi,%esi
  800803:	75 05                	jne    80080a <vprintfmt+0x1a6>
				p = "(null)";
  800805:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  80080a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080e:	7e 6d                	jle    80087d <vprintfmt+0x219>
  800810:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800814:	74 67                	je     80087d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	50                   	push   %eax
  80081d:	56                   	push   %esi
  80081e:	e8 26 05 00 00       	call   800d49 <strnlen>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800829:	eb 16                	jmp    800841 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80082b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80083e:	ff 4d e4             	decl   -0x1c(%ebp)
  800841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800845:	7f e4                	jg     80082b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800847:	eb 34                	jmp    80087d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800849:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80084d:	74 1c                	je     80086b <vprintfmt+0x207>
  80084f:	83 fb 1f             	cmp    $0x1f,%ebx
  800852:	7e 05                	jle    800859 <vprintfmt+0x1f5>
  800854:	83 fb 7e             	cmp    $0x7e,%ebx
  800857:	7e 12                	jle    80086b <vprintfmt+0x207>
					putch('?', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	6a 3f                	push   $0x3f
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	eb 0f                	jmp    80087a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	53                   	push   %ebx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087a:	ff 4d e4             	decl   -0x1c(%ebp)
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	8d 70 01             	lea    0x1(%eax),%esi
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f be d8             	movsbl %al,%ebx
  800887:	85 db                	test   %ebx,%ebx
  800889:	74 24                	je     8008af <vprintfmt+0x24b>
  80088b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088f:	78 b8                	js     800849 <vprintfmt+0x1e5>
  800891:	ff 4d e0             	decl   -0x20(%ebp)
  800894:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800898:	79 af                	jns    800849 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089a:	eb 13                	jmp    8008af <vprintfmt+0x24b>
				putch(' ', putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	6a 20                	push   $0x20
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8008af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b3:	7f e7                	jg     80089c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008b5:	e9 78 01 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c3:	50                   	push   %eax
  8008c4:	e8 3c fd ff ff       	call   800605 <getint>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d8:	85 d2                	test   %edx,%edx
  8008da:	79 23                	jns    8008ff <vprintfmt+0x29b>
				putch('-', putdat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	6a 2d                	push   $0x2d
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f2:	f7 d8                	neg    %eax
  8008f4:	83 d2 00             	adc    $0x0,%edx
  8008f7:	f7 da                	neg    %edx
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800906:	e9 bc 00 00 00       	jmp    8009c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 e8             	pushl  -0x18(%ebp)
  800911:	8d 45 14             	lea    0x14(%ebp),%eax
  800914:	50                   	push   %eax
  800915:	e8 84 fc ff ff       	call   80059e <getuint>
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800920:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800923:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80092a:	e9 98 00 00 00       	jmp    8009c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	6a 58                	push   $0x58
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	ff d0                	call   *%eax
  80093c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	6a 58                	push   $0x58
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	6a 58                	push   $0x58
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	ff d0                	call   *%eax
  80095c:	83 c4 10             	add    $0x10,%esp
			break;
  80095f:	e9 ce 00 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	6a 30                	push   $0x30
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	6a 78                	push   $0x78
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	ff d0                	call   *%eax
  800981:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80099f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009a6:	eb 1f                	jmp    8009c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b1:	50                   	push   %eax
  8009b2:	e8 e7 fb ff ff       	call   80059e <getuint>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	52                   	push   %edx
  8009d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d5:	50                   	push   %eax
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 00 fb ff ff       	call   8004e7 <printnum>
  8009e7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ea:	eb 46                	jmp    800a32 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			break;
  8009fb:	eb 35                	jmp    800a32 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009fd:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800a04:	eb 2c                	jmp    800a32 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a06:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800a0d:	eb 23                	jmp    800a32 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 25                	push   $0x25
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1f:	ff 4d 10             	decl   0x10(%ebp)
  800a22:	eb 03                	jmp    800a27 <vprintfmt+0x3c3>
  800a24:	ff 4d 10             	decl   0x10(%ebp)
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	48                   	dec    %eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	3c 25                	cmp    $0x25,%al
  800a2f:	75 f3                	jne    800a24 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a31:	90                   	nop
		}
	}
  800a32:	e9 35 fc ff ff       	jmp    80066c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a45:	8d 45 10             	lea    0x10(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 04 fc ff ff       	call   800664 <vprintfmt>
  800a60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a63:	90                   	nop
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 40 08             	mov    0x8(%eax),%eax
  800a6f:	8d 50 01             	lea    0x1(%eax),%edx
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	8b 10                	mov    (%eax),%edx
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8b 40 04             	mov    0x4(%eax),%eax
  800a83:	39 c2                	cmp    %eax,%edx
  800a85:	73 12                	jae    800a99 <sprintputch+0x33>
		*b->buf++ = ch;
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	89 0a                	mov    %ecx,(%edx)
  800a94:	8b 55 08             	mov    0x8(%ebp),%edx
  800a97:	88 10                	mov    %dl,(%eax)
}
  800a99:	90                   	nop
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	01 d0                	add    %edx,%eax
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ac1:	74 06                	je     800ac9 <vsnprintf+0x2d>
  800ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac7:	7f 07                	jg     800ad0 <vsnprintf+0x34>
		return -E_INVAL;
  800ac9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ace:	eb 20                	jmp    800af0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ad0:	ff 75 14             	pushl  0x14(%ebp)
  800ad3:	ff 75 10             	pushl  0x10(%ebp)
  800ad6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad9:	50                   	push   %eax
  800ada:	68 66 0a 80 00       	push   $0x800a66
  800adf:	e8 80 fb ff ff       	call   800664 <vprintfmt>
  800ae4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af8:	8d 45 10             	lea    0x10(%ebp),%eax
  800afb:	83 c0 04             	add    $0x4,%eax
  800afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b01:	8b 45 10             	mov    0x10(%ebp),%eax
  800b04:	ff 75 f4             	pushl  -0xc(%ebp)
  800b07:	50                   	push   %eax
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 89 ff ff ff       	call   800a9c <vsnprintf>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b28:	74 13                	je     800b3d <readline+0x1f>
		cprintf("%s", prompt);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	68 08 3f 80 00       	push   $0x803f08
  800b35:	e8 0b f9 ff ff       	call   800445 <cprintf>
  800b3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	6a 00                	push   $0x0
  800b49:	e8 ea 29 00 00       	call   803538 <iscons>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b54:	e8 cc 29 00 00       	call   803525 <getchar>
  800b59:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b60:	79 22                	jns    800b84 <readline+0x66>
			if (c != -E_EOF)
  800b62:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b66:	0f 84 ad 00 00 00    	je     800c19 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b72:	68 0b 3f 80 00       	push   $0x803f0b
  800b77:	e8 c9 f8 ff ff       	call   800445 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			break;
  800b7f:	e9 95 00 00 00       	jmp    800c19 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b84:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b88:	7e 34                	jle    800bbe <readline+0xa0>
  800b8a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b91:	7f 2b                	jg     800bbe <readline+0xa0>
			if (echoing)
  800b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b97:	74 0e                	je     800ba7 <readline+0x89>
				cputchar(c);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b9f:	e8 62 29 00 00       	call   803506 <cputchar>
  800ba4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800baa:	8d 50 01             	lea    0x1(%eax),%edx
  800bad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	01 d0                	add    %edx,%eax
  800bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bba:	88 10                	mov    %dl,(%eax)
  800bbc:	eb 56                	jmp    800c14 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800bbe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bc2:	75 1f                	jne    800be3 <readline+0xc5>
  800bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bc8:	7e 19                	jle    800be3 <readline+0xc5>
			if (echoing)
  800bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bce:	74 0e                	je     800bde <readline+0xc0>
				cputchar(c);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd6:	e8 2b 29 00 00       	call   803506 <cputchar>
  800bdb:	83 c4 10             	add    $0x10,%esp

			i--;
  800bde:	ff 4d f4             	decl   -0xc(%ebp)
  800be1:	eb 31                	jmp    800c14 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800be3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800be7:	74 0a                	je     800bf3 <readline+0xd5>
  800be9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bed:	0f 85 61 ff ff ff    	jne    800b54 <readline+0x36>
			if (echoing)
  800bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bf7:	74 0e                	je     800c07 <readline+0xe9>
				cputchar(c);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	ff 75 ec             	pushl  -0x14(%ebp)
  800bff:	e8 02 29 00 00       	call   803506 <cputchar>
  800c04:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800c12:	eb 06                	jmp    800c1a <readline+0xfc>
		}
	}
  800c14:	e9 3b ff ff ff       	jmp    800b54 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800c19:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800c1a:	90                   	nop
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800c23:	e8 81 16 00 00       	call   8022a9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2c:	74 13                	je     800c41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 08             	pushl  0x8(%ebp)
  800c34:	68 08 3f 80 00       	push   $0x803f08
  800c39:	e8 07 f8 ff ff       	call   800445 <cprintf>
  800c3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	6a 00                	push   $0x0
  800c4d:	e8 e6 28 00 00       	call   803538 <iscons>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c58:	e8 c8 28 00 00       	call   803525 <getchar>
  800c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c64:	79 22                	jns    800c88 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c66:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c6a:	0f 84 ad 00 00 00    	je     800d1d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 ec             	pushl  -0x14(%ebp)
  800c76:	68 0b 3f 80 00       	push   $0x803f0b
  800c7b:	e8 c5 f7 ff ff       	call   800445 <cprintf>
  800c80:	83 c4 10             	add    $0x10,%esp
				break;
  800c83:	e9 95 00 00 00       	jmp    800d1d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c8c:	7e 34                	jle    800cc2 <atomic_readline+0xa5>
  800c8e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c95:	7f 2b                	jg     800cc2 <atomic_readline+0xa5>
				if (echoing)
  800c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c9b:	74 0e                	je     800cab <atomic_readline+0x8e>
					cputchar(c);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ca3:	e8 5e 28 00 00       	call   803506 <cputchar>
  800ca8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	01 d0                	add    %edx,%eax
  800cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800cbe:	88 10                	mov    %dl,(%eax)
  800cc0:	eb 56                	jmp    800d18 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800cc2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800cc6:	75 1f                	jne    800ce7 <atomic_readline+0xca>
  800cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ccc:	7e 19                	jle    800ce7 <atomic_readline+0xca>
				if (echoing)
  800cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cd2:	74 0e                	je     800ce2 <atomic_readline+0xc5>
					cputchar(c);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  800cda:	e8 27 28 00 00       	call   803506 <cputchar>
  800cdf:	83 c4 10             	add    $0x10,%esp
				i--;
  800ce2:	ff 4d f4             	decl   -0xc(%ebp)
  800ce5:	eb 31                	jmp    800d18 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ce7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ceb:	74 0a                	je     800cf7 <atomic_readline+0xda>
  800ced:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cf1:	0f 85 61 ff ff ff    	jne    800c58 <atomic_readline+0x3b>
				if (echoing)
  800cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cfb:	74 0e                	je     800d0b <atomic_readline+0xee>
					cputchar(c);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	ff 75 ec             	pushl  -0x14(%ebp)
  800d03:	e8 fe 27 00 00       	call   803506 <cputchar>
  800d08:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	01 d0                	add    %edx,%eax
  800d13:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800d16:	eb 06                	jmp    800d1e <atomic_readline+0x101>
			}
		}
  800d18:	e9 3b ff ff ff       	jmp    800c58 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800d1d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800d1e:	e8 a0 15 00 00       	call   8022c3 <sys_unlock_cons>
}
  800d23:	90                   	nop
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d33:	eb 06                	jmp    800d3b <strlen+0x15>
		n++;
  800d35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	75 f1                	jne    800d35 <strlen+0xf>
		n++;
	return n;
  800d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 09                	jmp    800d61 <strnlen+0x18>
		n++;
  800d58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	ff 45 08             	incl   0x8(%ebp)
  800d5e:	ff 4d 0c             	decl   0xc(%ebp)
  800d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d65:	74 09                	je     800d70 <strnlen+0x27>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e8                	jne    800d58 <strnlen+0xf>
		n++;
	return n;
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d81:	90                   	nop
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 e4                	jne    800d82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800daf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db6:	eb 1f                	jmp    800dd7 <strncpy+0x34>
		*dst++ = *src;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc4:	8a 12                	mov    (%edx),%dl
  800dc6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	84 c0                	test   %al,%al
  800dcf:	74 03                	je     800dd4 <strncpy+0x31>
			src++;
  800dd1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd4:	ff 45 fc             	incl   -0x4(%ebp)
  800dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dda:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ddd:	72 d9                	jb     800db8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 30                	je     800e26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df6:	eb 16                	jmp    800e0e <strlcpy+0x2a>
			*dst++ = *src++;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e0e:	ff 4d 10             	decl   0x10(%ebp)
  800e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e15:	74 09                	je     800e20 <strlcpy+0x3c>
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	75 d8                	jne    800df8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e35:	eb 06                	jmp    800e3d <strcmp+0xb>
		p++, q++;
  800e37:	ff 45 08             	incl   0x8(%ebp)
  800e3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	74 0e                	je     800e54 <strcmp+0x22>
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 10                	mov    (%eax),%dl
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	38 c2                	cmp    %al,%dl
  800e52:	74 e3                	je     800e37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f b6 d0             	movzbl %al,%edx
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 c0             	movzbl %al,%eax
  800e64:	29 c2                	sub    %eax,%edx
  800e66:	89 d0                	mov    %edx,%eax
}
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e6d:	eb 09                	jmp    800e78 <strncmp+0xe>
		n--, p++, q++;
  800e6f:	ff 4d 10             	decl   0x10(%ebp)
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7c:	74 17                	je     800e95 <strncmp+0x2b>
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	84 c0                	test   %al,%al
  800e85:	74 0e                	je     800e95 <strncmp+0x2b>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 10                	mov    (%eax),%dl
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	38 c2                	cmp    %al,%dl
  800e93:	74 da                	je     800e6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e99:	75 07                	jne    800ea2 <strncmp+0x38>
		return 0;
  800e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea0:	eb 14                	jmp    800eb6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	0f b6 d0             	movzbl %al,%edx
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	0f b6 c0             	movzbl %al,%eax
  800eb2:	29 c2                	sub    %eax,%edx
  800eb4:	89 d0                	mov    %edx,%eax
}
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 04             	sub    $0x4,%esp
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec4:	eb 12                	jmp    800ed8 <strchr+0x20>
		if (*s == c)
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ece:	75 05                	jne    800ed5 <strchr+0x1d>
			return (char *) s;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	eb 11                	jmp    800ee6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	84 c0                	test   %al,%al
  800edf:	75 e5                	jne    800ec6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 04             	sub    $0x4,%esp
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef4:	eb 0d                	jmp    800f03 <strfind+0x1b>
		if (*s == c)
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800efe:	74 0e                	je     800f0e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f00:	ff 45 08             	incl   0x8(%ebp)
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 ea                	jne    800ef6 <strfind+0xe>
  800f0c:	eb 01                	jmp    800f0f <strfind+0x27>
		if (*s == c)
			break;
  800f0e:	90                   	nop
	return (char *) s;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f24:	76 63                	jbe    800f89 <memset+0x75>
		uint64 data_block = c;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	99                   	cltd   
  800f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f36:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f3a:	c1 e0 08             	shl    $0x8,%eax
  800f3d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f40:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f49:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f4d:	c1 e0 10             	shl    $0x10,%eax
  800f50:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f53:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f63:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f66:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f69:	eb 18                	jmp    800f83 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f6e:	8d 41 08             	lea    0x8(%ecx),%eax
  800f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7a:	89 01                	mov    %eax,(%ecx)
  800f7c:	89 51 04             	mov    %edx,0x4(%ecx)
  800f7f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f87:	77 e2                	ja     800f6b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8d:	74 23                	je     800fb2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f95:	eb 0e                	jmp    800fa5 <memset+0x91>
			*p8++ = (uint8)c;
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fab:	89 55 10             	mov    %edx,0x10(%ebp)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	75 e5                	jne    800f97 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fc9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fcd:	76 24                	jbe    800ff3 <memcpy+0x3c>
		while(n >= 8){
  800fcf:	eb 1c                	jmp    800fed <memcpy+0x36>
			*d64 = *s64;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8b 50 04             	mov    0x4(%eax),%edx
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	89 01                	mov    %eax,(%ecx)
  800fde:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fe1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fe5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fe9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff1:	77 de                	ja     800fd1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ff3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff7:	74 31                	je     80102a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801005:	eb 16                	jmp    80101d <memcpy+0x66>
			*d8++ = *s8++;
  801007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100a:	8d 50 01             	lea    0x1(%eax),%edx
  80100d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801013:	8d 4a 01             	lea    0x1(%edx),%ecx
  801016:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801019:	8a 12                	mov    (%edx),%dl
  80101b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	8d 50 ff             	lea    -0x1(%eax),%edx
  801023:	89 55 10             	mov    %edx,0x10(%ebp)
  801026:	85 c0                	test   %eax,%eax
  801028:	75 dd                	jne    801007 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801047:	73 50                	jae    801099 <memmove+0x6a>
  801049:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	01 d0                	add    %edx,%eax
  801051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801054:	76 43                	jbe    801099 <memmove+0x6a>
		s += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801062:	eb 10                	jmp    801074 <memmove+0x45>
			*--d = *--s;
  801064:	ff 4d f8             	decl   -0x8(%ebp)
  801067:	ff 4d fc             	decl   -0x4(%ebp)
  80106a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106d:	8a 10                	mov    (%eax),%dl
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107a:	89 55 10             	mov    %edx,0x10(%ebp)
  80107d:	85 c0                	test   %eax,%eax
  80107f:	75 e3                	jne    801064 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801081:	eb 23                	jmp    8010a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	8d 50 01             	lea    0x1(%eax),%edx
  801089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801092:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801095:	8a 12                	mov    (%edx),%dl
  801097:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109f:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 dd                	jne    801083 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010bd:	eb 2a                	jmp    8010e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	8a 10                	mov    (%eax),%dl
  8010c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	38 c2                	cmp    %al,%dl
  8010cb:	74 16                	je     8010e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	0f b6 d0             	movzbl %al,%edx
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 c0             	movzbl %al,%eax
  8010dd:	29 c2                	sub    %eax,%edx
  8010df:	89 d0                	mov    %edx,%eax
  8010e1:	eb 18                	jmp    8010fb <memcmp+0x50>
		s1++, s2++;
  8010e3:	ff 45 fc             	incl   -0x4(%ebp)
  8010e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	75 c9                	jne    8010bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80110e:	eb 15                	jmp    801125 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	0f b6 d0             	movzbl %al,%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	0f b6 c0             	movzbl %al,%eax
  80111e:	39 c2                	cmp    %eax,%edx
  801120:	74 0d                	je     80112f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801122:	ff 45 08             	incl   0x8(%ebp)
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80112b:	72 e3                	jb     801110 <memfind+0x13>
  80112d:	eb 01                	jmp    801130 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80112f:	90                   	nop
	return (void *) s;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80113b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801142:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801149:	eb 03                	jmp    80114e <strtol+0x19>
		s++;
  80114b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	3c 20                	cmp    $0x20,%al
  801155:	74 f4                	je     80114b <strtol+0x16>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 09                	cmp    $0x9,%al
  80115e:	74 eb                	je     80114b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 2b                	cmp    $0x2b,%al
  801167:	75 05                	jne    80116e <strtol+0x39>
		s++;
  801169:	ff 45 08             	incl   0x8(%ebp)
  80116c:	eb 13                	jmp    801181 <strtol+0x4c>
	else if (*s == '-')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 2d                	cmp    $0x2d,%al
  801175:	75 0a                	jne    801181 <strtol+0x4c>
		s++, neg = 1;
  801177:	ff 45 08             	incl   0x8(%ebp)
  80117a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801185:	74 06                	je     80118d <strtol+0x58>
  801187:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80118b:	75 20                	jne    8011ad <strtol+0x78>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 30                	cmp    $0x30,%al
  801194:	75 17                	jne    8011ad <strtol+0x78>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	40                   	inc    %eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 78                	cmp    $0x78,%al
  80119e:	75 0d                	jne    8011ad <strtol+0x78>
		s += 2, base = 16;
  8011a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011ab:	eb 28                	jmp    8011d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b1:	75 15                	jne    8011c8 <strtol+0x93>
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 30                	cmp    $0x30,%al
  8011ba:	75 0c                	jne    8011c8 <strtol+0x93>
		s++, base = 8;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c6:	eb 0d                	jmp    8011d5 <strtol+0xa0>
	else if (base == 0)
  8011c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cc:	75 07                	jne    8011d5 <strtol+0xa0>
		base = 10;
  8011ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 2f                	cmp    $0x2f,%al
  8011dc:	7e 19                	jle    8011f7 <strtol+0xc2>
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	3c 39                	cmp    $0x39,%al
  8011e5:	7f 10                	jg     8011f7 <strtol+0xc2>
			dig = *s - '0';
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f be c0             	movsbl %al,%eax
  8011ef:	83 e8 30             	sub    $0x30,%eax
  8011f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f5:	eb 42                	jmp    801239 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 60                	cmp    $0x60,%al
  8011fe:	7e 19                	jle    801219 <strtol+0xe4>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 7a                	cmp    $0x7a,%al
  801207:	7f 10                	jg     801219 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	0f be c0             	movsbl %al,%eax
  801211:	83 e8 57             	sub    $0x57,%eax
  801214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801217:	eb 20                	jmp    801239 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 40                	cmp    $0x40,%al
  801220:	7e 39                	jle    80125b <strtol+0x126>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 5a                	cmp    $0x5a,%al
  801229:	7f 30                	jg     80125b <strtol+0x126>
			dig = *s - 'A' + 10;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	0f be c0             	movsbl %al,%eax
  801233:	83 e8 37             	sub    $0x37,%eax
  801236:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80123f:	7d 19                	jge    80125a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801247:	0f af 45 10          	imul   0x10(%ebp),%eax
  80124b:	89 c2                	mov    %eax,%edx
  80124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801250:	01 d0                	add    %edx,%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801255:	e9 7b ff ff ff       	jmp    8011d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80125a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80125b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125f:	74 08                	je     801269 <strtol+0x134>
		*endptr = (char *) s;
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801269:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126d:	74 07                	je     801276 <strtol+0x141>
  80126f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801272:	f7 d8                	neg    %eax
  801274:	eb 03                	jmp    801279 <strtol+0x144>
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <ltostr>:

void
ltostr(long value, char *str)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801288:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80128f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801293:	79 13                	jns    8012a8 <ltostr+0x2d>
	{
		neg = 1;
  801295:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b0:	99                   	cltd   
  8012b1:	f7 f9                	idiv   %ecx
  8012b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	8d 50 01             	lea    0x1(%eax),%edx
  8012bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 d0                	add    %edx,%eax
  8012c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c9:	83 c2 30             	add    $0x30,%edx
  8012cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d6:	f7 e9                	imul   %ecx
  8012d8:	c1 fa 02             	sar    $0x2,%edx
  8012db:	89 c8                	mov    %ecx,%eax
  8012dd:	c1 f8 1f             	sar    $0x1f,%eax
  8012e0:	29 c2                	sub    %eax,%edx
  8012e2:	89 d0                	mov    %edx,%eax
  8012e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012eb:	75 bb                	jne    8012a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ff:	74 3d                	je     80133e <ltostr+0xc3>
		start = 1 ;
  801301:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801308:	eb 34                	jmp    80133e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80130a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	01 c2                	add    %eax,%edx
  80131f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 c8                	add    %ecx,%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80132b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	01 c2                	add    %eax,%edx
  801333:	8a 45 eb             	mov    -0x15(%ebp),%al
  801336:	88 02                	mov    %al,(%edx)
		start++ ;
  801338:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80133b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801344:	7c c4                	jl     80130a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801346:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 c4 f9 ff ff       	call   800d26 <strlen>
  801362:	83 c4 04             	add    $0x4,%esp
  801365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	e8 b6 f9 ff ff       	call   800d26 <strlen>
  801370:	83 c4 04             	add    $0x4,%esp
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801384:	eb 17                	jmp    80139d <strcconcat+0x49>
		final[s] = str1[s] ;
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 c2                	add    %eax,%edx
  80138e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	01 c8                	add    %ecx,%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80139a:	ff 45 fc             	incl   -0x4(%ebp)
  80139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a3:	7c e1                	jl     801386 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013b3:	eb 1f                	jmp    8013d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b8:	8d 50 01             	lea    0x1(%eax),%edx
  8013bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013be:	89 c2                	mov    %eax,%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 c2                	add    %eax,%edx
  8013c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 c8                	add    %ecx,%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d1:	ff 45 f8             	incl   -0x8(%ebp)
  8013d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013da:	7c d9                	jl     8013b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8013e7:	90                   	nop
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80140d:	eb 0c                	jmp    80141b <strsplit+0x31>
			*string++ = 0;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8d 50 01             	lea    0x1(%eax),%edx
  801415:	89 55 08             	mov    %edx,0x8(%ebp)
  801418:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	84 c0                	test   %al,%al
  801422:	74 18                	je     80143c <strsplit+0x52>
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	0f be c0             	movsbl %al,%eax
  80142c:	50                   	push   %eax
  80142d:	ff 75 0c             	pushl  0xc(%ebp)
  801430:	e8 83 fa ff ff       	call   800eb8 <strchr>
  801435:	83 c4 08             	add    $0x8,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	75 d3                	jne    80140f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	84 c0                	test   %al,%al
  801443:	74 5a                	je     80149f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801445:	8b 45 14             	mov    0x14(%ebp),%eax
  801448:	8b 00                	mov    (%eax),%eax
  80144a:	83 f8 0f             	cmp    $0xf,%eax
  80144d:	75 07                	jne    801456 <strsplit+0x6c>
		{
			return 0;
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	eb 66                	jmp    8014bc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	8b 00                	mov    (%eax),%eax
  80145b:	8d 48 01             	lea    0x1(%eax),%ecx
  80145e:	8b 55 14             	mov    0x14(%ebp),%edx
  801461:	89 0a                	mov    %ecx,(%edx)
  801463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146a:	8b 45 10             	mov    0x10(%ebp),%eax
  80146d:	01 c2                	add    %eax,%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801474:	eb 03                	jmp    801479 <strsplit+0x8f>
			string++;
  801476:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	84 c0                	test   %al,%al
  801480:	74 8b                	je     80140d <strsplit+0x23>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	0f be c0             	movsbl %al,%eax
  80148a:	50                   	push   %eax
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	e8 25 fa ff ff       	call   800eb8 <strchr>
  801493:	83 c4 08             	add    $0x8,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	74 dc                	je     801476 <strsplit+0x8c>
			string++;
	}
  80149a:	e9 6e ff ff ff       	jmp    80140d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80149f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a3:	8b 00                	mov    (%eax),%eax
  8014a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d1:	eb 4a                	jmp    80151d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	01 c2                	add    %eax,%edx
  8014db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	01 c8                	add    %ecx,%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 40                	cmp    $0x40,%al
  8014f3:	7e 25                	jle    80151a <str2lower+0x5c>
  8014f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	01 d0                	add    %edx,%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	3c 5a                	cmp    $0x5a,%al
  801501:	7f 17                	jg     80151a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	01 ca                	add    %ecx,%edx
  801513:	8a 12                	mov    (%edx),%dl
  801515:	83 c2 20             	add    $0x20,%edx
  801518:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80151a:	ff 45 fc             	incl   -0x4(%ebp)
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	e8 01 f8 ff ff       	call   800d26 <strlen>
  801525:	83 c4 04             	add    $0x4,%esp
  801528:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80152b:	7f a6                	jg     8014d3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	6a 10                	push   $0x10
  80153d:	e8 b2 15 00 00       	call   802af4 <alloc_block>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80154c:	75 14                	jne    801562 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	68 1c 3f 80 00       	push   $0x803f1c
  801556:	6a 14                	push   $0x14
  801558:	68 45 3f 80 00       	push   $0x803f45
  80155d:	e8 e0 1f 00 00       	call   803542 <_panic>

	node->start = start;
  801562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801565:	8b 55 08             	mov    0x8(%ebp),%edx
  801568:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80156a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801570:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801573:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80157a:	a1 24 50 80 00       	mov    0x805024,%eax
  80157f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801582:	eb 18                	jmp    80159c <insert_page_alloc+0x6a>
		if (start < it->start)
  801584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801587:	8b 00                	mov    (%eax),%eax
  801589:	3b 45 08             	cmp    0x8(%ebp),%eax
  80158c:	77 37                	ja     8015c5 <insert_page_alloc+0x93>
			break;
		prev = it;
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801594:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a0:	74 08                	je     8015aa <insert_page_alloc+0x78>
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	8b 40 08             	mov    0x8(%eax),%eax
  8015a8:	eb 05                	jmp    8015af <insert_page_alloc+0x7d>
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8015af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8015b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	75 c7                	jne    801584 <insert_page_alloc+0x52>
  8015bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c1:	75 c1                	jne    801584 <insert_page_alloc+0x52>
  8015c3:	eb 01                	jmp    8015c6 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8015c5:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8015c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ca:	75 64                	jne    801630 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8015cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d0:	75 14                	jne    8015e6 <insert_page_alloc+0xb4>
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 54 3f 80 00       	push   $0x803f54
  8015da:	6a 21                	push   $0x21
  8015dc:	68 45 3f 80 00       	push   $0x803f45
  8015e1:	e8 5c 1f 00 00       	call   803542 <_panic>
  8015e6:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ef:	89 50 08             	mov    %edx,0x8(%eax)
  8015f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f5:	8b 40 08             	mov    0x8(%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 0d                	je     801609 <insert_page_alloc+0xd7>
  8015fc:	a1 24 50 80 00       	mov    0x805024,%eax
  801601:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801604:	89 50 0c             	mov    %edx,0xc(%eax)
  801607:	eb 08                	jmp    801611 <insert_page_alloc+0xdf>
  801609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160c:	a3 28 50 80 00       	mov    %eax,0x805028
  801611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801614:	a3 24 50 80 00       	mov    %eax,0x805024
  801619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801623:	a1 30 50 80 00       	mov    0x805030,%eax
  801628:	40                   	inc    %eax
  801629:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  80162e:	eb 71                	jmp    8016a1 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801630:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801634:	74 06                	je     80163c <insert_page_alloc+0x10a>
  801636:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80163a:	75 14                	jne    801650 <insert_page_alloc+0x11e>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 78 3f 80 00       	push   $0x803f78
  801644:	6a 23                	push   $0x23
  801646:	68 45 3f 80 00       	push   $0x803f45
  80164b:	e8 f2 1e 00 00       	call   803542 <_panic>
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801653:	8b 50 08             	mov    0x8(%eax),%edx
  801656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801659:	89 50 08             	mov    %edx,0x8(%eax)
  80165c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165f:	8b 40 08             	mov    0x8(%eax),%eax
  801662:	85 c0                	test   %eax,%eax
  801664:	74 0c                	je     801672 <insert_page_alloc+0x140>
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	8b 40 08             	mov    0x8(%eax),%eax
  80166c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166f:	89 50 0c             	mov    %edx,0xc(%eax)
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801675:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801678:	89 50 08             	mov    %edx,0x8(%eax)
  80167b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801681:	89 50 0c             	mov    %edx,0xc(%eax)
  801684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801687:	8b 40 08             	mov    0x8(%eax),%eax
  80168a:	85 c0                	test   %eax,%eax
  80168c:	75 08                	jne    801696 <insert_page_alloc+0x164>
  80168e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801691:	a3 28 50 80 00       	mov    %eax,0x805028
  801696:	a1 30 50 80 00       	mov    0x805030,%eax
  80169b:	40                   	inc    %eax
  80169c:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8016a1:	90                   	nop
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8016aa:	a1 24 50 80 00       	mov    0x805024,%eax
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	75 0c                	jne    8016bf <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8016b3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8016b8:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8016bd:	eb 67                	jmp    801726 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8016bf:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8016c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8016c7:	a1 24 50 80 00       	mov    0x805024,%eax
  8016cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8016cf:	eb 26                	jmp    8016f7 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	8b 10                	mov    (%eax),%edx
  8016d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d9:	8b 40 04             	mov    0x4(%eax),%eax
  8016dc:	01 d0                	add    %edx,%eax
  8016de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016e7:	76 06                	jbe    8016ef <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8016ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8016f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016fb:	74 08                	je     801705 <recompute_page_alloc_break+0x61>
  8016fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801700:	8b 40 08             	mov    0x8(%eax),%eax
  801703:	eb 05                	jmp    80170a <recompute_page_alloc_break+0x66>
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
  80170a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80170f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801714:	85 c0                	test   %eax,%eax
  801716:	75 b9                	jne    8016d1 <recompute_page_alloc_break+0x2d>
  801718:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80171c:	75 b3                	jne    8016d1 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  80171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801721:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  80172e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801735:	8b 55 08             	mov    0x8(%ebp),%edx
  801738:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80173b:	01 d0                	add    %edx,%eax
  80173d:	48                   	dec    %eax
  80173e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801741:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	f7 75 d8             	divl   -0x28(%ebp)
  80174c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80174f:	29 d0                	sub    %edx,%eax
  801751:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801754:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801758:	75 0a                	jne    801764 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80175a:	b8 00 00 00 00       	mov    $0x0,%eax
  80175f:	e9 7e 01 00 00       	jmp    8018e2 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80176b:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80176f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801776:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80177d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801785:	a1 24 50 80 00       	mov    0x805024,%eax
  80178a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80178d:	eb 69                	jmp    8017f8 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80178f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801792:	8b 00                	mov    (%eax),%eax
  801794:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801797:	76 47                	jbe    8017e0 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80179f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a2:	8b 00                	mov    (%eax),%eax
  8017a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8017a7:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8017aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017ad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017b0:	72 2e                	jb     8017e0 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8017b2:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017b6:	75 14                	jne    8017cc <alloc_pages_custom_fit+0xa4>
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017be:	75 0c                	jne    8017cc <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8017c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8017c6:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8017ca:	eb 14                	jmp    8017e0 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8017cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017cf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017d2:	76 0c                	jbe    8017e0 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8017d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8017da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8017e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e3:	8b 10                	mov    (%eax),%edx
  8017e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e8:	8b 40 04             	mov    0x4(%eax),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8017f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017fc:	74 08                	je     801806 <alloc_pages_custom_fit+0xde>
  8017fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801801:	8b 40 08             	mov    0x8(%eax),%eax
  801804:	eb 05                	jmp    80180b <alloc_pages_custom_fit+0xe3>
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801810:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801815:	85 c0                	test   %eax,%eax
  801817:	0f 85 72 ff ff ff    	jne    80178f <alloc_pages_custom_fit+0x67>
  80181d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801821:	0f 85 68 ff ff ff    	jne    80178f <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801827:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80182c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80182f:	76 47                	jbe    801878 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801834:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801837:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80183c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80183f:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801842:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801845:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801848:	72 2e                	jb     801878 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80184a:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80184e:	75 14                	jne    801864 <alloc_pages_custom_fit+0x13c>
  801850:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801853:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801856:	75 0c                	jne    801864 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801858:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80185b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  80185e:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801862:	eb 14                	jmp    801878 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801864:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801867:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80186a:	76 0c                	jbe    801878 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80186c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80186f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801872:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801875:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80187f:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801883:	74 08                	je     80188d <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80188b:	eb 40                	jmp    8018cd <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80188d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801891:	74 08                	je     80189b <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801899:	eb 32                	jmp    8018cd <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80189b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8018a0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8018a3:	89 c2                	mov    %eax,%edx
  8018a5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018aa:	39 c2                	cmp    %eax,%edx
  8018ac:	73 07                	jae    8018b5 <alloc_pages_custom_fit+0x18d>
			return NULL;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b3:	eb 2d                	jmp    8018e2 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8018b5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8018bd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8018c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8018cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d0:	83 ec 08             	sub    $0x8,%esp
  8018d3:	ff 75 d0             	pushl  -0x30(%ebp)
  8018d6:	50                   	push   %eax
  8018d7:	e8 56 fc ff ff       	call   801532 <insert_page_alloc>
  8018dc:	83 c4 10             	add    $0x10,%esp

	return result;
  8018df:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018f0:	a1 24 50 80 00       	mov    0x805024,%eax
  8018f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018f8:	eb 1a                	jmp    801914 <find_allocated_size+0x30>
		if (it->start == va)
  8018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fd:	8b 00                	mov    (%eax),%eax
  8018ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801902:	75 08                	jne    80190c <find_allocated_size+0x28>
			return it->size;
  801904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801907:	8b 40 04             	mov    0x4(%eax),%eax
  80190a:	eb 34                	jmp    801940 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80190c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801911:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801914:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801918:	74 08                	je     801922 <find_allocated_size+0x3e>
  80191a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80191d:	8b 40 08             	mov    0x8(%eax),%eax
  801920:	eb 05                	jmp    801927 <find_allocated_size+0x43>
  801922:	b8 00 00 00 00       	mov    $0x0,%eax
  801927:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80192c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801931:	85 c0                	test   %eax,%eax
  801933:	75 c5                	jne    8018fa <find_allocated_size+0x16>
  801935:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801939:	75 bf                	jne    8018fa <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80194e:	a1 24 50 80 00       	mov    0x805024,%eax
  801953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801956:	e9 e1 01 00 00       	jmp    801b3c <free_pages+0x1fa>
		if (it->start == va) {
  80195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195e:	8b 00                	mov    (%eax),%eax
  801960:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801963:	0f 85 cb 01 00 00    	jne    801b34 <free_pages+0x1f2>

			uint32 start = it->start;
  801969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801974:	8b 40 04             	mov    0x4(%eax),%eax
  801977:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80197a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80197d:	f7 d0                	not    %eax
  80197f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801982:	73 1d                	jae    8019a1 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801984:	83 ec 0c             	sub    $0xc,%esp
  801987:	ff 75 e4             	pushl  -0x1c(%ebp)
  80198a:	ff 75 e8             	pushl  -0x18(%ebp)
  80198d:	68 ac 3f 80 00       	push   $0x803fac
  801992:	68 a5 00 00 00       	push   $0xa5
  801997:	68 45 3f 80 00       	push   $0x803f45
  80199c:	e8 a1 1b 00 00       	call   803542 <_panic>
			}

			uint32 start_end = start + size;
  8019a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  8019ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	79 19                	jns    8019cc <free_pages+0x8a>
  8019b3:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8019ba:	77 10                	ja     8019cc <free_pages+0x8a>
  8019bc:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  8019c3:	77 07                	ja     8019cc <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  8019c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 2c                	js     8019f8 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  8019cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	68 00 00 00 a0       	push   $0xa0000000
  8019d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8019da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019e3:	50                   	push   %eax
  8019e4:	68 f0 3f 80 00       	push   $0x803ff0
  8019e9:	68 ad 00 00 00       	push   $0xad
  8019ee:	68 45 3f 80 00       	push   $0x803f45
  8019f3:	e8 4a 1b 00 00       	call   803542 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019fe:	e9 88 00 00 00       	jmp    801a8b <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801a03:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801a0a:	76 17                	jbe    801a23 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801a0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801a0f:	68 54 40 80 00       	push   $0x804054
  801a14:	68 b4 00 00 00       	push   $0xb4
  801a19:	68 45 3f 80 00       	push   $0x803f45
  801a1e:	e8 1f 1b 00 00       	call   803542 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a26:	05 00 10 00 00       	add    $0x1000,%eax
  801a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	85 c0                	test   %eax,%eax
  801a33:	79 2e                	jns    801a63 <free_pages+0x121>
  801a35:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801a3c:	77 25                	ja     801a63 <free_pages+0x121>
  801a3e:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801a45:	77 1c                	ja     801a63 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801a47:	83 ec 08             	sub    $0x8,%esp
  801a4a:	68 00 10 00 00       	push   $0x1000
  801a4f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a52:	e8 38 0d 00 00       	call   80278f <sys_free_user_mem>
  801a57:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a5a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801a61:	eb 28                	jmp    801a8b <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a66:	68 00 00 00 a0       	push   $0xa0000000
  801a6b:	ff 75 dc             	pushl  -0x24(%ebp)
  801a6e:	68 00 10 00 00       	push   $0x1000
  801a73:	ff 75 f0             	pushl  -0x10(%ebp)
  801a76:	50                   	push   %eax
  801a77:	68 94 40 80 00       	push   $0x804094
  801a7c:	68 bd 00 00 00       	push   $0xbd
  801a81:	68 45 3f 80 00       	push   $0x803f45
  801a86:	e8 b7 1a 00 00       	call   803542 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a91:	0f 82 6c ff ff ff    	jb     801a03 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a9b:	75 17                	jne    801ab4 <free_pages+0x172>
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 f6 40 80 00       	push   $0x8040f6
  801aa5:	68 c1 00 00 00       	push   $0xc1
  801aaa:	68 45 3f 80 00       	push   $0x803f45
  801aaf:	e8 8e 1a 00 00       	call   803542 <_panic>
  801ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab7:	8b 40 08             	mov    0x8(%eax),%eax
  801aba:	85 c0                	test   %eax,%eax
  801abc:	74 11                	je     801acf <free_pages+0x18d>
  801abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac1:	8b 40 08             	mov    0x8(%eax),%eax
  801ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac7:	8b 52 0c             	mov    0xc(%edx),%edx
  801aca:	89 50 0c             	mov    %edx,0xc(%eax)
  801acd:	eb 0b                	jmp    801ada <free_pages+0x198>
  801acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad5:	a3 28 50 80 00       	mov    %eax,0x805028
  801ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801add:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	74 11                	je     801af5 <free_pages+0x1b3>
  801ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae7:	8b 40 0c             	mov    0xc(%eax),%eax
  801aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aed:	8b 52 08             	mov    0x8(%edx),%edx
  801af0:	89 50 08             	mov    %edx,0x8(%eax)
  801af3:	eb 0b                	jmp    801b00 <free_pages+0x1be>
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	8b 40 08             	mov    0x8(%eax),%eax
  801afb:	a3 24 50 80 00       	mov    %eax,0x805024
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801b14:	a1 30 50 80 00       	mov    0x805030,%eax
  801b19:	48                   	dec    %eax
  801b1a:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	ff 75 f4             	pushl  -0xc(%ebp)
  801b25:	e8 24 15 00 00       	call   80304e <free_block>
  801b2a:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801b2d:	e8 72 fb ff ff       	call   8016a4 <recompute_page_alloc_break>

			return;
  801b32:	eb 37                	jmp    801b6b <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b34:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b40:	74 08                	je     801b4a <free_pages+0x208>
  801b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b45:	8b 40 08             	mov    0x8(%eax),%eax
  801b48:	eb 05                	jmp    801b4f <free_pages+0x20d>
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b54:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	0f 85 fa fd ff ff    	jne    80195b <free_pages+0x19>
  801b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b65:	0f 85 f0 fd ff ff    	jne    80195b <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    

00801b77 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b7d:	a1 08 50 80 00       	mov    0x805008,%eax
  801b82:	85 c0                	test   %eax,%eax
  801b84:	74 60                	je     801be6 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	68 00 00 00 82       	push   $0x82000000
  801b8e:	68 00 00 00 80       	push   $0x80000000
  801b93:	e8 0d 0d 00 00       	call   8028a5 <initialize_dynamic_allocator>
  801b98:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b9b:	e8 f3 0a 00 00       	call   802693 <sys_get_uheap_strategy>
  801ba0:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ba5:	a1 40 50 80 00       	mov    0x805040,%eax
  801baa:	05 00 10 00 00       	add    $0x1000,%eax
  801baf:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801bb4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bb9:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801bbe:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801bc5:	00 00 00 
  801bc8:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801bcf:	00 00 00 
  801bd2:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801bd9:	00 00 00 

		__firstTimeFlag = 0;
  801bdc:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801be3:	00 00 00 
	}
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	68 06 04 00 00       	push   $0x406
  801c05:	50                   	push   %eax
  801c06:	e8 d2 06 00 00       	call   8022dd <__sys_allocate_page>
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c15:	79 17                	jns    801c2e <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 14 41 80 00       	push   $0x804114
  801c1f:	68 ea 00 00 00       	push   $0xea
  801c24:	68 45 3f 80 00       	push   $0x803f45
  801c29:	e8 14 19 00 00       	call   803542 <_panic>
	return 0;
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c49:	83 ec 0c             	sub    $0xc,%esp
  801c4c:	50                   	push   %eax
  801c4d:	e8 d2 06 00 00       	call   802324 <__sys_unmap_frame>
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c5c:	79 17                	jns    801c75 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	68 50 41 80 00       	push   $0x804150
  801c66:	68 f5 00 00 00       	push   $0xf5
  801c6b:	68 45 3f 80 00       	push   $0x803f45
  801c70:	e8 cd 18 00 00       	call   803542 <_panic>
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c7e:	e8 f4 fe ff ff       	call   801b77 <uheap_init>
	if (size == 0) return NULL ;
  801c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c87:	75 0a                	jne    801c93 <malloc+0x1b>
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	e9 67 01 00 00       	jmp    801dfa <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801c9a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ca1:	77 16                	ja     801cb9 <malloc+0x41>
		result = alloc_block(size);
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	ff 75 08             	pushl  0x8(%ebp)
  801ca9:	e8 46 0e 00 00       	call   802af4 <alloc_block>
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cb4:	e9 3e 01 00 00       	jmp    801df7 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801cb9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	01 d0                	add    %edx,%eax
  801cc8:	48                   	dec    %eax
  801cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd4:	f7 75 f0             	divl   -0x10(%ebp)
  801cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cda:	29 d0                	sub    %edx,%eax
  801cdc:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801cdf:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	75 0a                	jne    801cf2 <malloc+0x7a>
			return NULL;
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ced:	e9 08 01 00 00       	jmp    801dfa <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801cf2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	74 0f                	je     801d0a <malloc+0x92>
  801cfb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801d01:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d06:	39 c2                	cmp    %eax,%edx
  801d08:	73 0a                	jae    801d14 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801d0a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d0f:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801d14:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801d19:	83 f8 05             	cmp    $0x5,%eax
  801d1c:	75 11                	jne    801d2f <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	ff 75 e8             	pushl  -0x18(%ebp)
  801d24:	e8 ff f9 ff ff       	call   801728 <alloc_pages_custom_fit>
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d33:	0f 84 be 00 00 00    	je     801df7 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801d3f:	83 ec 0c             	sub    $0xc,%esp
  801d42:	ff 75 f4             	pushl  -0xc(%ebp)
  801d45:	e8 9a fb ff ff       	call   8018e4 <find_allocated_size>
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801d50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d54:	75 17                	jne    801d6d <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801d56:	ff 75 f4             	pushl  -0xc(%ebp)
  801d59:	68 90 41 80 00       	push   $0x804190
  801d5e:	68 24 01 00 00       	push   $0x124
  801d63:	68 45 3f 80 00       	push   $0x803f45
  801d68:	e8 d5 17 00 00       	call   803542 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d70:	f7 d0                	not    %eax
  801d72:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d75:	73 1d                	jae    801d94 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	ff 75 e0             	pushl  -0x20(%ebp)
  801d7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d80:	68 d8 41 80 00       	push   $0x8041d8
  801d85:	68 29 01 00 00       	push   $0x129
  801d8a:	68 45 3f 80 00       	push   $0x803f45
  801d8f:	e8 ae 17 00 00       	call   803542 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801d94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da2:	85 c0                	test   %eax,%eax
  801da4:	79 2c                	jns    801dd2 <malloc+0x15a>
  801da6:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801dad:	77 23                	ja     801dd2 <malloc+0x15a>
  801daf:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801db6:	77 1a                	ja     801dd2 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	79 13                	jns    801dd2 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	ff 75 e0             	pushl  -0x20(%ebp)
  801dc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dc8:	e8 de 09 00 00       	call   8027ab <sys_allocate_user_mem>
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	eb 25                	jmp    801df7 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801dd2:	68 00 00 00 a0       	push   $0xa0000000
  801dd7:	ff 75 dc             	pushl  -0x24(%ebp)
  801dda:	ff 75 e0             	pushl  -0x20(%ebp)
  801ddd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801de0:	ff 75 f4             	pushl  -0xc(%ebp)
  801de3:	68 14 42 80 00       	push   $0x804214
  801de8:	68 33 01 00 00       	push   $0x133
  801ded:	68 45 3f 80 00       	push   $0x803f45
  801df2:	e8 4b 17 00 00       	call   803542 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801e02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e06:	0f 84 26 01 00 00    	je     801f32 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	79 1c                	jns    801e35 <free+0x39>
  801e19:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801e20:	77 13                	ja     801e35 <free+0x39>
		free_block(virtual_address);
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	e8 21 12 00 00       	call   80304e <free_block>
  801e2d:	83 c4 10             	add    $0x10,%esp
		return;
  801e30:	e9 01 01 00 00       	jmp    801f36 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801e35:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801e3d:	0f 82 d8 00 00 00    	jb     801f1b <free+0x11f>
  801e43:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801e4a:	0f 87 cb 00 00 00    	ja     801f1b <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 17                	je     801e73 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	68 84 42 80 00       	push   $0x804284
  801e64:	68 57 01 00 00       	push   $0x157
  801e69:	68 45 3f 80 00       	push   $0x803f45
  801e6e:	e8 cf 16 00 00       	call   803542 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801e73:	83 ec 0c             	sub    $0xc,%esp
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	e8 66 fa ff ff       	call   8018e4 <find_allocated_size>
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801e84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e88:	0f 84 a7 00 00 00    	je     801f35 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e91:	f7 d0                	not    %eax
  801e93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e96:	73 1d                	jae    801eb5 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea1:	68 ac 42 80 00       	push   $0x8042ac
  801ea6:	68 61 01 00 00       	push   $0x161
  801eab:	68 45 3f 80 00       	push   $0x803f45
  801eb0:	e8 8d 16 00 00       	call   803542 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebb:	01 d0                	add    %edx,%eax
  801ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	79 19                	jns    801ee0 <free+0xe4>
  801ec7:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801ece:	77 10                	ja     801ee0 <free+0xe4>
  801ed0:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801ed7:	77 07                	ja     801ee0 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edc:	85 c0                	test   %eax,%eax
  801ede:	78 2b                	js     801f0b <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 00 00 00 a0       	push   $0xa0000000
  801ee8:	ff 75 ec             	pushl  -0x14(%ebp)
  801eeb:	ff 75 f0             	pushl  -0x10(%ebp)
  801eee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	68 e8 42 80 00       	push   $0x8042e8
  801efc:	68 69 01 00 00       	push   $0x169
  801f01:	68 45 3f 80 00       	push   $0x803f45
  801f06:	e8 37 16 00 00       	call   803542 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	e8 2c fa ff ff       	call   801942 <free_pages>
  801f16:	83 c4 10             	add    $0x10,%esp
		return;
  801f19:	eb 1b                	jmp    801f36 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	68 44 43 80 00       	push   $0x804344
  801f23:	68 70 01 00 00       	push   $0x170
  801f28:	68 45 3f 80 00       	push   $0x803f45
  801f2d:	e8 10 16 00 00       	call   803542 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f32:	90                   	nop
  801f33:	eb 01                	jmp    801f36 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801f35:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	83 ec 38             	sub    $0x38,%esp
  801f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f41:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f44:	e8 2e fc ff ff       	call   801b77 <uheap_init>
	if (size == 0) return NULL ;
  801f49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f4d:	75 0a                	jne    801f59 <smalloc+0x21>
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	e9 3d 01 00 00       	jmp    802096 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f62:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f67:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801f6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f6e:	74 0e                	je     801f7e <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801f76:	05 00 10 00 00       	add    $0x1000,%eax
  801f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	c1 e8 0c             	shr    $0xc,%eax
  801f84:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801f87:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	75 0a                	jne    801f9a <smalloc+0x62>
		return NULL;
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	e9 fc 00 00 00       	jmp    802096 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801f9a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	74 0f                	je     801fb2 <smalloc+0x7a>
  801fa3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fa9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fae:	39 c2                	cmp    %eax,%edx
  801fb0:	73 0a                	jae    801fbc <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801fb2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fb7:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801fbc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fc1:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801fc6:	29 c2                	sub    %eax,%edx
  801fc8:	89 d0                	mov    %edx,%eax
  801fca:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801fcd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fd3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fd8:	29 c2                	sub    %eax,%edx
  801fda:	89 d0                	mov    %edx,%eax
  801fdc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fe5:	77 13                	ja     801ffa <smalloc+0xc2>
  801fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fed:	77 0b                	ja     801ffa <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff2:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801ff5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ff8:	73 0a                	jae    802004 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  801fff:	e9 92 00 00 00       	jmp    802096 <smalloc+0x15e>
	}

	void *va = NULL;
  802004:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80200b:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802010:	83 f8 05             	cmp    $0x5,%eax
  802013:	75 11                	jne    802026 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	ff 75 f4             	pushl  -0xc(%ebp)
  80201b:	e8 08 f7 ff ff       	call   801728 <alloc_pages_custom_fit>
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202a:	75 27                	jne    802053 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80202c:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802033:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802036:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802039:	89 c2                	mov    %eax,%edx
  80203b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802040:	39 c2                	cmp    %eax,%edx
  802042:	73 07                	jae    80204b <smalloc+0x113>
			return NULL;}
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	eb 4b                	jmp    802096 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80204b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802050:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802053:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802057:	ff 75 f0             	pushl  -0x10(%ebp)
  80205a:	50                   	push   %eax
  80205b:	ff 75 0c             	pushl  0xc(%ebp)
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	e8 cb 03 00 00       	call   802431 <sys_create_shared_object>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80206c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802070:	79 07                	jns    802079 <smalloc+0x141>
		return NULL;
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	eb 1d                	jmp    802096 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802079:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80207e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802081:	75 10                	jne    802093 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802083:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	01 d0                	add    %edx,%eax
  80208e:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80209e:	e8 d4 fa ff ff       	call   801b77 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	e8 aa 03 00 00       	call   80245b <sys_size_of_shared_object>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8020b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020bb:	7f 0a                	jg     8020c7 <sget+0x2f>
		return NULL;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	e9 32 01 00 00       	jmp    8021f9 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8020c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8020cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8020d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020dc:	74 0e                	je     8020ec <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8020e4:	05 00 10 00 00       	add    $0x1000,%eax
  8020e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8020ec:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	75 0a                	jne    8020ff <sget+0x67>
		return NULL;
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fa:	e9 fa 00 00 00       	jmp    8021f9 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020ff:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802104:	85 c0                	test   %eax,%eax
  802106:	74 0f                	je     802117 <sget+0x7f>
  802108:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80210e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802113:	39 c2                	cmp    %eax,%edx
  802115:	73 0a                	jae    802121 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802117:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80211c:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802121:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802126:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80212b:	29 c2                	sub    %eax,%edx
  80212d:	89 d0                	mov    %edx,%eax
  80212f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802132:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802138:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80213d:	29 c2                	sub    %eax,%edx
  80213f:	89 d0                	mov    %edx,%eax
  802141:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80214a:	77 13                	ja     80215f <sget+0xc7>
  80214c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80214f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802152:	77 0b                	ja     80215f <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802157:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80215a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80215d:	73 0a                	jae    802169 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	e9 90 00 00 00       	jmp    8021f9 <sget+0x161>

	void *va = NULL;
  802169:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802170:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802175:	83 f8 05             	cmp    $0x5,%eax
  802178:	75 11                	jne    80218b <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	ff 75 f4             	pushl  -0xc(%ebp)
  802180:	e8 a3 f5 ff ff       	call   801728 <alloc_pages_custom_fit>
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80218b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218f:	75 27                	jne    8021b8 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802191:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802198:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80219b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80219e:	89 c2                	mov    %eax,%edx
  8021a0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021a5:	39 c2                	cmp    %eax,%edx
  8021a7:	73 07                	jae    8021b0 <sget+0x118>
			return NULL;
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	eb 49                	jmp    8021f9 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8021b0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8021be:	ff 75 0c             	pushl  0xc(%ebp)
  8021c1:	ff 75 08             	pushl  0x8(%ebp)
  8021c4:	e8 af 02 00 00       	call   802478 <sys_get_shared_object>
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8021cf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8021d3:	79 07                	jns    8021dc <sget+0x144>
		return NULL;
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	eb 1d                	jmp    8021f9 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8021dc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021e1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8021e4:	75 10                	jne    8021f6 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8021e6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	01 d0                	add    %edx,%eax
  8021f1:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8021f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802201:	e8 71 f9 ff ff       	call   801b77 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 68 43 80 00       	push   $0x804368
  80220e:	68 19 02 00 00       	push   $0x219
  802213:	68 45 3f 80 00       	push   $0x803f45
  802218:	e8 25 13 00 00       	call   803542 <_panic>

0080221d <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 90 43 80 00       	push   $0x804390
  80222b:	68 2b 02 00 00       	push   $0x22b
  802230:	68 45 3f 80 00       	push   $0x803f45
  802235:	e8 08 13 00 00       	call   803542 <_panic>

0080223a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	57                   	push   %edi
  80223e:	56                   	push   %esi
  80223f:	53                   	push   %ebx
  802240:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	8b 55 0c             	mov    0xc(%ebp),%edx
  802249:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80224c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80224f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802252:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802255:	cd 30                	int    $0x30
  802257:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5f                   	pop    %edi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    

00802265 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 04             	sub    $0x4,%esp
  80226b:	8b 45 10             	mov    0x10(%ebp),%eax
  80226e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802271:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802274:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	51                   	push   %ecx
  80227e:	52                   	push   %edx
  80227f:	ff 75 0c             	pushl  0xc(%ebp)
  802282:	50                   	push   %eax
  802283:	6a 00                	push   $0x0
  802285:	e8 b0 ff ff ff       	call   80223a <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	90                   	nop
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_cgetc>:

int
sys_cgetc(void)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 02                	push   $0x2
  80229f:	e8 96 ff ff ff       	call   80223a <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 03                	push   $0x3
  8022b8:	e8 7d ff ff ff       	call   80223a <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	90                   	nop
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 04                	push   $0x4
  8022d2:	e8 63 ff ff ff       	call   80223a <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	52                   	push   %edx
  8022ed:	50                   	push   %eax
  8022ee:	6a 08                	push   $0x8
  8022f0:	e8 45 ff ff ff       	call   80223a <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	56                   	push   %esi
  8022fe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022ff:	8b 75 18             	mov    0x18(%ebp),%esi
  802302:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802305:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	56                   	push   %esi
  80230f:	53                   	push   %ebx
  802310:	51                   	push   %ecx
  802311:	52                   	push   %edx
  802312:	50                   	push   %eax
  802313:	6a 09                	push   $0x9
  802315:	e8 20 ff ff ff       	call   80223a <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
}
  80231d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5d                   	pop    %ebp
  802323:	c3                   	ret    

00802324 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	ff 75 08             	pushl  0x8(%ebp)
  802332:	6a 0a                	push   $0xa
  802334:	e8 01 ff ff ff       	call   80223a <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	ff 75 0c             	pushl  0xc(%ebp)
  80234a:	ff 75 08             	pushl  0x8(%ebp)
  80234d:	6a 0b                	push   $0xb
  80234f:	e8 e6 fe ff ff       	call   80223a <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 0c                	push   $0xc
  802368:	e8 cd fe ff ff       	call   80223a <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 0d                	push   $0xd
  802381:	e8 b4 fe ff ff       	call   80223a <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 0e                	push   $0xe
  80239a:	e8 9b fe ff ff       	call   80223a <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 0f                	push   $0xf
  8023b3:	e8 82 fe ff ff       	call   80223a <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	ff 75 08             	pushl  0x8(%ebp)
  8023cb:	6a 10                	push   $0x10
  8023cd:	e8 68 fe ff ff       	call   80223a <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 11                	push   $0x11
  8023e6:	e8 4f fe ff ff       	call   80223a <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	90                   	nop
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 04             	sub    $0x4,%esp
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	50                   	push   %eax
  80240a:	6a 01                	push   $0x1
  80240c:	e8 29 fe ff ff       	call   80223a <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	90                   	nop
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 14                	push   $0x14
  802426:	e8 0f fe ff ff       	call   80223a <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	90                   	nop
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	8b 45 10             	mov    0x10(%ebp),%eax
  80243a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80243d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802440:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	6a 00                	push   $0x0
  802449:	51                   	push   %ecx
  80244a:	52                   	push   %edx
  80244b:	ff 75 0c             	pushl  0xc(%ebp)
  80244e:	50                   	push   %eax
  80244f:	6a 15                	push   $0x15
  802451:	e8 e4 fd ff ff       	call   80223a <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80245e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	52                   	push   %edx
  80246b:	50                   	push   %eax
  80246c:	6a 16                	push   $0x16
  80246e:	e8 c7 fd ff ff       	call   80223a <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80247b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80247e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	51                   	push   %ecx
  802489:	52                   	push   %edx
  80248a:	50                   	push   %eax
  80248b:	6a 17                	push   $0x17
  80248d:	e8 a8 fd ff ff       	call   80223a <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80249a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	52                   	push   %edx
  8024a7:	50                   	push   %eax
  8024a8:	6a 18                	push   $0x18
  8024aa:	e8 8b fd ff ff       	call   80223a <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	6a 00                	push   $0x0
  8024bc:	ff 75 14             	pushl  0x14(%ebp)
  8024bf:	ff 75 10             	pushl  0x10(%ebp)
  8024c2:	ff 75 0c             	pushl  0xc(%ebp)
  8024c5:	50                   	push   %eax
  8024c6:	6a 19                	push   $0x19
  8024c8:	e8 6d fd ff ff       	call   80223a <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	50                   	push   %eax
  8024e1:	6a 1a                	push   $0x1a
  8024e3:	e8 52 fd ff ff       	call   80223a <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	90                   	nop
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	50                   	push   %eax
  8024fd:	6a 1b                	push   $0x1b
  8024ff:	e8 36 fd ff ff       	call   80223a <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 05                	push   $0x5
  802518:	e8 1d fd ff ff       	call   80223a <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 06                	push   $0x6
  802531:	e8 04 fd ff ff       	call   80223a <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 07                	push   $0x7
  80254a:	e8 eb fc ff ff       	call   80223a <syscall>
  80254f:	83 c4 18             	add    $0x18,%esp
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <sys_exit_env>:


void sys_exit_env(void)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 1c                	push   $0x1c
  802563:	e8 d2 fc ff ff       	call   80223a <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
}
  80256b:	90                   	nop
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802574:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802577:	8d 50 04             	lea    0x4(%eax),%edx
  80257a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	52                   	push   %edx
  802584:	50                   	push   %eax
  802585:	6a 1d                	push   $0x1d
  802587:	e8 ae fc ff ff       	call   80223a <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
	return result;
  80258f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802595:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802598:	89 01                	mov    %eax,(%ecx)
  80259a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	c9                   	leave  
  8025a1:	c2 04 00             	ret    $0x4

008025a4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	ff 75 10             	pushl  0x10(%ebp)
  8025ae:	ff 75 0c             	pushl  0xc(%ebp)
  8025b1:	ff 75 08             	pushl  0x8(%ebp)
  8025b4:	6a 13                	push   $0x13
  8025b6:	e8 7f fc ff ff       	call   80223a <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025be:	90                   	nop
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 1e                	push   $0x1e
  8025d0:	e8 65 fc ff ff       	call   80223a <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 04             	sub    $0x4,%esp
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025e6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	50                   	push   %eax
  8025f3:	6a 1f                	push   $0x1f
  8025f5:	e8 40 fc ff ff       	call   80223a <syscall>
  8025fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fd:	90                   	nop
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <rsttst>:
void rsttst()
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 21                	push   $0x21
  80260f:	e8 26 fc ff ff       	call   80223a <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
	return ;
  802617:	90                   	nop
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 04             	sub    $0x4,%esp
  802620:	8b 45 14             	mov    0x14(%ebp),%eax
  802623:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802626:	8b 55 18             	mov    0x18(%ebp),%edx
  802629:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80262d:	52                   	push   %edx
  80262e:	50                   	push   %eax
  80262f:	ff 75 10             	pushl  0x10(%ebp)
  802632:	ff 75 0c             	pushl  0xc(%ebp)
  802635:	ff 75 08             	pushl  0x8(%ebp)
  802638:	6a 20                	push   $0x20
  80263a:	e8 fb fb ff ff       	call   80223a <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
	return ;
  802642:	90                   	nop
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <chktst>:
void chktst(uint32 n)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	ff 75 08             	pushl  0x8(%ebp)
  802653:	6a 22                	push   $0x22
  802655:	e8 e0 fb ff ff       	call   80223a <syscall>
  80265a:	83 c4 18             	add    $0x18,%esp
	return ;
  80265d:	90                   	nop
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <inctst>:

void inctst()
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 23                	push   $0x23
  80266f:	e8 c6 fb ff ff       	call   80223a <syscall>
  802674:	83 c4 18             	add    $0x18,%esp
	return ;
  802677:	90                   	nop
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <gettst>:
uint32 gettst()
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 24                	push   $0x24
  802689:	e8 ac fb ff ff       	call   80223a <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 25                	push   $0x25
  8026a2:	e8 93 fb ff ff       	call   80223a <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
  8026aa:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8026af:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	ff 75 08             	pushl  0x8(%ebp)
  8026cc:	6a 26                	push   $0x26
  8026ce:	e8 67 fb ff ff       	call   80223a <syscall>
  8026d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d6:	90                   	nop
}
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	6a 00                	push   $0x0
  8026eb:	53                   	push   %ebx
  8026ec:	51                   	push   %ecx
  8026ed:	52                   	push   %edx
  8026ee:	50                   	push   %eax
  8026ef:	6a 27                	push   $0x27
  8026f1:	e8 44 fb ff ff       	call   80223a <syscall>
  8026f6:	83 c4 18             	add    $0x18,%esp
}
  8026f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802701:	8b 55 0c             	mov    0xc(%ebp),%edx
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	52                   	push   %edx
  80270e:	50                   	push   %eax
  80270f:	6a 28                	push   $0x28
  802711:	e8 24 fb ff ff       	call   80223a <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80271e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802721:	8b 55 0c             	mov    0xc(%ebp),%edx
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	6a 00                	push   $0x0
  802729:	51                   	push   %ecx
  80272a:	ff 75 10             	pushl  0x10(%ebp)
  80272d:	52                   	push   %edx
  80272e:	50                   	push   %eax
  80272f:	6a 29                	push   $0x29
  802731:	e8 04 fb ff ff       	call   80223a <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
}
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	ff 75 10             	pushl  0x10(%ebp)
  802745:	ff 75 0c             	pushl  0xc(%ebp)
  802748:	ff 75 08             	pushl  0x8(%ebp)
  80274b:	6a 12                	push   $0x12
  80274d:	e8 e8 fa ff ff       	call   80223a <syscall>
  802752:	83 c4 18             	add    $0x18,%esp
	return ;
  802755:	90                   	nop
}
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80275b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	52                   	push   %edx
  802768:	50                   	push   %eax
  802769:	6a 2a                	push   $0x2a
  80276b:	e8 ca fa ff ff       	call   80223a <syscall>
  802770:	83 c4 18             	add    $0x18,%esp
	return;
  802773:	90                   	nop
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 2b                	push   $0x2b
  802785:	e8 b0 fa ff ff       	call   80223a <syscall>
  80278a:	83 c4 18             	add    $0x18,%esp
}
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	ff 75 0c             	pushl  0xc(%ebp)
  80279b:	ff 75 08             	pushl  0x8(%ebp)
  80279e:	6a 2d                	push   $0x2d
  8027a0:	e8 95 fa ff ff       	call   80223a <syscall>
  8027a5:	83 c4 18             	add    $0x18,%esp
	return;
  8027a8:	90                   	nop
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	ff 75 0c             	pushl  0xc(%ebp)
  8027b7:	ff 75 08             	pushl  0x8(%ebp)
  8027ba:	6a 2c                	push   $0x2c
  8027bc:	e8 79 fa ff ff       	call   80223a <syscall>
  8027c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c4:	90                   	nop
}
  8027c5:	c9                   	leave  
  8027c6:	c3                   	ret    

008027c7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8027ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	52                   	push   %edx
  8027d7:	50                   	push   %eax
  8027d8:	6a 2e                	push   $0x2e
  8027da:	e8 5b fa ff ff       	call   80223a <syscall>
  8027df:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e2:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8027eb:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8027f2:	72 09                	jb     8027fd <to_page_va+0x18>
  8027f4:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8027fb:	72 14                	jb     802811 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	68 b4 43 80 00       	push   $0x8043b4
  802805:	6a 15                	push   $0x15
  802807:	68 df 43 80 00       	push   $0x8043df
  80280c:	e8 31 0d 00 00       	call   803542 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	ba 60 50 80 00       	mov    $0x805060,%edx
  802819:	29 d0                	sub    %edx,%eax
  80281b:	c1 f8 02             	sar    $0x2,%eax
  80281e:	89 c2                	mov    %eax,%edx
  802820:	89 d0                	mov    %edx,%eax
  802822:	c1 e0 02             	shl    $0x2,%eax
  802825:	01 d0                	add    %edx,%eax
  802827:	c1 e0 02             	shl    $0x2,%eax
  80282a:	01 d0                	add    %edx,%eax
  80282c:	c1 e0 02             	shl    $0x2,%eax
  80282f:	01 d0                	add    %edx,%eax
  802831:	89 c1                	mov    %eax,%ecx
  802833:	c1 e1 08             	shl    $0x8,%ecx
  802836:	01 c8                	add    %ecx,%eax
  802838:	89 c1                	mov    %eax,%ecx
  80283a:	c1 e1 10             	shl    $0x10,%ecx
  80283d:	01 c8                	add    %ecx,%eax
  80283f:	01 c0                	add    %eax,%eax
  802841:	01 d0                	add    %edx,%eax
  802843:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	c1 e0 0c             	shl    $0xc,%eax
  80284c:	89 c2                	mov    %eax,%edx
  80284e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802853:	01 d0                	add    %edx,%eax
}
  802855:	c9                   	leave  
  802856:	c3                   	ret    

00802857 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80285d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802862:	8b 55 08             	mov    0x8(%ebp),%edx
  802865:	29 c2                	sub    %eax,%edx
  802867:	89 d0                	mov    %edx,%eax
  802869:	c1 e8 0c             	shr    $0xc,%eax
  80286c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80286f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802873:	78 09                	js     80287e <to_page_info+0x27>
  802875:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80287c:	7e 14                	jle    802892 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 f8 43 80 00       	push   $0x8043f8
  802886:	6a 22                	push   $0x22
  802888:	68 df 43 80 00       	push   $0x8043df
  80288d:	e8 b0 0c 00 00       	call   803542 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802895:	89 d0                	mov    %edx,%eax
  802897:	01 c0                	add    %eax,%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	c1 e0 02             	shl    $0x2,%eax
  80289e:	05 60 50 80 00       	add    $0x805060,%eax
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	05 00 00 00 02       	add    $0x2000000,%eax
  8028b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028b6:	73 16                	jae    8028ce <initialize_dynamic_allocator+0x29>
  8028b8:	68 1c 44 80 00       	push   $0x80441c
  8028bd:	68 42 44 80 00       	push   $0x804442
  8028c2:	6a 34                	push   $0x34
  8028c4:	68 df 43 80 00       	push   $0x8043df
  8028c9:	e8 74 0c 00 00       	call   803542 <_panic>
		is_initialized = 1;
  8028ce:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8028d5:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8028e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e3:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8028e8:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8028ef:	00 00 00 
  8028f2:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8028f9:	00 00 00 
  8028fc:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802903:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802906:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  80290d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802914:	eb 36                	jmp    80294c <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	c1 e0 04             	shl    $0x4,%eax
  80291c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802921:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	c1 e0 04             	shl    $0x4,%eax
  80292d:	05 84 d0 81 00       	add    $0x81d084,%eax
  802932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	c1 e0 04             	shl    $0x4,%eax
  80293e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802949:	ff 45 f4             	incl   -0xc(%ebp)
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802952:	72 c2                	jb     802916 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802954:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80295a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80295f:	29 c2                	sub    %eax,%edx
  802961:	89 d0                	mov    %edx,%eax
  802963:	c1 e8 0c             	shr    $0xc,%eax
  802966:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802969:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802970:	e9 c8 00 00 00       	jmp    802a3d <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802975:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802978:	89 d0                	mov    %edx,%eax
  80297a:	01 c0                	add    %eax,%eax
  80297c:	01 d0                	add    %edx,%eax
  80297e:	c1 e0 02             	shl    $0x2,%eax
  802981:	05 68 50 80 00       	add    $0x805068,%eax
  802986:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80298b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298e:	89 d0                	mov    %edx,%eax
  802990:	01 c0                	add    %eax,%eax
  802992:	01 d0                	add    %edx,%eax
  802994:	c1 e0 02             	shl    $0x2,%eax
  802997:	05 6a 50 80 00       	add    $0x80506a,%eax
  80299c:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8029a1:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8029a7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8029aa:	89 c8                	mov    %ecx,%eax
  8029ac:	01 c0                	add    %eax,%eax
  8029ae:	01 c8                	add    %ecx,%eax
  8029b0:	c1 e0 02             	shl    $0x2,%eax
  8029b3:	05 64 50 80 00       	add    $0x805064,%eax
  8029b8:	89 10                	mov    %edx,(%eax)
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	89 d0                	mov    %edx,%eax
  8029bf:	01 c0                	add    %eax,%eax
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	c1 e0 02             	shl    $0x2,%eax
  8029c6:	05 64 50 80 00       	add    $0x805064,%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 1b                	je     8029ec <initialize_dynamic_allocator+0x147>
  8029d1:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8029d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8029da:	89 c8                	mov    %ecx,%eax
  8029dc:	01 c0                	add    %eax,%eax
  8029de:	01 c8                	add    %ecx,%eax
  8029e0:	c1 e0 02             	shl    $0x2,%eax
  8029e3:	05 60 50 80 00       	add    $0x805060,%eax
  8029e8:	89 02                	mov    %eax,(%edx)
  8029ea:	eb 16                	jmp    802a02 <initialize_dynamic_allocator+0x15d>
  8029ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ef:	89 d0                	mov    %edx,%eax
  8029f1:	01 c0                	add    %eax,%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	c1 e0 02             	shl    $0x2,%eax
  8029f8:	05 60 50 80 00       	add    $0x805060,%eax
  8029fd:	a3 48 50 80 00       	mov    %eax,0x805048
  802a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a05:	89 d0                	mov    %edx,%eax
  802a07:	01 c0                	add    %eax,%eax
  802a09:	01 d0                	add    %edx,%eax
  802a0b:	c1 e0 02             	shl    $0x2,%eax
  802a0e:	05 60 50 80 00       	add    $0x805060,%eax
  802a13:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1b:	89 d0                	mov    %edx,%eax
  802a1d:	01 c0                	add    %eax,%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	c1 e0 02             	shl    $0x2,%eax
  802a24:	05 60 50 80 00       	add    $0x805060,%eax
  802a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2f:	a1 54 50 80 00       	mov    0x805054,%eax
  802a34:	40                   	inc    %eax
  802a35:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802a3a:	ff 45 f0             	incl   -0x10(%ebp)
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a43:	0f 82 2c ff ff ff    	jb     802975 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a4f:	eb 2f                	jmp    802a80 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802a51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a54:	89 d0                	mov    %edx,%eax
  802a56:	01 c0                	add    %eax,%eax
  802a58:	01 d0                	add    %edx,%eax
  802a5a:	c1 e0 02             	shl    $0x2,%eax
  802a5d:	05 68 50 80 00       	add    $0x805068,%eax
  802a62:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a6a:	89 d0                	mov    %edx,%eax
  802a6c:	01 c0                	add    %eax,%eax
  802a6e:	01 d0                	add    %edx,%eax
  802a70:	c1 e0 02             	shl    $0x2,%eax
  802a73:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a78:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a7d:	ff 45 ec             	incl   -0x14(%ebp)
  802a80:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802a87:	76 c8                	jbe    802a51 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802a89:	90                   	nop
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802a92:	8b 55 08             	mov    0x8(%ebp),%edx
  802a95:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a9a:	29 c2                	sub    %eax,%edx
  802a9c:	89 d0                	mov    %edx,%eax
  802a9e:	c1 e8 0c             	shr    $0xc,%eax
  802aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802aa4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802aa7:	89 d0                	mov    %edx,%eax
  802aa9:	01 c0                	add    %eax,%eax
  802aab:	01 d0                	add    %edx,%eax
  802aad:	c1 e0 02             	shl    $0x2,%eax
  802ab0:	05 68 50 80 00       	add    $0x805068,%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802aba:	c9                   	leave  
  802abb:	c3                   	ret    

00802abc <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802abc:	55                   	push   %ebp
  802abd:	89 e5                	mov    %esp,%ebp
  802abf:	83 ec 14             	sub    $0x14,%esp
  802ac2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802ac5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802ac9:	77 07                	ja     802ad2 <nearest_pow2_ceil.1513+0x16>
  802acb:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad0:	eb 20                	jmp    802af2 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802ad2:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802ad9:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802adc:	eb 08                	jmp    802ae6 <nearest_pow2_ceil.1513+0x2a>
  802ade:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ae1:	01 c0                	add    %eax,%eax
  802ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ae6:	d1 6d 08             	shrl   0x8(%ebp)
  802ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aed:	75 ef                	jne    802ade <nearest_pow2_ceil.1513+0x22>
        return power;
  802aef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
  802af7:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802afa:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802b01:	76 16                	jbe    802b19 <alloc_block+0x25>
  802b03:	68 58 44 80 00       	push   $0x804458
  802b08:	68 42 44 80 00       	push   $0x804442
  802b0d:	6a 72                	push   $0x72
  802b0f:	68 df 43 80 00       	push   $0x8043df
  802b14:	e8 29 0a 00 00       	call   803542 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802b19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1d:	75 0a                	jne    802b29 <alloc_block+0x35>
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	e9 bd 04 00 00       	jmp    802fe6 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802b29:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b36:	73 06                	jae    802b3e <alloc_block+0x4a>
        size = min_block_size;
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802b3e:	83 ec 0c             	sub    $0xc,%esp
  802b41:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802b44:	ff 75 08             	pushl  0x8(%ebp)
  802b47:	89 c1                	mov    %eax,%ecx
  802b49:	e8 6e ff ff ff       	call   802abc <nearest_pow2_ceil.1513>
  802b4e:	83 c4 10             	add    $0x10,%esp
  802b51:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802b54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b57:	83 ec 0c             	sub    $0xc,%esp
  802b5a:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802b5d:	52                   	push   %edx
  802b5e:	89 c1                	mov    %eax,%ecx
  802b60:	e8 83 04 00 00       	call   802fe8 <log2_ceil.1520>
  802b65:	83 c4 10             	add    $0x10,%esp
  802b68:	83 e8 03             	sub    $0x3,%eax
  802b6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802b6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b71:	c1 e0 04             	shl    $0x4,%eax
  802b74:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	0f 84 d8 00 00 00    	je     802c5b <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b86:	c1 e0 04             	shl    $0x4,%eax
  802b89:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b97:	75 17                	jne    802bb0 <alloc_block+0xbc>
  802b99:	83 ec 04             	sub    $0x4,%esp
  802b9c:	68 79 44 80 00       	push   $0x804479
  802ba1:	68 98 00 00 00       	push   $0x98
  802ba6:	68 df 43 80 00       	push   $0x8043df
  802bab:	e8 92 09 00 00       	call   803542 <_panic>
  802bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 10                	je     802bc9 <alloc_block+0xd5>
  802bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bc1:	8b 52 04             	mov    0x4(%edx),%edx
  802bc4:	89 50 04             	mov    %edx,0x4(%eax)
  802bc7:	eb 14                	jmp    802bdd <alloc_block+0xe9>
  802bc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bd2:	c1 e2 04             	shl    $0x4,%edx
  802bd5:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802bdb:	89 02                	mov    %eax,(%edx)
  802bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 0f                	je     802bf6 <alloc_block+0x102>
  802be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf0:	8b 12                	mov    (%edx),%edx
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	eb 13                	jmp    802c09 <alloc_block+0x115>
  802bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bfe:	c1 e2 04             	shl    $0x4,%edx
  802c01:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802c07:	89 02                	mov    %eax,(%edx)
  802c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1f:	c1 e0 04             	shl    $0x4,%eax
  802c22:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	c1 e0 04             	shl    $0x4,%eax
  802c32:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c37:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3c:	83 ec 0c             	sub    $0xc,%esp
  802c3f:	50                   	push   %eax
  802c40:	e8 12 fc ff ff       	call   802857 <to_page_info>
  802c45:	83 c4 10             	add    $0x10,%esp
  802c48:	89 c2                	mov    %eax,%edx
  802c4a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802c4e:	48                   	dec    %eax
  802c4f:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802c53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c56:	e9 8b 03 00 00       	jmp    802fe6 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802c5b:	a1 48 50 80 00       	mov    0x805048,%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	0f 84 64 02 00 00    	je     802ecc <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802c68:	a1 48 50 80 00       	mov    0x805048,%eax
  802c6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802c70:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c74:	75 17                	jne    802c8d <alloc_block+0x199>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 79 44 80 00       	push   $0x804479
  802c7e:	68 a0 00 00 00       	push   $0xa0
  802c83:	68 df 43 80 00       	push   $0x8043df
  802c88:	e8 b5 08 00 00       	call   803542 <_panic>
  802c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 10                	je     802ca6 <alloc_block+0x1b2>
  802c96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ca1:	89 50 04             	mov    %edx,0x4(%eax)
  802ca4:	eb 0b                	jmp    802cb1 <alloc_block+0x1bd>
  802ca6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802cb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0f                	je     802cca <alloc_block+0x1d6>
  802cbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cc4:	8b 12                	mov    (%edx),%edx
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	eb 0a                	jmp    802cd4 <alloc_block+0x1e0>
  802cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	a3 48 50 80 00       	mov    %eax,0x805048
  802cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 54 50 80 00       	mov    0x805054,%eax
  802cec:	48                   	dec    %eax
  802ced:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802cf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cf8:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802cfc:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d01:	99                   	cltd   
  802d02:	f7 7d e8             	idivl  -0x18(%ebp)
  802d05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d08:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802d0c:	83 ec 0c             	sub    $0xc,%esp
  802d0f:	ff 75 dc             	pushl  -0x24(%ebp)
  802d12:	e8 ce fa ff ff       	call   8027e5 <to_page_va>
  802d17:	83 c4 10             	add    $0x10,%esp
  802d1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802d1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d20:	83 ec 0c             	sub    $0xc,%esp
  802d23:	50                   	push   %eax
  802d24:	e8 c0 ee ff ff       	call   801be9 <get_page>
  802d29:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d33:	e9 aa 00 00 00       	jmp    802de2 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802d3f:	89 c2                	mov    %eax,%edx
  802d41:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d44:	01 d0                	add    %edx,%eax
  802d46:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802d49:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d4d:	75 17                	jne    802d66 <alloc_block+0x272>
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	68 98 44 80 00       	push   $0x804498
  802d57:	68 aa 00 00 00       	push   $0xaa
  802d5c:	68 df 43 80 00       	push   $0x8043df
  802d61:	e8 dc 07 00 00       	call   803542 <_panic>
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	c1 e0 04             	shl    $0x4,%eax
  802d6c:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d71:	8b 10                	mov    (%eax),%edx
  802d73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d76:	89 50 04             	mov    %edx,0x4(%eax)
  802d79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d7c:	8b 40 04             	mov    0x4(%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 14                	je     802d97 <alloc_block+0x2a3>
  802d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d86:	c1 e0 04             	shl    $0x4,%eax
  802d89:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 11                	jmp    802da8 <alloc_block+0x2b4>
  802d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9a:	c1 e0 04             	shl    $0x4,%eax
  802d9d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802da6:	89 02                	mov    %eax,(%edx)
  802da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dab:	c1 e0 04             	shl    $0x4,%eax
  802dae:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802db4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802db7:	89 02                	mov    %eax,(%edx)
  802db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc5:	c1 e0 04             	shl    $0x4,%eax
  802dc8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	8d 50 01             	lea    0x1(%eax),%edx
  802dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd5:	c1 e0 04             	shl    $0x4,%eax
  802dd8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ddd:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802ddf:	ff 45 f4             	incl   -0xc(%ebp)
  802de2:	b8 00 10 00 00       	mov    $0x1000,%eax
  802de7:	99                   	cltd   
  802de8:	f7 7d e8             	idivl  -0x18(%ebp)
  802deb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802dee:	0f 8f 44 ff ff ff    	jg     802d38 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df7:	c1 e0 04             	shl    $0x4,%eax
  802dfa:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802e04:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802e08:	75 17                	jne    802e21 <alloc_block+0x32d>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 79 44 80 00       	push   $0x804479
  802e12:	68 ae 00 00 00       	push   $0xae
  802e17:	68 df 43 80 00       	push   $0x8043df
  802e1c:	e8 21 07 00 00       	call   803542 <_panic>
  802e21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	74 10                	je     802e3a <alloc_block+0x346>
  802e2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e32:	8b 52 04             	mov    0x4(%edx),%edx
  802e35:	89 50 04             	mov    %edx,0x4(%eax)
  802e38:	eb 14                	jmp    802e4e <alloc_block+0x35a>
  802e3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e43:	c1 e2 04             	shl    $0x4,%edx
  802e46:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e4c:	89 02                	mov    %eax,(%edx)
  802e4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	74 0f                	je     802e67 <alloc_block+0x373>
  802e58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e5b:	8b 40 04             	mov    0x4(%eax),%eax
  802e5e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e61:	8b 12                	mov    (%edx),%edx
  802e63:	89 10                	mov    %edx,(%eax)
  802e65:	eb 13                	jmp    802e7a <alloc_block+0x386>
  802e67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e6f:	c1 e2 04             	shl    $0x4,%edx
  802e72:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e78:	89 02                	mov    %eax,(%edx)
  802e7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e90:	c1 e0 04             	shl    $0x4,%eax
  802e93:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea0:	c1 e0 04             	shl    $0x4,%eax
  802ea3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ea8:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802eaa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ead:	83 ec 0c             	sub    $0xc,%esp
  802eb0:	50                   	push   %eax
  802eb1:	e8 a1 f9 ff ff       	call   802857 <to_page_info>
  802eb6:	83 c4 10             	add    $0x10,%esp
  802eb9:	89 c2                	mov    %eax,%edx
  802ebb:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802ebf:	48                   	dec    %eax
  802ec0:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802ec4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ec7:	e9 1a 01 00 00       	jmp    802fe6 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecf:	40                   	inc    %eax
  802ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ed3:	e9 ed 00 00 00       	jmp    802fc5 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edb:	c1 e0 04             	shl    $0x4,%eax
  802ede:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ee3:	8b 00                	mov    (%eax),%eax
  802ee5:	85 c0                	test   %eax,%eax
  802ee7:	0f 84 d5 00 00 00    	je     802fc2 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	c1 e0 04             	shl    $0x4,%eax
  802ef3:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ef8:	8b 00                	mov    (%eax),%eax
  802efa:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802efd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f01:	75 17                	jne    802f1a <alloc_block+0x426>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 79 44 80 00       	push   $0x804479
  802f0b:	68 b8 00 00 00       	push   $0xb8
  802f10:	68 df 43 80 00       	push   $0x8043df
  802f15:	e8 28 06 00 00       	call   803542 <_panic>
  802f1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1d:	8b 00                	mov    (%eax),%eax
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	74 10                	je     802f33 <alloc_block+0x43f>
  802f23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f2b:	8b 52 04             	mov    0x4(%edx),%edx
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	eb 14                	jmp    802f47 <alloc_block+0x453>
  802f33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3c:	c1 e2 04             	shl    $0x4,%edx
  802f3f:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f45:	89 02                	mov    %eax,(%edx)
  802f47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0f                	je     802f60 <alloc_block+0x46c>
  802f51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f5a:	8b 12                	mov    (%edx),%edx
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	eb 13                	jmp    802f73 <alloc_block+0x47f>
  802f60:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f68:	c1 e2 04             	shl    $0x4,%edx
  802f6b:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f71:	89 02                	mov    %eax,(%edx)
  802f73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f89:	c1 e0 04             	shl    $0x4,%eax
  802f8c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f99:	c1 e0 04             	shl    $0x4,%eax
  802f9c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fa1:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802fa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa6:	83 ec 0c             	sub    $0xc,%esp
  802fa9:	50                   	push   %eax
  802faa:	e8 a8 f8 ff ff       	call   802857 <to_page_info>
  802faf:	83 c4 10             	add    $0x10,%esp
  802fb2:	89 c2                	mov    %eax,%edx
  802fb4:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fb8:	48                   	dec    %eax
  802fb9:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802fbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc0:	eb 24                	jmp    802fe6 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fc2:	ff 45 f0             	incl   -0x10(%ebp)
  802fc5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802fc9:	0f 8e 09 ff ff ff    	jle    802ed8 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802fcf:	83 ec 04             	sub    $0x4,%esp
  802fd2:	68 bb 44 80 00       	push   $0x8044bb
  802fd7:	68 bf 00 00 00       	push   $0xbf
  802fdc:	68 df 43 80 00       	push   $0x8043df
  802fe1:	e8 5c 05 00 00       	call   803542 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802fe6:	c9                   	leave  
  802fe7:	c3                   	ret    

00802fe8 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802fe8:	55                   	push   %ebp
  802fe9:	89 e5                	mov    %esp,%ebp
  802feb:	83 ec 14             	sub    $0x14,%esp
  802fee:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802ff1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff5:	75 07                	jne    802ffe <log2_ceil.1520+0x16>
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	eb 1b                	jmp    803019 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802ffe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803005:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803008:	eb 06                	jmp    803010 <log2_ceil.1520+0x28>
            x >>= 1;
  80300a:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80300d:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803010:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803014:	75 f4                	jne    80300a <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803016:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 14             	sub    $0x14,%esp
  803021:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803028:	75 07                	jne    803031 <log2_ceil.1547+0x16>
  80302a:	b8 00 00 00 00       	mov    $0x0,%eax
  80302f:	eb 1b                	jmp    80304c <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803031:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803038:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80303b:	eb 06                	jmp    803043 <log2_ceil.1547+0x28>
			x >>= 1;
  80303d:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803040:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803043:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803047:	75 f4                	jne    80303d <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803049:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80304c:	c9                   	leave  
  80304d:	c3                   	ret    

0080304e <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80304e:	55                   	push   %ebp
  80304f:	89 e5                	mov    %esp,%ebp
  803051:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803054:	8b 55 08             	mov    0x8(%ebp),%edx
  803057:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80305c:	39 c2                	cmp    %eax,%edx
  80305e:	72 0c                	jb     80306c <free_block+0x1e>
  803060:	8b 55 08             	mov    0x8(%ebp),%edx
  803063:	a1 40 50 80 00       	mov    0x805040,%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	72 19                	jb     803085 <free_block+0x37>
  80306c:	68 c0 44 80 00       	push   $0x8044c0
  803071:	68 42 44 80 00       	push   $0x804442
  803076:	68 d0 00 00 00       	push   $0xd0
  80307b:	68 df 43 80 00       	push   $0x8043df
  803080:	e8 bd 04 00 00       	call   803542 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803089:	0f 84 42 03 00 00    	je     8033d1 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80308f:	8b 55 08             	mov    0x8(%ebp),%edx
  803092:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803097:	39 c2                	cmp    %eax,%edx
  803099:	72 0c                	jb     8030a7 <free_block+0x59>
  80309b:	8b 55 08             	mov    0x8(%ebp),%edx
  80309e:	a1 40 50 80 00       	mov    0x805040,%eax
  8030a3:	39 c2                	cmp    %eax,%edx
  8030a5:	72 17                	jb     8030be <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8030a7:	83 ec 04             	sub    $0x4,%esp
  8030aa:	68 f8 44 80 00       	push   $0x8044f8
  8030af:	68 e6 00 00 00       	push   $0xe6
  8030b4:	68 df 43 80 00       	push   $0x8043df
  8030b9:	e8 84 04 00 00       	call   803542 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8030be:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030c6:	29 c2                	sub    %eax,%edx
  8030c8:	89 d0                	mov    %edx,%eax
  8030ca:	83 e0 07             	and    $0x7,%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	74 17                	je     8030e8 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	68 2c 45 80 00       	push   $0x80452c
  8030d9:	68 ea 00 00 00       	push   $0xea
  8030de:	68 df 43 80 00       	push   $0x8043df
  8030e3:	e8 5a 04 00 00       	call   803542 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	83 ec 0c             	sub    $0xc,%esp
  8030ee:	50                   	push   %eax
  8030ef:	e8 63 f7 ff ff       	call   802857 <to_page_info>
  8030f4:	83 c4 10             	add    $0x10,%esp
  8030f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8030fa:	83 ec 0c             	sub    $0xc,%esp
  8030fd:	ff 75 08             	pushl  0x8(%ebp)
  803100:	e8 87 f9 ff ff       	call   802a8c <get_block_size>
  803105:	83 c4 10             	add    $0x10,%esp
  803108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80310b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310f:	75 17                	jne    803128 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 58 45 80 00       	push   $0x804558
  803119:	68 f1 00 00 00       	push   $0xf1
  80311e:	68 df 43 80 00       	push   $0x8043df
  803123:	e8 1a 04 00 00       	call   803542 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803128:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312b:	83 ec 0c             	sub    $0xc,%esp
  80312e:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803131:	52                   	push   %edx
  803132:	89 c1                	mov    %eax,%ecx
  803134:	e8 e2 fe ff ff       	call   80301b <log2_ceil.1547>
  803139:	83 c4 10             	add    $0x10,%esp
  80313c:	83 e8 03             	sub    $0x3,%eax
  80313f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803148:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80314c:	75 17                	jne    803165 <free_block+0x117>
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	68 a4 45 80 00       	push   $0x8045a4
  803156:	68 f6 00 00 00       	push   $0xf6
  80315b:	68 df 43 80 00       	push   $0x8043df
  803160:	e8 dd 03 00 00       	call   803542 <_panic>
  803165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803168:	c1 e0 04             	shl    $0x4,%eax
  80316b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803170:	8b 10                	mov    (%eax),%edx
  803172:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803175:	89 10                	mov    %edx,(%eax)
  803177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 15                	je     803195 <free_block+0x147>
  803180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803183:	c1 e0 04             	shl    $0x4,%eax
  803186:	05 80 d0 81 00       	add    $0x81d080,%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803190:	89 50 04             	mov    %edx,0x4(%eax)
  803193:	eb 11                	jmp    8031a6 <free_block+0x158>
  803195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803198:	c1 e0 04             	shl    $0x4,%eax
  80319b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8031a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a4:	89 02                	mov    %eax,(%edx)
  8031a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a9:	c1 e0 04             	shl    $0x4,%eax
  8031ac:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8031b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b5:	89 02                	mov    %eax,(%edx)
  8031b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	c1 e0 04             	shl    $0x4,%eax
  8031c7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031cc:	8b 00                	mov    (%eax),%eax
  8031ce:	8d 50 01             	lea    0x1(%eax),%edx
  8031d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d4:	c1 e0 04             	shl    $0x4,%eax
  8031d7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031dc:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8031de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8031e5:	40                   	inc    %eax
  8031e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e9:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8031ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031f5:	29 c2                	sub    %eax,%edx
  8031f7:	89 d0                	mov    %edx,%eax
  8031f9:	c1 e8 0c             	shr    $0xc,%eax
  8031fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8031ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803202:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803206:	0f b7 c8             	movzwl %ax,%ecx
  803209:	b8 00 10 00 00       	mov    $0x1000,%eax
  80320e:	99                   	cltd   
  80320f:	f7 7d e8             	idivl  -0x18(%ebp)
  803212:	39 c1                	cmp    %eax,%ecx
  803214:	0f 85 b8 01 00 00    	jne    8033d2 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80321a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803224:	c1 e0 04             	shl    $0x4,%eax
  803227:	05 80 d0 81 00       	add    $0x81d080,%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803231:	e9 d5 00 00 00       	jmp    80330b <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80323e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803241:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803246:	29 c2                	sub    %eax,%edx
  803248:	89 d0                	mov    %edx,%eax
  80324a:	c1 e8 0c             	shr    $0xc,%eax
  80324d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803253:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803256:	0f 85 a9 00 00 00    	jne    803305 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80325c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803260:	75 17                	jne    803279 <free_block+0x22b>
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	68 79 44 80 00       	push   $0x804479
  80326a:	68 04 01 00 00       	push   $0x104
  80326f:	68 df 43 80 00       	push   $0x8043df
  803274:	e8 c9 02 00 00       	call   803542 <_panic>
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 10                	je     803292 <free_block+0x244>
  803282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328a:	8b 52 04             	mov    0x4(%edx),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%eax)
  803290:	eb 14                	jmp    8032a6 <free_block+0x258>
  803292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80329b:	c1 e2 04             	shl    $0x4,%edx
  80329e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8032a4:	89 02                	mov    %eax,(%edx)
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 0f                	je     8032bf <free_block+0x271>
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 40 04             	mov    0x4(%eax),%eax
  8032b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b9:	8b 12                	mov    (%edx),%edx
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	eb 13                	jmp    8032d2 <free_block+0x284>
  8032bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c2:	8b 00                	mov    (%eax),%eax
  8032c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032c7:	c1 e2 04             	shl    $0x4,%edx
  8032ca:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8032d0:	89 02                	mov    %eax,(%edx)
  8032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e8:	c1 e0 04             	shl    $0x4,%eax
  8032eb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f8:	c1 e0 04             	shl    $0x4,%eax
  8032fb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803300:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803302:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803305:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803308:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80330b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80330f:	0f 85 21 ff ff ff    	jne    803236 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803315:	b8 00 10 00 00       	mov    $0x1000,%eax
  80331a:	99                   	cltd   
  80331b:	f7 7d e8             	idivl  -0x18(%ebp)
  80331e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803321:	74 17                	je     80333a <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 c8 45 80 00       	push   $0x8045c8
  80332b:	68 0c 01 00 00       	push   $0x10c
  803330:	68 df 43 80 00       	push   $0x8043df
  803335:	e8 08 02 00 00       	call   803542 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80333a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803346:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80334c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803350:	75 17                	jne    803369 <free_block+0x31b>
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	68 98 44 80 00       	push   $0x804498
  80335a:	68 11 01 00 00       	push   $0x111
  80335f:	68 df 43 80 00       	push   $0x8043df
  803364:	e8 d9 01 00 00       	call   803542 <_panic>
  803369:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80336f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803372:	89 50 04             	mov    %edx,0x4(%eax)
  803375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 0c                	je     80338b <free_block+0x33d>
  80337f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803384:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803387:	89 10                	mov    %edx,(%eax)
  803389:	eb 08                	jmp    803393 <free_block+0x345>
  80338b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338e:	a3 48 50 80 00       	mov    %eax,0x805048
  803393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803396:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a4:	a1 54 50 80 00       	mov    0x805054,%eax
  8033a9:	40                   	inc    %eax
  8033aa:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8033af:	83 ec 0c             	sub    $0xc,%esp
  8033b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8033b5:	e8 2b f4 ff ff       	call   8027e5 <to_page_va>
  8033ba:	83 c4 10             	add    $0x10,%esp
  8033bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8033c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033c3:	83 ec 0c             	sub    $0xc,%esp
  8033c6:	50                   	push   %eax
  8033c7:	e8 69 e8 ff ff       	call   801c35 <return_page>
  8033cc:	83 c4 10             	add    $0x10,%esp
  8033cf:	eb 01                	jmp    8033d2 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8033d1:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8033d2:	c9                   	leave  
  8033d3:	c3                   	ret    

008033d4 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
  8033d7:	83 ec 14             	sub    $0x14,%esp
  8033da:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8033dd:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8033e1:	77 07                	ja     8033ea <nearest_pow2_ceil.1572+0x16>
      return 1;
  8033e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e8:	eb 20                	jmp    80340a <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8033ea:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8033f1:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8033f4:	eb 08                	jmp    8033fe <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8033f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f9:	01 c0                	add    %eax,%eax
  8033fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8033fe:	d1 6d 08             	shrl   0x8(%ebp)
  803401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803405:	75 ef                	jne    8033f6 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80340a:	c9                   	leave  
  80340b:	c3                   	ret    

0080340c <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80340c:	55                   	push   %ebp
  80340d:	89 e5                	mov    %esp,%ebp
  80340f:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803412:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803416:	75 13                	jne    80342b <realloc_block+0x1f>
    return alloc_block(new_size);
  803418:	83 ec 0c             	sub    $0xc,%esp
  80341b:	ff 75 0c             	pushl  0xc(%ebp)
  80341e:	e8 d1 f6 ff ff       	call   802af4 <alloc_block>
  803423:	83 c4 10             	add    $0x10,%esp
  803426:	e9 d9 00 00 00       	jmp    803504 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80342b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80342f:	75 18                	jne    803449 <realloc_block+0x3d>
    free_block(va);
  803431:	83 ec 0c             	sub    $0xc,%esp
  803434:	ff 75 08             	pushl  0x8(%ebp)
  803437:	e8 12 fc ff ff       	call   80304e <free_block>
  80343c:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80343f:	b8 00 00 00 00       	mov    $0x0,%eax
  803444:	e9 bb 00 00 00       	jmp    803504 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803449:	83 ec 0c             	sub    $0xc,%esp
  80344c:	ff 75 08             	pushl  0x8(%ebp)
  80344f:	e8 38 f6 ff ff       	call   802a8c <get_block_size>
  803454:	83 c4 10             	add    $0x10,%esp
  803457:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80345a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803461:	8b 45 0c             	mov    0xc(%ebp),%eax
  803464:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803467:	73 06                	jae    80346f <realloc_block+0x63>
    new_size = min_block_size;
  803469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346c:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80346f:	83 ec 0c             	sub    $0xc,%esp
  803472:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803475:	ff 75 0c             	pushl  0xc(%ebp)
  803478:	89 c1                	mov    %eax,%ecx
  80347a:	e8 55 ff ff ff       	call   8033d4 <nearest_pow2_ceil.1572>
  80347f:	83 c4 10             	add    $0x10,%esp
  803482:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803488:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80348b:	75 05                	jne    803492 <realloc_block+0x86>
    return va;
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	eb 72                	jmp    803504 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803492:	83 ec 0c             	sub    $0xc,%esp
  803495:	ff 75 0c             	pushl  0xc(%ebp)
  803498:	e8 57 f6 ff ff       	call   802af4 <alloc_block>
  80349d:	83 c4 10             	add    $0x10,%esp
  8034a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8034a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a7:	75 07                	jne    8034b0 <realloc_block+0xa4>
    return NULL;
  8034a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ae:	eb 54                	jmp    803504 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8034b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b6:	39 d0                	cmp    %edx,%eax
  8034b8:	76 02                	jbe    8034bc <realloc_block+0xb0>
  8034ba:	89 d0                	mov    %edx,%eax
  8034bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8034c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8034cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034d2:	eb 17                	jmp    8034eb <realloc_block+0xdf>
    dst[i] = src[i];
  8034d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	01 c2                	add    %eax,%edx
  8034dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8034df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e2:	01 c8                	add    %ecx,%eax
  8034e4:	8a 00                	mov    (%eax),%al
  8034e6:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8034e8:	ff 45 f4             	incl   -0xc(%ebp)
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034f1:	72 e1                	jb     8034d4 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8034f3:	83 ec 0c             	sub    $0xc,%esp
  8034f6:	ff 75 08             	pushl  0x8(%ebp)
  8034f9:	e8 50 fb ff ff       	call   80304e <free_block>
  8034fe:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803504:	c9                   	leave  
  803505:	c3                   	ret    

00803506 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803506:	55                   	push   %ebp
  803507:	89 e5                	mov    %esp,%ebp
  803509:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803512:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803516:	83 ec 0c             	sub    $0xc,%esp
  803519:	50                   	push   %eax
  80351a:	e8 d2 ee ff ff       	call   8023f1 <sys_cputc>
  80351f:	83 c4 10             	add    $0x10,%esp
}
  803522:	90                   	nop
  803523:	c9                   	leave  
  803524:	c3                   	ret    

00803525 <getchar>:


int
getchar(void)
{
  803525:	55                   	push   %ebp
  803526:	89 e5                	mov    %esp,%ebp
  803528:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80352b:	e8 60 ed ff ff       	call   802290 <sys_cgetc>
  803530:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803536:	c9                   	leave  
  803537:	c3                   	ret    

00803538 <iscons>:

int iscons(int fdnum)
{
  803538:	55                   	push   %ebp
  803539:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80353b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803540:	5d                   	pop    %ebp
  803541:	c3                   	ret    

00803542 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803542:	55                   	push   %ebp
  803543:	89 e5                	mov    %esp,%ebp
  803545:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803548:	8d 45 10             	lea    0x10(%ebp),%eax
  80354b:	83 c0 04             	add    $0x4,%eax
  80354e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803551:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 16                	je     803570 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80355a:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  80355f:	83 ec 08             	sub    $0x8,%esp
  803562:	50                   	push   %eax
  803563:	68 fc 45 80 00       	push   $0x8045fc
  803568:	e8 d8 ce ff ff       	call   800445 <cprintf>
  80356d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803570:	a1 04 50 80 00       	mov    0x805004,%eax
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	ff 75 0c             	pushl  0xc(%ebp)
  80357b:	ff 75 08             	pushl  0x8(%ebp)
  80357e:	50                   	push   %eax
  80357f:	68 04 46 80 00       	push   $0x804604
  803584:	6a 74                	push   $0x74
  803586:	e8 e7 ce ff ff       	call   800472 <cprintf_colored>
  80358b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80358e:	8b 45 10             	mov    0x10(%ebp),%eax
  803591:	83 ec 08             	sub    $0x8,%esp
  803594:	ff 75 f4             	pushl  -0xc(%ebp)
  803597:	50                   	push   %eax
  803598:	e8 39 ce ff ff       	call   8003d6 <vcprintf>
  80359d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8035a0:	83 ec 08             	sub    $0x8,%esp
  8035a3:	6a 00                	push   $0x0
  8035a5:	68 2c 46 80 00       	push   $0x80462c
  8035aa:	e8 27 ce ff ff       	call   8003d6 <vcprintf>
  8035af:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8035b2:	e8 a0 cd ff ff       	call   800357 <exit>

	// should not return here
	while (1) ;
  8035b7:	eb fe                	jmp    8035b7 <_panic+0x75>

008035b9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8035b9:	55                   	push   %ebp
  8035ba:	89 e5                	mov    %esp,%ebp
  8035bc:	53                   	push   %ebx
  8035bd:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8035c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8035c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8035cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ce:	39 c2                	cmp    %eax,%edx
  8035d0:	74 14                	je     8035e6 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8035d2:	83 ec 04             	sub    $0x4,%esp
  8035d5:	68 30 46 80 00       	push   $0x804630
  8035da:	6a 26                	push   $0x26
  8035dc:	68 7c 46 80 00       	push   $0x80467c
  8035e1:	e8 5c ff ff ff       	call   803542 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8035e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8035ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035f4:	e9 d9 00 00 00       	jmp    8036d2 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	01 d0                	add    %edx,%eax
  803608:	8b 00                	mov    (%eax),%eax
  80360a:	85 c0                	test   %eax,%eax
  80360c:	75 08                	jne    803616 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80360e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803611:	e9 b9 00 00 00       	jmp    8036cf <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803616:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80361d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803624:	eb 79                	jmp    80369f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803626:	a1 20 50 80 00       	mov    0x805020,%eax
  80362b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803631:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803634:	89 d0                	mov    %edx,%eax
  803636:	01 c0                	add    %eax,%eax
  803638:	01 d0                	add    %edx,%eax
  80363a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803641:	01 d8                	add    %ebx,%eax
  803643:	01 d0                	add    %edx,%eax
  803645:	01 c8                	add    %ecx,%eax
  803647:	8a 40 04             	mov    0x4(%eax),%al
  80364a:	84 c0                	test   %al,%al
  80364c:	75 4e                	jne    80369c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80364e:	a1 20 50 80 00       	mov    0x805020,%eax
  803653:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803659:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365c:	89 d0                	mov    %edx,%eax
  80365e:	01 c0                	add    %eax,%eax
  803660:	01 d0                	add    %edx,%eax
  803662:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803669:	01 d8                	add    %ebx,%eax
  80366b:	01 d0                	add    %edx,%eax
  80366d:	01 c8                	add    %ecx,%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803674:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803677:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80367c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80367e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803681:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	01 c8                	add    %ecx,%eax
  80368d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80368f:	39 c2                	cmp    %eax,%edx
  803691:	75 09                	jne    80369c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803693:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80369a:	eb 19                	jmp    8036b5 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80369c:	ff 45 e8             	incl   -0x18(%ebp)
  80369f:	a1 20 50 80 00       	mov    0x805020,%eax
  8036a4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8036aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ad:	39 c2                	cmp    %eax,%edx
  8036af:	0f 87 71 ff ff ff    	ja     803626 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8036b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036b9:	75 14                	jne    8036cf <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 88 46 80 00       	push   $0x804688
  8036c3:	6a 3a                	push   $0x3a
  8036c5:	68 7c 46 80 00       	push   $0x80467c
  8036ca:	e8 73 fe ff ff       	call   803542 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8036cf:	ff 45 f0             	incl   -0x10(%ebp)
  8036d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036d8:	0f 8c 1b ff ff ff    	jl     8035f9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8036de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8036ec:	eb 2e                	jmp    80371c <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8036ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8036f3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8036f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036fc:	89 d0                	mov    %edx,%eax
  8036fe:	01 c0                	add    %eax,%eax
  803700:	01 d0                	add    %edx,%eax
  803702:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803709:	01 d8                	add    %ebx,%eax
  80370b:	01 d0                	add    %edx,%eax
  80370d:	01 c8                	add    %ecx,%eax
  80370f:	8a 40 04             	mov    0x4(%eax),%al
  803712:	3c 01                	cmp    $0x1,%al
  803714:	75 03                	jne    803719 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803716:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803719:	ff 45 e0             	incl   -0x20(%ebp)
  80371c:	a1 20 50 80 00       	mov    0x805020,%eax
  803721:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80372a:	39 c2                	cmp    %eax,%edx
  80372c:	77 c0                	ja     8036ee <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803734:	74 14                	je     80374a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803736:	83 ec 04             	sub    $0x4,%esp
  803739:	68 dc 46 80 00       	push   $0x8046dc
  80373e:	6a 44                	push   $0x44
  803740:	68 7c 46 80 00       	push   $0x80467c
  803745:	e8 f8 fd ff ff       	call   803542 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80374a:	90                   	nop
  80374b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80374e:	c9                   	leave  
  80374f:	c3                   	ret    

00803750 <__udivdi3>:
  803750:	55                   	push   %ebp
  803751:	57                   	push   %edi
  803752:	56                   	push   %esi
  803753:	53                   	push   %ebx
  803754:	83 ec 1c             	sub    $0x1c,%esp
  803757:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80375b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80375f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803763:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803767:	89 ca                	mov    %ecx,%edx
  803769:	89 f8                	mov    %edi,%eax
  80376b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80376f:	85 f6                	test   %esi,%esi
  803771:	75 2d                	jne    8037a0 <__udivdi3+0x50>
  803773:	39 cf                	cmp    %ecx,%edi
  803775:	77 65                	ja     8037dc <__udivdi3+0x8c>
  803777:	89 fd                	mov    %edi,%ebp
  803779:	85 ff                	test   %edi,%edi
  80377b:	75 0b                	jne    803788 <__udivdi3+0x38>
  80377d:	b8 01 00 00 00       	mov    $0x1,%eax
  803782:	31 d2                	xor    %edx,%edx
  803784:	f7 f7                	div    %edi
  803786:	89 c5                	mov    %eax,%ebp
  803788:	31 d2                	xor    %edx,%edx
  80378a:	89 c8                	mov    %ecx,%eax
  80378c:	f7 f5                	div    %ebp
  80378e:	89 c1                	mov    %eax,%ecx
  803790:	89 d8                	mov    %ebx,%eax
  803792:	f7 f5                	div    %ebp
  803794:	89 cf                	mov    %ecx,%edi
  803796:	89 fa                	mov    %edi,%edx
  803798:	83 c4 1c             	add    $0x1c,%esp
  80379b:	5b                   	pop    %ebx
  80379c:	5e                   	pop    %esi
  80379d:	5f                   	pop    %edi
  80379e:	5d                   	pop    %ebp
  80379f:	c3                   	ret    
  8037a0:	39 ce                	cmp    %ecx,%esi
  8037a2:	77 28                	ja     8037cc <__udivdi3+0x7c>
  8037a4:	0f bd fe             	bsr    %esi,%edi
  8037a7:	83 f7 1f             	xor    $0x1f,%edi
  8037aa:	75 40                	jne    8037ec <__udivdi3+0x9c>
  8037ac:	39 ce                	cmp    %ecx,%esi
  8037ae:	72 0a                	jb     8037ba <__udivdi3+0x6a>
  8037b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037b4:	0f 87 9e 00 00 00    	ja     803858 <__udivdi3+0x108>
  8037ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8037bf:	89 fa                	mov    %edi,%edx
  8037c1:	83 c4 1c             	add    $0x1c,%esp
  8037c4:	5b                   	pop    %ebx
  8037c5:	5e                   	pop    %esi
  8037c6:	5f                   	pop    %edi
  8037c7:	5d                   	pop    %ebp
  8037c8:	c3                   	ret    
  8037c9:	8d 76 00             	lea    0x0(%esi),%esi
  8037cc:	31 ff                	xor    %edi,%edi
  8037ce:	31 c0                	xor    %eax,%eax
  8037d0:	89 fa                	mov    %edi,%edx
  8037d2:	83 c4 1c             	add    $0x1c,%esp
  8037d5:	5b                   	pop    %ebx
  8037d6:	5e                   	pop    %esi
  8037d7:	5f                   	pop    %edi
  8037d8:	5d                   	pop    %ebp
  8037d9:	c3                   	ret    
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	89 d8                	mov    %ebx,%eax
  8037de:	f7 f7                	div    %edi
  8037e0:	31 ff                	xor    %edi,%edi
  8037e2:	89 fa                	mov    %edi,%edx
  8037e4:	83 c4 1c             	add    $0x1c,%esp
  8037e7:	5b                   	pop    %ebx
  8037e8:	5e                   	pop    %esi
  8037e9:	5f                   	pop    %edi
  8037ea:	5d                   	pop    %ebp
  8037eb:	c3                   	ret    
  8037ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037f1:	89 eb                	mov    %ebp,%ebx
  8037f3:	29 fb                	sub    %edi,%ebx
  8037f5:	89 f9                	mov    %edi,%ecx
  8037f7:	d3 e6                	shl    %cl,%esi
  8037f9:	89 c5                	mov    %eax,%ebp
  8037fb:	88 d9                	mov    %bl,%cl
  8037fd:	d3 ed                	shr    %cl,%ebp
  8037ff:	89 e9                	mov    %ebp,%ecx
  803801:	09 f1                	or     %esi,%ecx
  803803:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803807:	89 f9                	mov    %edi,%ecx
  803809:	d3 e0                	shl    %cl,%eax
  80380b:	89 c5                	mov    %eax,%ebp
  80380d:	89 d6                	mov    %edx,%esi
  80380f:	88 d9                	mov    %bl,%cl
  803811:	d3 ee                	shr    %cl,%esi
  803813:	89 f9                	mov    %edi,%ecx
  803815:	d3 e2                	shl    %cl,%edx
  803817:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381b:	88 d9                	mov    %bl,%cl
  80381d:	d3 e8                	shr    %cl,%eax
  80381f:	09 c2                	or     %eax,%edx
  803821:	89 d0                	mov    %edx,%eax
  803823:	89 f2                	mov    %esi,%edx
  803825:	f7 74 24 0c          	divl   0xc(%esp)
  803829:	89 d6                	mov    %edx,%esi
  80382b:	89 c3                	mov    %eax,%ebx
  80382d:	f7 e5                	mul    %ebp
  80382f:	39 d6                	cmp    %edx,%esi
  803831:	72 19                	jb     80384c <__udivdi3+0xfc>
  803833:	74 0b                	je     803840 <__udivdi3+0xf0>
  803835:	89 d8                	mov    %ebx,%eax
  803837:	31 ff                	xor    %edi,%edi
  803839:	e9 58 ff ff ff       	jmp    803796 <__udivdi3+0x46>
  80383e:	66 90                	xchg   %ax,%ax
  803840:	8b 54 24 08          	mov    0x8(%esp),%edx
  803844:	89 f9                	mov    %edi,%ecx
  803846:	d3 e2                	shl    %cl,%edx
  803848:	39 c2                	cmp    %eax,%edx
  80384a:	73 e9                	jae    803835 <__udivdi3+0xe5>
  80384c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80384f:	31 ff                	xor    %edi,%edi
  803851:	e9 40 ff ff ff       	jmp    803796 <__udivdi3+0x46>
  803856:	66 90                	xchg   %ax,%ax
  803858:	31 c0                	xor    %eax,%eax
  80385a:	e9 37 ff ff ff       	jmp    803796 <__udivdi3+0x46>
  80385f:	90                   	nop

00803860 <__umoddi3>:
  803860:	55                   	push   %ebp
  803861:	57                   	push   %edi
  803862:	56                   	push   %esi
  803863:	53                   	push   %ebx
  803864:	83 ec 1c             	sub    $0x1c,%esp
  803867:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80386b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80386f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803873:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803877:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80387b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80387f:	89 f3                	mov    %esi,%ebx
  803881:	89 fa                	mov    %edi,%edx
  803883:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803887:	89 34 24             	mov    %esi,(%esp)
  80388a:	85 c0                	test   %eax,%eax
  80388c:	75 1a                	jne    8038a8 <__umoddi3+0x48>
  80388e:	39 f7                	cmp    %esi,%edi
  803890:	0f 86 a2 00 00 00    	jbe    803938 <__umoddi3+0xd8>
  803896:	89 c8                	mov    %ecx,%eax
  803898:	89 f2                	mov    %esi,%edx
  80389a:	f7 f7                	div    %edi
  80389c:	89 d0                	mov    %edx,%eax
  80389e:	31 d2                	xor    %edx,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	39 f0                	cmp    %esi,%eax
  8038aa:	0f 87 ac 00 00 00    	ja     80395c <__umoddi3+0xfc>
  8038b0:	0f bd e8             	bsr    %eax,%ebp
  8038b3:	83 f5 1f             	xor    $0x1f,%ebp
  8038b6:	0f 84 ac 00 00 00    	je     803968 <__umoddi3+0x108>
  8038bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8038c1:	29 ef                	sub    %ebp,%edi
  8038c3:	89 fe                	mov    %edi,%esi
  8038c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038c9:	89 e9                	mov    %ebp,%ecx
  8038cb:	d3 e0                	shl    %cl,%eax
  8038cd:	89 d7                	mov    %edx,%edi
  8038cf:	89 f1                	mov    %esi,%ecx
  8038d1:	d3 ef                	shr    %cl,%edi
  8038d3:	09 c7                	or     %eax,%edi
  8038d5:	89 e9                	mov    %ebp,%ecx
  8038d7:	d3 e2                	shl    %cl,%edx
  8038d9:	89 14 24             	mov    %edx,(%esp)
  8038dc:	89 d8                	mov    %ebx,%eax
  8038de:	d3 e0                	shl    %cl,%eax
  8038e0:	89 c2                	mov    %eax,%edx
  8038e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038e6:	d3 e0                	shl    %cl,%eax
  8038e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f0:	89 f1                	mov    %esi,%ecx
  8038f2:	d3 e8                	shr    %cl,%eax
  8038f4:	09 d0                	or     %edx,%eax
  8038f6:	d3 eb                	shr    %cl,%ebx
  8038f8:	89 da                	mov    %ebx,%edx
  8038fa:	f7 f7                	div    %edi
  8038fc:	89 d3                	mov    %edx,%ebx
  8038fe:	f7 24 24             	mull   (%esp)
  803901:	89 c6                	mov    %eax,%esi
  803903:	89 d1                	mov    %edx,%ecx
  803905:	39 d3                	cmp    %edx,%ebx
  803907:	0f 82 87 00 00 00    	jb     803994 <__umoddi3+0x134>
  80390d:	0f 84 91 00 00 00    	je     8039a4 <__umoddi3+0x144>
  803913:	8b 54 24 04          	mov    0x4(%esp),%edx
  803917:	29 f2                	sub    %esi,%edx
  803919:	19 cb                	sbb    %ecx,%ebx
  80391b:	89 d8                	mov    %ebx,%eax
  80391d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803921:	d3 e0                	shl    %cl,%eax
  803923:	89 e9                	mov    %ebp,%ecx
  803925:	d3 ea                	shr    %cl,%edx
  803927:	09 d0                	or     %edx,%eax
  803929:	89 e9                	mov    %ebp,%ecx
  80392b:	d3 eb                	shr    %cl,%ebx
  80392d:	89 da                	mov    %ebx,%edx
  80392f:	83 c4 1c             	add    $0x1c,%esp
  803932:	5b                   	pop    %ebx
  803933:	5e                   	pop    %esi
  803934:	5f                   	pop    %edi
  803935:	5d                   	pop    %ebp
  803936:	c3                   	ret    
  803937:	90                   	nop
  803938:	89 fd                	mov    %edi,%ebp
  80393a:	85 ff                	test   %edi,%edi
  80393c:	75 0b                	jne    803949 <__umoddi3+0xe9>
  80393e:	b8 01 00 00 00       	mov    $0x1,%eax
  803943:	31 d2                	xor    %edx,%edx
  803945:	f7 f7                	div    %edi
  803947:	89 c5                	mov    %eax,%ebp
  803949:	89 f0                	mov    %esi,%eax
  80394b:	31 d2                	xor    %edx,%edx
  80394d:	f7 f5                	div    %ebp
  80394f:	89 c8                	mov    %ecx,%eax
  803951:	f7 f5                	div    %ebp
  803953:	89 d0                	mov    %edx,%eax
  803955:	e9 44 ff ff ff       	jmp    80389e <__umoddi3+0x3e>
  80395a:	66 90                	xchg   %ax,%ax
  80395c:	89 c8                	mov    %ecx,%eax
  80395e:	89 f2                	mov    %esi,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	3b 04 24             	cmp    (%esp),%eax
  80396b:	72 06                	jb     803973 <__umoddi3+0x113>
  80396d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803971:	77 0f                	ja     803982 <__umoddi3+0x122>
  803973:	89 f2                	mov    %esi,%edx
  803975:	29 f9                	sub    %edi,%ecx
  803977:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80397b:	89 14 24             	mov    %edx,(%esp)
  80397e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803982:	8b 44 24 04          	mov    0x4(%esp),%eax
  803986:	8b 14 24             	mov    (%esp),%edx
  803989:	83 c4 1c             	add    $0x1c,%esp
  80398c:	5b                   	pop    %ebx
  80398d:	5e                   	pop    %esi
  80398e:	5f                   	pop    %edi
  80398f:	5d                   	pop    %ebp
  803990:	c3                   	ret    
  803991:	8d 76 00             	lea    0x0(%esi),%esi
  803994:	2b 04 24             	sub    (%esp),%eax
  803997:	19 fa                	sbb    %edi,%edx
  803999:	89 d1                	mov    %edx,%ecx
  80399b:	89 c6                	mov    %eax,%esi
  80399d:	e9 71 ff ff ff       	jmp    803913 <__umoddi3+0xb3>
  8039a2:	66 90                	xchg   %ax,%ax
  8039a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039a8:	72 ea                	jb     803994 <__umoddi3+0x134>
  8039aa:	89 d9                	mov    %ebx,%ecx
  8039ac:	e9 62 ff ff ff       	jmp    803913 <__umoddi3+0xb3>
